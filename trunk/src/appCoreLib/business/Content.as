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
	import flash.events.Event;
	
	/**
	 * Content facilitates access to string values stored in the content.xml.
	 * The content.xml should not contain data related to application settings or service related URLs.
	 */
	public class Content extends XMLDataBroker
	{
		//////////////////////////////////////////////////////////
		//	GET INSTANCE (singleton)
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private static var _instance:Content;
		
		/**
		 * Content is a Singleton class.  This provide a means to get application-wide instance.
		 */
		public static function getInstance ():Content
		{
			if (!_instance)
				_instance = new Content();
				
			return _instance;
		}
		
		//////////////////////////////////////////////////////////
		//	CONSTRUCTOR (singleton)
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function Content ()
		{
			if (Content._instance)
				throw new Error ("Content is a Singleton-type class.  Only one instance may be instantiated");
				
			Content._instance = this;
		}
		
		/**
		 * Method for retrieving string values contained in the content.xml.
		 * This is primarily used to retrieve strings associated with the copy contained within an application.
		 * 
		 * @param id The id of the string value located in the content.xml.
		 * @returns String The string value stored in the content.xml
		 */
		public function getStringValue (id:String):String
		{
			//assuming that the content.xml is following a similar structure, which it should.
			var value:String = xml.strings.string.(@id == id);
			
			return value;
		}
		
		/**
		 * Method for retrieving URLs contained in the content.xml.
		 * This is primarily used to retrieve URL links not used for sending and requesting data within an application.
		 * 
		 * @param id The id of the string value located in the content.xml.
		 * @returns String The URL value stored in the content.xml
		 */
		public function getURL (id:String):String
		{
			//assuming that the content.xml is following a similar structure, which it should.
			var value:String = xml.urls.url.(@id == id);
			
			return value;
		}
		
		/**
		 * Method for retrieving swf URL values contained in the content.xml.
		 * This is primarily used to retrieve the location of SWFs loaded in an application.
		 * 
		 * @param id The id of the string value located in the content.xml.
		 * @returns String The SWF's URL value stored in the content.xml
		 */
		public function getSwf (id:String):String
		{
			//assuming that the content.xml is following a similar structure, which it should.
			var value:String = xml.swfs.swf.(@id == id);
			
			return value;
		}
		
		/**
		 * Method for retrieving swf URL values contained in the content.xml.
		 * This is primarily used to retrieve the location of module SWFs loaded in an application.
		 * 
		 * @param id The id of the string value located in the content.xml.
		 * @returns String The SWF's URL value stored in the content.xml
		 */
		public function getModule (id:String):String
		{
			//assuming that the content.xml is following a similar structure, which it should.
			var value:String = xml.modules.module.(@id == id);
			
			return value;
		}
		
		/**
		 * Method for retrieving XMLLists contained in the content.xml.
		 * This is used to retrieve lists of data for use in dataProviders.
		 * 
		 * @param id The id of the string value located in the content.xml.
		 * @param listItemNodeName The node name associated with each listItem within the list.
		 * @returns XMLList A list of listItems in the content.xml.
		 */
		public function getList (id:String, listItemNodeName:String = "listItem"):XMLList
		{
			var value:XMLList = xml.lists.list.(@id == id)[listItemNodeName];
			
			return value;
		}
	}
}