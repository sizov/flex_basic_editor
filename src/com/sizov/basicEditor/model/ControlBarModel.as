package com.sizov.basicEditor.model
{

	import com.sizov.basicEditor.messages.ControlBarMessage;

	/**
	 * This com.sizov.basicEditor.model controls ControlBar com.sizov.basicEditor.view.
	 */

	[Bindable]
	public class ControlBarModel
	{

		[MessageDispatcher]
		public var dispatcher:Function;

		public function addSkinnableRectangle():void
		{
			dispatcher(new ControlBarMessage(ControlBarMessage.ADD_SKINNABLE_RECTANGLE));
		}

		public function addSkinnableText():void
		{
			dispatcher(new ControlBarMessage(ControlBarMessage.ADD_SKINNABLE_TEXT));
		}

		public function clearCanvasHandler():void
		{
			dispatcher(new ControlBarMessage(ControlBarMessage.CLEAR_CANVAS));
		}

	}
}
