{-
xmonad config files, borrows from @Brian-yee and @Altercation
maintained by Jerry Li github: jerryCoralis
layout for Lenovo x1 carbon 5th gen.

key              | mod                                       | ctrl+mod
-----------------+-------------------------------------------+----------------------------------------------------------
          LETTERS
-----------------+-------------------------------------------+----------------------------------------------------------
a                | jump to tiled TODO: not working           | -
b                | toggle xmobar                             | -
c                | -                                         | kill focused window
d                | push window back into tiling              | -
e                | grid: jump to WS TODO: chord redesign     | -
f                |                                           | -
g                | chrome thin bars                          | chrome with startup pages
h                | shrink master window                      | bash: 2 vertical monitors TODO
i                | move to left WS                           | move focused window to left WS
j                | toggle window focus cw                    | swap focused window w/cw window
k                | shift window ccw                          | swap focused window w/ccw window
l                | expand master window                      | lock screen
m                | focus master window                       |
n                | resize viewed windows to correct          | append to ~/notes.txt w/date TODO: make prompt bigger
o                | move to right WS                          | move window to right WS
p                | -                                         | dmenu
q                | restart xmonad TODO: buggy                | logout
r                | restore minimized window TODO: why?       | -
s                | -                                         | display shell prompt TODO: get to know this high potential
t                | -                                         | emacs
u                | -                                         | -
v                | focus physical screen3                    | -
w                | swap WS with physical screens             | -
x                | focus physical screen2                    | -
y                |                                           | bash: single display TODO:double yuck
z                | focus physical screen1                    | -

-----------------+-------------------------------------------+----------------------------------------------------------
          NUMBERS
-----------------+-------------------------------------------+----------------------------------------------------------
1                |       \                                   |  \
2                |        |                                  |   |
3                |        |                                  |   |
4                |        |                                  |   |
5                |        |-- move to WS: 1 to 6             |   |
6                |        |                                  |   |-- move application to WS#, focus doesn't follow
7                |       /                                   |   |
8                |   \                                       |   |
9                |    |-- move to WS: -3, -2, -1             |   |
0                |   /                                       |  /

-----------------+-------------------------------------------+----------------------------------------------------------
    FUNCTION KEYS
-----------------+-------------------------------------------+----------------------------------------------------------
F1               |                                           |
F2               |                                           |
F3               |                                           |
F4               |                                           |
F5               |                                           |
F6               |                                           |
F7               |                                           |
F8               |                                           |
F9               |                                           |
F10              |                                           |
F11              |                                           |
F12              |                                           |
mute             |                                           |
vol down         |                                           |
vol up           |                                           |
mic toggle       |                                           |
brightness down  |                                           |
brightness up    |                                           |
display key      |                                           |
WLAN key         |                                           |
tools key        |                                           |
bluetooth        |                                           |
keyboard         |                                           |
favorites        |                                           |

-----------------+-------------------------------------------+----------------------------------------------------------
      SYMBOL KEYS
-----------------+-------------------------------------------+----------------------------------------------------------
escape           | -                                         |
home             | -                                         |
end              | -                                         |
insert           | -                                         |
delete           | -                                         |
~                | -                                         |
- _              | -                                         |
= +              | -                                         |
backspace        | -                                         |
tab              | -                                         |
[ {              | -                                         |
] }              | -                                         |
\ |              | -                                         |
capslock         | [Lctrl]                                   | [Lctrl]
; :              | -                                         |
' "              | -                                         |
enter            | -                                         |
LShift           | -                                         |
, <              | -                                         |
. >              | -                                         |
/ ?              | -                                         |
RShift           | -                                         |
fn               | [fn]                                      | [fn]
LCtrl            |                                           |
window           | [Lalt]                                    | [Lalt]
LAlt             | [window]                                  | [window]
space            | cycling tiling algorithms                 | default tiling (IM tiled)
RAlt             | [RAlt]                                    | [RAlt]
printscreen      |                                           |
RCtrl            |                                           |
page up          |                                           |
page down        |                                           |
arrow up         |                                           |
arrow down       |                                           |
arrow left       |                                           |
arrow right      |                                           |

-----------------+-------------------------------------------+----------------------------------------------------------
            MOUSE
-----------------+-------------------------------------------+----------------------------------------------------------
mouse1           | float window                              | -
mouse2           | move to top of window stack               | -
mouse3           | resize window                             | -

-}


