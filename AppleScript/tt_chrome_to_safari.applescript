-- Transport tabs from one browser to another.  This script moves tabs from Chrome to Safari.

-- config
property sourceBrowser : "Google Chrome"
property destinationBrowser : "Safari"

on run
	assertRunning()
	assertHasOpenWindow()
	set sourceWindow to assertFrontmost()
	set urls to getTabs(sourceWindow)
	assertUrlsMoveable(urls)
	closeTabs(sourceWindow)
	openTabs(urls)
end run

-- warn if browser isn't running
on assertRunning()
	if application sourceBrowser is not running then peaceOut(sourceBrowser & " is not running.")
end assertRunning

-- warn if browser has no open windows
on assertHasOpenWindow()
	using terms from application "Google Chrome"
		tell application sourceBrowser to set openWindowCount to count windows
	end using terms from
	if openWindowCount ² 0 then peaceOut("There are no open windows to transport from " & sourceBrowser & ".")
end assertHasOpenWindow

-- warn if window is minimized to the Dock
on assertFrontmost()
	using terms from application "Google Chrome"
		tell application sourceBrowser to set sourceWindow to front window
	end using terms from
	if sourceWindow is miniaturized then peaceOut("The frontmost window of " & sourceBrowser & " is ignored because it is minimized.")
	return sourceWindow
end assertFrontmost

-- collect tabs from source browser, swallowing blank tabs
on getTabs(sourceWindow)
	set urls to {} -- list of urls to transport
	using terms from application "Google Chrome"
		tell application sourceBrowser
			try
				repeat with t in tabs of sourceWindow
					if URL of t is not "chrome://newtab/" then copy URL of t to end of urls
				end repeat
			end try
		end tell
	end using terms from
	return urls
end getTabs

-- warn if no urls can be moved (ex. topsites:// page)
on assertUrlsMoveable(urls)
	if (count of urls) = 0 then peaceOut("There are no valid URLs to transport.")
end assertUrlsMoveable

-- close tabs in source browser
on closeTabs(sourceWindow)
	using terms from application "Google Chrome"
		tell application sourceBrowser to close sourceWindow
	end using terms from
end closeTabs

-- open tabs in destination browser
on openTabs(urls)
	using terms from application "Safari"
		tell application destinationBrowser
			tell window 1
				repeat with u in urls
					set current tab to (make new tab with properties {URL:u})
				end repeat
			end tell
		end tell
	end using terms from
end openTabs

-- end this script
on peaceOut(errorMessage)
	display alert errorMessage
	error number -128
end peaceOut
