if application "Safari" is not running then
	display alert "Safari is not running."
	return
end if

set urls to {}

tell application "Safari"
	if (count windows) = 0 then
		display alert "There are no open tabs to transport."
		return
	end if
	
	if get front window is miniaturized then
		display alert "The frontmost window has been ignored due to being minimized."
		return
	end if
	
	-- stash tabs from Safari's frontmost window
	set the_tabs to get every tab of front window
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
	
	if (count of urls) = 0 then
		display alert "There are no valid URLs to transport."
		return
	end if
	
	-- close it
	activate
	tell application "System Events"
		keystroke "w" using {command down, shift down}
	end tell
end tell

-- open the tabs in Chrome
tell application "Google Chrome"
	tell (make new window)
		set URL of active tab to get item 1 of urls
		repeat with u in rest of urls
			open location u
		end repeat
	end tell
	
	activate
end tell
