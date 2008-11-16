package appCoreLib.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class HierarchicalNode extends EventDispatcher implements IHierarchicalNode
	{
		public function HierarchicalNode ()
		{
			super();
		}
		
		////////////////////////////////////////////////////////////
		//	ID
		////////////////////////////////////////////////////////////
		
		private var _id:String = "";
		
		public function get id ():String
		{
			return _id;
		}
		
		public function set id (value:String):void
		{
			_id = value;
		}
		
		////////////////////////////////////////////////////////////
		//	DATA
		////////////////////////////////////////////////////////////
		
		private var _data:Object;
		
		public function get data ():Object
		{
			return _data;
		}
		
		public function set data (value:Object):void
		{
			_data = value;
		}
		
		////////////////////////////////////////////////////////////
		//	CHILD METHODS
		////////////////////////////////////////////////////////////
		
		private var _children:ArrayCollection = new ArrayCollection();
		
		[Bindable("childrenChanged")]
		public function get children ():Array
		{
			return _children.source;
		}
		
		public function get numChildren ():uint
		{
			return _children.length;
		}
		
		//	ADD
		///////////
		
		public function addChild (child:IHierarchicalNode):void
		{
			if (!_children.contains(child))
			{
				child.parent = this;
				_children.addItem(child);
				
				dispatchEvent(new Event("childrenChanged"));
			}
		}
		
		public function addChildAt (child:IHierarchicalNode, index:int):void
		{
			if (!_children.contains(child))
			{
				child.parent = this;
				_children.addItemAt(child, index);
				
				dispatchEvent(new Event("childrenChanged"));	
			}
		}
		
		//	GET
		///////////
		
		public function getChildAt (index:uint):IHierarchicalNode
		{
			if (index < _children.length)
				return IHierarchicalNode(_children.getItemAt(index));
				
			else
				return null;
		}
		
		public function getChildById (id:String):IHierarchicalNode
		{
			var item:IHierarchicalNode;
			for each (item in _children)
			{
				if (item.id == id)
					return item;
			}
			
			return null;
		}
		
		//	REMOVE
		///////////
		
		public function removeChild (child:IHierarchicalNode):IHierarchicalNode
		{
			if (_children.contains(child))
			{
				child.parent = null;
				var i:int = _children.getItemIndex(child);
				
				dispatchEvent(new Event("childrenChanged"));
				
				return IHierarchicalNode(_children.removeItemAt(i));
			}
			
			else
				return null;
		}
		
		public function removeChildAt (index:uint):IHierarchicalNode
		{
			if (index < _children.length)
			{
				var child:IHierarchicalNode = IHierarchicalNode(_children.removeItemAt(index));
				child.parent = null;
				
				dispatchEvent(new Event("childrenChanged"));
				
				return child;
			}
		
			return null;
		}
		
		public function removeChildById (id:String):IHierarchicalNode
		{
			var item:IHierarchicalNode;
			var i:int;
			for each (item in _children)
			{
				if (item.id == id)
				{
					item.parent = null;
					i = _children.getItemIndex(item);
				
					dispatchEvent(new Event("childrenChanged"));
					
					return IHierarchicalNode(_children.removeItemAt(i));
				}
			}
			
			return null;
		}
		
		public function removeAllChildren ():void
		{
			_children.removeAll();
			
			var item:IHierarchicalNode;
			for each (item in _children)
				item.parent = null;
				
			dispatchEvent(new Event("childrenChanged"));
		}
		
		////////////////////////////////////////////////////////////
		//	PARENT METHODS
		////////////////////////////////////////////////////////////
		
		protected var _parent:IHierarchicalNode;
		
		[Bindable("parentChanged")]
		public function get parent ():IHierarchicalNode
		{
			return _parent;
		}
		
		public function set parent (value:IHierarchicalNode):void
		{
			if (_parent != value)
			{
				_parent = value;
				
				dispatchEvent(new Event("parentChanged"));
			}
		}
		
		public function get hasParent ():Boolean
		{
			return _parent? true: false;
		}		
	}
}