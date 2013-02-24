package com.sizov.basicEditor.model {

    import com.sizov.basicEditor.messages.ToolbarActionMessage;
    import com.sizov.basicEditor.utils.ShapesCanvasModes;

    /**
     * This com.sizov.basicEditor.model controls ControlBar com.sizov.basicEditor.view.
     */

    [Bindable]
    public class ToolbarViewModel {

        [MessageDispatcher]
        public var dispatcher:Function;

        public function changeCanvasMode(canvasMode:String):void {
            setCanvasMode(canvasMode);
        }

        public function setDefaultCanvasMode():void {
            setCanvasMode(ShapesCanvasModes.CREATE_AND_EDIT);
        }

        private function setCanvasMode(canvasMode:String):void {
            dispatcher(new ToolbarActionMessage(ToolbarActionMessage.SET_MODE, canvasMode));
        }

        public function save():void {
            dispatcher(new ToolbarActionMessage(ToolbarActionMessage.SAVE));
        }

        public function clear():void {
            dispatcher(new ToolbarActionMessage(ToolbarActionMessage.CLEAR_CANVAS));
        }
    }
}
