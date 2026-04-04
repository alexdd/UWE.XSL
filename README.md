# UWE.XSL

UWE.XSL turns **DITA 1.3** maps and topics into **PDF** (via XSL-FO and Apache FOP) and **HTML**, using XSLT and an **XProc 3** orchestration layer. The stylesheets come from the [Tektur CCMS](http://www.tekturcms.de) ecosystem and are suitable for automated builds in CI, Docker, or locally on your machine.

## Contents

- [Quick start](#quick-start)
- [Overview](#overview)
- [Screenshots](#screenshots)
- [Project structure](#project-structure)
- [Configuration](#configuration)
- [Prerequisites](#prerequisites)
- [Getting started (detailed)](#getting-started-detailed)
- [Docker](#docker)
- [Validation](#validation)
- [Dependencies](#dependencies)
- [Test data](#test-data)
- [Optional helper scripts](#optional-helper-scripts)
- [License](#license)

## Quick start

1. **Clone** with DITA DTDs: `git clone --recurse-submodules <repo-url>` then `cd UWE.XSL`
2. **Install** runtimes: `bash scripts/install.sh` (Git Bash on Windows is fine)
3. **Publish** the sample: `bash scripts/run.sh` (Unix/Git Bash) or `scripts\run.bat` (Windows CMD)

Default output goes under `test/output/XmlHandsOn/<language>/` (PDF + HTML). To use your own content, set the `UWE_*_BASE` variables (see [Custom input / output directories](#custom-input--output-directories)).

## Overview

| | |
|---|---|
| **Orchestration** | XProc 3.0 (`src/xpl/main.xpl`), run with **XML Calabash 3.x** |
| **PDF** | Pretransform → XSL-FO → **FOP** via `p:os-exec` (no proprietary FOP extension) |
| **HTML** | Pretransform → XSLT → static site + assets |
| **Validation** | DITA 1.3 DTDs + **SchXSLT**-driven Schematron (`validate.xpl`) |

The main entry point wires structure/layout/fonts/colors from `conf/params/a4_margin_book.xml`, walks the languages declared in `src/localize.xml`, and drives PDF and HTML sub-pipelines for each language.

## Screenshots

Real output from the **XmlHandsOn** sample (same pipeline as `run.sh` / `run.bat`): **PDF** via XSL-FO and Apache FOP, **HTML** as a static site with table of contents, topic body, and client-side search. 

**PDF** (English sample, different spreads):

![PDF: cover or opening pages](test/screenshots/pdf1.png)

![PDF: body text and typography](test/screenshots/pdf2.png)

![PDF: tables or figures](test/screenshots/pdf3.png)

**HTML** (German sample):

<img src="test/screenshots/html1.png" alt="HTML: navigation, topic content, and search chrome" width="680">

## Project structure

```
UWE.XSL/
├── Dockerfile                   # Container: Java + install.sh (Calabash, FOP, fonts, …)
├── docker-compose.yml           # Bind-mount input/output; run pipeline in Docker
├── scripts/
│   ├── install.sh               # Downloads Calabash 3, FOP, SchXSLT, etc.
│   ├── run.sh                   # Runs pipeline via Calabash 3 (Unix/Git Bash)
│   ├── run.bat                  # Windows: same; run from project root
│   ├── docker-entrypoint.sh     # Docker: validates UWE_*_BASE file: URIs, calls run.sh
│   └── pdf-list-fonts.py        # Optional: list fonts embedded in a PDF (needs PyMuPDF)
├── conf/
│   ├── params/
│   │   └── a4_margin_book.xml   # Layout, structure, fonts, cover, theme, pdf-config
│   └── fop/                     # FOP template → generated config at build time
├── src/
│   ├── catalog.xml              # XML catalog (DITA PUBLIC ids)
│   ├── localize.xml             # Languages + ditamaps; boilerplate strings (TOC, …)
│   ├── sch/                     # Schematron (content model + FO link errors)
│   ├── xpl/                     # XProc: main.xpl, pdf/html/validate sub-pipelines, tools
│   ├── topic2uwe.xsl, map2uwe.xsl
│   ├── dtd/                    # Submodule: OASIS DITA 1.3 DTDs
│   ├── pdf/                     # XSL-FO (main.xsl, uwe.xsl, carbook.xsl, pretransformation.xsl, …)
│   └── html/                    # HTML XSLT + res/lib (lunr, mark.js, …)
├── test/
│   ├── input/XmlHandsOn/        # Sample publication (de, en, shared images)
│   ├── screenshots/             # PDF/HTML sample captures (for README)
│   ├── output/                  # Generated output (.gitignore)
│   └── logs/                    # Logs (.gitignore)
├── lib/                         # Created by install.sh (not in git)
├── license.txt, THIRD-PARTY-NOTICES
└── README.md
```

## Configuration

| What | Purpose |
|------|---------|
| **`conf/params/a4_margin_book.xml`** | Single knobs file: paper, margins, TOC/index, fonts, colors, cover, theme, and `<pdf-config>` (cover image, logos, custom flag, …). Paths under `<pdf-config>` are relative to this file (e.g. `../../test/boilerplate/…` for repo assets). |
| **`car_book_theme` (`<theme>` in params)** | If `true`, the PDF step runs **`src/pdf/carbook.xsl`** (imports `uwe.xsl`, overrides page geometry and headers for the car-book layout); otherwise **`src/pdf/uwe.xsl`** is the FO entry stylesheet. |
| **`src/localize.xml`** | `<langs>`: which languages and ditamaps to build. `<boilerplate>`: UI strings per language. |
| **`lib/fonts/noto/`** | Noto fonts; fetched by `install.sh`, referenced from generated FOP config. |
| **`conf/fop/fop-template.xconf`** | Template; `run.sh` / `run.bat` expand to **`conf/fop/fop-generated.xconf`** with absolute font paths. |

**FOP config at run time** — `conf/fop/fop-generated.xconf` is **not** checked into git (see `.gitignore`). On each pipeline run, the shell scripts regenerate it from `fop-template.xconf` via `src/xpl/tools/fop-config-resolve.xsl` and the Noto font directory under `lib/fonts/noto/`, so PDF builds keep working after `install.sh` on any machine.

**Per-language metadata** — For each language, the main pipeline stores a small XML file under **`<output>/<lang>/uwe/.pipeline_viewport.xml`**. It records which merged params document applies to that language run. You normally ignore these files; they exist so the DITA→UWE map step can resolve the correct params URI when several languages are built in one invocation.

## Prerequisites

- **Java 11+** (often tested with newer LTS). On macOS, `/usr/bin/java` may be a stub—use a real JDK (e.g. Homebrew `openjdk`).
- **Git** (submodule for DTDs).
- **Bash** for `install.sh` and `run.sh`; on Windows, **Git Bash** or **`run.bat`** for the pipeline.
- **curl** and **unzip** for `install.sh`.

**Choosing the Java binary** — set `JAVA_BIN` if the default is wrong:

- macOS (Homebrew): `export JAVA_BIN=/opt/homebrew/opt/openjdk/bin/java`
- Windows CMD: `set JAVA_BIN=C:\Program Files\Eclipse Adoptium\jdk-17\bin\java.exe`
- Linux / Docker: `java` on `PATH` is usually enough

## Getting started (detailed)

### 1. Clone the repository

```bash
git clone --recurse-submodules https://github.com/user/UWE.XSL.git
cd UWE.XSL
```

If you already cloned without submodules:

```bash
git submodule init
git submodule update
```

The submodule **`src/dtd`** holds the OASIS DITA 1.3 DTDs.

### 2. Install dependencies

```bash
bash scripts/install.sh
```

This is **idempotent**: existing `lib/` artifacts are skipped on repeat runs. It pulls XML Calabash 3, Apache FOP, SchXSLT, Noto fonts, and other declared payloads into `lib/` (and related paths). For the exact URLs and versions, open `scripts/install.sh`.

### 3. Run the main pipeline

From the **repository root**:

| Platform | Command |
|----------|---------|
| macOS / Linux | `bash scripts/run.sh` |
| Windows CMD | `scripts\run.bat` |
| Windows (Git Bash) | `bash scripts/run.sh` |
| Docker | See [Docker](#docker) |

With no arguments, this runs **`main.xpl`**: validate (unless disabled), then for each language—clean output tree, load params, DITA→UWE, PDF (FO+FOP) and HTML.

- **Default locations:** `test/output/XmlHandsOn/<lang>/pdf|html/`, temp under `test/tmp/` (or `UWE_TMP_BASE`).
- **FOP:** Scripts regenerate `conf/fop/fop-generated.xconf` so font paths work on each OS. Windows invokes FOP via `cmd` + `fop.bat`; Unix uses the FOP shell launcher.

**Validation flags** (passed through to `run.sh` / `run.bat`):

| Flag | Behavior |
|------|----------|
| _(default)_ | Run `validate.xpl` first; on errors, **continue** and still build |
| `--no-validate` | Skip validation |
| `--fail-on-validate` | Stop the run if validation fails |

**PDF:** If a later step rebuilds PDF from `at2.xml`, an existing target PDF may be overwritten.

#### Custom input / output directories

For your own DITA tree, set these to **`file:` URIs** ending with **`/`**:

| Variable | Role |
|----------|------|
| `UWE_INPUT_BASE` | Content root (same idea as sample: per-lang folders + shared `images/`, …) |
| `UWE_OUTPUT_BASE` | PDF/HTML (and related) output |
| `UWE_LOG_BASE` | SVRL / FO link reports |
| `UWE_TMP_BASE` | `at.xml`, `at2.xml`, `fixed.fo`, … |
| `UWE_VALIDATE_OUTPUT_BASE` | **Only for `validate.xpl`:** validated copies |

**Unix example:**

```bash
export UWE_INPUT_BASE="file:///path/to/my-dita-bundle/"
export UWE_OUTPUT_BASE="file:///path/to/build-out/"
export UWE_LOG_BASE="file:///path/to/build-out/.logs/"
export UWE_TMP_BASE="file:///path/to/build-out/.tmp/"
export UWE_VALIDATE_OUTPUT_BASE="file:///path/to/build-out/validate/"
bash scripts/run.sh
```

**Windows CMD example:**

```bat
set "UWE_INPUT_BASE=file:///D:/projects/MyBook/input/"
set "UWE_OUTPUT_BASE=file:///D:/projects/MyBook/out/"
set "UWE_LOG_BASE=file:///D:/projects/MyBook/out/.logs/"
set "UWE_TMP_BASE=file:///D:/projects/MyBook/out/.tmp/"
set "UWE_VALIDATE_OUTPUT_BASE=file:///D:/projects/MyBook/out/validate/"
scripts\run.bat
```

### 4. Run validation only

```bash
bash scripts/run.sh validate.xpl
```

Console lines look like `[VALID] …`, `[DTD-FAIL] …`, `[SCH-FAIL] …`. By default (`validate.xpl` options), validated copies go under **`test/validate-output/XmlHandsOn/`** and the aggregated log to **`test/logs/validate-run.xml`**. Docker or `UWE_VALIDATE_OUTPUT_BASE` can redirect those paths.

## Docker

**Needs:** [Docker](https://docs.docker.com/get-docker/) with Compose v2 (`docker compose`). **Clone with submodules** so the DITA DTDs exist before `docker compose build`.

**Build** (repo root):

```bash
docker compose build
```

**Run** the main pipeline by mounting host folders. Compose env vars `UWE_INPUT` and `UWE_OUTPUT` are host paths (defaults point at the bundled sample under `test/input/XmlHandsOn` and `test/output/XmlHandsOn`).

```bash
UWE_INPUT=/absolute/path/to/dita-root UWE_OUTPUT=/absolute/path/to/out docker compose run --rm pipeline
```

**PowerShell:**

```powershell
$env:UWE_INPUT = "D:\projects\MyBook\input"
$env:UWE_OUTPUT = "D:\projects\MyBook\out"
docker compose run --rm pipeline
```

Inside the container, input/output appear as `/data/input` and `/data/output`. Compose wires `UWE_INPUT_BASE`, `UWE_OUTPUT_BASE`, `UWE_LOG_BASE`, `UWE_TMP_BASE`, and `UWE_VALIDATE_OUTPUT_BASE`. Languages/maps still come from `src/localize.xml`.

**Other pipelines** (e.g. validation):

```bash
docker compose run --rm pipeline validate.xpl
```

The **first** image build runs `install.sh` inside the image (network, may take several minutes).

## Validation

The dedicated pipeline is `src/xpl/pipelines/validate.xpl`. In short:

1. **DTD** — Each file is parsed with DITA 1.3 DTDs via `src/catalog.xml`.
2. **Schematron** — Passing files go through SchXSLT-compiled `src/sch/validate.sch` → SVRL.

Default output: **`test/validate-output/XmlHandsOn/`** (per-language tree) and **`test/logs/validate-run.xml`**. Override with `validate.xpl` options or environment (e.g. Docker / `UWE_VALIDATE_OUTPUT_BASE`).

### Schematron rules (high level)

`src/sch/validate.sch` encodes the UWE content model, including:

- Allowed parent/child element combinations.
- Image `href` conventions and extensions under `../images/…`.
- Text-only leaves (e.g. `codeph`, `uicontrol`, `code`, `author`) must not contain nested elements.

## Dependencies

Everything listed below is fetched by **`scripts/install.sh`**, except the DITA DTDs (**git submodule**).

| Component | Version | License | Location |
|-----------|---------|---------|----------|
| XML Calabash | 3.0.41 | GPL v2 + Classpath Exception | `lib/calabash-dist/` |
| Apache FOP | 2.11 | Apache 2.0 | `lib/fop/` |
| SchXSLT | v1.10 | MIT | `lib/schxslt/` |
| lunr.js / lunr-languages / mark.js | see install | MIT / MPL 1.1 (lunr-languages) | `src/html/res/lib/…` |
| DITA 1.3 DTDs | submodule | Apache 2.0 | `src/dtd/` |

Links mirror those in `scripts/install.sh` and upstream release pages.

### Runtime stack

- **Calabash** runs the XProc graph and **p:os-exec** for FOP.
- **FOP** renders FO → area tree → PDF in two steps (`fixed.fo` / `at.xml` / `at2.xml`).
- **SchXSLT** compiles Schematron to XSLT for SVRL reports.

Calabash ships **Saxon-HE**; you normally do not install Saxon separately. To upgrade Saxon, replace the JAR under `lib/calabash-dist/lib/` and keep a single Saxon on the classpath.

### XML catalog

`src/catalog.xml` delegates to `src/dtd/` so PUBLIC ids resolve offline. `run.sh` / `run.bat` pass `-Dxml.catalog.files=…` to the JVM.

## Test data

`test/input/XmlHandsOn/` is a full sample (“XML Developer’s Handbook”) in **de** and **en** (64 topics per language, one ditamap each), with shared images under `images/`.

## Optional helper scripts

| Script | Purpose |
|--------|---------|
| **`scripts/pdf-list-fonts.py`** | Prints base font names used in a PDF. Requires Python 3 and `pip install pymupdf`. Example: `python scripts/pdf-list-fonts.py test/output/XmlHandsOn/de/pdf/de.pdf` |

## License

UWE.XSL is **LGPL-3.0** — see [license.txt](license.txt).

Third-party licensing is summarized in [THIRD-PARTY-NOTICES](THIRD-PARTY-NOTICES). Front-end assets deployed to HTML are mostly MIT; **lunr-languages** is MPL 1.1. Runtime stack includes Apache 2.0 (FOP, DITA DTDs), MIT (SchXSLT), and GPL v2 + Classpath Exception (Calabash / bundled Saxon-HE under MPL 2.0).