-------------------------------------------------------------
{- modules                                                 -}
-------------------------------------------------------------

-- [system]
import Control.Monad ( liftM2, unless )
-- import Control.Monad
import Data.Monoid
import System.Exit
-- import System.Exit -- commenting this out see if we crash
import XMonad.Util.Dmenu               -- blocks input while in dmenu
import XMonad hiding ( (|||) )         -- don't use the normal |||
                                       -- operator. It conflicts with
                                       -- LayoutCombinators.

-- [xmobar]
import System.IO                       -- send data to status bar
import XMonad.Hooks.DynamicLog         -- system state
import XMonad.Hooks.SetWMName          -- Window name in status bar
import XMonad.Hooks.ManageDocks        -- Status bar not tiled over
import XMonad.Util.Run(spawnPipe)      -- Send data to status bar

-- [keybindings]
import Graphics.X11.ExtraTypes.XF86    -- Special keybindings
import XMonad.Util.EZConfig            -- Easier keybinding names

-- [prompts]
import XMonad.Prompt                   -- Core library
import XMonad.Prompt.AppendFile        -- Appends a single line to a file
import XMonad.Prompt.Man               -- Displays the man page of something
import XMonad.Prompt.Shell             -- Displays a shell prompt
import XMonad.Prompt.Window            -- Lets you see a list of windows and
                                       -- summon them or go to them.

-- [WS & Window management]
import XMonad.Actions.CycleWS          -- cycle through virtual desktops
import XMonad.Actions.CycleRecentWS    -- cycle to last WS
import XMonad.Actions.GridSelect       -- alt tab of xmonad
import XMonad.Actions.WindowMenu       -- Window mover popup
import XMonad.Hooks.UrgencyHook        -- informs DBUS & user when a program needs attention
import XMonad.Layout.NoBorders         -- Full screen windows have no borders
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.Roledex           -- For stacked cycling layout
import XMonad.Layout.ResizableTile     -- For being able to resize non-master windows
import XMonad.Layout.LayoutCombinators -- jump to specific layouts
import XMonad.Layout.Grid              -- gride layout
import XMonad.Layout.Named             -- custom layout names
import XMonad.Layout.ThreeColumns      -- three columns
import XMonad.Layout.Roledex           -- For stacked cycling layout
import XMonad.Layout.ResizableTile     -- For being able to resize non-master windows
--import XMonad.Layout.Spiral         -- For the spiral layout
import qualified XMonad.StackSet as W  -- for controling layout
import qualified Data.Map        as M

-- [Compatibility]
import XMonad.Hooks.EwmhDesktops       -- touchpad compatibility
import XMonad.Hooks.SetWMName          -- Matlab compataiblity

-- [Instant messanger]
import XMonad.Layout.IM
import Data.Ratio ((%))

-- [Swipe Gestures]
-- import XMonad.Actions.MouseGestures


-------------------------------------------------------------
{- Definitions                                             -}
-------------------------------------------------------------
myTerminal           = "urxvt"
myFocusFollowsMouse  :: Bool
myFocusFollowsMouse  = True
myClickJustFocuses   :: Bool
myClickJustFocuses   = False
myBorderWidth        = 1 -- Width of the window border in pixels.
myNormalBorderColor  = "#dddddd" -- white
myFocusedBorderColor = "#ff0000" -- red

ctrlm     = controlMask
myModMask = mod4Mask
          -- xmonad's modMask = mod key on keyboard
          -- modMask lets you specify which modkey you want to use. The default
          -- is mod1Mask ("left alt").  You may also consider using mod3Mask
          -- ("right alt"), which does not conflict with emacs keybindings. The
          -- "windows key" is usually mod4Mask.

myWorkspaces = ["1","2","3","4","5","6","-3","-2","-1"]
             -- The default number of workspaces and their names.
             -- By default we use numeric strings, but any string may be used as a
             -- workspace name. The number of workspaces is determined by the length
             -- of this list.
             --
             -- Atagging example:
             -- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]


