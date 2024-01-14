#if windows
import native.Windows;
#end
import haxe.PosInfos;
import native.ConsoleColor;

class Log {
	public static inline function retrace(v:Dynamic, color:ConsoleColor = WHITE, ?infos:PosInfos) {
		#if windows
		Windows.setConsoleColors(color, BLACK);
		#end

		var filePosInfo:String = '${infos.fileName}:${infos.lineNumber}';
		var date:Date = Date.now();
		var str:String = '$filePosInfo [${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}]: $v';
		#if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
			(untyped console).log(str);
		#elseif lua
		untyped __define_feature__("use._hx_print", _hx_print(str));
		#elseif sys
		Sys.println(str);
		#else
		throw new haxe.exceptions.NotImplementedException();
		#end

		#if windows
		Windows.setConsoleColors(WHITE, BLACK);
		#end
	}
}