package endscreen;

import event.Event;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import observer.Observer;
import templates.Menu;

/**
 * ...
 * @author ...
 */
class EndScreen extends Menu implements Observer
{
	private var score:Int;
	private var message:String;
	
	private var scoreText:FlxText;
	private var messageText:FlxText;
	
	public function new(color:FlxColor, alpha:Float, score:Int, message:String)
	{
		this.score = score;
		this.message = message;
		super(color,alpha,this);
	}
	override public function create()
	{
		super.create();
		
		messageText = new FlxText(FlxG.width/2-250,FlxG.height/2-50, 500, message); // x, y, width
		messageText.setFormat(null, 40, FlxColor.WHITE, CENTER);
		messageText.cameras = [FlxG.cameras.list[5]];
		add(messageText);
		
		
		scoreText = new FlxText(FlxG.width/2-250,FlxG.height/2, 500,"Score: "+Std.string(score)); // x, y, width
		scoreText.setFormat(null, 40, FlxColor.WHITE, CENTER);
		scoreText.setBorderStyle(OUTLINE, FlxColor.RED, 5);
		scoreText.cameras = [FlxG.cameras.list[5]];
		add(scoreText);
		
	}
	
	/* INTERFACE observer.Observer */
	public function onNotify(event:Event):Void {}
}