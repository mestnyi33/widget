#Requires AutoHotkey v2.0
#SingleInstance Force

*CapsLock::
{
    ; Ждем отпускания клавиши 0.25 секунды
    if !KeyWait("CapsLock", "T0.25")
    {
        ; Если клавиша все еще зажата (удерживание) — переключаем состояние больших букв
        if GetKeyState("CapsLock", "T")
            SetCapsLockState "AlwaysOff"
        else
            SetCapsLockState "AlwaysOn"
        
        ; Ждем, пока пользователь окончательно отпустит Caps Lock, чтобы не было повторных срабатываний
        KeyWait("CapsLock")
    }
    else
    {
        ; Если это был короткий клик — переключаем раскладку напрямую через систему
        hWnd := WinExist("A")
        if hWnd
        {
            PostMessage(0x0050, 2, 0, hWnd) ; WM_INPUTLANGCHANGEREQUEST
        }
    }
}
