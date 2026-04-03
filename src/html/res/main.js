/* UWE.XSL - DITA Publishing Stylesheets
   Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
   SPDX-License-Identifier: LGPL-3.0-only
   See license.txt for the full license text. */
(function() {
	function init() {
		var typeEl = document.getElementById("TekturHelpType");
		var type = typeEl ? typeEl.textContent : "";

		switch(type) {
			case "meta":
				TEKTUR_HELP.handleMetaPage(null);
				break;
			case "content":
				TEKTUR_HELP.handleContentPages(null);
				break;
			default:
				TEKTUR_HELP.makeNavigation({
					NAVIGATION_FRACTION : 3,
					ACCORDION_ACTIVE_HOFFSET : 218,
					SIDENAV_HOFFSET : 60,
				});
		}
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', init);
	} else {
		init();
	}
})();
