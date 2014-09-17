if application "Safari" is not running then
	return
end if

-- stash tabs from Safari's frontmost window
tell application "Safari"
	set urls to get URL of every tab of front window
end tell

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
