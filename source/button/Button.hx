package button;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import event.Event;
import event.EventType;
import event.MouseEvent;
import event.MouseEventType;
import observer.Observer;
import observer.Subject;

/**
 * ...
 * @author ...
 */
class Button extends FlxSprite 
{
	private var buttons:Array<MouseEventType>;
	private var buttonSubject:Subject;
	public function new(width:Int, height:Int, x:Int, y:Int, color:FlxColor,observer:Observer,?camera:Null<FlxCamera>=null,?image:Null<FlxGraphicAsset>=null,?imgW=0,?imgH=0)
	{
		if (image == null){
			trace("asdf");
			super(x, y);
			this.makeGraphic(width, height, color);
		}else{
			trace("qwer");
			super(x, y);
			this.loadGraphic(image, false, imgW, imgH);
		}
		
		if (camera != null){this.cameras = [camera]; }
		
		FlxMouseEventManager.add(this, mouseDown, mouseUp, mouseOver, mouseOff, null, null, false, [FlxMouseButtonID.LEFT, FlxMouseButtonID.RIGHT]);
		buttons = [];
		buttonSubject = new Subject(observer);
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
		if (buttons.length>0){
			buttonSubject.notify(new MouseEvent(buttonSubject,buttons));
			buttons = [];
		}
	}
}