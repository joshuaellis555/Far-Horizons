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
	
	public function getScore(player:Player):Int
	{
		var score:Int = 0;
		for (planet in Groups.planets.all())
			if (planet.getOwner().getID() == player.getID())
				score+= planet.population();
		return score;
	}
	
	public function all():Array<Player>
	{
		return members;
	}
}