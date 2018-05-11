package player;

import event.Event;
import event.ResourceEvent;
import event.ResourceEventType;
import observer.Observer;
import observer.Subject;
import groups.Players;
import resources.ResourceEnabled;
import resources.ResourceTypes;
import resources.Resources;

/**
 * ...
 * @author ...
 */
class Player implements Observer implements ResourceEnabled
{
	public var income:Resources = new Resources([0, 0, 0, 0, 0, 0, 0, 0]);
	private var incomeSources:Map<Int,Resources>=new Map<Int,Resources>();
	
	public var resources:Resources;
	
	public var playerSubject:Subject;
	
	public function new(resources:Resources) 
	{
		this.resources = resources;
		
		playerSubject = new Subject();
		
		var players:Players = new Players();
		players.add(this);
	}
	public function updateIncome()
	{
		income = new Resources([0, 0, 0, 0, 0, 0, 0, 0]);
		for (key in incomeSources.keys())
		{
			income.add(incomeSources[key]);
		}
		
	}
	
	public function getID():Int
	{
		return playerSubject.getID();
	}
	public function setID(newID:Int)
	{
		playerSubject.setID(newID);
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
						resources.add(resourceEvent.resources);
					}
					case Lose:{
						resources.remove(resourceEvent.resources);
					}
					case LoseNoCheck:{
						resources.remove(resourceEvent.resources,false);
					}
					case Update:{
						incomeSources[event.eventSource] = resourceEvent.resources;
					}
					default:null;
				}
			}
			default:null;
		}
	}
}