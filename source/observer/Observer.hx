package observer;
import event.Event;

/**
 * ...
 * @author JoshuaEllis
 */
interface Observer 
{
	public function onNotify(event:Event):Void;
}