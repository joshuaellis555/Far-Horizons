package groups;
import player.Player;

/**
 * ...
 * @author JoshuaEllis
 */
class Players 
{
	public static var members:Array<Player> = [];
	private static var pID:Int=100;
	
	public function new(){}
	
	public function add(player:Player)
	{
		player.setID(pID);
		pID++;
		members.push(player);
	}
	
	public function all():Array<Player>
	{
		return members;
	}
}