myXPConfig :: XPConfig -- configures xmonad prompt look&feel
myXPConfig = defaultXPConfig { autoComplete = Just 500000
                             , position = Top
                             , promptBorderWidth = 0
                             , height = 20
                             , bgColor = "grey"
                             , fgColor = "blue"
                             , font = "-windows-proggyclean-medium-r-normal--13-80-96-96-c-70-iso8859-1"
                           --, font = "-bitstream-bitstream vera sans-bold-r-normal--0-0-0-0-p-0-microsoft-cp1252"
                           --, font = "-windows-proggycleansz-medium-r-normal--0-0-96-96-c-0-iso8859-1"
                           --, font = "-misc-proggycleantt-ce-medium-r-normal--0-0-0-0-c-0-ascii-0"
}


-------------------------------------------------------------
{- Keybindings                                             --
-------------------------------------------------------------
K_<KEY> for windows keys, xF86XK_<KEY> for special laptop keys.
modm for modmask.  shiftMask for shift.
.|. for "this key and another key."
ctrlm for what X percieves as control
0 in the first key slot indicates "don't wait for a second key."
spawn "command" sends a command to the shell (bash in this case).
-------------------------------------------------------------}
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
-- [Window Manipulation]
      ((modm,           xK_p     ), spawn "dmenu_run -i -fn Sans-11")
    , ((modm,           xK_m     ), windows W.focusMaster)  -- focus master window
    , ((modm,           xK_w     ), swapNextScreen)
    , ((modm,           xK_n     ), refresh) -- resize viewed windows to correct size TODO:clarify funciton
    , ((modm,           xK_r     ), sendMessage RestoreNextMinimizedWin) --TODO: clarify function
    , ((modm,           xK_d     ), withFocused $ windows . W.sink) -- Push window back into tiling TODO:chord redesign
    , ((modm,           xK_comma ), sendMessage (IncMasterN 1))     -- number++ of windows in master
    , ((modm,           xK_period), sendMessage (IncMasterN (-1)))  -- number-- of windows in master
    , ((modm,           xK_b     ), sendMessage ToggleStruts) -- Toggle the status bar gap
                                                              -- Use this binding with avoidStruts from Hooks.ManageDocks
                                                              -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm,           xK_j     ), windows W.focusDown)    -- shift focus CW
    , ((modm .|. ctrlm, xK_j     ), windows W.swapDown  )   -- swap focused window with CW window
    , ((modm,           xK_k     ), windows W.focusUp)      -- shift focus CCW
    , ((modm .|. ctrlm, xK_k     ), windows W.swapUp    )   -- swap focused w/CCW window
    , ((modm,           xK_h     ), sendMessage Shrink) -- shrink master window
    , ((modm,           xK_l     ), sendMessage Expand) -- expand master window
    , ((modm,           xK_Return), windows W.swapMaster)   -- swap focused window & master
    , ((modm .|. ctrlm, xK_Return), spawn $ XMonad.terminal conf) -- terminal
    , ((modm,           xK_space ), sendMessage NextLayout) -- rotate through available layouts
    , ((modm .|. ctrlm, xK_space ), setLayout $ XMonad.layoutHook conf) -- reset current layout to default
    , ((modm .|. ctrlm, xK_c     ), kill)
--  , ((modm,           xK_bracketleft), sendMessage MirrorShrink)  -- Shrink the focused area TODO: necessary?
--  , ((modm,           xK_bracketright), sendMessage MirrorExpand) -- Expand the focused area TODO: necessary?

-- [Workspace & physical screen manipulation]
    , ((modm,           xK_o     ), nextWS)
    , ((modm,           xK_i     ), prevWS)
    , ((modm,           xK_u     ), nextScreen)  -- physical displays
--  , ((modm,           xK_0     ), cycleRecentWS) -- go to most recent WS
    , ((shiftMask,      xK_Page_Down), nextScreen)  -- physical displays
--  , ((modm,           xK_      ), windowPromptGoto myXPConfig)  -- Get a window list and go to a window you call legit shit command TODO: clarify
--  , ((modm,           xK_Up    ), focusUrgent) -- Toggle to a window that wants your attention
    , ((modm,           xK_e     ), gridselectWorkspace defaultGSConfig (\ws -> W.greedyView ws . W.shift ws)) -- TODO: necessary?
    , ((modm,           xK_grave ), goToSelected defaultGSConfig) -- hive window select
    , ((modm,           xK_Tab   ), moveTo Next EmptyWS)
    , ((modm .|. ctrlm, xK_Tab   ), shiftTo Next EmptyWS >> moveTo Next EmptyWS >> prevWS) -- TODO: 2hack4me
    , ((modm .|. ctrlm, xK_u     ), shiftNextScreen >> nextScreen) -- TODO: make focus follow window shift
    , ((modm .|. ctrlm, xK_o     ), shiftToNext >> nextWS)
    , ((modm .|. ctrlm, xK_i     ), shiftToPrev >> prevWS)
    , ((modm .|. ctrlm, xK_q     ), io (exitWith ExitSuccess))    -- Quit xmonad
