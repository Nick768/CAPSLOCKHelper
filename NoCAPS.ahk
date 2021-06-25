#Requires AutoHotkey v2.0-

CoordMode("Mouse", "Screen")

wx := 0, wy := 0, ww := 0, wh := 0

notifyWin := Gui()
notifyWin.Opt("-Caption +Owner +AlwaysOnTop +")
notifyWin.Add("Text", "", "CapsLock activated")
notifyWin.Show("Y0 AutoSize")
WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " . notifyWin.Hwnd)

if GetKeyState("CapsLock", "T") {
    transparency := 175
    SetTimer(checkHover, 250)
} else
    transparency := 0
    
WinSetTransparent(transparency, "ahk_id " . notifyWin.Hwnd)

checkHover(*) {
    global notifyWin, transparency, wx, wy, ww, wh
    
    mx := 0, my := 0
    MouseGetPos(&mx, &my)
    
    transparency := wx <= mx and mx <= (wx + ww) and wy <= my and my <= (wy + wh) ? 0 : 175

    WinSetTransparent(transparency, "ahk_id " . notifyWin.Hwnd)
    
    return
}

*CapsLock::return

CapsLock:: {
    global transparency
    
    start := A_TickCount
    While(GetKeyState("CapsLock", "P") and A_TickCount - start <= 1000){
        ToolTip("Hold for " . Round((1000 - (A_TickCount - start)) / 1000, 1) . "s")
        Sleep(100)
    }
    ToolTip()
    
    if A_TickCount - start >= 1000 {
        SetCapsLockState(not GetKeyState("CapsLock", "T"))
        if GetKeyState("CapsLock", "T") {
            transparency := 175
            SetTimer(checkHover, 250)
        } else {
            transparency := 0
            SetTimer(checkHover, 0)
        }
        WinSetTransparent(transparency, "ahk_id " . notifyWin.Hwnd)
    }
    
    KeyWait("CapsLock")
}
