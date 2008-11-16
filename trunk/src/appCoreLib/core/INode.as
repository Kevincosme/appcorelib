package appCoreLib.core
{
	import flash.events.IEventDispatcher;
	
	public interface INode extends IEventDispatcher
	{
		function get id ():String;
		function set id (value:String):void;
		
		function get data ():Object;
		function set data (value:Object):void;
	}
}