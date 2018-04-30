package observer;

import observer.Event;
import observer.EventType;

/**
 * ...
 * @author JoshuaEllis
 */
class MouseEvent extends Event 
{
	public var mouseEvents:Array<MouseEventType>
	
	public function new(source:Int, type:EventType,events:Array<MouseEventType>) 
	{
		super(source, type);
		mouseEvents = events;
	}
	
}