--  , ((modm .|. ctrlm, xK_      ), bringSelected defaultGSConfig)
--  , ((modm .|. ctrlm, xK_      ), windowPromptBring myXPConfig) -- Get a window list and summon a window you call

    , ((modm, xK_1), windows $ W.greedyView "1")
    , ((modm, xK_2), windows $ W.greedyView "2")
    , ((modm, xK_3), windows $ W.greedyView "3")
    , ((modm, xK_4), windows $ W.greedyView "4")
    , ((modm, xK_5), windows $ W.greedyView "5")
    , ((modm, xK_6), windows $ W.greedyView "6")
    , ((modm .|. ctrlm, xK_1), windows $ W.shift "1")
    , ((modm .|. ctrlm, xK_2), windows $ W.shift "2")
    , ((modm .|. ctrlm, xK_3), windows $ W.shift "3")
    , ((modm .|. ctrlm, xK_4), windows $ W.shift "4")
    , ((modm .|. ctrlm, xK_5), windows $ W.shift "5")
    , ((modm .|. ctrlm, xK_6), windows $ W.shift "6")

    , ((modm, xK_0), windows $ W.greedyView "-1")
    , ((modm, xK_9), windows $ W.greedyView "-2")
    , ((modm, xK_8), windows $ W.greedyView "-3")
    , ((modm .|. ctrlm, xK_0), windows $ W.shift "-1")
    , ((modm .|. ctrlm, xK_9), windows $ W.shift "-2")
    , ((modm .|. ctrlm, xK_8), windows $ W.shift "-3")

-- [screenshot]
-- selection to: clibpard, file, screen to file
    , ((0,              xK_Print), spawn "import png:- | xclip -selection c -t image/png") -- selection to clipboard
    , ((modm,           xK_Print), spawn "sleep 0.2; scrot -s '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/Pictures/screen_shots/'")
    , ((modm .|. ctrlm, xK_Print), spawn "scrot -b '%Y:%m:%d:%H:%S.png' -e 'mv $f ~/Pictures/screen_shots/'")

-- [system]
    , ((modm,           xK_q        ), spawn "xmonad --recompile; xmonad --restart")     -- Restart xmonad
    , ((modm,           xK_F7       ), spawn "/home/jerry/.xmonad/presentation-mode.sh")
    , ((modm,           xK_F9       ), spawn "/home/jerry/.xmonad/trackpad-toggle.sh")   -- Toggle touchpad
    , ((modm,           xK_F4       ), spawn "sudo /home/jerry/.xmonad/backlightOff.sh") -- backlight controls
    , ((modm,           xK_F5       ), spawn "sudo /home/jerry/.xmonad/backlight.sh")
    , ((modm,           xK_F6       ), spawn "sudo /home/jerry/.xmonad/backlightHigh.sh")
    , ((modm .|.        ctrlm, xK_l ), spawn "gnome-screensaver-command -l")             -- Screensaver/lock screen
    , ((0, xF86XK_MonBrightnessUp   ), spawn "light -A 5")                               -- xbacklight installed but N/W
    , ((0, xF86XK_MonBrightnessDown ), spawn "light -U 5")
    , ((0, xF86XK_Display           ), spawn "/home/jerry/.xmonad/presentation-mode.sh") -- external projector

-- [audio]
    , ((0,     xF86XK_AudioRaiseVolume ), spawn "amixer -c 0 sset Master 1%+ unmute")
    , ((0,     xF86XK_AudioLowerVolume ), spawn "amixer -c 0 sset Master 1%- unmute")
    , ((0,     xF86XK_AudioMute        ), spawn "amixer -q -D pulse sset Master toggle")
    , ((modm,  xF86XK_AudioMute        ), spawn "spotify-cli --prev")
    , ((modm,  xF86XK_AudioLowerVolume ), spawn "spotify-cli --playpause")
    , ((modm,  xF86XK_AudioRaiseVolume ), spawn "spotify-cli --next")
