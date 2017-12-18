-- xmonad config files, borrows from @Brian-yee and @Altercation
-- maintained by Jerry Li github: jerryCoralis
-- last updated Nov. 19 2017
-- main features: 4 tiling algorithms
-- planned for the layout of Lenovo's X1 Carbon 5th gen.

-------------------------------------------------------------
-- Imports
-------------------------------------------------------------

-- [system]
import Control.Monad
import Data.Monoid
import System.Exit
import System.Exit
import XMonad.Util.Dmenu -- blocks input while in dmenu
import XMonad hiding ( (|||) ) -- don't use the normal |||
                               -- operator. It conflicts with
                               -- LayoutCombinators.

-- xmobar ---------------------------------------------------
import System.IO                  -- send data to status bar
import XMonad.Hooks.DynamicLog    -- system state
import XMonad.Hooks.SetWMName     -- Window name in status bar
import XMonad.Hooks.ManageDocks   -- Status bar not tiled over
import XMonad.Util.Run(spawnPipe) -- Send data to status bar

-- keybindings ----------------------------------------------
import Graphics.X11.ExtraTypes.XF86 -- Special keybindings
import XMonad.Util.EZConfig         -- Easier keybinding names

-- prompts --------------------------------------------------
import XMonad.Prompt            -- Core library
import XMonad.Prompt.AppendFile -- Appends a single line to a file
import XMonad.Prompt.Man        -- Displays the man page of something
import XMonad.Prompt.Shell      -- Displays a shell prompt
import XMonad.Prompt.Window     -- Lets you see a list of windows and
                                -- summon them or go to them.

-- WS & Window management -----------------------------------
import XMonad.Actions.CycleWS          -- cycle through virtual desktops
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
-- import XMonad.Layout.Spiral         -- For the spiral layout
import qualified XMonad.StackSet as W  -- for controling layout
import qualified Data.Map        as M

-- Compatibility --------------------------------------------
import XMonad.Hooks.EwmhDesktops -- touchpad compatibility
import XMonad.Hooks.SetWMName    -- Matlab compataiblity

-- Instant messanger ----------------------------------------
import XMonad.Layout.IM
import Data.Ratio ((%))

-- Swipe Gestures -------------------------------------------
-- import XMonad.Actions.MouseGestures


-------------------------------------------------------------
-- Definitions
-------------------------------------------------------------
myTerminal = "gnome-terminal"
myFocusFollowsMouse :: Bool -- if focus follows mouse pointer
myFocusFollowsMouse = True
myClickJustFocuses :: Bool
myClickJustFocuses = False
myBorderWidth = 1 -- Width of the window border in pixels.
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"
ctrlm     = controlMask -- !!poor work around
myModMask = mod4Mask --xmonad's modMask = mod key on keyboard
                     -- modMask lets you specify which modkey you want to use. The default
                     -- is mod1Mask ("left alt").  You may also consider using mod3Mask
                     -- ("right alt"), which does not conflict with emacs keybindings. The
                     -- "windows key" is usually mod4Mask.

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
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
--                           , font = "-bitstream-bitstream vera sans-bold-r-normal--0-0-0-0-p-0-microsoft-cp1252"
--                           , font = "-windows-proggycleansz-medium-r-normal--0-0-96-96-c-0-iso8859-1"
--                           , font = "-misc-proggycleantt-ce-medium-r-normal--0-0-0-0-c-0-ascii-0"
}


-------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------
-- xK_<KEY> for windows keys, xF86XK_<KEY> for special laptop keys.
-- modm for modmask.  shiftMask for shift.
-- .|. for "this key and another key." ctrlm for control.

