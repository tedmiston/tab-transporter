-- get all tabs from frontmost window in Safari
tell application "Safari"
	set urls to get URL of every tab of front window
end tell

-- close frontmost window in safari
tell application "Safari"
	activate
	tell application "System Events"
		keystroke "w" using {command down, shift down}
	end tell
end tell

-- open all of the tabs in Chrome
tell application "Google Chrome"
	tell (make new window)
		set URL of active tab to get item 1 of urls
		repeat with u in rest of urls
			open location u
		end repeat
	end tell
	activate
end tell