--  , ((0, xF86XK_AudioPlay        ), spawn "clementine -t")
--  , ((0, xF86XK_AudioStop        ), spawn "clementine -s")
--  , ((0, xF86XK_AudioNext        ), spawn "clementine -f")
--  , ((0, xF86XK_AudioPrev        ), spawn "clementine -r")
--  , ((0, xF86XK_AudioRaiseVolume ), spawn "/usr/bin/pulseaudio-ctl up")
--  , ((0, xF86XK_AudioLowerVolume ), spawn "/usr/bin/pulseaudio-ctl down")
--  , ((0, xF86XK_AudioMute        ), spawn "/usr/bin/pulseaudio-ctl mute")

-- [Application Hotkeys]
    , ((modm,           xK_a      ), sendMessage $ JumpToLayout "TallSimpleTabbed") -- Jump to a tabbed layout
    , ((modm,           xK_Home   ), manPrompt myXPConfig) -- Display the man page of something
    , ((modm,           xK_F2     ), spawn "rxvt-unicode -e htop") -- Summons a system monitor
    , ((modm,           xK_Return ), spawn "env EDITOR=vim urxvt -e ranger")
--  , ((modm,           xK_F12    ), spawn "/home/jerry/.xmonad/startup_applications.sh") -- spawn commonly used programs
    , ((modm,           xK_g      ), spawn "google-chrome --high-dpi-support=1 --force-device-scale-factor=1.2") -- <1.5 = scale out
    , ((modm .|. ctrlm, xK_g      ), spawn "google-chrome --high-dpi-supoort=1 --force-device-scale-factor=1.2 https://calendar.google.com                      i https://mail.sfu.ca/owa/#authRedirect=true")
    , ((modm,           xK_t      ), spawn "emacs25")
    , ((modm .|. ctrlm, xK_t      ), spawn "emacs25 ~/Dropbox/org/life.org")
    , ((modm .|. ctrlm, xK_s      ), shellPrompt myXPConfig {autoComplete = Nothing }) -- Displays a shell prompt TODO: over dmenU?
    , ((modm .|. ctrlm, xK_n      ), do -- Append a single line and date to a notes file
         spawn ("date>>"++"/home/jerry/notes.txt")
         appendFilePrompt myXPConfig "/home/jerry/notes.txt")

-- [Displays & screens] -- all this will be ported to dmenu soon, not necessary
--  , ((modm .|. ctrlm, xK_h       ), spawn "/home/jerry/.screenlayout/verticalDuo.sh") -- 2 monitors stacked vertically
--  , ((modm .|. ctrlm, xK_y       ), spawn "/home/jerry/.screenlayout/startup.sh")     -- default layout
    ]

    ++

-- [functionality replaced by chord: mod + number, to accommadate negative WS numbers]
    -- -- mod-[1..9], Switch to workspace N TODO: don't want to be restricted to just 1-9 keys
    -- -- mod-shift-[1..9], Move client to workspace N
    -- [((m .|. modm, k), windows $ f i)
    --     | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    --     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    -- ]

    -- ++
    -- mod-{z,x,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3



    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_x, xK_v] [0..]         --TODO: wtf is going on here
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- default actions bound to mouse events
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- swipe gestures
   -- , ( ( 0, button1 ), mouseGesture gestures )
    ]

-- swipe gestures defined
-- gestures = M.fromList
--            [ ( [ L ], \_ -> nextWS )
--            , ( [ R ], \_ -> prevWS )
--            ]

{-----------------------------------------------------------------
   Layouts
------------------------------------------------------------------
You can specify and transform your layouts by modifying these values.
If you change layout bindings be sure to use 'mod-shift-space' after
restarting (with 'mod-q') to reset your layout state to the new
defaults, as xmonad preserves your old layout settings by default.

The available layouts.  Note that each layout is separated by |||,
which denotes layout choice.

I have added the commands:
avoidStruts, which prevents windows from overlapping with the status bar
smartBorders, which removes the border pixels on fullscreen.
$ tiled ||| Mirror tiled ||| noBorders Full
-----------------------------------------------------------------}
myLayout = avoidStruts $ smartBorders
           $ withIM (1%6) (Role "buddy_list")
           $ tiled ||| threecol              -- cycle removed from layouts
           ||| grid ||| full

  where
    -- cycling algorithms: tiled is default
    tiled    = named "tiled"    (minimize (maximize (ResizableTall nmaster delta ratio [])))
    full     = named "full"     (minimize Full)
    grid     = named "grid"     (minimize (maximize Grid))
    threecol = named "threecol" (minimize (maximize (ThreeColMid nmaster delta threeratio)))
    --spir     = named "Spiral" (minimize (maximize (spiral sratio)))
    --cycle = named "Cycle" (minimize (maximize Roledex)) -- Roledex cycling algorithm

    nmaster    = 1     -- default number of windows in master pane
    ratio      = 1/2   -- master pane's default screen portion
    threeratio = 1/3   -- master pane ratio in threeCol mode
    delta      = 2/100 -- percent of screen to resize by
    sratio     = 6/7   -- Spiral ratio

