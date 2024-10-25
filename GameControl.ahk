#Requires AutoHotkey v2.0
#Include ImageUtils.ahk

class GameControl {
    ahkId := 0
    imgUtils := 0
    debug := 0
    isTerminate := false
    

    __New(ahkId, debugGui) {
        this.ahkId := ahkId
        this.imgUtils := ImageUtils(this.ahkId)
        this.imgUtils.debug := debugGui
        this.debug := debugGui
    }

    terminate() {
        this.isTerminate := true
        this.imgUtils.terminate()
    }


    autoCombat() {
        this.isTerminate := false
        this.debug.write("Bắt đầu farm đấu trường")
        this.activeGameWindow()

        while !this.isTerminate {
            this.clickAdvanced(1, 309, 387, 414, 426, "dau-truong/khiêu-chiến")
            this.clickAdvanced(1, 412, 412, 514, 452, "ok")
            this.clickAdvanced(1, 766, 576, 919, 603, "kết-quả")
            this.clickAdvanced(1, 766, 576, 919, 603, "dau-truong/xác-nhận")
            this.clickCombatControl2(1, "kết-quả", "kết-quả-2")
            this.clickCombatControl1(1, "thoát-1", "thoát-2")
        }
    }


    autoMap() {
        this.isTerminate := false
        this.debug.write("Bắt đầu leo map.")
        this.activeGameWindow()
        
        while !this.isTerminate {
            this.click(50, "đã-thoát-chiến-đấu")
            while !this.isTerminate && this.click(1, "đã-thoát-chiến-đấu") {
                if (this.click(1, "enemy-yellow", "enemy-yellow-2")) {
                    this.click(5, "tấn-công-1")
                }

                if (this.click(1, "quân-đoàn")) {
                    this.click(5, "tấn-công-1")
                    this.click(5, "lập-đội")
                    this.click(5, "khai-chiến")
                }

                if (Mod(A_Index, 10) == 0) {
                    this.click(1, "bỏ-qua-1", "bỏ-qua-2")
                    this.click(1, "ok")
                    this.click(1, "có-thêm-điểm-skill")
                    this.click(1, "x-nâng-skill")
                    this.click(1, "leo-map-thông-báo-1")
                }
            }
            
            this.click(50, "chưa-thoát-chiến-đấu")
            while !this.isTerminate && this.search(, "chưa-thoát-chiến-đấu") {
                this.click(1, "kết-quả")
                this.click(1, "thoát-1", "thoát-2")
            }
            
            this.click(1, "x")
        }
    }

    autoFarmMap(times := 20, coordinates*) {
        this.isTerminate := false
        this.debug.write("Bắt đầu farm map")
        this.activeGameWindow()

        while !this.isTerminate {
            for coordinate in coordinates {
                ControlClick coordinate, this.ahkId,,,, "NA"
                Sleep 200
                this.clickAttackBox(100 , "tiến-công", "tấn-công-1", "tấn-công-2")
                ; Sleep 100
            }
        }
    }

    autoCorps() {
        this.isTerminate := false
        this.debug.write("Bắt đầu farm map")
        this.activeGameWindow()

        while !this.isTerminate {
            this.click(100, "vào-nhóm")
            this.click(1, "lỗi-chiến-báo")
            Sleep 3000
        }
    }


