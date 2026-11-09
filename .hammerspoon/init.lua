-- Mouse shortcuts Karabiner can't do: it never sees scroll-wheel input, and
-- remapping clicks there means letting it grab the mouse and trackpads, which
-- breaks trackpad gestures and Logi Options+. Hammerspoon rewrites the events
-- after the devices (and Options+) have produced them.
--
-- Also the keyboard remaps that used to be Karabiner rules, since the company's
-- device management blocks Karabiner's virtual keyboard driver.
--
-- Needs Accessibility access (System Settings → Privacy & Security), and a
-- Hammerspoon relaunch after granting it.

require 'hs.ipc' -- lets the `hs` CLI drive this instance, e.g. `hs -c 'hs.reload()'`
hs.autoLaunch(true)

local types = hs.eventtap.event.types
local props = hs.eventtap.event.properties
local masks = hs.eventtap.event.rawFlagMasks

-- Same list as the old Karabiner "Ctrl(+Shift)+key also sends Cmd(+Shift)+key" rule.
local KITTY = 'net.kovidgoyal.kitty'
local terminals = {
  ['net.kovidgoyal.kitty'] = true,
  ['com.apple.Terminal'] = true,
  ['com.googlecode.iterm2'] = true,
  ['com.mitchellh.ghostty'] = true,
  ['com.github.wez.wezterm'] = true,
  ['org.alacritty'] = true,
  ['dev.warp.Warp-Stable'] = true,
}

local function terminal_is_frontmost()
  local app = hs.application.frontmostApplication()
  return app ~= nil and terminals[app:bundleID()] == true
end

-- [[ Ctrl+scroll up/down → bigger/smaller text, everywhere ]]
-- Sends ⌘+ and ⌘−. ⌘+ goes out as ⌘⇧=: Cocoa and Electron menus only match the
-- shifted key, and kitty, browsers and Cursor accept it too. "Up" is whatever
-- scrolls the page up: Options+ keeps the MX Master wheel in standard direction,
-- trackpads follow natural scrolling.
--
-- Options+ generates the MX Master's wheel events itself, one per notch, and
-- stamps them with whatever modifiers macOS last saw. So:
--  * the keystrokes go straight to the frontmost app: posted system-wide, their
--    ⌘⇧ would end up on the next notches, which then no longer match Ctrl+scroll
--  * the thumb button's ⌘ (an Options+ keystroke) only ever exists on those wheel
--    events, so a ⌘ that no keyboard is holding counts as Ctrl

local STEP_POINTS = 50 -- trackpad travel per extra step
local BURST_GAP = 0.15 -- seconds without scrolling that end a swipe

local keyboard_mods = {} -- held on real keyboards, Karabiner's virtual one included
local burst = { last = 0, dir = 0, travel = 0 }

local function change_text_size(dir)
  local app = hs.application.frontmostApplication()
  if dir > 0 then
    hs.eventtap.keyStroke({ 'cmd', 'shift' }, '=', 0, app)
  else
    hs.eventtap.keyStroke({ 'cmd' }, '-', 0, app)
  end
end

local function on_flags(e)
  if e:getProperty(props.eventSourceUnixProcessID) == 0 then
    keyboard_mods = e:getFlags()
  end
  return false
end

local function on_scroll(e)
  local f = e:getFlags()
  local cmd = f.cmd and keyboard_mods.cmd
  local ctrl = f.ctrl or (f.cmd and not keyboard_mods.cmd)
  if not ctrl or cmd or f.alt or f.shift or f.fn then
    return false
  end
  -- Drop trackpad inertia, so a flick neither keeps zooming nor scrolls the page.
  if e:getProperty(props.scrollWheelEventMomentumPhase) ~= 0 then
    return true
  end
  local dy = e:getProperty(props.scrollWheelEventPointDeltaAxis1)
  if dy == 0 then
    return false -- horizontal scrolling passes through
  end

  local dir = dy > 0 and 1 or -1
  -- Only trackpad events carry a scroll phase; anything else is a wheel notch.
  if e:getProperty(props.scrollWheelEventScrollPhase) == 0 then
    change_text_size(dir)
    return true
  end
  local now = hs.timer.secondsSinceEpoch()
  if now - burst.last > BURST_GAP or dir ~= burst.dir then
    -- A swipe steps right away, then once per STEP_POINTS.
    burst.travel = 0
    change_text_size(dir)
  else
    burst.travel = burst.travel + math.abs(dy)
    while burst.travel >= STEP_POINTS do
      burst.travel = burst.travel - STEP_POINTS
      change_text_size(dir)
    end
  end
  burst.last, burst.dir = now, dir
  return true
