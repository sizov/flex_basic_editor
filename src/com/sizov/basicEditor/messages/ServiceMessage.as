package com.sizov.basicEditor.messages {

    import mx.rpc.IResponder;

    public class ServiceMessage extends BaseMessage{

        public static const LOAD_SHAPES:String = "loadShapes";
        public static const SAVE_SHAPES:String = "saveShapes";

        public var responder:IResponder;

        public function ServiceMessage(type:String, data:* = null) {
            super(type, data);
        }
    }
}
