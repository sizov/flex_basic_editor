package com.sizov.basicEditor.components.skinnableShape {

    import com.sizov.basicEditor.skins.TextSkin;

    import flash.events.MouseEvent;

    import spark.components.TextInput;

    import spark.events.TextOperationEvent;

    public class TextSkinnableShape extends SkinnableShape {

        [SkinPart(required="true")]
        public var textInput:TextInput;

        [Bindable]
        public var text:String = "Samle text frame";

        public function TextSkinnableShape() {
            setStyle("skinClass", TextSkin);
        }

        /*==============================================================*/
        /*Skin parts*/
        /*==============================================================*/
        override protected function partAdded(partName:String, instance:Object):void {
            super.partAdded(partName, instance);

            if (instance == textInput) {
                textInput.addEventListener(TextOperationEvent.CHANGE, textInput_changeHandler);
                textInput.addEventListener(MouseEvent.CLICK, textInput_clickHandler);
                textInput.addEventListener(MouseEvent.MOUSE_DOWN, textInput_mouseDownHandler);
            }
        }


        override protected function partRemoved(partName:String, instance:Object):void {
            super.partRemoved(partName, instance);

            if (instance == textInput) {
                textInput.removeEventListener(TextOperationEvent.CHANGE, textInput_changeHandler);
                textInput.removeEventListener(MouseEvent.CLICK, textInput_clickHandler);
                textInput.removeEventListener(MouseEvent.MOUSE_DOWN, textInput_mouseDownHandler);
            }
        }

        private function textInput_changeHandler(event:TextOperationEvent):void {
            text = textInput.text;
        }

        private function textInput_clickHandler(event:MouseEvent):void {
            trace("textInput_clickHandler");
            //if text frame is selected - don't propagate click as it will deselect node
            if (selected) {
                event.stopImmediatePropagation();
            }
        }

        private function textInput_mouseDownHandler(event:MouseEvent):void {
            trace("textInput_mouseDownHandler");
            //if text frame is selected - don't propagate click as it will deselect node
            if (selected) {
                event.stopImmediatePropagation();
            }
        }
    }
}
