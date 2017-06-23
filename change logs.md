### swapping `alt` and `command/super`
- `sudo nano /usr/share/X11/xkb/symbols/pc` did not work
- We created a simple a hidden text file called `.Xmodmap' to contain our new bindings
- used xev in terminal to determine what the keycode for the key we wanted to rebind was. `keycode 64 =    Alt_L Meta_L` where key64 was the left alt key on mac air
- once all the custom keybindings were completed, file is saved and ran through xmodmap via terminal `xmodmap .Xmodmap Changes were instant  


- it seems this is how Brian changed caps to ctrl. He made a new modifier button holding ctrl, cleared caps and assigned that mod button to caps. 
`You can do the first (mapping Caps Lock to Esc) but you cannot do the second.
Simple Explanation: Caps Lock is just not designed to do something when pressed.
Elaborate Explanation: There are many types of keys. Two of them are Modifier Keys and Lock Keys.
Caps Lock is a Lock Key while keys such as Ctrl, Alt, and Shift are Modifier Keys.
It's apparent from their names that Modifier Keys modify the function of the next key(s) pressed, and Lock Keys act as a toggle switch to turn on or off some particular function.
Now, since Caps Lock is a Lock Key, you cannot have it behave like a Modifier Key without mapping it to one. Caps Lock by itself cannot function as a Modifier Key.`

[xmodmap tutorial](http://xahlee.info/linux/linux_xmodmap_tutorial.html)
[guide line for xmodmap that Brian followed](https://blacketernal.wordpress.com/set-up-key-mappings-with-xmodmap/)
