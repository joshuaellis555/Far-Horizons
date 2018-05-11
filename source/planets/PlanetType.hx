package planets;

/**
 * @author JoshuaEllis
 */
@:enum
class PlanetType
{
	public static var BLUE(default, never):Int = 0;
	public static var GREEN(default, never):Int = 1;
	public static var WHITE(default, never):Int = 2;
	public static var GRAY(default, never):Int = 3;
	public static var ORANGE(default, never):Int = 4;
	public static var PURPLE(default, never):Int = 5;
	public static var types(default, never):Array<Int> =[
	cast PlanetType.BLUE, cast PlanetType.GREEN, cast PlanetType.WHITE, cast PlanetType.GRAY, cast PlanetType.ORANGE, cast PlanetType.PURPLE];
}