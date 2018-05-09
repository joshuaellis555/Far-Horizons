package arbiters;

import event.Event;
import event.MerchantEvent;
import event.ResourceEvent;
import event.ResourceEventType;
import observer.Observer;
import observer.Subject;
import groups.Planets;
import groups.Players;
import resources.ResourceEnabled;
import resources.Resources;

/**
 * ...
 * @author JoshuaEllis
 */
class Merchant implements Observer 
{
	private static var subject:Subject = new Subject(null,-1);
	private static var players:Players;
	private static var planets:Planets;
	private static var prices:Null<Resources>;
	
	private var answer:Null<Array<Null<Bool>>>;

	public function new() 
	{
		if (prices == null)
			prices = new Resources([4, 4, 4, 4, 4, null, null, null]);
	}
	
	/* INTERFACE observer.Observer */
	
	public function onNotify(event:Event):Void
	{
		switch(event.eventType){
			case Merchant:{
				var merchantEvent:MerchantEvent = cast event;
				switch(merchantEvent.transactionType)
				{
					case Upkeep:{
						for (planet in planets.all()){
							planet.upkeep();
						}
					}
					case Pay:{
						for (buyer in merchantEvent.buyers){
							for (seller in merchantEvent.sellers){
								buyer.onNotify(new ResourceEvent(subject, seller.resources, ResourceEventType.Gain));
							}
						}
					}
					case Charge:{
						var answers:Array<Bool> = [];
						for (buyer in merchantEvent.buyers){
							for (seller in merchantEvent.sellers){
								answer = [null];
								buyer.onNotify(new ResourceEvent(subject, seller.resources, ResourceEventType.Lose, this.Answer));
								answer = answers.concat(answer);
							}
						}
						trace(merchantEvent.returnCall,answer);
						merchantEvent.returnCall(answer);
					}
					case ReportIncome:{
						
					}
					default:null;
				}
			}
			default:null;
		}
	}
	
	private function Answer(a:Array<Null<Bool>>):Array<Null<Bool>>
	{
		answer = a;
		return a;
	}
}