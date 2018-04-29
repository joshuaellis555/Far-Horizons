package templates;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Constraints.Function;

/**
 * ...
 * @author ...
 */
class Button extends FlxSprite 
{
	public function new(width:Int,height:Int,x:Int,y:Int,color:FlxColor,object:ButtonTriggers) 
	{
		super(x, y);
		this.makeGraphic(width, height, color);
		trace(object.Clicked);
		FlxMouseEventManager.add(this,null,object.Clicked,null,null,null,null,false,[FlxMouseButtonID.LEFT,FlxMouseButtonID.RIGHT]);
	}
}