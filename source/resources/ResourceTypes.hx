package resources;
import flixel.util.FlxColor;

/**
 * @author ...
 */

@:enum
class ResourceTypes
{
	public static var Organic(default, never):FlxColor = FlxColor.GREEN;
	public static var Productivity(default, never):FlxColor = FlxColor.BLUE;
	public static var Science(default, never):FlxColor = FlxColor.WHITE;
	public static var Credits(default, never):FlxColor = FlxColor.ORANGE;
	public static var Materials(default, never):FlxColor = FlxColor.GRAY;
	
	//  \/ testing \/ 
	public static var Power(default, never):FlxColor = FlxColor.RED;
	public static var Happyness(default, never):FlxColor = FlxColor.YELLOW;
	public static var Influence(default, never):FlxColor = FlxColor.PURPLE;
	
	public static var types(default, never):Array<FlxColor> = [ResourceTypes.Organic, ResourceTypes.Productivity, ResourceTypes.Science, ResourceTypes.Credits, ResourceTypes.Materials,
	ResourceTypes.Power,ResourceTypes.Happyness,ResourceTypes.Influence];
}