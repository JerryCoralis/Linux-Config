`emacs --daemon` to run in the background.
`emacsclient.emacs24 <filename/dirname>` to open in terminal

NOTE: "M-m and SPC can be used interchangeably".

* Undo - `C-/`
* Redo - `C-?`
* Change case: 1. Camel Case : `M-c`
               2. Upper Case : `M-u`
               3. Lower Case : `M-l`
* Helm-projectile find file : `M-m p f`
* Helm-projectile-grep : `M-m p s g`
* Toggle Auto complete : `M-m t a`
* Neotree root directory : `M-m p t`
* Linum-relative : `M-m t r`
* Ace-jump mode : `M-m SPC`
*. Helm-bookmarks : `M-m h b`
* Iedit mode : 1. `M-<left>`, `M-<right>` to navigate,
               2. `C-;` to select/deselct all for edit at once
* Expand Region 1. Expand: `M-m v`
                2. Contract: `M-m V`
* Winner mode: 1. Undo : `C-c <left>`
               2. Redo : `C-c <right>`
* Toggle Aggressive Indent Mode : `M-m t I`
* Open file in new buffer after `M-m p f` : `C-c o`
* Dired mode : 1. Copy file : `C`
               2. Delete the file : `D`
               3. Rename the file : `R`
               4. Create a new directory : `+`
               5. Reload directory listing : `g`
* Search : 1. The last searched query : `C-s C-s`
           2. The string under the cursor : `C-s C-w`
* Un-indent by 4 spaces : `C-u -4 C-x TAB`
* Open emacs dired mode: `M-m a d`
* Erase contents of buffer: `M-m b e`
* Replace contents of buffer with the contents of the clipboard: `M-m b P`
* Copy contents of the whole buffer: `M-m b Y`
* Open current file directory: `M-m f j`
* Rename current file: `M-m f R`
* Indent region/buffer: `M-m j =`
* Kill all buffers (of current project): `M-m p k`
* Reload spacemacs conf: `M-m f e R`
* Kill all buffers except the current one: `M-m b K`
* Go to conf file (~/.spacemacs): `M-m f e d`
* Toggle display fill-column(column 80): `M-m t f`
* Enable/Disable read-only mode `C-x C-q`
* Go one level up in directory: `C-x C-j`
* Indent/unindent region by n/-n spaces(n=4,8,... usually): `C-u <n> C-x TAB` 
* Go to previous cursor position(before ace-jump): `M-m SPC ``
* Do ag (code search) inside project : `M-m s a p`
* Narrow to function : `M-m n f` (`M-m n w` to exit)
* Enable rainbow mode: `M-m t C c`
* Search selected region or current word through ag in project: `M-m s p`
* Highlight search results in another buffer (helm swoop): `M-m s s` (`M-m s s` to exit)
* Toggle current frame transparency: `M-m T T`
* Toggle non-matching lines for iedit mode: `C-'` when in iedit mode (C-;)
* Helm-resume background task: `M-m h l`
* Enter .spacemacs diff mode: `M-m f e D`
* Show kill ring history: `M-m r y`
* When in dired mode, press `?` to display a list of commands.
* Search within given buffer (helm-swoop mode): `M-m s s`
* List all functions in the given buffer (imenu): `M-m s l`
