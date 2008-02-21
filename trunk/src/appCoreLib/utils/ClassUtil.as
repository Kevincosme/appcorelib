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
package appCoreLib.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Contains methods for translating various object types to specific class instances and data types.
	 */
	public class ClassUtil
	{		
		/**
		 * Creates a specified class instance from a generic object.
		 * If the object is an XML instance, then it will utilize createClassFromXMLObject.
		 * 
		 * @param obj The object to translate into a class instance.
		 * @param targetClass The class which the object is translated to.
		 * 
		 * @return Object The class instance of the translated object.
		 */
		static public function createClassFromObject (obj:Object, targetClass:Class):Object
		{
			//if its an xml object we have a more optimized process to extract assembly the object
			if (obj is XML)
				return createClassFromXMLObject(obj as XML, targetClass);
			
			//otherwise we assemble the object normally
			var classInstance:Object = new targetClass();
			
			var info:XML = describeType(classInstance);
			var vars:XMLList = mergeXMLlists(info..variable, info..accessor);
			
			var propName:String;
			var propType:String;
			var propValue:*;
			
			//get the vars first
			var item:XML;
			for each (item in vars)
			{
				if (String(item.@access) == "readonly")
					continue;
					
				propName = String(item.@name);
				
				if (obj.hasOwnProperty(propName))
				{
					propType = String(item.@type);
					propValue = obj[propName];
					classInstance[propName] = customCast(propType, propValue);
				}
			}
			
			return classInstance;
		}
		
		/**
		 * Creates a specified class instance from an XML object. 
		 *  
		 * 
		 * The XML object should implement the following structure:
		 * <item>
		 * 		<property name="id" type="String">widget_p486</property>
		 * 		<property name="name" type="String">Widget P486</property>
		 * 		
		 * 		<!-- simple array elements -->
		 * 		<property name="tags" type="Array" arrayElementType="String">flash,flex,actionscript</property>
		 * 		
		 * 		<!-- complex array elements -->
		 * 		<property name="complexObjects" type="Array">
		 * 			<item>
		 * 				<property/>
		 * 				<property/>
		 * 			</item>
		 * 			<item>
		 * 				<property/>
		 * 				<property/>
		 * 			</item>
		 * 		</property>
		 * 		<property name="price" type="Number">22.95</property>
		 * </item>
		 * 
		 * @param obj The XML object to translate into a class instance.
		 * @param targetClass The class which the object is translated to.
		 * 
		 * @return * The class instance of the translated XML object.
		 */
		static public function createClassFromXMLObject (obj:XML, targetClass:Class):*
		{
			var classInstance:Object = new targetClass();
			
			var info:XML = describeType(classInstance);
			var vars:XMLList = mergeXMLlists(info..variable, info..accessor);
			
			var propName:String;
			var propType:String;
			
			var arrayElementType:String;
			
			var properties:XMLList = obj.property;
			var prop:XML;
			for each (prop in properties)
			{
				propName = String(prop.@name);
				
				//if this doesn't have the prop name then pass on it.
				if (!classInstance.hasOwnProperty(propName))
					continue;
				
				//if it's readonly then pass.
				if (String(vars.(@name == propName).@access) == "readonly")
					continue;
				
				propType = String(vars.(@name == propName).@type);
				
				// we could be passing nested XML items so we have to check the XML structure and proceed appropriately
				if (prop.hasComplexContent())
				{
					if (propType.toLowerCase() == "array")
					{
						var a:Array = [];
						
						arrayElementType = String(vars.(@name == propName).metadata.(@name == "ArrayElementType").arg.(@key == "" || @key == "type").@value);
						var itemClass:Class = getDefinitionByName(arrayElementType) as Class;
						
						var item:XML; //item to populate array
						var items:XMLList = prop.item; //ilst of items to add to array
						for each (item in items)
							a.push(createClassFromXMLObject(item, itemClass));
							
						classInstance[propName] = a;
					}
				}
				
				else
					classInstance[propName] = customCast(propType, prop);
			}
			
			return classInstance;
		}		
		
		/**
		 * @param dataType The desired object type to translate the value to.
		 * @param value The value to be cast.
		 * 
		 * @return * the value cast to the specified dataType.
		 */
		public static function customCast (dataType:String, value:*):*
		{
			switch (dataType.toLowerCase())
			{
				case "int": case "int_8": case "int_16": case "int_32":
				{
					var intValue:int = value;
					return intValue;
				}
				
				case "uint": case "uint_8": case "uint_16": case "uint_32":
				{
					var uintValue:uint = value;
					return uintValue;
				}
				
				case "number": case "float": case "double":
				{
					var numberValue:Number = value;
					return numberValue;
				}
				
				case "boolean": case "bool":
				{
					var booleanValue:Boolean = value;
					if (String(value).toLowerCase() == "false" || String(value) == "0")
						booleanValue = false;
					
					if (String(value).toLowerCase() == "true" || String(value) == "1")
						booleanValue = true;
					
					return booleanValue;
				}
				
				case "array":
				{
					var arrayValue:Array = String(value).split(",");
					return arrayValue;
				}
				
				case "xml":
				{
					var xmlValue:XML = XML(value);
					return xmlValue;
				}
				
				case "object": case "obj":
				{
					var objValue:Object = value;
					return objValue;
				}
				
				case "string": case "char": case "varchar": case "text":
				default:
				{
					var stringValue:String = value;
					return stringValue;
				}
			}
		}
		
		static private function mergeXMLlists (a:XMLList, b:XMLList):XMLList
		{
			var items:XML = <xml/>;
			
			var item:XML;
			for each (item in a)
				items.appendChild(item);
				
			for each (item in b)
				items.appendChild(item);
			
			return items.children();
		}
	}
}