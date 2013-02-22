package com.sizov.basicEditor.messages {

	public class ControlBarMessage {

		public static const ADD_SKINNABLE_RECTANGLE:String="addSkinnableRectangle";
		public static const ADD_SKINNABLE_TEXT:String="addSkinnableText";
		public static const CLEAR_CANVAS:String="clearCanvas";

		private var _type:String;

		public function ControlBarMessage(type:String) {
			_type=type;
		}

		[Selector]
		public function get type():String {
			return _type;
		}
	}
}
