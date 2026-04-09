#!/usr/bin/env bash

set -euo pipefail

preview_url="${1:-}"

if [[ -z "$preview_url" ]]; then
  exit 1
fi

osascript - "$preview_url" <<'APPLESCRIPT'
on run argv
  set previewUrl to item 1 of argv

  -- Read the current desktop bounds to size windows to half-screen.
  tell application "Finder"
    set screenBounds to bounds of window of desktop
  end tell
  set leftX to item 1 of screenBounds
  set topY to item 2 of screenBounds
  set rightX to item 3 of screenBounds
  set bottomY to item 4 of screenBounds
  set midX to leftX + ((rightX - leftX) div 2)

  -- Move the currently frontmost terminal window to the left half.
  tell application "System Events"
    set frontProc to first process whose frontmost is true
    if (count of windows of frontProc) > 0 then
      set position of front window of frontProc to {leftX, topY}
      set size of front window of frontProc to {midX - leftX, bottomY - topY}
    end if
  end tell

  -- Open the Typst preview in Safari, then move Safari to the right half.
  tell application "Safari"
    activate
    open location previewUrl
  end tell

  delay 0.25

  tell application "System Events"
    tell process "Safari"
      if (count of windows) > 0 then
        set position of front window to {midX, topY}
        set size of front window to {rightX - midX, bottomY - topY}
      end if
    end tell
  end tell
end run
APPLESCRIPT
