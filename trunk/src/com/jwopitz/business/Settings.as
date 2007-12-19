package com.jwopitz.business
{
	/**
	 * Settings facilitates access to string values stored in the config.xml.
	 * The config.xml generally contains application settings and service related URLs not found in a Services.mxml.
	 * The config.xml should not contain copy or static URL related values.
	 */
	public class Settings extends XMLDataBroker
	{
		//////////////////////////////////////////////////////////
		//	GET INSTANCE (singleton)
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private static var _instance:Settings;
		
		/**
		 * Settings is a Singleton class.  This provide a means to get application-wide instance.
		 */
		public static function getInstance ():Settings
		{
			if (!_instance)
				_instance = new Settings();
				
			return _instance;
		}
		
		//////////////////////////////////////////////////////////
		//	CONSTRUCTOR (singleton)
		//////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function Settings ()
		{
			super();
		}
				
		/**
		 * Method for retrieving URLs contained in the config.xml.
		 * This is used to access URLs for services.
		 * 
		 * @param id The id of the string value located in the config.xml.
		 * @returns String The URL value stored in the config.xml
		 */
		public function getURL (id:String):String
		{
			//assuming that the config.xml is following a similar structure, which it should.
			var value:String = xml.urls.url.(@id == id);
			
			return value;
		}
		
		/**
		 * Method for retrieving settings contained in the config.xml.
		 * This is used to access settings for an application.
		 * 
		 * @param id The id of the string value located in the config.xml.
		 * @returns String The setting value stored in the config.xml.  The accesor of this method will need to cast the value to the appropriate data type (if applicable).
		 */
		public function getSetting (id:String):String
		{
			//assuming that the config.xml is following a similar structure, which it should.
			var value:String = xml.settings.setting.(@id == id);
			
			return value;
		}
	}
}