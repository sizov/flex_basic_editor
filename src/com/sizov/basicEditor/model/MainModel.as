package com.sizov.basicEditor.model {

    import com.sizov.basicEditor.utils.ShapesCanvasModes;

    /**
     * This model controls Main view.
     */

    [Bindable]
    public class MainModel {

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

        public function setDefaultCanvasMode():void {
            canvasMode = ShapesCanvasModes.CREATE_AND_EDIT;
        }
    }
}