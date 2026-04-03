/* UWE.XSL - DITA Publishing Stylesheets
   Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
   SPDX-License-Identifier: LGPL-3.0-only
   See license.txt for the full license text. */
var TEKTUR_HELP = (function(settings) {

	var NAVIGATION_SETTINGS,
		CONTENT_SETTINGS,
		META_SETTINGS = null;
		
	var topicIdx = 0;

	function qs(sel, ctx) { return (ctx || document).querySelector(sel); }
	function qsa(sel, ctx) { return (ctx || document).querySelectorAll(sel); }

	function parents(el, selector) {
		var result = [];
		var cur = el.parentElement;
		while (cur) {
			if (cur.matches(selector)) result.push(cur);
			cur = cur.parentElement;
		}
		return result;
	}

	/* returns value of url paramter with name sParam */
	function getUrlParameter(sParam) {
		var sPageURL = window.location.search.substring(1);
		var sURLVariables = sPageURL.split('&');
		for (var i = 0; i < sURLVariables.length; i++) {
			var sParameterName = sURLVariables[i].split('=');
			if (sParameterName[0] == sParam) {
				return sParameterName[1];
			}
		}
	};

	/* return autocomplete words from tokenstore of lunrjs */
	function updateWords(inp, idx_autocomplete) {
		var tokenSet = idx_autocomplete.tokenSet;
		if (!tokenSet) return;
		// reduce the tokenset character by character
		var part = "";
		for (var c=0; c<inp.length; c++) {
			var reducedTokenSet = tokenSet.edges[inp[c]];
			if (reducedTokenSet) {
				tokenSet = reducedTokenSet;
				part += inp[c];
			}
			else {
				break;
			}
		}
		var allTokens = tokenSet.toArray();
		var result = new Array();
		for (var t=0;t<allTokens.length;t++)
			if (allTokens[t] !== "") result.push(part + allTokens[t]);
		return result;
	};

	/* Finds y position of given DOM object */
	function findPos(obj) {
		var curtop = 0;
		if (obj.offsetParent) {
			do {
				curtop += obj.offsetTop;
			} while (obj = obj.offsetParent);
			return [curtop];
		}
	};

	/* updates the breadcrumb navigation */
	function updateBreadcrumbs(topic) {
		var parentLis = parents(topic, "li").reverse();
		var breadcrumbs = parentLis.map(function(li) { return qs("a", li); });
		var bcEl = qs("#breadcrumbs");
		try {
			bcEl.innerHTML = '<a href="index.html?meta=true" target="_self">Cover</a> ';
		} catch(e) {}
		for (var bc=0; bc<breadcrumbs.length; bc++) {
			if (breadcrumbs[bc]) {
				bcEl.insertAdjacentHTML('beforeend', '<span class="crumb"> ' + breadcrumbs[bc].outerHTML + ' </span>');
			}
		}
		qsa(".toc-unfold", bcEl).forEach(function(el) {
			el.addEventListener('click', function() {
				var tid = this.getAttribute("data-tid");
				this.href = tid + ".html";
				updateTOC(tid);
				qs("#iframe").setAttribute("src", tid + ".html?tid=" + tid);
			});
		});
		qsa(".toc-link", bcEl).forEach(function(el) {
			el.addEventListener('click', function() {
				updateTOC(this.getAttribute("data-tid"));
			});
		});
	};

	/* unfolds nested TOC entries, highlights and scrolls to active entry */
	function updateTOC(tid) {
		var topic = qs('#topic-tree .toc-link[data-tid="' + tid + '"]');
		if (!topic) return;
		var nested = parents(topic, ".nested");
		nested.forEach(function(el) {
			el.classList.add("active");
			var li = el.parentElement;
			if (li) {
				var ch = li.children;
				for (var c = 0; c < ch.length; c++) {
					if (ch[c].matches && ch[c].matches(".caret")) {
						ch[c].classList.add("caret-down");
						break;
					}
				}
			}
		});
		qsa(".activated").forEach(function(el) { el.classList.remove("activated"); });
		topic.classList.add("activated");
		try {
			var sidenav = topic.closest("#sidenav");
			if (sidenav) sidenav.scroll(0, findPos(topic) - 120);
		} catch(e) {}
		updateBreadcrumbs(topic);
	};

	/* update GUI when on TOC link clicked */
	function tocLinkClicked() {
		qsa(".activated").forEach(function(el) { el.classList.remove("activated"); });
		var src = qs("#search-result-container");
		if (src) src.style.display = "none";
		qs("#breadcrumbs").style.display = "";
		qs("#iframe").style.display = "";
		document.body.style.overflow = "hidden";
		document.body.style.marginTop = "0px";
	};
	
	function normalizeComparedText(txt) {
		var string = txt || "";
    	string = string.replace(/\u00c4/g, "A");
    	string = string.replace(/\u00dc/g, "U");
    	string = string.replace(/\u00d6/g, "O");
    	string = string.replace(/\u00fc/g, "u");
    	string = string.replace(/\u00e4/g, "a");
    	string = string.replace(/\u00f6/g, "o");
    	string = string.replace(/\u00df/g, "s");
    	string = string.replace(/ae/g, "a");
    	string = string.replace(/ue/g, "u");
    	string = string.replace(/oe/g, "o");
    	string = string.replace(/ss/g, "s");
    	string = string.replace(/á/g, "a");
		string = string.toUpperCase();
    	return string;
	}

	/* implement autocomplete search field */
	function autocomplete(inp, idx_autocomplete, submitSearchFn) {
		var currentFocus;
		if(!inp) return;
		inp.addEventListener("input", function(e) {
			var a, b, i, val = this.value;
			var arr = updateWords(this.value, idx_autocomplete);
			closeAllLists();
			if (!val) { return false; }
			currentFocus = -1;
			a = document.createElement("DIV");
			a.setAttribute("id", this.id + "autocomplete-list");
			a.setAttribute("class", "autocomplete-items");
			this.parentNode.appendChild(a);
			for (i = 0; i < arr.length; i++) {
				if (normalizeComparedText(arr[i].substr(0, val.length).toUpperCase()) == normalizeComparedText(val)) {
					b = document.createElement("DIV");
					b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
					b.innerHTML += arr[i].substr(val.length);
					b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
					b.addEventListener("click", function(e) {
						inp.value = this.getElementsByTagName("input")[0].value;
						closeAllLists();
						submitSearchFn();
					});
					a.appendChild(b);
				}
			}
			qs("#breadcrumbs").style.zIndex = "-10";
		});
		inp.addEventListener("keydown", function(e) {
			var x = document.getElementById(this.id + "autocomplete-list");
			if (x) x = x.getElementsByTagName("div");
			if (e.keyCode == 40) {
				currentFocus++;
				addActive(x);
			} else if (e.keyCode == 38) {
				currentFocus--;
				addActive(x);
			} else if (e.keyCode == 13) {
				e.preventDefault();
				if (currentFocus > -1) {
					if (x) {
						inp.value = x[currentFocus].textContent;
						closeAllLists();
						submitSearchFn();
					}
				} else {
					submitSearchFn();
				}
			}
		});
		function addActive(x) {
			if (!x) return false;
			removeActive(x);
			if (currentFocus >= x.length) currentFocus = 0;
			if (currentFocus < 0) currentFocus = (x.length - 1);
			x[currentFocus].classList.add("autocomplete-active");
		};
		function removeActive(x) {
			for (var i = 0; i < x.length; i++) {
				x[i].classList.remove("autocomplete-active");
			}
		};
		function closeAllLists(elmnt) {
			var x = document.getElementsByClassName("autocomplete-items");
			for (var i = 0; i < x.length; i++) {
				if (elmnt != x[i] && elmnt != inp) {
					x[i].parentNode.removeChild(x[i]);
				}
			}
		}
		document.addEventListener('click', function(e) {
			closeAllLists(e.target);
			qs("#breadcrumbs").style.zIndex = "10";
		});
	};

	/* initializes all click handlers */
	function initNavigation() {
		
		var shifted = false;	
		var dynav = qs("#dyOnlinhelpNavigation");
		if (dynav) dynav.style.display = "none";
		
		var topicId = getUrlParameter("tid");
		if (topicId) {
			updateTOC(topicId);
			qs("#iframe").setAttribute("src", topicId + ".html?tid=" + topicId);
		}
		
		var language = (qs("#language") || {}).textContent || "de";
		var	idx_autocomplete = lunr(function() {
				if(language != "en")
				this.use(lunr[language]);
				this.ref('tid');
				this.field('content');
				documents.forEach(function(doc) {
					this.add(doc)
				}, this)
			});
		var idx = idx_autocomplete;
		var inp = document.getElementById("search");

		function doSearch() {
			qs("#search-result").innerHTML = "";
			if (!inp.value.length) return;
			var searchResult = idx.search(inp.value.replace("\:"," "));
			if (!searchResult.length) {
				qs("#search-result").insertAdjacentHTML('beforeend',
					'<li style="color:#CAD400">Keine Treffer!</li>');
			}
			else {
				var i = 0;
				while (i < searchResult.length) {
					var tid = searchResult[i].ref;
					qs("#search-result").insertAdjacentHTML('beforeend',
						'<li><a class="search-link" target="content" href="' + tid + '.html?search=' +
						encodeURIComponent(inp.value.replace("\:"," ")) + '&tid=x" data-tid="' + tid + '">' +
						mapping["_" + tid] + '</a></li>');
					i++;
				}
			}
			if(!qs("#search-result-container")) {
				var sr = qs("#search-result");
				var wrapper = document.createElement("div");
				wrapper.id = "search-result-container";
				sr.parentNode.insertBefore(wrapper, sr);
				wrapper.appendChild(sr);
				wrapper.style.height = (qs("#main").clientHeight - 122) + "px";
			}
			qs("#iframe").style.display = "none";
			qsa(".search-link").forEach(function(link) {
				link.addEventListener('click', function(e) {
					qs("#search-result-container").style.display = "none";
					qs("#breadcrumbs").style.display = "block";
					qs("#sidebarbtn").style.top = "26px";
					qs("#iframe").style.display = "block";
					document.body.style.overflow = "hidden";
					document.body.style.marginTop = "0px";
					updateTOC(this.getAttribute("data-tid"));
				});
			});
			qs("#search-result-container").style.display = "block";
			qs("#breadcrumbs").style.display = "none";
			qs("#sidebarbtn").style.top = "42px";
		}

		autocomplete(inp, idx_autocomplete, doSearch);

		qs("#search-form").addEventListener("submit", function(e) {
			e.preventDefault();
			doSearch();
		});
		// sidepanel button
		qs("#sidebarbtn").addEventListener('click', function() {
			if (this.classList.contains("open")) {
				this.classList.remove("open");
				this.classList.add("closed");
				qs("#sidenav").style.width = "0px";
				qs("#main").style.marginLeft = "0px";
				qs("img", this).setAttribute("src", "./res/images/book_icon.png");
			} else {
				this.classList.remove("closed");
				this.classList.add("open");
				qs("#sidenav").style.width = (window.innerWidth / NAVIGATION_SETTINGS.NAVIGATION_FRACTION) + "px";
				qs("#main").style.marginLeft = (window.innerWidth / NAVIGATION_SETTINGS.NAVIGATION_FRACTION) + "px";
				qs("img", this).setAttribute("src", "./res/images/toc_open_close.png");
			}
		});
		
		if(getUrlParameter("menu")=="true") {
			qs("#sidebarbtn").click();
		}
		
		if (dynav) dynav.style.display = "";

		var toggler = document.getElementsByClassName("caret");
		var i;
		for (i = 0; i < toggler.length; i++) {
			toggler[i].addEventListener("click", function() {
				this.parentElement.querySelector(".nested").classList.toggle("active");
				this.classList.toggle("caret-down");
			});
		}
		// handle clicks in TOC
		qsa(".toc-link").forEach(function(el) {
			el.addEventListener('click', function() {
				if (this.getAttribute("data-is-meta-topic") == 'true') {
					window.location.href = "index.html?meta=true";
				} else {
					tocLinkClicked();
					updateTOC(this.getAttribute("data-tid"));
				}
			});
		});
		// handle message received from iframe
		window.addEventListener("message", function(event) {
			if(!event.data) return;
			if (event.data == 'click') {
				//
			} else if (event.data == "shift") {
				shifted = true;	
			} else if (event.data.startsWith("key")) {
				dispatchKeyShortcut(event.data.substring(4))
			} else {
				updateTOC(event.data);
			}
		});
		// jump from one topic to the next
		var topics = qsa("#topic-tree .toc-link[data-tid]");
		qs("#nexttopicbtn").addEventListener('click', function() {
			var src = qs("#search-result-container");
			if (src && src.offsetParent !== null) return false;
			topicIdx++;
			if (topicIdx == topics.length) topicIdx = 0;
			var topicId = topics[topicIdx].getAttribute("data-tid");
			updateTOC(topicId);
			qs("#iframe").setAttribute("src", topicId + ".html?tid=" + topicId);
		});
		qs("#prevtopicbtn").addEventListener('click', function() {
			var src = qs("#search-result-container");
			if (src && src.offsetParent !== null) return false;
			topicIdx--;
			if (topicIdx == -1) topicIdx = topics.length - 1;
			var topicId = topics[topicIdx].getAttribute("data-tid");
			updateTOC(topicId);
			qs("#iframe").setAttribute("src", topicId + ".html?tid=" + topicId);
		});

		// update element position if window was resized
		window.addEventListener('resize', function() {
			if (qs("#sidebarbtn").classList.contains("open")) {
				qs("#sidenav").style.width = (window.innerWidth / NAVIGATION_SETTINGS.NAVIGATION_FRACTION) + "px";
				qs("#sidenav").style.height = (window.innerHeight - 42) + "px";
				qs("#main").style.marginLeft = (window.innerWidth / NAVIGATION_SETTINGS.NAVIGATION_FRACTION) + "px";
				qs("#iframe").style.height = (window.innerHeight - NAVIGATION_SETTINGS.SIDENAV_HOFFSET) + "px";
			}
		});
			
		qsa(".toc-link").forEach(function(el) {
			el.addEventListener('click', function() {
				this.classList.add("activated");
				topicIdx = Array.prototype.indexOf.call(qsa(".toc-link"), this);
			});
		});
		// adjust iframe a and accordion height
		qs("#iframe").style.height = (window.innerHeight - NAVIGATION_SETTINGS.SIDENAV_HOFFSET) + "px";
		qs("#sidenav").style.height = (window.innerHeight - 42) + "px";
		
		// key shortcuts
		document.addEventListener('keydown', function(e) {
    		if(e.shiftKey) shifted = true;
		});
		document.addEventListener('keyup', function(e) {
    		dispatchKeyShortcut(e.keyCode);
		});
		
		function dispatchKeyShortcut(keyCode) {
   			if(shifted) {
				shifted = false;
				if(keyCode==39) qs("#nexttopicbtn").click();
				else if(keyCode==37) qs("#prevtopicbtn").click();
				else if(keyCode==70) { var el = qs("#search"); if(el) el.focus(); }
			}
		}
    };

	function initContentPages() {

		var topicId = (qs("#tid") || {}).textContent;
		if (!getUrlParameter("tid") && getUrlParameter("menu")!="none") window.location.href = "nav.html?tid=" + topicId + "&menu=" + (getUrlParameter("menu") || "false");

		var scrollTopButton = document.getElementById("scrollTopBtn");

		window.onscroll = function() { scrollFunction() };

		function scrollFunction() {
			if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
				scrollTopButton.style.display = "flex";
			} else {
				scrollTopButton.style.display = "none";
			}
		}

		if (scrollTopButton) {
			scrollTopButton.addEventListener('click', function() {
				document.body.scrollTop = 0;
				document.documentElement.scrollTop = 0;
			});
		}

		var sw = getUrlParameter("search");
		var searchWord = "";
		if (sw) {
			searchWord = decodeURIComponent(sw);
			var options = {};
			options.separateWordSearch = true;
			options.diacritics = true;
			options.accuracy = "complementary";
			new Mark(document.body).mark(searchWord, options);
			try {
				var firstMark = document.querySelector("mark");
				if (firstMark) document.body.scrollTop = firstMark.offsetTop - 60;
			} catch(e) {}
		}

		qsa(".content-link").forEach(function(el) {
			el.addEventListener('click', function(e) {
				parent.postMessage(this.getAttribute("data-tid"), '*');
			});
		});
		
		document.addEventListener('keydown', function(e) {
    		if(e.shiftKey) parent.postMessage("shift", '*');
		});
		document.addEventListener('keyup', function(e) {
    		parent.postMessage("key-"+e.keyCode, '*');
		});
		
		var printIcon = qs("#print-icon");
		if (printIcon) {
			printIcon.addEventListener('click', function() {
				window.print();
			});
		}
	};

	function initMetaPage() {
		var startBtn = qs("#startbtn");
		if (startBtn) {
			startBtn.addEventListener('click', function() {
				window.location.href = this.getAttribute("data-href") + "?menu=true";
			});
		}
	};
	return {
		makeNavigation: function(settings) {
			NAVIGATION_SETTINGS = settings;
			initNavigation();
		},
		handleContentPages: function(settings) {
			CONTENT_SETTINGS = settings;
			initContentPages();
		},
		handleMetaPage: function(settings) {
			META_SETTINGS = settings;
			initMetaPage();
		}
	};
})();

