#Requires AutoHotkey v2.0

; dp := DebugPanel()
; dp.show("X925 Y790 w200 h200")

; dp.write(A_ScriptHwnd)
; WinGetPos(&x, &y, &w, &h, dp.getAhkId())
; dp.write(x ", " y ", " w ", " h)

class DebugPanel {
    limit := 200
    gui := Gui()
    debugControl := this.gui.Add("Edit", "w200 h200")

    __New() {
        
    }

    attachTo(gui, options := "ReadOnly w300 h200") {
        this.debugControl := gui.Add("Edit", options)
    }

    write(inputText*) {
        this.debugControl.Text := SubStr(this.debugControl.Text this.strJoin(, inputText*) "`r`n", -300)
    }

    strJoin(delimiter := ", ", strs*) {
        result := ""
        for str in strs {
            result := result str
            if strs.Length > A_Index
                result := result delimiter
        }

        return result
    }

    show(options?) {
        this.gui.Show(options)
    }

    getAhkId() {
        return this.gui.Hwnd
    }
}