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
	
	public final class ObjectUtil
	{
		static public function createClassFromObject (obj:Object, targetClass:Class):Object
		{
			var classInstance:Object = new targetClass();
			
			var info:XML = describeType(classInstance);
			var vars:XMLList = info..variable;
			var accessors:XMLList = info..accessor;
			
			var propName:String;
			var propType:String;
			var propValue:*;
			
			var item:XML;
			for each (item in vars)
			{
				propName = String(item.@name);
				
				if (obj.hasOwnProperty(propName))
				{
					propType = String(item.@type);
					propValue = obj[propName];
					classInstance[propName] = customCast(propType, propValue);
				}
			}
			
			for each (item in accessors)
			{
				//ignore readonly
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
		
		public static function customCast (dataType:String, value:*):*
		{
			switch (dataType.toLowerCase())
			{
				case "integer": case "int": case "int_8": case "int_16": case "int_32":
				{
					var intValue:int = value;
					return intValue;
				}
				
				case "unsigned integer": case "uint": case "uint_8": case "uint_16": case "uint_32":
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
	}
}