-- Template:
-- ((key, otherkey), command)
-- 0 in the first key slot indicates "don't wait for a second key."
-- spawn "command" sends a command to the shell (mine is bash).
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
    -- Window Manipulation --------------------------------------
      ((modm,           xK_p     ), spawn "dmenu_run -fn Sans-12")
    , ((modm,           xK_n     ), refresh) -- resize viewed windows to correct size
    , ((modm,           xK_Tab   ), windows W.focusDown) --shift focus to next window
    , ((modm,           xK_r     ), sendMessage RestoreNextMinimizedWin)
    , ((modm,           xK_h     ), sendMessage Shrink) -- shrink master window
    , ((modm,           xK_l     ), sendMessage Expand) -- expand master window
    , ((modm,           xK_d     ), withFocused $ windows . W.sink) -- Push window back into tiling
    , ((modm,           xK_comma ), sendMessage (IncMasterN 1))    -- ++number of windows in master
    , ((modm,           xK_period), sendMessage (IncMasterN (-1))) -- --number of windows in master
    , ((modm,           xK_b     ), sendMessage ToggleStruts) -- Toggle the status bar gap
                                                              -- Use this binding with avoidStruts from Hooks.ManageDocks
                                                              -- See also the statusBar function from Hooks.DynamicLog.
    -- , ((modm,           xK_bracketleft), sendMessage MirrorShrink) -- Shrink the focused area !!notworking
    -- , ((modm,           xK_bracketright), sendMessage MirrorExpand) -- Expand the focused area !!notworking
    , ((modm,           xK_j     ), windows W.focusDown) -- shift focus CW
    , ((modm,           xK_k     ), windows W.focusUp) -- shift focus CCW
    , ((modm,           xK_Return), windows W.swapMaster) -- swap focused window & master
    , ((modm,           xK_space ), sendMessage NextLayout) -- rotate through available layouts
    , ((modm .|. ctrlm, xK_space ), setLayout $ XMonad.layoutHook conf) -- reset current layout to default
    , ((modm .|. ctrlm, xK_Return), spawn $ XMonad.terminal conf) -- terminal
    , ((modm .|. ctrlm, xK_j     ), windows W.swapDown  ) -- swap focused window with CW window
    , ((modm .|. ctrlm, xK_k     ), windows W.swapUp    ) -- swap focused w/CCW window
    , ((modm .|. ctrlm, xK_c     ), kill)
    , ((modm .|. ctrlm, xK_m     ), windows W.focusMaster) -- focus master window

    -- Workspace Manipulation -------------------------------------
    -- , ((modm,           xK_m     ), withFocused minimizeWindow) -- Minimizes a window
    , ((modm,           xK_w     ), swapNextScreen) -- swap ws in multi-monitor
    , ((modm,           xK_o     ), nextWS)
    , ((modm,           xK_i     ), prevWS)
    , ((modm,           xK_Up    ), focusUrgent) -- Toggle to a window that wants your attention
    , ((modm,           xK_e     ), gridselectWorkspace defaultGSConfig (\ws -> W.greedyView ws . W.shift ws))
    , ((modm .|. ctrlm, xK_o     ), shiftToNext >> nextWS)
    , ((modm .|. ctrlm, xK_i     ), shiftToPrev >> prevWS)
    , ((modm .|. ctrlm, xK_q     ), io (exitWith ExitSuccess)) --Quit xmonad
    , ((modm .|. ctrlm, xK_g     ), windowPromptGoto myXPConfig) -- Get a window list and go to a window you call
    , ((modm .|. ctrlm, xK_Right ), shiftToNext >> nextWS)
    , ((modm .|. ctrlm, xK_Left  ), shiftToPrev >> prevWS)
    , ((modm .|. ctrlm, xK_Tab   ), moveTo Next EmptyWS)
    , ((modm .|. ctrlm, xK_g     ), goToSelected defaultGSConfig)
    , ((modm .|. ctrlm, xK_b     ), bringSelected defaultGSConfig)
    , ((modm .|. ctrlm, xK_b     ), windowPromptBring myXPConfig) -- Get a window list and summon a window you call

    -- screenshot ------------------------------------------------
    , ((ctrlm, xK_Print ), spawn "sleep 0.2; scrot -s '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/Storage/Pictures/screen_shots/'")
    , ((0, xK_Print ), spawn "scrot '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/Pictures/screen_shots/'") -- add functionality for import
    , ((modm, xK_u), spawn "import png:- | xclip -selection c -t image/png") -- screenshot to clipboard 
    -- system ----------------------------------------------------
    , ((modm,           xK_q       ), spawn "xmonad --recompile; xmonad --restart") -- Restart xmonad
    , ((modm,           xK_F7      ), spawn "/home/jerry/.xmonad/presentation-mode.sh")
    , ((modm,           xK_F9      ), spawn "/home/jerry/.xmonad/trackpad-toggle.sh")   -- Toggle touchpad
    , ((modm,           xK_F4      ), spawn "sudo /home/jerry/.xmonad/backlightOff.sh") -- backlight controls
    , ((modm,           xK_F5      ), spawn "sudo /home/jerry/.xmonad/backlight.sh")
    , ((modm,           xK_F6      ), spawn "sudo /home/jerry/.xmonad/backlightHigh.sh")
    , ((0, xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 10")                       -- Laptop brightness control
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")
    , ((0, xF86XK_Display          ), spawn "/home/jerry/.xmonad/presentation-mode.sh") -- external projector
    , ((modm .|. ctrlm, xK_l       ), spawn "gnome-screensaver-command -l") -- Screensaver/lock screen

    -- Workaround for broken audio keys in clementine ------------
    , ((0, xF86XK_AudioPlay       ), spawn "clementine -t")
    , ((0, xF86XK_AudioStop       ), spawn "clementine -s")
    , ((0, xF86XK_AudioNext       ), spawn "clementine -f")
    , ((0, xF86XK_AudioPrev       ), spawn "clementine -r")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -c 0 sset Master 1+ unmute") -- was previously pulseaudio from Brian
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -c 0 sset Master 1- unmute")
    -- , ((0, xF86XK_AudioMute       ), spawn "amixer sset Master toggle") !!notworking
    -- , ((0, xF86XK_AudioRaiseVolume), spawn "/usr/bin/pulseaudio-ctl up")
    -- , ((0, xF86XK_AudioLowerVolume), spawn "/usr/bin/pulseaudio-ctl down")
    -- , ((0, xF86XK_AudioMute       ), spawn "/usr/bin/pulseaudio-ctl mute")

    -- Application Hotkeys ---------------------------------------
    , ((modm,           xK_F2 ), spawn "rxvt-unicode -e htop") -- Summons a system monitor
    -- , ((modm,           xK_F3 ), spawn "env EDITOR=vim urxvt -e ranger")
    , ((modm,           xK_F3 ), spawn "env EDITOR=vim gnome-terminal -e ranger")
    , ((modm,           xK_F12), spawn "/home/jerry/.xmonad/startup_applications.sh") -- spawn commonly used programs
    , ((modm,           xK_F11), spawn "python3 /home/jerry/.xmonad/randomwallpaper.py") -- !!notworking
    , ((modm,           xK_g  ), spawn "google-chrome")
    , ((modm,           xK_y  ), spawn "google-chrome --kiosk https://connect.sfu.ca/zimbra/mail#1")
    , ((modm .|. ctrlm, xK_t  ), spawn "emacs")        -- Open graphical emacs client
    , ((modm .|. ctrlm, xK_m  ), spawn "clementine")   -- Call Music player
    , ((modm .|. ctrlm, xK_s  ), shellPrompt myXPConfig {autoComplete = Nothing }) -- Displays a shell prompt
    , ((modm,           xK_a  ), sendMessage $ JumpToLayout "TallSimpleTabbed") -- Jump to a tabbed layout
    , ((modm,           xK_F1 ), manPrompt myXPConfig) -- Display the man page of something
    , ((modm .|. ctrlm, xK_n  ), do -- Append a single line and date to a notes file
         spawn ("date>>"++"/home/jerry/notes.txt")
         appendFilePrompt myXPConfig "/home/jerry/notes.txt")

    -- Change Focus ----------------------------------------------
    , ((modm .|. ctrlm, xK_h       ), spawn "/home/jerry/.screenlayout/verticalStack.sh") -- 2 monitors stacked vertically
    , ((modm .|. ctrlm, xK_y       ), spawn "/home/jerry/.screenlayout/singleDefault.sh")
    ]

    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]

    ++
    -- mod-{z,x,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_x, xK_v] [0..]
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

