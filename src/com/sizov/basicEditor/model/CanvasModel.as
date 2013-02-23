package com.sizov.basicEditor.model {

    import com.sizov.basicEditor.components.skinnableShape.RectangleSkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.TexteSkinnableShape;
    import com.sizov.basicEditor.messages.ToolbarMessage;

    import mx.collections.ArrayCollection;

    /**
     * This model controls ShapesCanvas view.
     */

    [Bindable]
    public class CanvasModel {

        public var shapesDataProvider:ArrayCollection = new ArrayCollection();

        /*==============================================================*/
        /* Canvas mode */
        /*==============================================================*/
        private var _canvasMode:String;

        [PublishSubscribe(objectId="canvasMode")]
        public function get canvasMode():String {
            return _canvasMode;
        }

        public function set canvasMode(value:String):void {
            _canvasMode = value;
        }
        /*==============================================================*/

        [MessageHandler]
        public function canvasMessageHandler(message:ToolbarMessage):void {
            switch (message.type) {
                case ToolbarMessage.ADD_SKINNABLE_RECTANGLE:
                    addSkinnableShape(new RectangleSkinnableShape());
                    break;
                case ToolbarMessage.ADD_SKINNABLE_TEXT:
                    addSkinnableShape(new TexteSkinnableShape());
                    break;
                case ToolbarMessage.CLEAR_CANVAS:
                    clearCanvas();
                    break;
            }
        }

        public function addSkinnableShape(skinnableShape:SkinnableShape):void {
            shapesDataProvider.addItem(skinnableShape);
        }

        public function clearCanvas():void {
            shapesDataProvider.removeAll();
        }

    }
}