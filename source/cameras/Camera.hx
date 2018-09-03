package cameras;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * ...
 * @author JoshuaEllis
 */
class Camera extends FlxBasic 
{
	private var mirror:Null<Camera> = null;
	private var bgcolor:FlxColor;
	private var cam:FlxCamera;
	private var isActive:Bool = false;
	
	public var X:Float;
	public var Y:Float;
	public var width:Int;
	public var height:Int;
	public var zoom:Float;
	
	public var scroll:FlxPoint = new FlxPoint(0, 0);
	
	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, mirror:Null<Camera> = null, bgcolor = FlxColor.TRANSPARENT)
	{
		super();
		
		this.X = X;
		this.Y = Y;
		this.width = Width;
		this.height = Height;
		this.zoom = 0;
		this.mirror = mirror;
		this.bgcolor = bgcolor;
	}
	public function activate()
	{
		cam = new FlxCamera(Std.int(X), Std.int(Y), width, height, Std.int(zoom));
		cam.bgColor = this.bgcolor;
		cam.antialiasing = true;
		isActive = true;
		FlxG.state.add(this);
		FlxG.cameras.add(cam);
	}
	public function flxCam():FlxCamera
	{
		return cam;
	}
	override public function update(elapsed:Float):Void
	{
		if (isActive=true){
			if (mirror!=null){
				cam.x = mirror.X;
				cam.y = mirror.Y;
				cam.width = mirror.width;
				cam.height = mirror.height;
				cam.zoom = mirror.zoom;
				cam.scroll = mirror.scroll;
			} else {
				cam.x = this.X;
				cam.y = this.Y;
				cam.width = this.width;
				cam.height = this.height;
				cam.zoom = this.zoom;
				cam.scroll = this.scroll;
			}
		}
		super.update(elapsed);
		cam.update(elapsed);
	}
}