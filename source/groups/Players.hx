package groups;
import flixel.FlxG;
import flixel.FlxState;
import player.Player;


/**
 * ...
 * @author JoshuaEllis
 */
class Players
{
	public static var members:Array<Player> = [];
	private static var pID:Int = 100;

	public function new() {}

	public function add(player:Player)
	{
		trace(pID);
		player.setID(pID);
		pID++;
		members.push(player);
		FlxG.state.add(player);
	}

	public function getScore(player:Player):Int
	{
		var score:Int = 0;
		for (planet in Groups.planets.all())
			for (owner in planet.getOwners())
				if (player.getID() == owner.getID())
					score+= planet.population();
		return score;
	}

	public function all():Array<Player>
	{
		return members;
	}
}