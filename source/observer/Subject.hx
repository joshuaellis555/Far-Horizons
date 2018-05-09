package observer;
import event.Event;
import event.EventType;
import event.MerchantEvent;
import event.ResourceEvent;

/**
 * Basic class for subjects in the Observer design pattern.
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<Observer>;
	private var subjectID:Int;
	private var answer:Null<Array<Null<Bool>>>;
	
	public function new(?observers:Array<Observer>,?setID:Int = 0)
	{
		subjectID = setID;
		if (observers == null) this.observers = [];
		else this.observers = observers;
	}
	
	public function getID():Int
	{
		return subjectID;
	}
	
	public function setID(newID:Int):Void
	{
		subjectID = newID;
	}
	
	public function addObserver(obs:Observer):Void
	{
		observers.push(obs);
	}
	
	public function removeObserver(obs:Observer):Void
	{
		observers.remove(obs);
	}
	
	public function notify(event:Event):Array<Null<Bool>>
	{
		switch (event.eventType)
		{
			case Resource:{
				var r:ResourceEvent = cast event;
				if (r.returnCall == null)
				{
					r.returnCall = Answer;
					var answers:Array<Null<Bool>> = [];
					for (obs in observers)
					{
						answer = [];
						obs.onNotify(r);
						trace(answer);
						answers = answers.concat(answer);
					}
					return answers;
				}	
			}
			case Merchant:{
				var m:MerchantEvent = cast event;
				if (m.returnCall == null)
				{
					m.returnCall = Answer;
					var answers:Array<Null<Bool>> = [];
					for (obs in observers)
					{
						answer = [];
						obs.onNotify(m);
						trace(answer);
						answers = answers.concat(answer);
					}
					return answers;
				}	
			}
			default:null;	
		}
		for (obs in observers)
		{
			obs.onNotify(event);
		}
		return [null];
	}
	public function directMessage(distination:Observer,event:Event):Array<Null<Bool>>
	{
		switch (event.eventType)
		{
			case Resource:{
				var r:ResourceEvent = cast event;
				if (r.returnCall == null)
				{
					answer = [null];
					r.returnCall = Answer;
					distination.onNotify(r);
					return answer;
				}
			}
			case Merchant:{
				var m:MerchantEvent = cast event;
				if (m.returnCall == null)
				{
					answer = [null];
					m.returnCall = Answer;
					distination.onNotify(m);
					return answer;
				}
			}
			default:null;
		}
		distination.onNotify(event);
		return [null];
	}
	
	private function Answer(a:Array<Null<Bool>>):Array<Null<Bool>>
	{
		answer = a;
		return a;
	}
}