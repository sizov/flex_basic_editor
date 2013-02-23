package com.sizov.basicEditor.model {

    /**
     * This com.sizov.basicEditor.model controls ControlBar com.sizov.basicEditor.view.
     */

    [Bindable]
    public class ToolbarModel {

        [MessageDispatcher]
        public var dispatcher:Function;

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

        public function save():void {

        }
    }
}
