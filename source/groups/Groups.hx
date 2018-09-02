package groups;
import player.Player;
import resources.Resources;

/**
 * @author JoshuaEllis
 */
@:enum
class Groups
{
	public static var planets(default, never):Planets = new Planets();
	public static var players(default, never):Players = new Players();
}