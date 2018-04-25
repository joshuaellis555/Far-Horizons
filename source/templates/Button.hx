package templates;

import flixel.FlxSprite;
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
	
	public function new(width:Int,height:Int,x:Int,y:Int,color:FlxColor)//,click:Function,rightClick:Function) 
	{
		super(x, y);
		this.makeGraphic(width, height, color);
		//FlxMouseEventManager.add(this,click,rightClick);
	}
}