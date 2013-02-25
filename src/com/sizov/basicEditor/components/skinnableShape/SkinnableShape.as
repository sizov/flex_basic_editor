package com.sizov.basicEditor.components.skinnableShape {

    import com.sizov.basicEditor.events.SkinnableShapeEvent;

    import flash.events.MouseEvent;

    import spark.components.supportClasses.SkinnableComponent;
    import spark.primitives.Graphic;

    public class SkinnableShape extends SkinnableComponent {

        [SkinPart(required="true")]
        public var bottomRightHandler:Graphic;

        public function SkinnableShape() {
            super();

            addEventListener(MouseEvent.CLICK, shapeMouseClickHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, shapeMouseDownHandler);
        }

        override protected function getCurrentSkinState():String {
            if (selected) {
                return "selected";
            }
            else {
                return "up";
            }
        }

        private var _resizeRequested:Boolean;

        public function get resizeRequested():Boolean {
            return _resizeRequested;
        }

        /*==============================================================*/
        /*Selection*/
        /*==============================================================*/

        /**Shows if shape can be selected on canvas*/
        public var canBeSelected:Boolean = true;

        private var _selected:Boolean;

        /**
         * Shows if shape is selected on the canvas
         */
        public function get selected():Boolean {
            return _selected;
        }

        public function set selected(value:Boolean):void {
            if (!canBeSelected || selected == value) return;

            _selected = value;

            invalidateSkinState();
        }

        protected function shapeMouseDownHandler(event:MouseEvent):void {
            //if clicked on resize handler, mark it as one to be resized
            _resizeRequested = event.target == bottomRightHandler;

            dispatchEvent(new SkinnableShapeEvent(SkinnableShapeEvent.MOUSE_DOWN, true));
        }

        protected function shapeMouseClickHandler(event:MouseEvent):void {
            if (canBeSelected) {
                selected = !selected;
                dispatchEvent(new SkinnableShapeEvent(SkinnableShapeEvent.SELECTION_CHANGE, true));
            }
        }
    }
}
