# UWE.XSL - DITA Publishing Stylesheets
# Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
# SPDX-License-Identifier: LGPL-3.0-only
# See license.txt for the full license text.
#
# PDF pipeline (Calabash 3 + FOP + SchXSLT + Noto)
# Build: docker compose build
# Requires DITA DTD submodule present in build context (git clone --recurse-submodules).

FROM eclipse-temurin:17-jdk

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash curl unzip ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Fresh dependency install in image (do not rely on host lib/)
COPY . /workspace
RUN rm -rf /workspace/lib /workspace/test/tmp /workspace/test/output \
  && bash /workspace/scripts/install.sh \
  && chmod +x /workspace/lib/fop/fop/fop

RUN chmod +x /workspace/scripts/docker-entrypoint.sh /workspace/scripts/run.sh

ENV LANG=C.UTF-8
ENTRYPOINT ["/workspace/scripts/docker-entrypoint.sh"]
CMD ["main.xpl"]
