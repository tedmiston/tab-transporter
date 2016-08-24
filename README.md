# Tab Transporter

Move tabs from the frontmost Safari window into Chrome.

I developed Tab Transporter out of personal utility because I couldn't find anything else that did exactly what I wanted.

Tested on Mac OS X 10.11.6.

## Use Case

- I've opened a bunch of tabs in Safari (such as new apps to check out), but I need to get them out of the way for now to focus on work
- [OneTab](https://www.one-tab.com) handles this in Chrome, but it doesn't exist for Safari
- I desire to stash all of these tabs in one centralized location

## Installation

- Open AppleScript Editor in Applications > Utilities 
- Copy and paste the contents of `/AppleScript/tab_transporter.scpt` into a new document
- File > Save
  - File Format: Application 
  - Where: Applications

## Usage

- Launch it when you want to move tabs (I type `tt` in [Alfred](http://www.alfredapp.com), but Spotlight works just as well)

## Alternatives
This section covers possible solutions that didn't work for me, which led me to create Tab Transporter.

Dr. Drang wrote a similar survey of the same problem in October 2012 in *[Saving browser tab sets](http://leancrew.com/all-this/2012/10/saving-browser-tab-sets/)*.

- [Pinboard Tab Sets](https://blog.pinboard.in/2011/04/new_save_tabs_feature/)
  - Available in the [Save tabs to Pinboard](https://pinboard.in/resources/safari/save_tabs) Safari extension (which is separate from the main [browser extensions](https://pinboard.in/resources/extensions/))
- Safari
  - `Add Bookmarks for These n Tabs` - doesn't integrate with Chrome tabs
  - `Add These n Tabs to Reading List` - doesn't sync with OneTab in Chrome, Pocket, etc.
  - `Develop > Open Page With > Google Chrome` - moves only one tab at a time
    - If you don't have this menu item, ensure this is checked: `Preferences > Advanced > Show Develop menu in menu bar`
- [Switch](http://www.macupdate.com/app/mac/42431/switch)
  - Has cross-browser sync, but... handles only one page at a time, and consumes precious menu bar real estate
  - No longer maintained
