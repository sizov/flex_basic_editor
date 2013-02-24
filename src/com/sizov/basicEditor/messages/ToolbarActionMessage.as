package com.sizov.basicEditor.messages {

    public class ToolbarActionMessage extends BaseMessage{

        public static const SET_MODE:String = "setMode";
        public static const CLEAR_CANVAS:String = "clearCanvas";
        public static const SAVE:String = "save";

        public function ToolbarActionMessage(type:String, data:* = null) {
            super(type, data);
        }
    }
}
