-- Transport tabs from one browser to another.

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
	if application sourceBrowser is not running then
		set msg to sourceBrowser & " is not running."
		peaceOut(msg)
	end if
end assertRunning

-- warn if browser has no open windows
on assertHasOpenWindow()
	using terms from application "Safari"
		tell application sourceBrowser
			set openWindowCount to count windows
		end tell
	end using terms from
	if openWindowCount ² 0 then
		set msg to "There are no open windows to transport from " & sourceBrowser & "."
		peaceOut(msg)
	end if
end assertHasOpenWindow

-- warn if window is minimized to the Dock
on assertFrontmost()
	using terms from application "Safari"
		tell application sourceBrowser
			set sourceWindow to front window
		end tell
	end using terms from
	if sourceWindow is miniaturized then
		set msg to "The frontmost window of " & sourceBrowser & " is ignored because it is minimized."
		peaceOut(msg)
	end if
	return sourceWindow
end assertFrontmost

-- collect tabs from source browser
on getTabs(sourceWindow)
	set urls to {} -- list of urls to transport
	using terms from application "Safari"
		tell application sourceBrowser
			set the_tabs to get every tab of sourceWindow
			repeat with t in the_tabs
				set u to (get URL of t)
				try
					if u is not "topsites://" then
						copy u to end of urls
					end if
				on error errorStr number errorNumber
					-- swallow blank tabs
				end try
			end repeat
		end tell
	end using terms from
	return urls
end getTabs

-- warn if no urls can be moved (ex. topsites:// page)
on assertUrlsMoveable(urls)
	if (count of urls) = 0 then
		set msg to "There are no valid URLs to transport."
		peaceOut(msg)
	end if
end assertUrlsMoveable

-- close tabs in source browser
on closeTabs(sourceWindow)
	using terms from application "Safari"
		tell application sourceBrowser
			-- TODO: breaks "History > Reopen Last Closed Window" in Safari
			close sourceWindow
		end tell
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
