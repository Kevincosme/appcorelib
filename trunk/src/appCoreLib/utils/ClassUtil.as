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
	 * 
	 * <p><b>NOTE</b><br/>In order for complex data types in arrays to correctly translate,
	 * you need to ensure to add the following to your project's compiler options:
	 * <em>-keep-as3-metadata ArrayElementType</em></p> and any other custom metadata tags used in your project necessary for proper object translation.
	 * 
	 * <p>Also you will need to add the ArrayElementType metadata tags to your classes.</p>
	 */
	public class ClassUtil
	{		
		static private const ARRAY_ELEMENT_TYPE_METADATA:String = "ArrayElementType";
		
		static private const CLASS_UTIL_METADATA:String = "ClassUtil";
		
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
		
		static public function createClassFromXMLObject (obj:XML, targetClass:Class):*
		{
			if (!obj || obj.toXMLString() == "")
				return null;
				
			var classInstance:* = new targetClass();
				
			var info:XML = describeType(classInstance);
			var vars:XMLList = mergeXMLlists(info..variable, info..accessor);
			
			var arrayElementType:String;
			var propName:String;
			var propType:String;
			var propValue:*;
			
			var subItem:XML;
			var subItems:XMLList;
			var subItemClass:Class;
			
			var item:XML;
			for each (item in vars)
			{
				if (String(item.@access) == "readonly")
					continue;
				
				if (String(item.metadata.(@name == CLASS_UTIL_METADATA).arg.(@key == "ignore").@value) == "true")
					continue;
				
				propName = String(item.@name);
				
				if (obj.hasOwnProperty(propName) || obj[propName].length > 0)
				{
					propType = String(item.@type);
					
					//handle complex data i.e. nestedNodes
					if (obj[propName].hasComplexContent())
					{
						//for complex arrays
						if (propType.toLowerCase() == "array")
						{
							//first see if a specific type was designated via  [ClassUtil(type="some.specific.ClassType")]
							if (String(item.metadata.(@name == CLASS_UTIL_METADATA).arg.(@key == "type").@value) != "")
								arrayElementType = String(item.metadata.(@name == CLASS_UTIL_METADATA).arg.(@key == "type").@value);
							
							//next we will try to see if something was specified other than an interface
							else if (String(item.metadata.(@name == ARRAY_ELEMENT_TYPE_METADATA).arg.(@key == "" || @key == "type").@value) != "")
								arrayElementType = String(item.metadata.(@name == ARRAY_ELEMENT_TYPE_METADATA).arg.(@key == "" || @key == "type").@value);
							
							//chances are we haven't enough info or simply can't translate this subchild,
							//though we could try to derive from the <ClassInstanceType/> node in the XML of the first element
							else
								continue;
							
							//we should have enough to recursively build the sub items.
							var a:Array = [];
							subItemClass = getDefinitionByName(arrayElementType) as Class;
							subItems = obj[propName].elements();
							for each (subItem in subItems)
								a.push(createClassFromXMLObject(subItem, subItemClass));
								
							classInstance[propName] = a;
						}
						
						//just a class instance for a property value.
						else
						{
							//if the property type is an interface, it is necessary to specify an implementor class via the metadata.
							//else it will fail to instantiate properly and throw an RTE
							var t:String = String(item.metadata.(@name == CLASS_UTIL_METADATA).arg.(@key == "type").@value);
							if (t != "") //for interfaces and/or where [ClassUtil(type="some.specific.ClassType")]
								subItemClass = getDefinitionByName(t) as Class;
								
							else //just a regular class, no interface specified for casting.
								subItemClass = getDefinitionByName(propType.replace("::", ".")) as Class;
															
							subItem = obj[propName].elements()[0]; //there should only be one element which itself is a XML object to be translated
							
							classInstance[propName] = createClassFromXMLObject(subItem, subItemClass);
						}
					}
					
					else
					{
						propValue = obj[propName];//will initially be an XMLList due to e4x syntax
						if (propValue)
							classInstance[propName] = customCast(propType, propValue);
					}					
				}
			}
			
			return classInstance;
		}
		
		/**
		 * Creates an XML object from a target object.
		 * 
		 * @param obj The target object to translate into XML.
		 * @param skipOnNullValues You can elect to not add XML nodes to the XML object if the target object's properties are null.
		 * 
		 * @return An XML object representation of the target object
		 */
		static public function createXMLfromObject (obj:Object, skipOnNullValues:Boolean = true):XML
		{
			var info:XML = describeType(obj);
			var vars:XMLList = mergeXMLlists(info..variable, info..accessor);
			
			var objName:String = String(info.@name);
			var classIndex:int = objName.indexOf("::");
			objName = classIndex == -1? objName: objName.substring(classIndex + 2);
			
			var xmlObj:XML = XML("<" + objName + "/>");
			var xmlProp:XML;
			
			var arrayElementType:String;
			
			var propName:String;
			var propType:String;
			var propValue:*;
			
			var item:XML;
			for each (item in vars)
			{
				if (String(item.@access) == "readonly")
					continue;
				
				if (String(item.metadata.(@name == CLASS_UTIL_METADATA).arg.(@key == "ignore").@value) == "true")
					continue;
				
				propName = String(item.@name);
				propType = String(item.@type);
				propValue = obj[propName];
				
				if (propValue != null && propValue != undefined)
				{
					switch (propType.toLowerCase())
					{
						case "boolean":
						case "string":
						case "number": case "int": case "uint":
						case "xml":
						{
							xmlProp = XML("<" + propName + ">" + propValue + "</" + propName + ">");
							break;
						}
						
						case "array":
						{
							if (propValue.length < 1)
								continue;
							
							xmlProp = XML("<" + propName + "/>");
							
							arrayElementType = String(item.metadata.(@name == ARRAY_ELEMENT_TYPE_METADATA).arg.(@key == "" || @key == "type").@value);
							if (arrayElementType.toLowerCase() == "" ||
								arrayElementType.toLowerCase() == "string" ||
								arrayElementType.toLowerCase() == "number" ||
								arrayElementType.toLowerCase() == "int" ||
								arrayElementType.toLowerCase() == "uint" ||
								arrayElementType.toLowerCase() == "boolean")
							{
								xmlProp = XML("<" + propName + ">" + (obj[propName] as Array).toString() + "</" + propName + ">");
							}
							
							else
							{
								var subItem:Object;
								for each (subItem in obj[propName])
									xmlProp.appendChild(createXMLfromObject(subItem));
							}
							
							break;
						}
						
						case "object":
						default:
						{
							xmlProp = XML("<" + propName + ">" + createXMLfromObject(obj[propName]) + "</" + propName + ">");
						}
					}
					
					xmlObj.appendChild(xmlProp);
				}
				
				else if (!propValue && !skipOnNullValues)
				{
					xmlProp = XML("<" + propName + "/>");
					xmlObj.appendChild(xmlProp);
				}
			}
			
			return xmlObj;
		}
		
		/**
		 * Takes a value and cast to a specified type.
		 * 
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
		
		/**
		 * @private
		 */
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