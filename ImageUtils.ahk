#Requires AutoHotkey v2.0

class ImageUtils {
    isTerminate := false
    imgRoot := ".\images\search\"
    imgEx := "png"
    imgQuery := "*80 {root}{name}.{extension}"
    idQuery := ""
    ahkId := 0

    debug := 0

    __New(idQuery, imgRoot?) {
        this.idQuery := idQuery
        this.ahkId := WinGetID(this.idQuery)
        if IsSet(imgRoot)
            this.imgRoot := imgRoot
        this.imgQuery := StrReplace(this.imgQuery, "{root}", this.imgRoot)
        this.imgQuery := StrReplace(this.imgQuery, "{extension}", this.imgEx)
    }

    click(times := 1, names*) {
        return this.clickAdvanced(times, , , , , names*)
    }

    clickAdvanced(times := 1, topX := 0, topY := 0, bottomX := 1020, bottomY := 690, names*) {
        loop times {
            if (this.isTerminate) {
                this.isTerminate := false
                return false
            }

            if (this.searchAdvanced(&coordinate, topX, topY, bottomX, bottomY, names*)) {
                ControlClick coordinate, this.ahkId,,,, "NA"
                return coordinate
            }
            Sleep 100
        }
        return false
    }

    search(&outputCoordinate?, names*) {
        return this.searchAdvanced(&outputCoordinate, , , , , names*)
    }

    searchAdvanced(&outputCoordinate?, topX := 0, topY := 0, bottomX := 1020, bottomY := 690, names*) {
        if (this.debug) {
            this.debug.write(names*)
        }

        for name in names {
            if (ImageSearch(&x, &y, topX, topY, bottomX, bottomY, StrReplace(this.imgQuery, "{name}", name))) {
                outputCoordinate := "x" x + 5 " y" y + 5
                return outputCoordinate
            }
        }

        return false    
    }

    terminate() {
        if (this.debug) {
            this.debug.write("Image utils terminated.")
        }
        this.isTerminate := true
    }
}