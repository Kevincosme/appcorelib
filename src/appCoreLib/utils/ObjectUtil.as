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
			var accessor:XMLList = info..accessor;
			
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
			
			for each (item in accessor)
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
						booleanValue = false; // handles odd XML casting bug
					
					if (String(value).toLowerCase() == "true" || String(value) == "1")
						booleanValue = true; // handles odd XML casting bug
					
					return booleanValue;
				}
				
				case "string": case "char": case "varchar": case "text":
				{
					var stringValue:String = value;
					return stringValue;
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
				
				default:
				{
					return null;
				}
			}
		}
	}
}