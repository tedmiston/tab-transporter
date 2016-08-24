if application "Safari" is not running then
	display alert "Safari is not running."
	return
end if

tell application "Safari"
	if (count windows) = 0 then
		display alert "There are no open tabs to transport."
		return
	end if
end tell

tell application "Safari"
	if get front window is miniaturized then
		display alert "The frontmost window has been ignored due to being minimized."
		return
	end if
end tell

-- stash tabs from Safari's frontmost window
set urls to {}
tell application "Safari"
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
end tell

if (count of urls) = 0 then
	display alert "There are no valid URLs to transport."
	return
end if

-- close it
tell application "Safari"
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
