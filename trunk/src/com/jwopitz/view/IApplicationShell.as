package com.jwopitz.view
{
	import flash.events.Event;
	
	/**
	 * IApplicationShell provided a single method for letting the application know that its assets have been loaded and can now load visual content.
	 * The Application level class will implement this interface.
	 */
	public interface IApplicationShell
	{
		function shellInitialized (evt:Event):void
	}
}