; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

;#z::Run www.autohotkey.com

;^!n::
;IfWinExist Untitled - Notepad
	;WinActivate
;else
	;Run Notepad
;return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.




;;;; Custom below ;;;;
; Find documentation of key names at: https://www.autohotkey.com/docs/KeyList.htm

; Map Escape to Capslock key.
Capslock::Esc

; Let Pause button send Capslock.
Pause::Capslock

; Produce a backspace character with ^h.
;^h::Backspace
^h::Send {Backspace}

; Media control shortcuts.
^F6::Media_Prev
^F7::Media_Play_Pause
^F8::Media_Next

; Volume control.
^F10::Volume_Down
^F11::Volume_Up
^F12::Volume_Mute



; MACOS-CONFIG
; Swap Alt and Windows key on Mac keyboards.
LAlt::LWin
LWin::LAlt