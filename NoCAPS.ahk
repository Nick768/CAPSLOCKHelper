#Requires AutoHotkey v2.0-
CoordMode("Mouse", "Screen")

wx := 0, wy := 0, ww := 0, wh := 0, notifyWin := Gui()
notifyWin.Opt("-Caption +Owner +AlwaysOnTop")
notifyWin.BackColor := "Red"
notifyWin.SetFont("S12")
notifyWin.Add("Text", "+Center W" . A_ScreenWidth / 1.3, "CapsLock activated!")
notifyWin.Show("Y0 AutoSize")
WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " . notifyWin.Hwnd)

if GetKeyState("CapsLock", "T") {
    WinSetTransparent(200, "ahk_id " . notifyWin.Hwnd)
    SetTimer(checkHover)
} else
    WinSetTransparent(0, "ahk_id " . notifyWin.Hwnd)

checkHover(*) {
    mx := 0, my := 0
    MouseGetPos(&mx, &my)
    WinSetTransparent(wx <= mx and mx <= (wx + ww) and wy <= my and my <= (wy + wh) ? 0 : 200, "ahk_id " . notifyWin.Hwnd)
}

*CapsLock:: return
 CapsLock:: {
    start := A_TickCount
    While(GetKeyState("CapsLock", "P") and A_TickCount - start <= 1000) {
        ToolTip("Hold for " . Round((1000 - (A_TickCount - start)) / 1000, 1) . "s")
        Sleep(100)
    }
    ToolTip()
    
    if A_TickCount - start >= 1000 {
        SetCapsLockState(not GetKeyState("CapsLock", "T"))
        if GetKeyState("CapsLock", "T") {
            WinSetTransparent(200, "ahk_id " . notifyWin.Hwnd)
            SetTimer(checkHover)
        } else {
            WinSetTransparent(0, "ahk_id " . notifyWin.Hwnd)
            SetTimer(checkHover, 0)
        }
    }
    
    KeyWait("CapsLock")
}
