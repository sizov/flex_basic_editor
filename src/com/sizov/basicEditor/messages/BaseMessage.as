package com.sizov.basicEditor.messages {

    public class BaseMessage {

        private var _type:String;

        private var _data:*;

        public function BaseMessage(type:String, data:*) {
            _type = type;
            _data = data;
        }

        [Selector]
        public function get type():String {
            return _type;
        }

        public function get data():* {
            return _data;
        }
    }
}
