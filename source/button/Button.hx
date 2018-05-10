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
	public function new(width:Int, height:Int, x:Int, y:Int, color:FlxColor,observer:Observer,?id:Int=0,?camera:Null<FlxCamera>=null,?pixelPerfect:Bool=false,?mouseChildren:Bool=false,?image:Null<FlxGraphicAsset>=null,?animated:Bool=false,?imgW=0,?imgH=0)
	{
		if (image == null){
			super(x, y);
			this.makeGraphic(width, height, color);
		}else{
			super(x, y);
			this.loadGraphic(image, animated, imgW, imgH);
		}
		if (camera!=null)
			this.cameras = [camera];
		
		FlxMouseEventManager.add(this, this.mouseDown, this.mouseUp, this.mouseOver, this.mouseOff, mouseChildren, true, pixelPerfect, [FlxMouseButtonID.LEFT, FlxMouseButtonID.RIGHT]);
		buttons = [];
		buttonSubject = new Subject([observer],id);
	}
	private function mouseDown(button:Button):Void
	{
		if (FlxG.mouse.justPressed){
			buttons.push(MouseEventType.LeftJustClicked);
		}
		else if (FlxG.mouse.justPressedRight){
			buttons.push(MouseEventType.RightJustClicked);
		}
	}
	private function mouseUp(button:Button):Void
	{
		if (FlxG.mouse.justReleased){
			buttons.push(MouseEventType.LeftJustReleased);
		}
		else if (FlxG.mouse.justReleasedRight){
			buttons.push(MouseEventType.RightJustReleased);
		}
	}
	private function mouseOver(button:Button):Void
	{
		buttons.push(MouseEventType.MouseOver);
	}
	private function mouseOff(button:Button):Void
	{
		buttons.push(MouseEventType.MouseOff);
	}
	override public function update(elapsed:Float):Void
	{
		//trace(FlxG.cameras.list[5].scroll,"button1");
		super.update(elapsed);
		if (buttons.length > 0){
			buttonSubject.notify(new MouseEvent(buttonSubject,buttons));
			buttons = [];
		}
		//trace(FlxG.cameras.list[5].scroll,"button");
	}
}