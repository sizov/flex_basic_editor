package com.sizov.basicEditor.components
{

	import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;

	import flash.events.Event;

	import mx.collections.IList;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	import spark.components.BorderContainer;

	public class ShapesCanvas extends BorderContainer
	{

		public function ShapesCanvas()
		{
			super();

			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false, 0, true);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false, 0, true);
		}

		protected function dragEnterHandler(event:DragEvent):void
		{
			if (event.dragInitiator is SkinnableShape && event.currentTarget as ShapesCanvas) {
				DragManager.acceptDragDrop(event.currentTarget as ShapesCanvas);
			}
		}

		protected function dragDropHandler(event:DragEvent):void
		{
			if (event.dragInitiator.parent == contentGroup) {
				handleExistingShapeMove(event);
			}
			else {
				handleNewShapeInserted(event);
			}
		}

		protected function handleExistingShapeMove(event:DragEvent):void
		{
			moveShapeAfterDropHandler(event.dragInitiator, event);
		}

		protected function handleNewShapeInserted(event:DragEvent):void
		{
//			var newShapeClass:Class = Object(event.dragInitiator).constructor;
//			var newShape:GenericShape = new newShapeClass();
//			addDroppedShape(newShape);
//			moveShapeAfterDropHandler(newShape, event);
		}

		protected function addDroppedShape(shape:IVisualElement):void
		{
			addElement(shape);
		}

		protected function moveShapeAfterDropHandler(shape:IUIComponent/*GenericShape*/, event:DragEvent):void
		{
			var localX:Number = Number(event.dragSource.dataForFormat("localX"));
			var localY:Number = Number(event.dragSource.dataForFormat("localY"));
			shape.x = ShapesCanvas(event.currentTarget).mouseX - localX;
			shape.y = ShapesCanvas(event.currentTarget).mouseY - localY;
		}

		private var _dataProvider:IList;
		private var dataProviderChanged:Boolean;

		[Bindable("dataProviderChanged")]
		[Inspectable(category="Data")]
		/**
		 *  The data provider for this Shapes.
		 */
		public function get dataProvider():IList
		{
			return _dataProvider;
		}

		public function set dataProvider(value:IList):void
		{
			if (_dataProvider == value)
				return;

			removeDataProviderListener();
			_dataProvider = value; // listener will be added by commitProperties()
			dataProviderChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private function addDataProviderListener():void
		{
			if (_dataProvider)
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler, false, 0, true);
		}

		private function removeDataProviderListener():void
		{
			if (_dataProvider)
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
		}

		/**
		 *  Called when contents within the dataProvider changes.  We will catch certain
		 *  events and update our children based on that.
		 */
		protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind) {
				case CollectionEventKind.ADD:
				{
					adjustAfterAdd(event.items, event.location);
					break;
				}

				case CollectionEventKind.REPLACE:
				{
					adjustAfterReplace(event.items, event.location);
					break;
				}

				case CollectionEventKind.REMOVE:
				{
					adjustAfterRemove(event.items, event.location);
					break;
				}

				case CollectionEventKind.MOVE:
				{
					adjustAfterMove(event.items[0], event.location, event.oldLocation);
					break;
				}

				case CollectionEventKind.REFRESH:
				{
					removeDataProviderListener();
					dataProviderChanged = true;
					invalidateProperties();
					break;
				}

				case CollectionEventKind.RESET:
				{
					removeDataProviderListener();
					dataProviderChanged = true;
					invalidateProperties();
					break;
				}

				case CollectionEventKind.UPDATE:
				{
					break;
				}
			}
		}

		override protected function commitProperties():void
		{
			if (dataProviderChanged) {
				createShapes();
				addDataProviderListener();
				dataProviderChanged = false;
			}

			super.commitProperties();
		}

		protected function adjustAfterAdd(items:Array, location:int):void
		{
			var length:int = items.length;
			for (var i:int = 0; i < length; i++) {
				itemAdded(items[i], location + i);
			}
		}

		protected function adjustAfterRemove(items:Array, location:int):void
		{
			/*
			 var length:int=items.length;
			 for (var i:int=length - 1; i >= 0; i--) {
			 itemRemoved(items[i], location + i);
			 }

			 // the order might have changed, so we might need to redraw the other
			 // renderers that are order-dependent (for instance alternatingItemColor)
			 resetRenderersIndices();
			 */
		}

		protected function adjustAfterMove(item:Object, location:int, oldLocation:int):void
		{
			/*
			 itemRemoved(item, oldLocation);
			 itemAdded(item, location);
			 resetRenderersIndices();
			 */
		}

		protected function adjustAfterReplace(propertyChangeEvents:Array, location:int):void
		{
			/*
			 var length:int=propertyChangeEvents.length;
			 for (var i:int=length - 1; i >= 0; i--) {
			 itemRemoved(propertyChangeEvents[i].oldValue, location + i);
			 }

			 for (i=length - 1; i >= 0; i--) {
			 itemAdded(propertyChangeEvents[i].newValue, location);
			 }
			 */
		}

		protected function itemAdded(item:Object, index:int):void
		{
			if (item is IVisualElement) {
				addElementAt(IVisualElement(item), index);
			}
		}

		protected function removeAllShapes():void
		{
			removeAllElements();
		}

		public function createShapes():void
		{
			removeAllShapes();

			if (!dataProvider || dataProvider.length == 0) {
				return;
			}

			for (var index:int = 0; index < dataProvider.length - 1; index++) {
				itemAdded(dataProvider.getItemAt(index), index);
			}
		}
	}
}