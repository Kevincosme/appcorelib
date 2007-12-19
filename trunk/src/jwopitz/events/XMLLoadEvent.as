package com.jwopitz.events
{
	import flash.events.Event;
	
	/**
	 * XMLLoadEvent is triggered by XMLDataBroker and its subclasses once a targeted XML has loaded or failed to load.
	 */
	public class XMLLoadEvent extends Event
	{
		/**
		 * Triggered when an xml document has successfully loaded.
		 */
		public static const XML_LOAD_SUCCESS:String = "xmlLoadSuccess";
		
		/**
		 * Triggered when an xml document has failed to load.
		 */
		public static const XML_LOAD_FAILURE:String = "xmlLoadFailure";
		
		///////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////////
		
		/**
		 * Constructor for new XMLLoadEvent instance.
		 * 
		 * @param type The XMLLoadEvent type.
		 * @param data The XML data associated with this event if it was successfully loaded.
		 * @param bubbles Flag indicating if the event bubbles through the display list.
		 * @param cancelable Flag indicating if the event is cancelable.
		 */
		public function XMLLoadEvent (type:String, data:XML = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}
		
		///////////////////////////////////////////////////////////////
		//	DATA
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var xmlData:XML;
		
		/**
		 * The XML data associated with the XMLLoadEvent if the XML was successfully loaded.
		 */
		public function get data ():XML
		{
			return xmlData;
		}
		
		/**
		 * @private
		 */
		public function set data (value:XML):void
		{
			if (xmlData != value)
			{
				xmlData = value;
			}
		}
	}
}