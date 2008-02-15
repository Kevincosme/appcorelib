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
	import appCoreLib.utils.ObjectUtil;
	
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
		public function Settings ()
		{
			if (Settings._instance)
			{
				throw new Error ("Settings is a Singleton-type class.  Only one instance may be instantiated");
				return;
			}
				
			Settings._instance = this;
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
		 * @returns The setting value stored in the config.xml.
		 */
		public function getSetting (id:String):*
		{
			//assuming that the config.xml is following a similar structure, which it should.
			var type:String = String(xml.settings.setting.(@id == id).@type);
			var setting:* = xml.settings.setting.(@id == id);
			
			return ObjectUtil.customCast(type, setting);
		}
	}
}