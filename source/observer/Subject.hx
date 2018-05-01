package observer;
import event.Event;
import event.EventType;

/**
 * Basic class for subjects in the Observer design pattern.
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<Observer>;
	private var subjectID:Int;
	
	public function new(observer:Observer,?setID:Int = 0)
	{
		subjectID = setID;
		observers = [observer];
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
	
	public function notify(event:Event):Void
	{
		for (obs in observers)
		{
			obs.onNotify(event);
		}
	}
}