package native;

import cpp.ConstCharStar;
import haxe.io.Path;
import sys.FileSystem;
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



	#define SAFE_RELEASE(punk)  \\
				if ((punk) != NULL)  \\
					{ (punk)->Release(); (punk) = NULL; }

	static long lastDefId = 0;

	static HCURSOR cursor;
')

@:dox(hide)
class Windows {
	@:functionCode('
		int darkMode = enable ? 1 : 0;
		HWND window = GetActiveWindow();
		if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode)))
			DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
	')
	public static function setDarkMode(enable:Bool) {}

	@:functionCode('
		unsigned long long allocatedRAM = 0;
		GetPhysicallyInstalledSystemMemory(&allocatedRAM);
		return (allocatedRAM / 1024);
	')
	public static function getTotalRam():Float{
		return 0;
	}

	#if windows
	@:functionCode('
		HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE); 
		SetConsoleTextAttribute(console, color);
	')
	#end
	public static function __setConsoleColors(color:Int) {

	}

	public static function setConsoleColors(foregroundColor:ConsoleColor = LIGHTGRAY, ?backgroundColor:ConsoleColor = BLACK) {
		var fg = cast(foregroundColor, Int);
		var bg = cast(backgroundColor, Int);
		__setConsoleColors((bg * 16) + fg);
	}
	/*
	public static function consoleColorToOpenFL(color:ConsoleColor) {
		return switch(color) {
			case BLACK:         0xFF000000;
			case DARKBLUE:      0xFF000088;
			case DARKGREEN:     0xFF008800;
			case DARKCYAN:      0xFF008888;
			case DARKRED:       0xFF880000;
			case DARKMAGENTA:   0xFF880000;
			case DARKYELLOW:    0xFF888800;
			case LIGHTGRAY:     0xFFBBBBBB;
			case GRAY:          0xFF888888;
			case BLUE:          0xFF0000FF;
			case GREEN:         0xFF00FF00;
			case CYAN:          0xFF00FFFF;
			case RED:           0xFFFF0000;
			case MAGENTA:       0xFFFF00FF;
			case YELLOW:        0xFFFFFF00;
			case WHITE | _:     0xFFFFFFFF;
		}
	}
	*/

	@:functionCode('
		HWND window = GetActiveWindow();
		HRESULT result = SetWindowTheme(window, L" ", L" ");
	')
	public static function windowsXP() {}

	@:functionCode('
		cursor = LoadCursorFromFile(reinterpret_cast<LPCSTR>(path));
	')
	public static function __loadCursor(path:ConstCharStar) {}

	public static function loadCursor(path:String) {
		var cwd:String = Sys.getCwd();
		if (FileSystem.exists(Path.join([cwd, path])))
			__loadCursor(cast Path.join([cwd, path]));
		else
			__loadCursor(cast path);
	}

	@:functionCode('
		SetCursor(cursor);
	')
	public static function updateCusror() {}
}
#end