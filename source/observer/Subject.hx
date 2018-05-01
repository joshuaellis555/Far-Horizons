package observer;

/**
 * Basic class for subjects in the Observer design pattern.
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<Observer>;
	private var subjectID:Int;
	private var subjectType:EventType;
	
	public function new(setType:EventType,observer:Observer,?setID:Int = 0)
	{
		subjectID = setID;
		subjectType = setType;
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
	
	public function getType():EventType
	{
		return subjectType;
	}
	
	public function setType(newType:EventType):Void
	{
		subjectType = newType;
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