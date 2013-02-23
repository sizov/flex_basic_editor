package com.sizov.basicEditor.messages {

    public class ToolbarMessage {

        public static const SET_MODE:String = "setMode";

        public static const ADD_SKINNABLE_RECTANGLE:String = "addSkinnableRectangle";
        public static const ADD_SKINNABLE_TEXT:String = "addSkinnableText";
        public static const CLEAR_CANVAS:String = "clearCanvas";

        private var _type:String;

        public function ToolbarMessage(type:String) {
            _type = type;
        }

        [Selector]
        public function get type():String {
            return _type;
        }
    }
}
