package cameras;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author JoshuaEllis
 */
@:enum
class Cameras 
{	
	public static var bgCam(default,never):Camera = new Camera(0, 0, FlxG.width, FlxG.height,null,FlxColor.WHITE);
	public static var mapCam(default, never):Camera = new Camera(0, 0, FlxG.width, FlxG.height);
	public static var planetUiCam(default,never):Camera = new Camera(0, 0, FlxG.width, FlxG.height, mapCam);
	public static var cursorCam(default,never):Camera = new Camera(0, 0, FlxG.width, FlxG.height, mapCam);
	public static var uiCam(default,never):Camera = new Camera(0, 0, FlxG.width, FlxG.height);
}