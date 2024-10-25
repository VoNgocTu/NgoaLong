#Requires AutoHotkey v2.0
#Include CustomGui.ahk
#Include DebugPanel.ahk
#Include ImageUtils.ahk
#Include GameControl.ahk
#SingleInstance Force

title := "Sv 206 Ngọa Long Việt Nam - Coowon Browser"
; title := "Draw.ahk - Games (Workspace) - Visual Studio Code"
; title := "AutoHotkey v2 Help"
; title := "Ngọa Long Vn - Coowon Browser"

isTerminate := false
ahkId := WinGetID(title)


coordinates := []

imgUtils := ImageUtils(ahkId)
debug := DebugPanel()
imgUtils.debug := debug

F1:: {
    autoClick()
}

F2:: {
    global isTerminate := true
    control.terminate()
    imgUtils.terminate()
}

autoClick() {
    global isTerminate := false
    debug.write("Start auto click")

    while !isTerminate {
        for coordinate in coordinates {
            control.controlClick(coordinate)
            Sleep 50
        }
    }
}

; ========================= GUI =========================

mainGui := CustomGui()
control := GameControl(ahkId, debug)

mainGui.newC1Button("Reload", (*) => Reload())
mainGui.newC1Button("Farm Map", (*) => control.autoFarmMap(, coordinates*))
mainGui.newC1Button("Farm Quân Đoàn", (*) => autoFarmCorps())
mainGui.newC1Button("Farm Vào Nhóm", (*) => control.autoCorps())
mainGui.newC2Button("Mở Rương Tinh Tú", (*) => control.rollStar())
mainGui.newC2Button("Leo Map", (*) => control.autoMap())
mainGui.newC2Button("Leo Tháp", (*) => control.autoTower())
mainGui.newC2Button("Farm Võ Khôi Tháp", (*) => control.autoVKT())
mainGui.newC2Button("Farm Đấu Trường", (*) => control.autoCombat())



mainGui.newC1Button("Dừng lại", (*) => control.terminate())
; mainGui.AddDebug()
debug.attachTo(mainGui, "ReadOnly w300 h200")
mainGui.Show("X925 Y790")
; WinGetPos(&x, &y, &w, &h, mainGui.getAhkId())
; debug.show("x" (x + w - 13) " y" y)

; imgUtils.debug := debug


~!1:: {
    pid := WinActive(title)
    if (pid == 0) {
        return
    }

    MouseGetPos &x, &y, &id
    debug.write(x ", " y)
}

; ========================= FEATURE =========================

control1 := 0
control2 := 0

~^1:: {
    global control1 := GameControl(getGameId(), debug)
}


~^2:: {
    global control2 := GameControl(getGameId(), debug)
}


getGameId() {
    try {
        id := WinGetID(title)
        debug.write("ID: " id)
        return id
    } catch {
        MsgBox("Vui lòng mở cửa sổ game trước khi lấy ID")
    }
}

autoFarmCorps() {
    if (coordinates.Length == 0) {
        MsgBox("Vui lòng chọn toạ độ quân đoàn trước")
    }
    coordinate := coordinates.Get(coordinates.Length)
    global control1
    global control2

    control1.activeGameWindow()
    control1.clickChatBox(2, "khung-chat\ẩn") ; click ẩn => hiện
    control1.clickFeature1(2, "tinh-nang\hiện")  ; click hiện => ẩn
    if (control2) {
        control2.activeGameWindow(30, 100)
        control2.clickChatBox(2, "khung-chat\ẩn") ; click ẩn => hiện
        control2.clickFeature1(2, "tinh-nang\hiện")  ; click hiện => ẩn
    }

    loop {
        while !control1.clickFeatureBox(1, "đoàn-chiến") {
            control1.activeGameWindow()

            control1.controlClick(coordinate)
            Sleep 500
            if !control1.clickAttackBox(1, "tấn-công-1") {
                control1.click(1, "lỗi-chiến-báo")
                control1.clickCombatControl2(1, "kết-quả", "kết-quả-2")
                control1.clickCombatControl2(1, "thoát-1", "thoát-2")
            }
        }

        while !control1.clickFeatureBox(1, "đã-vào-đội") {
            control1.clickFeatureBox(1, "lập-đội")
            if (control1.clickFeatureBox(1, "hết-lượt-quân-đoàn")) {
                MsgBox("Lượt farm quân đoàn này đã hết, vui lòng chọn quân đoàn khác.")
                return
            }
            control1.clickFeatureBox(3, "ok")
            control1.clickFeatureBox(3, "mời-đội", "mời-đội-2")
        }

        if (control2) {
            loop {
                control2.activeGameWindow(30, 100)
                loop 5 {
                    control2.clickAdvanced(1, 35, 465 + (A_Index - 1) * 32, 290, 465 + A_Index * 32, "vào-đội")
                }
                if control2.clickFeatureBox(10, "đã-vào-đội") {
                    control1.activeGameWindow()
                    if (control2 && control1.click(3, "2-8", "3-8")) {
                        break
                    }

                    ; Thoát khi vào nhầm đội
                    control2.activeGameWindow(30, 100)
                    control2.clickCombatControl2("thoát-1", "thoát-2")

                } else {
                    control1.activeGameWindow()
                    control1.clickFeatureBox(80, "mời-đội", "mời-đội-2")
                }
            }
        }

        control1.activeGameWindow()
        while control1.clickFeatureBox(1, "đoàn-chiến") {
            control1.clickFeatureBox(1, "khai-chiến")
        }
    }
}




; ========================= FEATURE =========================

~RButton Up:: {
    pid := WinActive(title)
    if (pid == 0) {
        return
    }

    MouseGetPos &x, &y, &id
    coordinate := "x" x " y" y
    coordinates.Push(coordinate)
    debug.write("Toạ độ đã chọn: " coordinate)
}


~^RButton:: {
    pid := WinActive(title)
    if (pid == 0) {
        return
    }

    MouseGetPos &topX, &topY, &id
    KeyWait "RButton", "U"
    MouseGetPos &bottomX, &bottomY, &id

    A_Clipboard := topX ", " topY ", " bottomX ", " bottomY
    debug.write(A_Clipboard)
} 