    autoVKT() {
        global isTerminate := false
        this.debug.write("Bắt đầu auto Võ Khôi tháp")
        this.activeGameWindow()
    
        while !this.isTerminate {
            this.clickFeature2(5, "thế-giới")
            this.clickChatBox(5, "khung-chat\hiện")
            this.clickFeature1(5, "tinh-nang\hiện")
            this.clickAdvanced(100, 197, 387, 286, 451, "vo-khoi-thap\tháp")
            click(100, "vo-khoi-thap\tấn-công")
            click(100, "vo-khoi-thap\lập-đội")
            
            if this.click(5, "vo-khoi-thap\hết-quân-lệnh") {
                click(5, "vo-khoi-thap\thoát-1", "vo-khoi-thap\thoát-2")
                click(5, "vo-khoi-thap\thoát-1", "vo-khoi-thap\thoát-2")
                        
                this.rollStar(300)
        
                this.clickFeature2(5, "tinh-nang\trang-bị")
        
                notFoundTimes := 0
                while notFoundTimes < 5 {
                    if this.clickFeatureBox(1, "trang-bi\hộp-1", "trang-bi\hộp-2") {
                        this.clickAdvanced(1, 469, 480, 555, 513, "trang-bi/sử-dụng-1", "trang-bi/sử-dụng-2")
                    } else {
                        notFoundTimes++
                    }
                }
        
                this.click(5, "x")
                continue
            }
        
            click(100, "vo-khoi-thap\khai-chiến")
        
            while !click(5, "ok") {
                click(20, "vo-khoi-thap\tấn-công-boss")
        
                if (this.imgUtils.search(, "thong-bao\bạc-vượt-giới-hạn")) {
                    Sleep 1000
                    this.clickFeatureBox(5, "cường-hoá")
                    Sleep 15000
                    this.clickFeatureBox(5, "trang-bi\cửa-hiệu")
                    Sleep 1000
                    loop 15 {
                        this.clickFeatureBox(5, "lăn-xuống")
                    }
                    this.clickFeatureBox(5, "trang-bi\cua-hieu\rương-1-tỷ")
                    Sleep 200
                    this.clickFeatureBox(5, "trang-bi\mua")
                    Sleep 200
                    this.clickFeatureBox(5, "trang-bi\mua")
            
                    this.clickFeatureBox(20, "x")
                }
            }
        }
        
        click(times, names*) {
            return this.clickAdvanced(times, 342, 484, 914, 682, names*)
        }
    }
    
    
    rollStar(times := 100) {
        global isTerminate := false
    
        this.activeGameWindow()
    
        this.clickChatBox(3, "khung-chat\hiện")
        this.clickFeature1(3, "tinh-nang\ẩn")
        
        while !this.clickFeatureBox(1, "tinh-tu\rương") {
            Sleep 3000
            this.clickFeature1(1, "tinh-nang\tinh-tú")
        }
        this.clickFeatureBox(5, "tinh-tu\ngừng-mở")
        Sleep 1000
        coordinate1 := this.clickFeatureBox(1, "tinh-tu\tự-mở-1", "tinh-tu\tự-mở-2")
        Sleep 500
        coordinate2 := this.clickFeatureBox(1, "ok")

        loop times {
            if isTerminate
                break
    
            ControlClick coordinate1, this.ahkId,,,, "NA"
            Sleep 50   
            ControlClick coordinate1, this.ahkId,,,, "NA"   
            Sleep 50   
            ControlClick coordinate2, this.ahkId,,,, "NA"   
            Sleep 50   
    
            if (this.clickFeatureBox(1, "tinh-tu\không-đủ-rương")) {
                break
            }
    
            if (this.clickFeatureBox(1, "thong-bao\lúa-vượt-giới-hạn")) {
                this.clickFeatureBox(3, "huỷ-bỏ")
                this.clickFeatureBox(3, "ok")
            }
        }
    
        Sleep 500
        loop 10 {
            this.clickFeatureBox(1, "ok", "ok-2")
            Sleep 200
        }
        this.clickFeatureBox(3, "tinh-tu\ngừng-mở", "tinh-tu\ngừng-mở-2")
    }


    autoTower() {
        global isTerminate := false
        this.debug.write("Bắt đầu auto tháp")
        this.activeGameWindow()
    
        reachLastFloor := false
        while !isTerminate {
            if (reachLastFloor) {
                this.click(1000, "tower-next")
            }
    
            loop 1000 {
                clickNextFloor := this.click(1, "next-tower-floor-select", "next-tower-floor-select-2")
                reachLastFloor := this.click(1, "last-tower-floor-select", "last-tower-floor-select-2")
                if (clickNextFloor || reachLastFloor || isTerminate)
                    break
            }
            
            this.click(1000, "tower-attack")
            this.click(1000, "tower-confirm")
            while !this.click(1, "thoát-1") {
                this.click(1, "tower-solider")
                this.click(1, "ok")
                Sleep 500
            }
        }
    }


    clickFeature1(times, names*) {
        return this.clickAdvanced(times, 366, 114, 858, 214, names*)
    }

    clickFeature2(times, names*) {
        return this.clickAdvanced(times, 660, 556, 1006, 669, names*)
    }

    clickFeatureBox(times, names*) {
        return this.clickAdvanced(times, 185, 185, 830, 585, names*)
    }

    clickAttackBox(times, names*) {
        return this.clickAdvanced(times, 360, 250, 665, 510, names*)
    }

    clickChatBox(times, names*) {
        return this.clickAdvanced(times, 10, 466, 288, 679, names*)
    }

    clickCombatControl1(times, names*) {
        return this.clickAdvanced(times, 418, 470, 601, 508, names*)
    }

    clickCombatControl2(times, names*) {
        return this.clickAdvanced(times, 786, 643, 1007, 671, names*)
    }



    search(&outputCoordinate?, names*) {
        return this.imgUtils.search(&outputCoordinate, names*)
    }

    click(times, names*) {
        return this.imgUtils.click(times, names*)
    }

    clickAdvanced(times, x1 := 0, y1 := 0, x2 := 1020, y2 := 690, names*) {
        return this.imgUtils.clickAdvanced(times, x1, y1, x2, y2,  names*)
    }

    controlClick(coordinate) {
        ControlClick coordinate, this.ahkId,,,, "NA"
    }

    activeGameWindow(x := 0, y := 0) {
        WinActivate this.ahkId
        WinMove x, y, 1029, 698, this.ahkId
        Sleep 1000
    }
}