package com.jwopitz.business
{
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
		function Content ()
		{
			super();
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
		 * @param listItemID The node name associated with each listItem within the list.
		 * @returns XMLList A list of listItems in the content.xml.
		 */
		public function getList (id:String, listItemNodeName:String = "listItem"):XMLList
		{
			var value:XMLList = xml.lists.list.(@id == id)[listItemNodeName];
			
			return value;
		}
	}
}