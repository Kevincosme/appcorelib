/*

Copyright (c) 2007 J.W.Opitz, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package appCoreLib.business
{
	import appCoreLib.events.XMLLoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.core.EventPriority;
	import mx.utils.StringUtil;
	
	[Event(name="xmlLoadFailure", type="appCoreLib.events.XMLLoadEvent")]
	[Event(name="xmlLoadSuccess", type="appCoreLib.events.XMLLoadEvent")]
	
	/**
	 * XMLDataBroker serves as the base class for loading application config & setting XML documents.
	 */
	public class XMLDataBroker extends EventDispatcher
	{	
		//////////////////////////////////////////////////////////
		//	LOAD
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var xmlLoader:URLLoader;
		
		/**
		 * @private
		 */
		public function loadXML (url:String = null):void
		{
			if (url)
				source = url;
			
			if (!source || StringUtil.trim(source) == "")
				throw new Error ("url parameter/source does not specify a location");
			
			if (!xmlLoader)
			{
				xmlLoader = new URLLoader();
				
				xmlLoader.addEventListener(Event.COMPLETE, onComplete_xmlLoaderHandler, false, EventPriority.DEFAULT_HANDLER, true);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError_xmlLoaderHandler, false, EventPriority.DEFAULT_HANDLER, true);
			}
			
			xmlLoader.load(new URLRequest(source));
		}
		
		/**
		 * @private
		 */
		public function reloadXML ():void
		{
			loadXML(source);
		}
		
		//////////////////////////////////////////////////////////
		//	IS LOADED
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isXMLLoaded:Boolean = false;
		
		/**
		 * Flag indicating whether the target XML is loaded.
		 */
		public function get isLoaded ():Boolean
		{
			return isXMLLoaded;
		}
		
		//////////////////////////////////////////////////////////
		//	URL
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var xmlSource:String;
		
		/**
		 * Convenience accessor for traversing the XML document.
		 */
		public function get source ():String
		{
			return xmlSource;
		}
		
		/**
		 * @private
		 */
		public function set source (value:String):void
		{
			xmlSource = value;
		}
		
		//////////////////////////////////////////////////////////
		//	XML DATA
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var xmlData:XML;
		
		/**
		 * Convenience accessor for traversing the XML document.
		 */
		public function get xml ():XML
		{
			return xmlData;
		}
		
		//////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function onComplete_xmlLoaderHandler (evt:Event):void
		{
			if (xmlLoader.data == undefined || StringUtil.trim(xmlLoader.data.toString()) == "")
			{
				dispatchEvent(new XMLLoadEvent(XMLLoadEvent.XML_LOAD_FAILURE));
			}	
			else
			{
				xmlData = new XML(xmlLoader.data);
				isXMLLoaded = true;
				
				dispatchEvent(new XMLLoadEvent(XMLLoadEvent.XML_LOAD_SUCCESS));
			}
		}
		
		/**
		 * @private
		 */
		protected function onIOError_xmlLoaderHandler (evt:IOErrorEvent):void
		{
			dispatchEvent(new XMLLoadEvent(XMLLoadEvent.XML_LOAD_FAILURE));
		}
	}
}