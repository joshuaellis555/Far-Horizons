package resources;
import event.Event;
import resources.Resources;
/**
 * @author JoshuaEllis
 */
interface ResourceEnabled 
{
	public var resources:Resources;
	public function onNotify(event:Event):Void;
}