package utils.windows;

import lime.system.DisplayMode;
import lime.system.Display;
import lime.ui.MouseCursor;
import lime.graphics.RenderContext;
import lime.app.Application.current as App;

#if windows
@:buildXml('
    <target id="haxe">
        <lib name="dwmapi.lib" if="windows" />
        <lib name="shell32.lib" if="windows" />
        <lib name="gdi32.lib" if="windows" />
        <lib name="ole32.lib" if="windows" />
        <lib name="uxtheme.lib" if="windows" />
    </target>
')

// majority is taken from microsofts doc 
@:cppFileCode('
    #include "mmdeviceapi.h"
    #include "combaseapi.h"
    #include <iostream>
    #include <Windows.h>
    #include <cstdio>
    #include <tchar.h>
    #include <dwmapi.h>
    #include <winuser.h>
    #include <Shlobj.h>
    #include <wingdi.h>
    #include <shellapi.h>
    #include <uxtheme.h>
')
#end

class Window {
    public function new() {}

    public var darkMode(default, set):Bool = false;
    @:functionCode('
        HWND window = GetActiveWindow();
        int darkMode = value ? 1 : 0;
        if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
            DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
        }
    ')
    public function set_darkMode(value:Bool)
        return value;

    public var vsync(get, set):Bool;
    public function get_vsync() return App.window.context.attributes.vsync;
    public function set_vsync(value:Bool) {
        App.window.context.attributes.vsync = true;
        return value;
    }
}