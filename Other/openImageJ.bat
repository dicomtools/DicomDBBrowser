echo on
echo Please wait...

setlocal enableextensions enabledelayedexpansion
call :getargc argc %*
start .\Other\Fiji.app\ImageJ-win64.exe -macro openImageJ.ijm "%*"
exit
endlocal
goto :eof

:getargc
    set getargc_v0=%1
    set /a "%getargc_v0% = 0"
:getargc_l0
    if not x%2x==xx (
        shift
        set /a "%getargc_v0% = %getargc_v0% + 1"
        goto :getargc_l0
    )
    set getargc_v0=
    goto :eof
