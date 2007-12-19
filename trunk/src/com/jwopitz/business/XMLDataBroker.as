package com.jwopitz.business
{
	import com.jwopitz.events.XMLLoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.core.EventPriority;
	import mx.utils.StringUtil;
	
	/**
	 * XMLDataBroker serves as the base class for loading application config & setting XML documents.
	 */
	public class XMLDataBroker extends EventDispatcher
	{	
		//////////////////////////////////////////////////////////
		//	GET INSTANCE (singleton)
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private static var _instance:XMLDataBroker;
		
		/**
		 * XMLDataBroker is a Singleton class.  This provide a means to get application-wide instance.
		 */
		public static function getInstance ():XMLDataBroker
		{
			if (!_instance)
				_instance = new XMLDataBroker();
				
			return _instance;
		}
		
		//////////////////////////////////////////////////////////
		//	
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var xmlLoader:URLLoader;
		
		//////////////////////////////////////////////////////////
		//	CONSTRUCTOR (singleton)
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function XMLDataBroker ()
		{
			super();
		}
		
		/**
		 * @private
		 */
		public function loadXML (url:String):void
		{
			if (StringUtil.trim(url) == "")
				throw new Error ("url parameter does not specify a location");
			
			if (!xmlLoader)
			{
				xmlLoader = new URLLoader();
				
				xmlLoader.addEventListener(Event.COMPLETE, onComplete_xmlLoaderHandler, false, EventPriority.DEFAULT_HANDLER, true);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError_xmlLoaderHandler, false, EventPriority.DEFAULT_HANDLER, true);
			}
			
			xmlLoader.load(new URLRequest(url));
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