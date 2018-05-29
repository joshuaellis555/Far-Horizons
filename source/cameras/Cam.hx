package cameras;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author JoshuaEllis
 */
class Cam extends FlxCamera 
{

	public function new(?X:Int=0, ?Y:Int=0, ?Width:Int=0, ?Height:Int=0,?bgColor:Null<FlxColor>=null,?scrollWidth:Null<Int>=null,?scrollHeight:Null<Int>=null,?antialiasing:Bool=true) 
	{
		super(X, Y, Width, Height, 0);
		if (bgColor != null) this.bgColor = bgColor;
		if (scrollWidth != null && scrollHeight != null){
			trace(0, scrollWidth, 0, scrollHeight);
			this.setScrollBounds(0, scrollWidth, 0, scrollHeight);
		}
		FlxG.cameras.add(this);
	}
	
}