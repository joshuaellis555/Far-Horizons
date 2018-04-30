package button;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import observer.MouseEventType;

/**
 * ...
 * @author ...
 */
class Button extends FlxSprite 
{
	private var buttons:Array<MouseEventType>;
	public function new(width:Int, height:Int, x:Int, y:Int, color:FlxColor)
	{
		super(x, y);
		this.makeGraphic(width, height, color);
		FlxMouseEventManager.add(this, mouseDown, mouseUp, mouseOver, mouseOff, null, null, false, [FlxMouseButtonID.LEFT, FlxMouseButtonID.RIGHT]);
		buttons = [];
	}
	public function mouseDown(button:Button):Void
	{
		if (FlxG.mouse.justPressed){
			buttons.push(MouseEventType.LeftJustClicked);
		}
		else if (FlxG.mouse.justPressedRight){
			buttons.push(MouseEventType.RightJustClicked);
		}
	}
	public function mouseUp(button:Button):Void
	{
		if (FlxG.mouse.justReleased){
			buttons.push(MouseEventType.LeftJustReleased);
		}
		else if (FlxG.mouse.justReleasedRight){
			buttons.push(MouseEventType.RightJustReleased);
		}
	}
	public function mouseOver(button:Button):Void
	{
		
	}
	public function mouseOff(button:Button):Void
	{
		
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		buttons = [];
	}
}