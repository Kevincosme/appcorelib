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
package appCoreLib.events
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
		//	XML
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _xml:XML;
		
		/**
		 * The XML data associated with the XMLLoadEvent if the XML was successfully loaded.
		 */
		public function get xml ():XML
		{
			return _xml;
		}
		
		/**
		 * @private
		 */
		public function set xml (value:XML):void
		{
			if (_xml != value)
			{
				_xml = value;
			}
		}
		
		///////////////////////////////////////////////////////////////
		//	DATA
		///////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var xmlData:XML;
		
		/**
		 * This property has been deprecated.  Please use the xml property instead.
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