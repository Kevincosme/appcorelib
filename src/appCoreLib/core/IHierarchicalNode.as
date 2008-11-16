package appCoreLib.core
{
	public interface IHierarchicalNode extends INode
	{
		////////////////////////////////////////////////////////////
		//	CHILD METHODS
		////////////////////////////////////////////////////////////
		
		function get children ():Array;
		function get numChildren ():uint;
		
		function addChild (child:IHierarchicalNode):void;
		function addChildAt (child:IHierarchicalNode, index:int):void;
		
		function getChildAt (index:uint):IHierarchicalNode;
		function getChildById (id:String):IHierarchicalNode;
		
		function removeChild (child:IHierarchicalNode):IHierarchicalNode;
		function removeChildAt (index:uint):IHierarchicalNode;
		function removeChildById (id:String):IHierarchicalNode;
		function removeAllChildren ():void;
		
		////////////////////////////////////////////////////////////
		//	PARENT METHODS
		////////////////////////////////////////////////////////////
		
		function get parent ():IHierarchicalNode;
		function set parent (value:IHierarchicalNode):void;
		
		function get hasParent ():Boolean;
	}
}