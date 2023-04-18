package flixel.custom.system;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import lime.ui.Window;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
import openfl.Lib;
import openfl.display.Sprite;

using StringTools;

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

class FlxCrashHandler extends Sprite
{
    public function new()
    {
        super();
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    }

    function onCrash(e:UncaughtErrorEvent)
    {
        var name:String = "Another-Rhythm-Game";
        var errMsg:String = '\nUncaught Error: ${e.error}';

        Application.current.window.alert(errMsg, 'FlixelCrashHandler/$name');

        Sys.exit(1);
    }

    public static function alert(win:String, message:String, exit:Bool = false) {
        var name:String = "Another-Rhythm-Game";
        var errMsg:String = message;

        Application.current.window.alert(errMsg, win);
        if (exit) {
            Sys.exit(1);
        }
    }
}