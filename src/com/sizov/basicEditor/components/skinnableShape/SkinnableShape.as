package com.sizov.basicEditor.components.skinnableShape {

    import flash.events.MouseEvent;
    import flash.geom.Point;

    import mx.core.DragSource;
    import mx.core.IUIComponent;
    import mx.managers.DragManager;

    import spark.components.supportClasses.SkinnableComponent;
    import spark.primitives.Graphic;

    public class SkinnableShape extends SkinnableComponent {

        private static const MIN_SHAPE_WIDTH:Number = 10;
        private static const MIN_SHAPE_HEIGHT:Number = 10;

        [SkinPart(required="true")]
        public var bottomRightHandler:Graphic;

        public function SkinnableShape() {
            super();

            addEventListener(MouseEvent.MOUSE_DOWN, shapeMouseDownHandler);
            addEventListener(MouseEvent.CLICK, shapeMouseClickHandler);
        }

        override protected function getCurrentSkinState():String {
            if (isSelected) {
                return "selected";
            }
            else {
                return "up";
            }
        }


        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);

            if (instance == bottomRightHandler) {
                bottomRightHandler.addEventListener(MouseEvent.MOUSE_DOWN, bottomRightHandlerMouseDownHandler);
            }
        }


        override protected function partRemoved(partName:String, instance:Object):void {
            super.partRemoved(partName, instance);

            if (instance == bottomRightHandler) {
                bottomRightHandler.removeEventListener(MouseEvent.MOUSE_DOWN, bottomRightHandlerMouseDownHandler);
            }
        }

//        override protected function measure():void
//        {
//            measuredMinWidth = GenericShape.DEFAULT_MEASURED_MIN_WIDTH;
//            measuredMinHeight = GenericShape.DEFAULT_MEASURED_MIN_HEIGHT;
//            measuredWidth = GenericShape.DEFAULT_MEASURED_WIDTH;
//            measuredHeight = GenericShape.DEFAULT_MEASURED_HEIGHT;
//        }


        /* ==============================================================  */
        /* ========================== MOVE ==============================  */
        /* ==============================================================  */

        protected function shapeMouseDownHandler(event:MouseEvent):void {
            doDrag(event);
        }

        protected function doDrag(event:MouseEvent):void {
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
        public function get isSelected():Boolean {
            return _isSelected;
        }

        public function set isSelected(value:Boolean):void {
            if (isSelected == value) {
                return;
            }

            isSelectedChanged = true;
            _isSelected = value;
            invalidateDisplayList();
        }

        protected function shapeMouseClickHandler(event:MouseEvent):void {
            if (canBeSelected) {
                isSelected = !isSelected;
                invalidateSkinState();
            }
        }

        /* ==============================================================  */
        /* ========================== HANDLES ===========================  */
        /* ==============================================================  */

        protected function bottomRightHandlerMouseDownHandler(event:MouseEvent):void {
            //stop propagation of this event to parent shape
            event.stopImmediatePropagation();

            stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);

//            removeEventListener(MouseEvent.CLICK, shapeMouseClickHandler);
        }

        protected function stageMouseMoveHandler(event:MouseEvent):void {
            resizeBottomRightHandler(event);
        }

        protected function stageMouseUpHandler(event:MouseEvent):void {
//            addEventListener(MouseEvent.CLICK, shapeMouseClickHandler);

            stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
        }

        /* ==============================================================  */
        /* ==================== RESIZE EVENTS ===========================  */
        /* ==============================================================  */

        protected function resizeBottomRightHandler(event:MouseEvent):void {
            var stageMousePoint:Point = new Point(event.stageX, event.stageY);
            var localShapePoint:Point = globalToLocal(stageMousePoint);

            var newWidth:Number = localShapePoint.x;
            var newHeight:Number = localShapePoint.y;

            width = newWidth >= MIN_SHAPE_WIDTH ? newWidth : MIN_SHAPE_WIDTH;
            height = newHeight >= MIN_SHAPE_HEIGHT ? newHeight : MIN_SHAPE_WIDTH;
        }

    }
}
