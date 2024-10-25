#Requires AutoHotkey v2.0
#SingleInstance Force

isTerminate := true


~F2:: {
    terminate()
}

imageRoot := "*80 *TransBlack .\images\search\"
; title := "AutoHotkey v2 Help"
title := "Sv 206 Ngọa Long Việt Nam - Coowon Browser"
; title := "Ngọa Long Vn - Coowon Browser"

ahkId1 := ""
ahkId2 := ""

coordinate := ""
imgUtils := ImageUtils(title, imageRoot)
debug := DebugPanel()



; =============================== GUI =============================== 

guiMain := Gui()
guiMain.OnEvent("Close", (*) => ExitApp())

newButton("Reload", (*) => Reload())
btnId1 := newButton("ID1: ", (*) => Reload)
btnId2 := newButton("ID2: ", (*) => Reload)
btnCorpsCoordinate := newButton("Toạ độ quân đoàn: ", (*) => Reload)
newButton("Auto Quân Đoàn 2 Acc", (*) => autoCorps())
newButton("Auto Quân Đoàn 3 Acc", (*) => autoCorps3())
newButton("Auto Gia Nhập Quân Đoàn", (*) => autoJoinCorps())
newButton("Dừng auto", (*) => terminate())

debug.attach(guiMain, "w200 h170 ReadOnly vAttachDebug")

guiMain.Show()

newButton(name, callback) {
    global guiMain
    btnStop := guiMain.Add("Button", "w200 h30", name)
    btnStop.OnEvent("Click", callback)
    return btnStop
}

; =============================== GUI =============================== 


autoCorps() {
    global isTerminate := false
    debug.append("Bắt đầu auto quân đoàn")
    debug.append("Toạ độ: " coordinate)

    WinMove 0, 0, 1029, 698, ahkId1
    WinMove 100, 100, 1029, 698, ahkId2

    loop {
        if isTerminate
            break

        WinActivate ahkId1
        Sleep 500

        ControlClick coordinate, ahkId1,,,, "NA"
        Sleep 500
        imageSearchAndClick("attack-1.png", 80)       
        imageSearchAndClick("create-group.png", 80)
        imageSearchAndClick("corps-ignore-1.png", 5)
        
        WinActivate ahkId1
        Sleep 500
        imageSearchAndClick("corps-invite.png", 80)

        WinActivate ahkId2
        Sleep 500
        imageSearchAndClick("corps-join-2.png", 80)

        WinActivate ahkId1
        Sleep 500
        imageArraySearchAndClick(["corps-enough.png", "corps-enough-3.png"], 80)
        

        imageSearchAndClick("attack-2.png", 80)
        imageSearchAndClick("result-1.png", 80)
        Sleep 500
        imageSearchAndClick("result-1.png", 5)
        Sleep 500
        ControlClick "x826 y659", ahkId1,,,, "NA"

        imageArraySearchAndClick(["exit-1.png", "exit-2.png"], 80)
    }
}

autoCorps3() {
    global isTerminate := false
    debug.append("Bắt đầu auto quân đoàn")
    debug.append("Toạ độ: " coordinate)

    WinMove 0, 0, 1029, 698, ahkId1
    WinMove 100, 100, 1029, 698, ahkId2

    loop {
        if isTerminate
            break

        WinActivate ahkId1
        Sleep 500

        ControlClick coordinate, ahkId1,,,, "NA"
        Sleep 500
        imageSearchAndClick("attack-1.png", 80)       
        imageSearchAndClick("create-group.png", 80)
        
        WinActivate ahkId1
        Sleep 500
        imageSearchAndClick("corps-invite.png", 80)

        WinActivate ahkId2
        Sleep 500
        imageSearchAndClick("corps-join-2.png", 80)

        WinActivate ahkId1
        Sleep 500
        imageSearchAndClick("corps-enough-3.png", 80)
        

        imageSearchAndClick("attack-2.png", 80)
        imageSearchAndClick("result-1.png", 80)
        imageArraySearchAndClick(["exit-1.png", "exit-2.png"], 80)
    }
}

autoJoinCorps() {
    global isTerminate := false
    debug.append("Bắt đầu auto gia nhập quân đoàn")
    loop {
        if isTerminate
            break
    
        WinActivate ahkId1
        Sleep 1000
        imageSearchAndClick("corps-join-2.png", 80)
    }
}


~^1:: {
    if (ahkId1 == "") {
        global ahkId1 := getGameId()
        global btnId1
        btnId1.Text := "ID1: " ahkId1
    }
    show(ahkId1)
}


~^2:: {
    if (ahkId2 == "") {
        global ahkId2 := getGameId()
        global btnId2
        btnId2.Text := "ID2: " ahkId2
    }
    show(ahkId2)
}

show(ahkId) {
    WinActivate ahkId
    Sleep 500
}


getGameId() {
    try {
        return WinGetID(title)
    } catch {
        MsgBox("Vui lòng mở cửa sổ game trước khi lấy ID")
    }
}


imageSearchAndClick(name, time := 1) {
    debug.append("Tìm kiếm: " name)
    return imgUtils.searchAndClick(name, time)
}


imageArraySearchAndClick(names, time := 1) {
    loop time {
        for name in names {
            if imageSearchAndClick(name, 1)
                return true
        }
    }
    return false
}


terminate(*) {
    global isTerminate := true
    imgUtils.isTerminate := true
    debug.append("Stop auto")
}


selectCoordinate() {
    KeyWait "RButton", "D T30"
    return coordinate
}


~RButton Up:: {
    pid := WinActive(title)
    if (pid == 0) {
        return
    }

    MouseGetPos &x, &y, &id
    global coordinate := "x" x " y" y
    btnCorpsCoordinate.Text := "Toạ độ quân đoàn: " coordinate
    debug.append("Toạ độ đã chọn: " coordinate)
}

class ImageUtils {
    title := ""
    imageRoot := ""
    topX := 0
    topY := 0
    bottomX := 0
    bottomY := 0

    isTerminate := false


    __New(title, imageRoot, topX := 0, topY := 0, bottomX := 1200, bottomY := 800) {
        this.title := title
        this.imageRoot := imageRoot
        this.topX := topX
        this.topY := topY
        this.bottomX := bottomX
        this.bottomY := bottomY
    }

    searchAndClick(name, time := 1) { ; 10 seconds
        ahkId := WinGetID(this.title)
        loop time {
            if (this.isTerminate) {
                this.isTerminate := false
                return false
            }

            if (this.search(name, &x, &y)) {
                ControlClick "x" x + 5 " y" y + 5, ahkId,,,, "NA"
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