------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.

-- I have added the commands:
-- avoidStruts, which prevents windows from overlapping with the status bar
-- smartBorders, which removes the border pixels on fullscreen.
------------------------------------------------------------------
-- $ tiled ||| Mirror tiled ||| noBorders Full
--   tiled   = Tall nmaster delta ratio
myLayout =  avoidStruts $ smartBorders
           $ withIM (1%6) (Role "buddy_list")
           $ tiled ||| threecol              -- cycle removed from layouts
           ||| grid ||| full

  where
    -- cycling algorithms: tiled is default
    tiled    = named "tiled"    (minimize (maximize (ResizableTall nmaster delta ratio [])))
    full     = named "full"     (minimize Full)
    grid     = named "grid"     (minimize (maximize Grid))
    threecol = named "threecol" (minimize (maximize (ThreeColMid nmaster delta threeratio)))
    -- spir     = named "Spiral" (minimize (maximize (spiral sratio)))
    -- cycle = named "Cycle" (minimize (maximize Roledex)) -- Roledex cycling algorithm

    nmaster    = 1     -- default number of windows in master pane
    ratio      = 1/2   -- master pane's default screen portion
    threeratio = 1/3   -- master pane ratio in threeCol mode
    delta      = 3/100 -- percent of screen to resize by
    sratio     = 6/7   -- Spiral ratio

