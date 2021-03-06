## [xmonad] - Swapping `alt` and `command`
- `sudo nano /usr/share/X11/xkb/symbols/pc` did not work
- We created a simple a hidden text file called `.Xmodmap` to contain our new bindings
- used xev in terminal to determine what the keycode for the key we wanted to rebind was. `keycode 64 =    Alt_L Meta_L` where key64 was the left alt key on mac air
- once all the custom keybindings were completed, file is saved and ran through xmodmap via terminal `xmodmap .Xmodmap Changes were instant`


- it seems this is how Brian changed caps to ctrl. He made a new modifier button holding ctrl, cleared caps and assigned that mod button to caps. 
> You can do the first (mapping Caps Lock to Esc) but you cannot do the second.
> Simple Explanation: Caps Lock is just not designed to do something when pressed.
> Elaborate Explanation: There are many types of keys. Two of them are Modifier Keys and Lock Keys.
> Caps Lock is a Lock Key while keys such as Ctrl, Alt, and Shift are Modifier Keys.
> It's apparent from their names that Modifier Keys modify the function of the next key(s) pressed, and Lock Keys act as a toggle switch to turn on or off some particular function.
> Now, since Caps Lock is a Lock Key, you cannot have it behave like a Modifier Key without mapping it to one. Caps Lock by itself cannot function as a Modifier Key.

[xmodmap tutorial](http://xahlee.info/linux/linux_xmodmap_tutorial.html)  
[guide line for xmodmap that Brian followed](https://blacketernal.wordpress.com/set-up-key-mappings-with-xmodmap/)

---

## [xmonad] - Enabling volumn media keys
- via xev, shift was held while pressing desired media keys to properly display their keycodes. 
- the assignment for volumn up, down, mute toggle were found in /usr/include/X11/XF86keysym.h
   `#define XF86XK_AudioLowerVolume	0x1008FF11   /* Volume control down        */` 
   `#define XF86XK_AudioMute	0x1008FF12   /* Mute sound from the system */` 
   `#define XF86XK_AudioRaiseVolume	0x1008FF13   /* Volume control up          */ `
- these definitions were then mapped to keycode 121, 122, 123 in .Xmodmap 
- finally in xmonad.hs, we assigned these definitons to call audio functionality
  ` , ((0, xF86XK_AudioRaiseVolume ), spawn "amixer -c 0 sset Master 1+ unmute")`
- doesn't work with pulseaudio, have to use amixer. 
- mute toggle mutes, but doesn't unmute, have to swap to ubuntu to enable via UI. Line commented out for now. 

---
## [ubuntu] - Wacom tablet - designate screen
`xinput --list` to determine name of device
xsetwacom set "device name" MapToOutput "head name"
use arandr to grab head name 

https://ubuntuforums.org/showthread.php?t=1656089

terminal input for setting display contraint
`xsetwacom set "Wacom Intuos S 2 Pen stylus" MapToOutput eDP1`

---
## [Firefox] - custom browser skin
moving from Chrome to Firefox for: custom UI, smooth vim, keyword nav

keyword: right-clicking a search input allows that search to be added as a keyword.

eg) facebook search 'tyler' becomes `fb tyler` in the url


|**Extensions**|**Functiion**|
| :----------- | ----------- |
|VimFX|functions better than vimperator, more akin to vimium|
|Stylish|CSS themes for browser skins & individual webpages|
|Dorando keyconfig|bringing chrome bindings|

browser skin of choice via Luke Smith, CSS code found in `firefox` folder

---
## [spacemacs] - neotree & \*scratch\* on startup
~/.spacemacs
` (defun dotspacemacs/uer-config ()  
  (neotree-toggle)  
  (switch-to-buffer-other-window "*scratch*")  
    ;; Make linums relative by default
  (with-eval-after-load 'linum
    (linum-relative-toggle))
  )`  
  
---
## [xmonad] - HIDPI multi-monitors
when a second monitors was plugged in, it displayed a portion of the primary screen instead of extending to it's own
display. This lead to either the main laptop monitor or the external monitor having anomalies such as:
1. Workspace displayed in only a portion of one of the screens or was abdnormally truncated.
2. a screen meant for one monitor will overlap into another physical screen.
3. 

previous attempts via xrandr of resolving this these issues lead to unintended monitor configurations or produced no
response. Attempts and results include:
1. using xrandr --above or --below led to screens overlapping across the physical screens.
2. using xrandr --fb, this lead to certain screens having the virtual screen function but didn't resolve the issue.
3. using xrandr --pos, partially reoslved issue but the (x,y) coord have +y going in the -y direciton 
   ie) --pos 0x1080 on a coordinates: (0x-1080)
4. screen 0 not addressed. current = 3200x2880 to account for scaling and space for both physical monitors

solution:
using the previous failures final cli was 
`xrandr --output eDP-1 --pos 0x1080 --panning 2560x1440+0+1080 --output DP-2 --pos 0x0`
using command `xrandr` ensure that Screen 0: current(####x####) has dimensions enough for BOTH your monitors.
To avoid configuration randoning snapping back to an erronous one ensure --panning has coordinate arguements.


















