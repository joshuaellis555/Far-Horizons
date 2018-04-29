package player;

import templates.Observer;

/**
 * ...
 * @author ...
 */
class Player extends Observer 
{
	public var playerResources:Resources;
	
	public function new() 
	{
		super();
		playerResources = new Resources(1000, 1000, 1000, 1000, 1000);
	}
	override public function notify() 
	{
		super.notify();
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