end

-- [[ Ctrl(+Shift)+click → Cmd(+Shift)+click, except in terminals ]]
-- Mirrors the Karabiner Ctrl→Cmd keyboard rule, so Opt and Cmd combos are left
-- alone. The modifier is swapped on the click events themselves, so drags and
-- trackpad taps work too. Context menus are on right-click now, outside terminals.
--
-- [[ Cmd+click → Shift+Cmd+click in Skim ]]
-- Skim's SyncTeX backward search (jump to the source line in Neovim) is fixed to
-- ⇧⌘-click, with no setting to change it; Skim's own ⌘-click takes a snapshot.
-- This runs after the Ctrl swap, so a Ctrl+click turned ⌘-click counts too. It
-- goes by the window under the pointer, not the frontmost app: after an inverse
-- search kitty is in front, and the next ⌘-click lands on Skim behind it.

local SKIM = 'net.sourceforge.skim-app.skim'
local CTRL = masks.control | masks.deviceLeftControl | masks.deviceRightControl
local CMD = masks.command | masks.deviceLeftCommand
local SHIFT = masks.shift | masks.deviceLeftShift

-- Both decided on mouse down, kept for the drag and release.
local remap_click = false
local sync_click = false

-- hs.window.list() is the window server's on-screen list, front to back. It takes
-- ~5 ms and, unlike Accessibility, can't hang on a busy app. (The click's own
-- window-under-pointer fields are still 0 when this tap sees it.)
local function skim_is_under(p)
  for _, w in ipairs(hs.window.list()) do
    local b = w.kCGWindowBounds
    if w.kCGWindowAlpha > 0 and p.x >= b.X and p.x < b.X + b.Width and p.y >= b.Y and p.y < b.Y + b.Height then
      local app = hs.application.applicationForPID(w.kCGWindowOwnerPID)
      return app ~= nil and app:bundleID() == SKIM
    end
  end
  return false
end

local function on_click(e)
  local down = e:getType() == types.leftMouseDown
  local f = e:getFlags()
  if down then
    remap_click = f.ctrl and not (f.cmd or f.alt or f.fn) and not terminal_is_frontmost()
  end
  if remap_click and f.ctrl then
    e:rawFlags((e:rawFlags() & ~CTRL) | CMD)
    f = e:getFlags()
  end
  if down then
    sync_click = f.cmd and not (f.shift or f.ctrl or f.alt or f.fn) and skim_is_under(e:location())
  end
  if sync_click and f.cmd then
    e:rawFlags(e:rawFlags() | SHIFT)
  end
  return false
end

-- [[ Mouse Back/Forward buttons → ⌘[ / ⌘] in Skim ]]
-- Options+ sends the side buttons as a swipe gesture (NSEventTypeSwipe), which
-- Skim ignores; its Go → Back/Forward only answer to the keys. Each press is a
-- begin/end pair, and only the end carries the direction. The field numbers are
-- undocumented CGEvent ones, read off Options+'s events. Trackpad swipes that
-- macOS turns into Back/Forward arrive the same way, so they work too.

local GESTURE_HID_TYPE = 110 -- 16: swipe
local GESTURE_PHASE = 132 -- 1: began, 4: ended
local SWIPE_DIRECTION = 115 -- 4: back, 8: forward
local SWIPE_KEYS = { [4] = '[', [8] = ']' }

local function on_gesture(e)
  if e:getProperty(GESTURE_HID_TYPE) ~= 16 or e:getProperty(GESTURE_PHASE) ~= 4 then
    return false
  end
  local key = SWIPE_KEYS[e:getProperty(SWIPE_DIRECTION)]
  local app = hs.application.frontmostApplication()
  if key and app ~= nil and app:bundleID() == SKIM then
    hs.eventtap.keyStroke({ 'cmd' }, key, 0, app)
  end
  return false
end

-- [[ Keyboard remaps, formerly Karabiner rules ]]
--  * Ctrl(+Shift)+letter/digit/punctuation → Cmd(+Shift), except in terminals
--  * Ctrl+= / Ctrl+_ → smaller / bigger text, the way kitty.conf has them,
--    except in terminals (Karabiner did this for the Iris only; Hammerspoon
--    can't tell keyboards apart, so it's every keyboard now)
--  * Ctrl+arrows → Opt+arrows (word / paragraph movement), everywhere
--  * Ctrl+Delete → Opt+Delete (previous word, not the whole line), except in kitty
--  * Ctrl+Fwd-Delete → Opt+Fwd-Delete (next word), except in terminals
-- Caps Lock → Control is macOS's own Modifier Keys setting, per keyboard.
--
-- The flags are swapped on the key events themselves, like the clicks above, so
-- auto-repeat works. While Secure Input is on (a password field has focus, or an
-- app left it on), macOS hides keystrokes from event taps and none of this
-- applies. If Karabiner works again its rules act first, and these never match:
-- they all need a Ctrl that Karabiner has already replaced.

