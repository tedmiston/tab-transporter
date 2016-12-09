-- Transport tabs from one browser to another.  This script moves tabs from Safari to Google Chrome.

-- config
property sourceBrowser : "Safari"
property destinationBrowser : "Google Chrome"

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
	using terms from application "Safari"
		tell application sourceBrowser to set openWindowCount to count windows
	end using terms from
	if openWindowCount ² 0 then peaceOut("There are no open windows to transport from " & sourceBrowser & ".")
end assertHasOpenWindow

-- warn if window is minimized to the Dock
on assertFrontmost()
	using terms from application "Safari"
		tell application sourceBrowser to set sourceWindow to front window
	end using terms from
	if sourceWindow is miniaturized then peaceOut("The frontmost window of " & sourceBrowser & " is ignored because it is minimized.")
	return sourceWindow
end assertFrontmost

-- collect tabs from source browser, swallowing blank tabs
on getTabs(sourceWindow)
	set urls to {} -- list of urls to transport
	using terms from application "Safari"
		tell application sourceBrowser
			try
				repeat with t in tabs of sourceWindow
					if URL of t is not "topsites://" then copy URL of t to end of urls
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
	using terms from application "Safari"
		tell application sourceBrowser to close sourceWindow
	end using terms from
end closeTabs

-- open tabs in destination browser
on openTabs(urls)
	using terms from application "Google Chrome"
		tell application destinationBrowser
			tell (make new window)
				set URL of active tab to get item 1 of urls
				repeat with u in rest of urls
					open location u
				end repeat
			end tell
			activate
		end tell
	end using terms from
end openTabs

-- end this script
on peaceOut(errorMessage)
	display alert errorMessage
	error number -128
end peaceOut
