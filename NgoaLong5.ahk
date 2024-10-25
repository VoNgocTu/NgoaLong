#Requires AutoHotkey v2.0
#Include ImageUtils.ahk
#Include DebugPanel.ahk
#SingleInstance Force

isTerminate := true
~F1:: {
    autoClick()
}

~F2:: {
    terminate()
}

imageRoot := "*80 *TransBlack .\images\search\"
; title := "AutoHotkey v2 Help"
title := "Sv 206 Ngọa Long Việt Nam - Coowon Browser"
; title := "Ngọa Long Vn - Coowon Browser"
try {
    ahkId := WinGetID(title)
} catch {
    MsgBox("Game chưa mở, vui lòng mở game trước khi chạy auto")
    exit()
}

coordinate := ""
imgUtils := ImageUtils(ahkId, imageRoot)
debug := DebugPanel()


; coowonPath := EnvGet("LOCALAPPDATA") "\Coowon\Coowon\Application\chrome.exe"

; BaTomLink := "http://www.ngoalongviet.com:86/Start.aspx?accid=79955&accname=vntu03_s85&serverid=6&tstamp=1827623957&ticket=ab761ccf6c2a355349688a3b28815b93&fcm=1&isguest=&wlydm=526xy.com"


; =============================== GUI =============================== 


guiMain := Gui()
guiMain.OnEvent("Close", (*) => ExitApp())

newButton("Reload", (*) => Reload())
; newButton("3aTom", (*) => Run(coowonPath " " BaTomLink))
newButton("Auto Map", (*) => autoMap())
newButton("Auto Tháp", (*) => autoTower())
newButton("Auto Farm Quân Đoàn", (*) => autoCorps())
newButton("Auto Farm Map", (*) => autoFarmMap())
newButton("Auto Farm Map Tiến Công", (*) => autoFarmMapAdvan())
newButton("Auto Võ Khôi Tháp", (*) => autoWorldTower())
newButton("Auto Mở Hộp Tinh Tú", (*) => rollStar())
newButton("Auto Click", (*) => autoClick())
newButton("Dừng auto", (*) => terminate())

debug.attach(guiMain, "w150 h170 ReadOnly vAttachDebug")

guiMain.Show("X1019 Y0")

newButton(name, callback) {
    global guiMain
    btnStop := guiMain.Add("Button", "w150 h30", name)
    btnStop.OnEvent("Click", callback)
}

; =============================== GUI =============================== 

autoMap() {
    global isTerminate := false
    debug.append("Bắt đầu auto map")
    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000
    
    loop {
        if isTerminate
            break
        
        imageArraySearchAndClick(["enemy-yellow.png", "enemy-yellow-2.png"])
        imageSearchAndClick("attack-1.png")
        imageSearchAndClick("result-1.png")
        imageArraySearchAndClick(["exit-1.png", "exit-2.png"])
        imageSearchAndClick("reset.png")
        Sleep 100
    }
}


autoTower() {
    global isTerminate := false
    debug.append("Bắt đầu auto tháp")
    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000

    reachLastFloor := false
    loop {
        if isTerminate
            break

        if (reachLastFloor) {
            imageSearchAndClick("tower-next.png", 1000)    
        }

        loop 1000 {
            clickNextFloor := imageArraySearchAndClick(["next-tower-floor-select.png", "next-tower-floor-select-2.png"], 1)
            reachLastFloor := imageArraySearchAndClick(["last-tower-floor-select.png", "last-tower-floor-select-2.png"], 1)
            if (clickNextFloor || reachLastFloor || isTerminate)
                break
        }
        
        imageSearchAndClick("tower-attack.png", 1000)
        imageSearchAndClick("tower-confirm.png", 1000)
        loop 7 {
            imageSearchAndClick("tower-solider.png", 1)
            Sleep 1000
        }
        imageSearchAndClick("exit-1.png", 1000)
    }
}


autoCorps() {
    global isTerminate := false
    debug.append("Bắt đầu auto quân đoàn")
    debug.append("Toạ độ: " coordinate)

    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000

    loop {
        if isTerminate
            break

        ControlClick coordinate, ahkId,,,, "NA"
        Sleep 500
        imageSearchAndClick("attack-1.png", 80)       
        imageSearchAndClick("create-group.png", 80)
        ; imageSearchAndClick("corps-invite.png", 80)
        Sleep 1000
        ; imageSearchAndClick("corps-invite.png", 5)
        ; imageSearchAndClick("corps-enough.png", 80)

        ; imageSearchAndClick("corps-join.png", 80)

        imageSearchAndClick("attack-2.png", 80)
        imageSearchAndClick("result-1.png", 80)
        imageArraySearchAndClick(["exit-1.png", "exit-2.png"], 80)
    }
}

autoWorldTower() {
    global isTerminate := false
    debug.append("Bắt đầu auto Võ Khôi tháp")

    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000

    loop {
        if isTerminate
            break

        autoWorldTowerActions()
    }
    
}