------------------------------------------------------------------
-- Window rules
------------------------------------------------------------------
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
-- The doFloat command is super useful It tells Xmonad to respect the
-- geometry of the window, and ignore it with respect to the
-- tiling. The issue is it is always above the other windows. Useful
-- for some things, I suppose, but I find it pretty annoying.
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat -- make mplayers window float
    , className =? "gimp"           --> doFloat -- Make gimp's windows float
    , resource  =? "desktop_window" --> doIgnore -- There is no desktop
    , resource  =? "kdesktop"       --> doIgnore -- There is no dpesktop
    , className =? "Iceweasel"     <&&> resource =? "Dialog" --> doFloat
    , className =? "Terminator" --> doF W.swapDown >> doIgnore -- make terminator a background thing
    , className =? "Pidgin" --> doShift "9" -- send Pidgin to WS 9
    , className =? "Thunderbird" --> doShift "8" -- send Thunderbird to WS 8
    ]

-- Event handling ------------------------------------------------------
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty

-- Status bars and logging ----------------------------------------------
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook :: X ()
myLogHook = do
  ewmhDesktopsLogHook
  return ()

-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
-- Runs a bunch of programs we want.
-- myStartupHook = return () -- setWMName "LG3D" -- Trick Java into working correctly
myStartupHook :: X()
myStartupHook = do
  spawn "/home/jerry/.xmonad/autostart" -- runs my startup programs
  setWMName "LG3D"

-- Now run xmonad with all the defaults we set up.
-- main = xmonad defaults We also call xmobar here. We can't run the
-- loghook until xmobar is running, which is why we call it in main.
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/jerry/.xmobarrc" --call xmobar
  xmonad $ ewmh $ withUrgencyHook NoUrgencyHook  defaults
      {
        manageHook = manageDocks <+> myManageHook
      , logHook = dynamicLogWithPP xmobarPP -- make xmobar look nice
                      {
                        ppOutput = hPutStrLn xmproc
                      , ppTitle = xmobarColor "green" ""
                      , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                      }
      }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        clickJustFocuses   = myClickJustFocuses,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