local keycodes = hs.keycodes.map
local ALT = masks.alternate | masks.deviceLeftAlternate

local CMD_KEYS = {}
for k in ('abcdefghijklmnopqrstuvwxyz0123456789-=[]\\;\',./'):gmatch('.') do
  CMD_KEYS[keycodes[k]] = true
end
local ARROWS = { [keycodes.left] = true, [keycodes.right] = true, [keycodes.up] = true, [keycodes.down] = true }

-- What a key press turns into ({ clear, set } flags, or { zoom = dir }), or nil.
local function key_remap(code, f)
  if not f.ctrl then
    return nil
  end
  local app = hs.application.frontmostApplication()
  local id = app and app:bundleID()
  if code == keycodes.delete then
    return id ~= KITTY and { clear = CTRL, set = ALT } or nil
  end
  if f.cmd or f.alt then
    return nil
  end
  -- Arrows and forward delete always carry the fn flag.
  if ARROWS[code] then
    return not f.shift and { clear = CTRL, set = ALT } or nil
  end
  if terminals[id] then
    return nil
  end
  if code == keycodes.forwarddelete then
    return not f.shift and { clear = CTRL, set = ALT } or nil
  end
  if f.fn then
    return nil
  end
  if code == keycodes['='] and not f.shift then
    return { zoom = -1 }
  end
  if code == keycodes['-'] and f.shift then
    return { zoom = 1 }
  end
  return CMD_KEYS[code] and { clear = CTRL, set = CMD } or nil
end

-- Decided on key down, kept for the repeats and the release.
local held_keys = {}

local function on_key(e)
  local code = e:getKeyCode()
  local down = e:getType() == types.keyDown
  local remap = held_keys[code]
  if not down then
    held_keys[code] = nil
  elseif e:getProperty(props.keyboardEventAutorepeat) == 0 then
    remap = key_remap(code, e:getFlags())
    held_keys[code] = remap
  end
  if remap == nil then
    return false
  end
  if remap.zoom then
    if down then
      change_text_size(remap.zoom)
    end
    return true
  end
  e:rawFlags((e:rawFlags() & ~remap.clear) | remap.set)
  return false
end

-- [[ Ctrl+Opt+Cmd+Shift+Return / B → new kitty / Firefox window, from anywhere ]]
-- When the app is running, its binary hands the request to the running copy;
-- otherwise `open` starts it, which opens a window anyway. kitty's handoff needs
-- --single-instance in .config/kitty/macos-launch-services-cmdline.

local HYPER = { 'ctrl', 'alt', 'cmd', 'shift' }
local launches = {} -- running tasks, so they aren't garbage-collected

local function launcher(cmd)
  return function()
    local task
    task = hs.task.new('/bin/sh', function()
      launches[task] = nil
    end, { '-c', cmd })
    launches[task] = true
    task:start()
  end
end

hyper_keys = {
  hs.hotkey.bind(HYPER, 'return', launcher(
    'if /usr/bin/pgrep -aqx kitty; then /Applications/kitty.app/Contents/MacOS/kitty --single-instance --directory ~; else /usr/bin/open -a kitty; fi'
  )),
  hs.hotkey.bind(HYPER, 'b', launcher(
    'if /usr/bin/pgrep -aqx firefox; then /Applications/Firefox.app/Contents/MacOS/firefox --new-window; else /usr/bin/open -a Firefox; fi'
  )),
}

-- Globals, so the taps aren't garbage-collected.
taps = {
  hs.eventtap.new({ types.flagsChanged }, on_flags),
  hs.eventtap.new({ types.scrollWheel }, on_scroll),
  hs.eventtap.new({ types.leftMouseDown, types.leftMouseDragged, types.leftMouseUp }, on_click),
  hs.eventtap.new({ types.gesture }, on_gesture),
  hs.eventtap.new({ types.keyDown, types.keyUp }, on_key),
}
for _, tap in ipairs(taps) do
  tap:start()
end

-- macOS switches off a tap whose callback ever stalls; switch it back on.
tap_watchdog = hs.timer.doEvery(5, function()
  if not hs.accessibilityState() then
    return
  end
  for _, tap in ipairs(taps) do
    if not tap:isEnabled() then
      tap:stop():start()
    end
  end
end)
