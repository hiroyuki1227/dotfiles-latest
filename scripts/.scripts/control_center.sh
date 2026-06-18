#!/bin/bash

osascript -e '
tell application "System Events"
    tell process "ControlCenter"
        -- どのインデックスであっても、ControlCenterプロセスに属する最初のメニューバーアイテムを叩く
        perform action "AXPress" of menu bar item 1 of menu bar 1
    end tell
end tell
'
