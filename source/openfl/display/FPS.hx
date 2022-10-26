
//credit to https://keyreal-code.github.io/haxecoder-tutorials/17_displaying_fps_and_memory_usage_using_openfl.html lol
package openfl.display;
import haxe.Timer;
import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**

 * FPS class extension to display memory usage.

 * @author Kirill Poletaev

 */
class FPS extends TextField

{
	private var times:Array<Float>;
	private var memPeak:Float = 0;
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();
		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 14, inCol);
		text = "FPS: ";
		times = [];
		currentFPS = 0;
		cacheCount = 0;
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;

	}
	private function onEnter(_)

	{	
		var now = Timer.stamp();
		times.push(now);		
		while (times[0] < now - 1) times.shift();		
		
		textColor = 0xFFFFFFFF;
		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.framerate) currentFPS = ClientPrefs.framerate;
		
		var mem:Float = Math.abs(Math.round(System.totalMemory / (1e+6)));
		if (mem > 3000 || currentFPS <= ClientPrefs.framerate / 2)
		{
			textColor  = 0xFFFF0000;
		}

		if (mem > memPeak) memPeak = mem;
		if (visible)
		{	
			text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";	
		}
	}
}