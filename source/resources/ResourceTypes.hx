package resources;
import flixel.util.FlxColor;

/**
 * @author ...
 */

@:enum
class ResourceTypes
{
	public static var Productivity(default, never):FlxColor = FlxColor.BLUE;
	public static var Natural(default, never):FlxColor = FlxColor.GREEN;
	public static var Science(default, never):FlxColor = FlxColor.WHITE;
	public static var Minerals(default, never):FlxColor = FlxColor.GRAY;
	public static var Credits(default, never):FlxColor = FlxColor.ORANGE;
	//  \/ testing \/ 
	public static var Power(default, never):FlxColor = FlxColor.RED;
	public static var Happyness(default, never):FlxColor = FlxColor.YELLOW;
	public static var Influence(default, never):FlxColor = FlxColor.PURPLE;
	
	public static var types(default, never):Array<FlxColor> = [ResourceTypes.Productivity, ResourceTypes.Natural, ResourceTypes.Science, ResourceTypes.Minerals, ResourceTypes.Credits,
	ResourceTypes.Power,ResourceTypes.Happyness,ResourceTypes.Influence];
}