{-----------------------------------------------------------------
   Window rules
------------------------------------------------------------------
Execute arbitrary actions and WindowSet manipulations when managing
a new window. You can use this to, for example, always float a
particular program, or have a client always appear on a particular
workspace.

To find the property name associated with a program, use
> xprop | grep WM_CLASS
and click on the client you're interested in.

To match on the WM_NAME, you can use 'title' in the same way that
'className' and 'resource' are used below.

The doFloat command is super useful It tells Xmonad to respect the
geometry of the window, and ignore it with respect to the
tiling. The issue is it is always above the other windows. Useful
for some things, I suppose, but I find it pretty annoying.
-----------------------------------------------------------------}
myManageHook = composeAll
    [ className =? "gimp"           --> doFloat -- Make gimp's windows float
    , resource  =? "desktop_window" --> doIgnore -- There is no desktop
    , resource  =? "kdesktop"       --> doIgnore -- There is no dpesktop
    , className =? "Iceweasel"     <&&> resource =? "Dialog" --> doFloat
    , className =? "Terminator" --> doF W.swapDown >> doIgnore -- make terminator a background thing
    , className =? "Pidgin" --> doShift "9" -- send Pidgin to WS 9
    , className =? "Thunderbird" --> doShift "8" -- send Thunderbird to WS 8
    ]

{-----------------------------------------------------------------
   Event handling
------------------------------------------------------------------
* EwmhDesktops users should change this to ewmhDesktopsEventHook
Defines a custom handler function for X Events. The function should
return (All True) if the default handler is to be run afterwards. To
combine event hooks use mappend or mconcat from Data.Monoid.
-----------------------------------------------------------------}
myEventHook = mempty
-- [Status bars and logging]
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook :: X ()
myLogHook = do
  ewmhDesktopsLogHook
  return ()

{-----------------------------------------------------------------
   Startup hook
------------------------------------------------------------------
Perform an arbitrary action each time xmonad starts or is restarted
with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
per-workspace layout choices.

By default, do nothing.
Runs a bunch of programs we want.
myStartupHook = return () -- setWMName "LG3D" -- Trick Java into working correctly
-----------------------------------------------------------------}
myStartupHook :: X()
myStartupHook = do
  setWMName "LG3D"
  spawn "/home/jerry/.screenLayout/startup.sh"
  spawn "dropbox start"
  spawn "blueman-applet"
  spawn "synclient MaxTapTime=0"
  spawn "synclient PalmDetect=1"
  spawn "synclient vertedgescroll=0"
--spawn "xmodmap .Xmodmap"
--spawn "/home/jerry/.xmonad/autostart" -- runs my startup programs

-- Now run xmonad with all the defaults we set up.
-- main = xmonad defaults We also call xmobar here. We can't run the
-- loghook until xmobar is running, which is why we call it in main.
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/jerry/.xmobarrc" --call xmobar
  xmonad $ ewmh
         $ withUrgencyHook NoUrgencyHook  defaults
      {
        manageHook = manageDocks <+> myManageHook
      , logHook = dynamicLogWithPP xmobarPP -- make xmobar look nice
                      {
                        ppOutput = hPutStrLn xmproc
                      , ppTitle = xmobarColor "green" ""
                      , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                      }
      }

{-----------------------------------------------------------------
A structure containing your configuration settings, overriding
fields in the default config. Any you don't override, will
use the defaults defined in xmonad/XMonad/Config.hs
-----------------------------------------------------------------}
defaults = defaultConfig {
-- [simple stuff]
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        clickJustFocuses   = myClickJustFocuses,

-- [key bindings]
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

-- [hooks, layouts]
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