autoWorldTowerActions() {
    imageSearchAndClick("thế-giới.png", 100)
    imageSearchAndClick("\khung-chat\ẩn.png", 5) ; click ẩn => hiện
    imageSearchAndClick("\vo-khoi-thap\tháp.png", 100)
    imageSearchAndClick("\vo-khoi-thap\tấn-công.png", 100)
    imageSearchAndClick("\vo-khoi-thap\lập-đội.png", 100)
    
    if imageSearchAndClick("\vo-khoi-thap\hết-quân-lệnh.png", 10) {
        imageArraySearchAndClick(["\vo-khoi-thap\thoát-1.png", "\vo-khoi-thap\thoát-2.png"], 5)
        imageArraySearchAndClick(["\vo-khoi-thap\thoát-1.png", "\vo-khoi-thap\thoát-2.png"], 5)
                
        rollStar(300)

        imageSearchAndClick("\tinh-nang\trang-bị.png", 5)

        notFoundTimes := 0
        while notFoundTimes < 5 {
            if imageArraySearchAndClick(["\trang-bi\hộp-1.png", "\trang-bi\hộp-2.png"]) {
                imageArraySearchAndClick(["\trang-bi\sử-dụng-1.png", "\trang-bi\sử-dụng-2.png"])
                Sleep 100
            } else {
                notFoundTimes++
            }
        }

        imageSearchAndClick("x.png", 5)
        return
    }

    imageSearchAndClick("\vo-khoi-thap\khai-chiến.png", 100)

    while !imageSearchAndClick("ok.png", 5) {
        imageSearchAndClick("\vo-khoi-thap\tấn-công-boss.png", 5)

        if (imgUtils.search("\thong-bao\bạc-vượt-giới-hạn.png") != "") {
            Sleep 1000
            imageSearchAndClick("cường-hoá.png")
            Sleep 10000
            imageSearchAndClick("\trang-bi\cửa-hiệu.png")
            Sleep 200
            loop 15 {
                imageSearchAndClick("lăn-xuống.png")    
            }
            imageSearchAndClick("\trang-bi\cua-hieu\rương-1-tỷ.png")
            Sleep 200
            imageSearchAndClick("\trang-bi\mua.png")
            Sleep 200
            imageSearchAndClick("\trang-bi\mua.png")
    
            imageSearchAndClick("x.png", 20)
        }
        Sleep 500
    }
}

rollStar(times := 100) {
    global isTerminate := false

    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000

    ; imageSearchAndClick("về-thành.png", 5)
    ; Sleep 500
    imageSearchAndClick("\khung-chat\hiện.png", 5) ; click hiện => ẩn
    imageSearchAndClick("\tinh-nang\ẩn.png", 5) ; click ẩn => hiện
    imageSearchAndClick("\tinh-nang\tinh-tú.png", 5)

    imageSearchAndClick("\tinh-tu\rương.png", 100) ; chờ load tinh tú 10s
    imageSearchAndClick("\tinh-tu\ngừng-mở.png", 5)
    Sleep 1000
    coordinate1 := imgUtils.search("\tinh-tu\tự-mở-1.png")
    if (coordinate1 == "")
        coordinate1 := imgUtils.search("\tinh-tu\tự-mở-2.png")
    ControlClick coordinate1, ahkId,,,, "NA"
    debug.append("Toạ độ 1: " coordinate1)

    Sleep 500
    coordinate2 := imgUtils.search("ok.png")
    debug.append("Toạ độ 2: " coordinate2)
    loop times {
        if isTerminate
            break

        ControlClick coordinate1, ahkId,,,, "NA"   
        ControlClick coordinate1, ahkId,,,, "NA"   
        ControlClick coordinate2, ahkId,,,, "NA"   

        if (imgUtils.search("\tinh-tu\không-đủ-rương.png") != "") {
            break
        }

        if (imgUtils.search("\thong-bao\lúa-vượt-giới-hạn.png") != "") {
            imageSearchAndClick("huỷ-bỏ.png")
            imageSearchAndClick("ok.png")
        }
    }

    Sleep 500
    loop 10 {
        imageArraySearchAndClick(["ok.png", "ok-2.png"])
        Sleep 200
    }
    imageSearchAndClick("\tinh-tu\ngừng-mở.png", 5)
}


autoFarmMap() {
    global isTerminate := false
    debug.append("Bắt đầu auto farm map")
    debug.append("Toạ độ: " coordinate)

    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000

    loop {
        if isTerminate
            break

        ControlClick coordinate, ahkId,,,, "NA"
        Sleep 100
        imageArraySearchAndClick(["attack-1.png", "attack-3.png"], 1)
        imageSearchAndClick("farm-map-warn.png", 1)
    }
}


autoFarmMapAdvan() {
    global isTerminate := false
    debug.append("Bắt đầu auto farm map")
    debug.append("Toạ độ: " coordinate)

    WinActivate ahkId
    WinMove 0, 0, 1029, 698, ahkId
    Sleep 1000

    loop {
        if isTerminate
            break

        ControlClick coordinate, ahkId,,,, "NA"
        Sleep 100
        imageSearchAndClick("advan-attack-1.png", 1)
        imageSearchAndClick("farm-map-warn.png", 1)
    }
}



autoClick() {
    global isTerminate := false
    debug.append("Start auto click")

    loop {
        if isTerminate
            break

        ControlClick coordinate, ahkId,,,, "NA"   
        Sleep 50
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
    debug.append("Toạ độ đã chọn: " coordinate)
}