#Requires AutoHotkey v2.0
#SingleInstance Force


newButton(name, options, callback) {
    global guiMain
    btnStop := guiMain.Add("Button", options, name)
    btnStop.OnEvent("Click", callback)
    return btnStop
}


guiMain := Gui()
guiMain.OnEvent("Close", (*) => ExitApp())

; newButton("a", "w30 h30", (*) => Reload())
; newButton("b", "w30 h30", (*) => Reload())
; newButton("c", "w30 h30", (*) => Reload())

; newButton("a", "ym w30 h30", (*) => Reload())
; newButton("b", "w30 h30", (*) => Reload())
; newButton("c", "w30 h30", (*) => Reload())

; newButton("a", "w30 h30", (*) => Reload())
; newButton("b", "ym w30 h30", (*) => Reload())
; newButton("c", "ym w30 h30", (*) => Reload())

; newButton("a", "xm w30 h30", (*) => Reload())
; newButton("b", "w30 h30", (*) => Reload())
; newButton("c", "w30 h30", (*) => Reload())

eventBtn := newButton("events", "w500 h70", (*) => Reload())
guiMain.Show()

SetTimer WatchCursor, 100

WatchCursor()
{
    MouseGetPos &x, &y, &id, &control
    eventBtn.Text := "ahk_id " id ", ahk_class: " WinGetClass(id) ", Window title: " WinGetTitle(id) ", Control: " control ", Position: x" x " y" y
}




; =================================== Classes ===================================

class DebugPanel {
    gui := Gui()
    attachGui := ""
    limit := 200
    debugPanel := ""
    attachDebugPannel := ""

    __New(w := 200, h := 150, limit := 200) {
        this.limit := limit
        this.debugPanel := this.gui.Add("Edit", "w" w " h" h " ReadOnly vDebug")
    }

    attach(gui, options) {
        this.attachGui := gui
        this.attachDebugPannel := gui.Add("Edit", options)
    }

    append(text) {
        log := SubStr(this.debugPanel.Text text "`r`n", -200)
        this.debugPanel.Text := log
        this.attachDebugPannel.Text := log
    }

    show() {
        this.gui.Show()
    }

    close(Callback) {
        this.gui.OnEvent("Close", Callback)
    }
}


class ImageUtils {
    ahkId := ""
    imageRoot := ""
    topX := 0
    topY := 0
    bottomX := 0
    bottomY := 0

    isTerminate := false


    __New(ahkId, imageRoot, topX := 0, topY := 0, bottomX := 1200, bottomY := 800) {
        this.ahkId := ahkId
        this.imageRoot := imageRoot
        this.topX := topX
        this.topY := topY
        this.bottomX := bottomX
        this.bottomY := bottomY
    }

    searchAndClick(name, time := 1) { ; 10 seconds
        loop time {
            if (this.isTerminate) {
                this.isTerminate := false
                return false
            }

            if (this.search(name, &x, &y)) {
                ControlClick "x" x + 5 " y" y + 5, this.ahkId,,,, "NA"
                return true
            }
            Sleep 100
        }
        return false
    }


    search(name, &x, &y) {
        return ImageSearch(&x, &y, this.topX, this.topY, this.bottomX, this.bottomY, this.imageRoot name)
    }
}