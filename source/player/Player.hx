package player;

import event.Event;
import event.ResourceEvent;
import event.ResourceEventType;
import observer.Observer;
import resources.ResourceTypes;
import resources.Resources;

/**
 * ...
 * @author ...
 */
class Player implements Observer
{
	public var playerResources:Resources;
	
	public function new() 
	{
		playerResources = new Resources([1000, 1000, 1000, 1000, 1000]);
	}
	public function Gain(resources)
	{
		playerResources.add(resources);
	}
	public function Lose(resources)
	{
		playerResources.remove(resources);
	}
	
	
	/* INTERFACE observer.Observer */
	
	public function onNotify(event:Event):Void 
	{
		switch(event.eventType){
			case Resource:{
				var resourceEvent:ResourceEvent = cast event;
				switch(resourceEvent.transactionType)
				{
					case Gain:{
						trace("Gain");
						playerResources.add(resourceEvent.resources);
					}
					case Lose:{
						trace("Lose");
						if (resourceEvent.returnCall!=null){
							resourceEvent.returnCall(playerResources.remove(resourceEvent.resources));
						}else{
							playerResources.remove(resourceEvent.resources);
						}
					}
					case LoseNoCheck:{
						trace("LoseNoCheck");
						playerResources.remove(resourceEvent.resources,false);
					}
					case Check:{
						trace("Check");
						if (resourceEvent.returnCall!=null){
							resourceEvent.returnCall(playerResources.check(resourceEvent.resources));
						}
					}
					default:null;
				}
			}
			default:null;
		}
		trace(playerResources.getMap());
	}
}