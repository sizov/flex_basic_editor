package com.sizov.basicEditor.components.skinnableShape
{
	import flash.events.MouseEvent;

	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.managers.DragManager;

	import spark.components.supportClasses.SkinnableComponent;

	public class SkinnableShape extends SkinnableComponent
	{
		public function SkinnableShape()
		{
			super();

			addEventListener(MouseEvent.MOUSE_DOWN, shapeMouseDownHandler, false, 0, true);
			addEventListener(MouseEvent.CLICK, shapeMouseClickHandler, false, 0, true);
		}

		override protected function getCurrentSkinState():String
		{
			if (isSelected) {
				return "selected";
			}
			else {
				return "up";
			}
		}

		/* ==============================================================  */
		/* ========================== MOVE ==============================  */
		/* ==============================================================  */

		protected function shapeMouseDownHandler(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, shapeMouseMoveHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, shapeMouseUpHandler, false, 0, true);
		}

		protected function shapeMouseUpHandler(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, shapeMouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, shapeMouseUpHandler);
		}

		protected function shapeMouseMoveHandler(event:MouseEvent):void
		{
			doDrag(event);
		}

		protected function doDrag(event:MouseEvent):void
		{
			var dragSource:DragSource = new DragSource();
			dragSource.addData(event.localX, "localX");
			dragSource.addData(event.localY, "localY");
			DragManager.doDrag(event.currentTarget as IUIComponent, dragSource, event);
		}

		/* ==============================================================  */
		/* ========================== SELECTION =========================  */
		/* ==============================================================  */

		/**Shows if shape can be selected on canvas*/
		public var canBeSelected:Boolean = true;

		private var _isSelected:Boolean;
		private var isSelectedChanged:Boolean;

		/**
		 * Shows if shape is selected on the canvas
		 */
		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			if (isSelected == value) {
				return;
			}

			isSelectedChanged = true;
			_isSelected = value;
			invalidateDisplayList();
		}

		protected function shapeMouseClickHandler(event:MouseEvent):void
		{
			if (canBeSelected) {
				isSelected = !isSelected;
				invalidateSkinState();
			}
		}

//        override protected function measure():void
//        {
//            measuredMinWidth = GenericShape.DEFAULT_MEASURED_MIN_WIDTH;
//            measuredMinHeight = GenericShape.DEFAULT_MEASURED_MIN_HEIGHT;
//            measuredWidth = GenericShape.DEFAULT_MEASURED_WIDTH;
//            measuredHeight = GenericShape.DEFAULT_MEASURED_HEIGHT;
//        }
	}
}
