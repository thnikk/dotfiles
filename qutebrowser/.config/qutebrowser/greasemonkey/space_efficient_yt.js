// ==UserScript==
// @name        Space-efficient Youtube
// @namespace   1N07
// @author      1N07
// @icon        https://i.imgur.com/VgEiyi3.png
// @icon64      https://i.imgur.com/VgEiyi3.png
// @description AKA: "Wide Youtube", AKA: "Wide video container" - Uses the page space on youtube more efficiently (especially good for high resolutions)
// @include     https://www.youtube.com/*
// @version     2.3.1
// @require     https://openuserjs.org/src/libs/sizzle/GM_config.js
// @grant       GM_registerMenuCommand
// @grant       GM_unregisterMenuCommand
// @grant       GM_getValue
// @grant       GM_setValue
// @noframes
// ==/UserScript==

(function() {
    if(true)
    {
        var configCSS = `
			#SEYConfig {
				width: 320px !important;
				height: 670px !important;
				max-height: 100% !important;
				border: none !important;
				border-radius: 0 0 0 20px !important;
				box-shadow: black -1px 1px 20px;
				position: fixed !important;
				top: 0 !important;
				right: 0 !important;
				left: unset !important;
				background: #383838 !important;
			}

			#SEYConfig_wrapper
			{
				padding: 10px;
				background-color: #212121;
				color: white;
				background-color: transparent;
			}

			#SEYConfig .config_var
			{
				padding: 1px 20px;
			}

			#SEYConfig input
			{
				background-color: #181818;
				color: white;
				border: none;
				float: left;
				margin-right: 5px;
			}

			#SEYConfig input[type="text"]
			{
				width: 40px;
				text-align: center;
			}

			#SEYConfig input[type="checkbox"]
			{
				filter: invert(90%);
			}

			#SEYConfig .saveclose_buttons
			{
				background-color: #181818;
				color: white;
				border-color: gray;
			}

			#SEYConfig .section_header {
				background: #202020;
				margin-bottom: 5px;
			}

			#SEYConfig .section_header_holder {
				margin-top: 8px;
				background-color: rgba(0,0,0,0.3);
				padding: 0 0 5px 0;
				border-radius: 0 0 10px 10px;
			}

			#SEYConfig_resetLink { color: white !important; }
		`;
    }

    var frame = document.createElement('div');
    frame.id = "SEYConf";
    document.body.appendChild(frame);

    GM_config.init(
        {
            'id': 'SEYConfig', // The id used for this instance of GM_config
            'title': 'Space-efficient Youtube Config',
            'fields': // Fields object
            {
                'FPPCompOn': // This is the id of the field
                {
                    'section': 'Fade++',
                    'label': 'Fade++ compatibility mode', // Appears next to field
                    'type': 'checkbox', // Makes this setting a text field
                    'default': false // Default value if user doesn't change it
                },

                'HomeVideoContainerWidth':
                {
                    'section': 'Home page',
                    'label': 'Video container width',
                    'title': 'The width of the container which includes both the thumbnail and the title/other info',
                    'type': 'unsigned float',
                    'default': '360'
                },
                'ShowChannelIconNextToVideosOnHomePage':
                {
                    'label': 'Show channel icon in video container',
                    'type': 'checkbox',
                    'default': true
                },

                'SubVideoContainerWidth':
                {
                    'section': 'Subscriptions page',
                    'label': 'Video container width',
                    'title': 'The width of the container which includes both the thumbnail and the title/other info',
                    'type': 'unsigned float',
                    'default': '210'
                },

                'TrendingVideoContainerWidth':
                {
                    'section': 'Trending page',
                    'label': 'Video container width',
                    'title': 'The width of the container which includes both the thumbnail and the title/other info',
                    'type': 'unsigned float',
                    'default': '600'
                },
                'TrendingVideoContainerHeight':
                {
                    'label': 'Video container height',
                    'title': 'The height of the container. This directly affects thumnail size and how much space is left for the other info',
                    'type': 'unsigned float',
                    'default': '138'
                },

                'HQTN':
                {
                    'section': 'Subscriptions & Trending pages',
                    'label': 'Load high quality thumbnails',
                    'title': 'The default thumbnail resolution is fitted for the default video container size, so if you use defaults(or smaller) there is no need to enable this.',
                    'type': 'checkbox',
                    'default': false
                },

                'SearchVideoContainerWidth':
                {
                    'section': 'Search results page',
                    'label': 'Video container width',
                    'title': 'The width of the container which includes both the thumbnail and the title/other info',
                    'type': 'unsigned float',
                    'default': '600'
                },
                'SearchVideoContainerHeight':
                {
                    'label': 'Video container height',
                    'title': 'The height of the container. This directly affects thumnail size and how much space is left for the other info',
                    'type': 'unsigned float',
                    'default': '150'
                },
                'HideSearchVideoBadges':
                {
                    'label': 'Hide video badges',
                    'title': 'Hides the little badges like New/4K/CC etc. on the video containers leaving more space for the description',
                    'type': 'checkbox',
                    'default': false
                },

                'AutoExpandChannelVidContainers':
                {
                    'section': 'Channel pages',
                    'label': 'Auto-expand horizontal video lists',
                    'type': 'checkbox',
                    'default': false
                }
            },
            'frame': frame,
            'css': configCSS
        }
    );

    var refreshAfterSave = false;
    GM_config.onOpen = function(doc, win, frame) {
        let saveBtn = $(frame).find("#SEYConfig_saveBtn");
        saveBtn.before(saveBtn.clone().prop("id", "SEYConfig_saveRefreshBtn").text("Save & Refresh"));
        $("#SEYConfig_saveRefreshBtn").click(() => {
            refreshAfterSave = true;
            $("#SEYConfig_saveBtn").click();
        });
    };
    GM_config.onSave = function(){
        $("#SEYConfig .reset_holder").prepend(`<span id="SEYCSavedNotif" style="float: left; margin: 0 0 5px 5px; color: green; font-size: 18px; font-weight: bold;">Saved!</span>`).hide().fadeIn(200, () => {
            if(refreshAfterSave)
                location.reload();
            setTimeout(() => {
                $("#SEYCSavedNotif").fadeOut(200, () => {
                    $("#SEYCSavedNotif").remove();
                });
            }, 1800);
        });
    };

    var FPPCompOn = GM_config.get('FPPCompOn');
    var HomeVideoContainerWidth = CleanNumber(GM_config.get('HomeVideoContainerWidth'));
    var ShowChannelIconNextToVideosOnHomePage = GM_config.get('ShowChannelIconNextToVideosOnHomePage');
    var SubVideoContainerWidth = CleanNumber(GM_config.get("SubVideoContainerWidth"));
    var TrendingVideoContainerWidth = CleanNumber(GM_config.get('TrendingVideoContainerWidth'));
    var TrendingVideoContainerHeight = CleanNumber(GM_config.get('TrendingVideoContainerHeight'));
    var HQTN = GM_config.get('HQTN');
    var SearchVideoContainerWidth = CleanNumber(GM_config.get('SearchVideoContainerWidth'));
    var SearchVideoContainerHeight = CleanNumber(GM_config.get('SearchVideoContainerHeight'));
    var HideSearchVideoBadges = GM_config.get('HideSearchVideoBadges');
    var AutoExpandChannelVidContainers = GM_config.get('AutoExpandChannelVidContainers');


    GM_registerMenuCommand("Settings", () => {
		if(!GM_config.isOpen)
			GM_config.open();
	});

    const ratioMultiplier = 16 / 9;
    var screenWidth = screen.width;
    if(!!document.getElementById("early-body")) { //if old youtube
        document.getElementById("content").setAttribute("style", "width: 99%;");
    } else { //new youtube
        //Main container width and padding
        if(true) {
            addGlobalStyle(`
				/*search*/
				ytd-search ytd-two-column-search-results-renderer.ytd-search,
				ytd-search ytd-two-column-search-results-renderer.ytd-search > #primary,
				/*home*/
				ytd-browse[page-subtype="home"] #contents.ytd-rich-grid-renderer,
				/*other*/
				ytd-browse > ytd-two-column-browse-results-renderer.ytd-browse
				{
					width: 100% !important;
					max-width: 100% !important;
				}

				ytd-browse > ytd-two-column-browse-results-renderer.ytd-browse > #primary,
				ytd-search
				{
					padding: 16px;
				}
			`);
        }

		//vertical lists to horizontal grid / video container sizing
		if(true) {
			//trending
			if(true) {
				addGlobalStyle(`
					/*container*/
					#grid-container.ytd-expanded-shelf-contents-renderer > .ytd-expanded-shelf-contents-renderer
					{
						display: inline-block;
						width: `+TrendingVideoContainerWidth+`px;
						height: `+TrendingVideoContainerHeight+`px;
					}
					#grid-container.ytd-expanded-shelf-contents-renderer > .ytd-expanded-shelf-contents-renderer > #dismissable
					{
						width: 100%;
						height: 100%;
					}

					/*thumnail container*/
					#grid-container.ytd-expanded-shelf-contents-renderer > ytd-video-renderer:not([use-prominent-thumbs]) ytd-thumbnail.ytd-video-renderer,
					#grid-container.ytd-expanded-shelf-contents-renderer > ytd-video-renderer:not([use-prominent-thumbs]) ytd-thumbnail #thumbnail.ytd-thumbnail yt-img-shadow.ytd-thumbnail
					{
						height: 100%;
						width: `+(TrendingVideoContainerHeight * ratioMultiplier)+`px;
					}

					/*thumnail shadow and image*/
					#grid-container.ytd-expanded-shelf-contents-renderer > ytd-video-renderer:not([use-prominent-thumbs]) ytd-thumbnail #thumbnail.ytd-thumbnail yt-img-shadow.ytd-thumbnail > img
					{
						height: 100% !important;
						width: 100% !important;
					}
				`);
			}

			//search
			if(true) {
				addGlobalStyle(`
					/*container*/
					ytd-search ytd-video-renderer, ytd-search ytd-channel-renderer, ytd-search ytd-radio-renderer, ytd-search ytd-playlist-renderer
					{
						display: inline-block;
						width: `+SearchVideoContainerWidth+`px;
						height: `+SearchVideoContainerHeight+`px;
						box-sizing: border-box;
					}
					ytd-search ytd-video-renderer > #dismissable
					{
						width: 100%;
						height: 100%;
					}

					/*thumnail container*/
					ytd-search ytd-video-renderer[use-prominent-thumbs] ytd-thumbnail.ytd-video-renderer,
					ytd-search ytd-radio-renderer[use-prominent-thumbs] ytd-thumbnail.ytd-radio-renderer,
					ytd-search ytd-playlist-renderer[use-prominent-thumbs] ytd-playlist-thumbnail.ytd-playlist-renderer
					{
						max-width: none;
						min-width: none;
						height: 100%;
						width: `+(SearchVideoContainerHeight * ratioMultiplier)+`px;
						-ms-flex: none;
						-webkit-flex: none;
						flex: none;
					}
					ytd-search ytd-radio-renderer.ytd-item-section-renderer,
					ytd-search ytd-playlist-renderer.ytd-item-section-renderer
					{
						display: flex;
					}

					/*thumnail shadow and image*/
					ytd-search ytd-thumbnail #thumbnail.ytd-thumbnail yt-img-shadow.ytd-thumbnail,
					ytd-search ytd-thumbnail #thumbnail.ytd-thumbnail yt-img-shadow.ytd-thumbnail > img
					{
						width: 100%;
						height: 100%;
					}

					/*other*/
					ytd-search #description-text.ytd-video-renderer
					{
						margin-bottom: 2px;
					}
					ytd-search ytd-video-renderer > #dismissable #channel-info
					{
						padding: 2px 0 0 0;
					}
					ytd-search #description-text.ytd-video-renderer
					{
						max-height: none;
					}
					`+(HideSearchVideoBadges ? `ytd-search ytd-badge-supported-renderer { display: none; }` : ``)+`

					/*channel thumnail container*/
					ytd-search #avatar.ytd-channel-renderer,
					ytd-search ytd-channel-renderer[use-prominent-thumbs] #avatar-section.ytd-channel-renderer .channel-link.ytd-channel-renderer,
					ytd-search ytd-channel-renderer[use-prominent-thumbs] #avatar-section.ytd-channel-renderer
					{
						width: min-content;
						width: -moz-min-content;
						flex: none;
						max-width: none;
						min-width: 0;
					}
				`);
			}

			//home
			if(true) {
				addGlobalStyle(`
					/*container*/
					ytd-browse[page-subtype="home"] ytd-rich-item-renderer
					{
						width: `+HomeVideoContainerWidth+`px;
					}
					`+(ShowChannelIconNextToVideosOnHomePage ? `` : `ytd-browse[page-subtype="home"] #avatar-link.ytd-rich-grid-media { display: none; }`)+`
				`);
			}

			//subs
			if(true) {
				addGlobalStyle(`
					/*container*/
					ytd-browse[page-subtype="subscriptions"] #items.ytd-grid-renderer > ytd-grid-video-renderer.ytd-grid-renderer
					{
						width: `+SubVideoContainerWidth+`px;
					}

					/*thumnail container*/
					ytd-browse[page-subtype="subscriptions"] ytd-thumbnail.ytd-grid-video-renderer
					{
						width: `+SubVideoContainerWidth+`px;
						height: `+(SubVideoContainerWidth / ratioMultiplier)+`px;
					}

					/*thumnail shadow and image*/
					ytd-browse[page-subtype="subscriptions"] ytd-thumbnail #thumbnail.ytd-thumbnail yt-img-shadow.ytd-thumbnail,
					ytd-browse[page-subtype="subscriptions"] ytd-thumbnail #thumbnail.ytd-thumbnail yt-img-shadow.ytd-thumbnail > img
					{
						width: 100%;
						height: 100%;
					}
				`);
			}
		}

		//video container padding/margin
		if(true) {
			//trending
			if(true) {
				addGlobalStyle(`
					#grid-container.ytd-expanded-shelf-contents-renderer > .ytd-expanded-shelf-contents-renderer
					{
						padding: 0 10px 0 0;
					}
					#grid-container.ytd-expanded-shelf-contents-renderer > .ytd-expanded-shelf-contents-renderer:not(:last-child)
					{
						margin: 0 0 10px 0;
					}
				`);
			}

			//search
			if(true) {
				addGlobalStyle(`
					ytd-search ytd-video-renderer.ytd-item-section-renderer,
					ytd-search ytd-channel-renderer.ytd-item-section-renderer,
					ytd-search ytd-radio-renderer.ytd-item-section-renderer,
					ytd-search ytd-playlist-renderer.ytd-item-section-renderer,
					ytd-search #items.ytd-vertical-list-renderer > .ytd-vertical-list-renderer
					{
						padding: 0 10px 0 0;
						margin: 10px 0 0 0;
					}
					ytd-search ytd-shelf-renderer.ytd-item-section-renderer
					{
						margin: 10px 0 0 0;
					}
				`);
			}

			//home
			if(true) {
				addGlobalStyle(`
					ytd-browse[page-subtype="home"] ytd-rich-item-renderer
					{
						margin: 0 5px 20px 5px;
					}
					ytd-browse[page-subtype="home"] ytd-rich-section-renderer
					{
						margin: 0;
					}
				`);
			}

			//subs
			if(true) {
				addGlobalStyle(`
					ytd-browse[page-subtype="subscriptions"] #items.ytd-grid-renderer > ytd-grid-video-renderer.ytd-grid-renderer
					{
						margin: 0 5px 15px 0;
					}
				`);
			}
		}

        //channel page horizontal list arrow visibility
		if(true) {
			addGlobalStyle(`
				yt-horizontal-list-renderer[at-start] #left-arrow.yt-horizontal-list-renderer .arrow.yt-horizontal-list-renderer,
				yt-horizontal-list-renderer[at-end] #right-arrow.yt-horizontal-list-renderer .arrow.yt-horizontal-list-renderer
				{
					display: block;
					opacity: 1;
				}
                `+(!!window.chrome ? `
                #left-arrow.yt-horizontal-list-renderer { left: 20px; }
                #right-arrow.yt-horizontal-list-renderer { right: 20px; }
                ` : `
                #left-arrow.yt-horizontal-list-renderer { left: 0px; }
                #right-arrow.yt-horizontal-list-renderer { right: 40px; }
                `)
            );
		}

        if(HQTN) {
            addGlobalStyle(`
				img.yt-img-shadow:not([src*='?'])
				{
					object-fit: cover;
				}
			`);
        }
        if(FPPCompOn) {
			addGlobalStyle(`
				/*========== Fade++ Compatibility ==========*/
				ytd-app #page-manager > ytd-browse:not([page-subtype="playlist"]) {
					display: block;
				}
				ytd-app[guide-persistent-and-visible] #page-manager > ytd-browse:not([page-subtype="playlist"]) ytd-two-column-browse-results-renderer.ytd-browse
				{
					margin-left: 250px !important;
				}
			`);
            //console.log("Youtube Wide video container Fade++ compatibilty style added to DOM");
        }
    }

    if(AutoExpandChannelVidContainers || HQTN)
    {
        var lastCheckedURL = window.location.href;
        URLChanged(); //for initial page load

        //poll for url changes
        setInterval(function(){
            if(lastCheckedURL != window.location.href)
            {
                lastCheckedURL = window.location.href;
                URLChanged();
            }
        }, 200);
        var waitForArrows, waitForSubsThumbnails;
    }
    /*============================================================*/

    function AutoExpandContainers()
    {
        clearInterval(waitForArrows);

        //=== clear potential old containers ===//
        let expandedEls = document.getElementsByClassName("expanded-wwc");
        //console.log("expanded els found: " + expandedEls.length);
        let numRemoved = 0;

        //seems to always remove exactly half of them only, for some reason. So I guess do this until all have been removed
        while(expandedEls.length > 0)
        {
            for(let x = 0; x < expandedEls.length; x++)
            {
                if(!!expandedEls[x])
                {
                    expandedEls[x].classList.remove("expanded-wwc");
                    //console.log(++numRemoved + " cleared");
                }
            }
            expandedEls = document.getElementsByClassName("expanded-wwc");
        }
        //=== old containers cleared ===//

        //=== unmark container arrows marked as clicked ===//
        numRemoved = 0;
        let clickedArrows = document.getElementsByClassName("clicked");
        //console.log("clicked found: " + clickedArrows.length);
        while(clickedArrows.length > 0)
        {
            for(let x = 0; x < clickedArrows.length; x++)
            {
                if(!!clickedArrows[x])
                {
                    clickedArrows[x].classList.remove("clicked");
                    //console.log(++numRemoved + " cleared");
                }
            }
            clickedArrows = document.getElementsByClassName("clicked");
        }
        //=== all arrows unmarked ===//
        //console.log("-expandedclear-");

        //check that we are on a page that can have containers
        if(lastCheckedURL.includes("/user/") || lastCheckedURL.includes("/channel/") || lastCheckedURL.includes("/c/"))
        {
            //poll for untouched containers
            waitForArrows = setInterval(function(){
                //console.log("-searching...-");
                let arrowsRight = document.querySelectorAll("yt-horizontal-list-renderer:not(.expanded-wwc) > #right-arrow > ytd-button-renderer.arrow");
                let arrowsLeft = document.querySelectorAll("yt-horizontal-list-renderer:not(.expanded-wwc) > #left-arrow > ytd-button-renderer.arrow");
                if(!!arrowsRight && arrowsRight.length > 0 && !!arrowsLeft && arrowsLeft.length > 0)
                {
                    //console.log("-found "+arrowsRight.length+"-");
                    //do the thing for found untouched containers and mark them
                    for(let i = 0; i < arrowsRight.length; i++)
                    {
                        if(!!arrowsRight[i] && arrowsRight[i].offsetParent !== null && !!arrowsLeft[i] && arrowsLeft[i].offsetParent !== null)
                        {
                            arrowsRight[i].parentElement.parentElement.classList.add("expanded-wwc");
                            arrowsRight[i].click();
                            //console.log("simulated click on right arrow");
                            arrowsRight[i].classList.add("clicked");
                            arrowsLeft[i].click();
                            //console.log("simulated click on left arrow");
                            arrowsLeft[i].classList.add("clicked");
                        }
                    }
                }
            }, 250);
        }
    }

    function SwapSubsVidThumbnailsHQ()
    {
        clearInterval(waitForSubsThumbnails);
        if(lastCheckedURL.includes("/subscriptions") || lastCheckedURL.includes("/trending"))
        {
            waitForSubsThumbnails = setInterval(function(){
                let nails = document.querySelectorAll("img.yt-img-shadow[src*='hqdefault.jpg?']");
                //console.log("found " + nails.length + " LQ nails");
                for(let i = 0; i < nails.length; i++)
                    nails[i].src = nails[i].src.split("?")[0];
            }, 200);
        }
    }

    function URLChanged()
    {
        if(AutoExpandChannelVidContainers)
            AutoExpandContainers();

        if(HQTN)
            SwapSubsVidThumbnailsHQ();
    }
    function CleanCSSValue(val)
    {
        val = val.trim();

        //if only numbers...
        if(/^\d+$/.test(val))
            val += "px"; //...add px

        return val;
    }
    function CleanNumber(val)
    {
        val = parseFloat(val);

        return val;
    }

    function addGlobalStyle(css)
    {
        var head, style;
        head = document.getElementsByTagName('head')[0];
        if (!head) { return; }
        style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = css;
        head.appendChild(style);
    }

})();