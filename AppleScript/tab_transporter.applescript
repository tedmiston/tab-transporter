set sourceBrowser to "Safari"
set destinationBrowser to "Google Chrome"

if application sourceBrowser is not running then
	display alert sourceBrowser & " is not running."
	return
end if

set urls to {} -- a list of tab urls to transport

-- collect tabs open in the frontmost window of source browser
using terms from application "Safari"
	tell application sourceBrowser
		
		-- exit if no tabs are open
		if (count windows) = 0 then
			display alert "There are no open tabs to transport from " & sourceBrowser & "."
			return
		end if
		
		set currentWindow to front window
		
		-- exit if no frontmost tabs are open
		if currentWindow is miniaturized then
			display alert "The frontmost window of " & sourceBrowser & " is ignored because it is minimized."
			return
		end if
		
		-- stash tabs from source browser's frontmost window
		set the_tabs to get every tab of currentWindow
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
		
		-- exit if no valid tabs
		if (count of urls) = 0 then
			display alert "There are no valid URLs to transport."
			return
		end if
		
		close currentWindow -- close window in source browser
		
	end tell
end using terms from

-- open tabs in desination browser
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
