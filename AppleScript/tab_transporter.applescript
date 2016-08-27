-- Transport tabs from one browser to another.

-- config
property source_browser : "Safari"
property destination_browser : "Google Chrome"

on run
	assert_running()
	assert_has_open_window()
	set source_window to assert_frontmost()
	set urls to get_tabs(source_window)
	assert_urls_moveable(urls)
	close_tabs(source_window)
	open_tabs(urls)
end run

-- warn if browser isn't running
on assert_running()
	if application source_browser is not running then peace_out(source_browser & " is not running.")
end assert_running

-- warn if browser has no open windows
on assert_has_open_window()
	using terms from application "Safari"
		tell application source_browser to set open_window_count to count windows
	end using terms from
	if open_window_count ² 0 then peace_out("There are no open windows to transport from " & source_browser & ".")
end assert_has_open_window

-- warn if window is minimized to the Dock
on assert_frontmost()
	using terms from application "Safari"
		tell application source_browser to set source_window to front window
	end using terms from
	if source_window is miniaturized then peace_out("The frontmost window of " & source_browser & " is ignored because it is minimized.")
	return source_window
end assert_frontmost

-- collect tabs from source browser
on get_tabs(source_window)
	set urls to {} -- list of urls to transport
	using terms from application "Safari"
		tell application source_browser
			set the_tabs to get every tab of source_window
			repeat with t in the_tabs
				set u to (get URL of t)
				try
					if u is not "topsites://" then
						copy u to end of urls
					end if
				on error errorStr number errorNumber -- TODO: hmmm
					-- swallow blank tabs
				end try
			end repeat
		end tell
	end using terms from
	return urls
end get_tabs

-- warn if no urls can be moved (ex. topsites:// page)
on assert_urls_moveable(urls)
	if (count of urls) = 0 then peace_out("There are no valid URLs to transport.")
end assert_urls_moveable

-- close tabs in source browser
on close_tabs(source_window)
	using terms from application "Safari"
		-- TODO: breaks "History > Reopen Last Closed Window" in Safari
		tell application source_browser to close source_window
	end using terms from
end close_tabs

-- open tabs in destination browser
on open_tabs(urls)
	using terms from application "Google Chrome"
		tell application destination_browser
			tell (make new window)
				set URL of active tab to get item 1 of urls
				repeat with u in rest of urls
					open location u
				end repeat
			end tell
			activate
		end tell
	end using terms from
end open_tabs

-- end this script
on peace_out(error_message)
	display alert error_message
	error number -128
end peace_out
