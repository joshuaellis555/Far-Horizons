package player;

import observer.Observer;

/**
 * ...
 * @author ...
 */
class Player
{
	public var playerResources:Resources;
	
	public function new() 
	{
		playerResources = new Resources(1000, 1000, 1000, 1000, 1000);
	}
	public function pay(resources)
	{
		playerResources.add(resources);
	}
	public function charge(resources)
	{
		playerResources.remove(resources);
	}
}