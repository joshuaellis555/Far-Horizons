package templates;

import button.Button;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import observer.Observer;

/**
 * ...
 * @author 
 */
class Menu extends FlxSubState
{
	private var background:Button;
	private var color:FlxColor;
	private var alpha:Float;
	private var observer:Observer;
	
	public function new(color:FlxColor,alpha:Float,observer:Observer)
	{
		this.color = color;
		this.alpha = alpha;
		this.observer = observer;
		super(FlxColor.TRANSPARENT);
	}
	override public function create()
	{
		super.create();
		background = new Button(FlxG.width, FlxG.height, 0, 0 , color, observer, 99, FlxG.cameras.list[3]);
		background.alpha = alpha;
		add(background);
		
	}
}