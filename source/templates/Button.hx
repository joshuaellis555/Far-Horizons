package templates;

import flixel.FlxObject;
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
	
	public function new(width:Int,height:Int,x:Int,y:Int,color:FlxColor,click:Button->Void,rightClick:Button->Void) 
	{
		super(x, y);
		this.makeGraphic(width, height, color);
		FlxMouseEventManager.add(this,null,click,null,null,null,false);
		FlxMouseEventManager.add(this, null, rightClick, null, null, null, null, false, [FlxMouseButtonID.RIGHT]);
	}
}