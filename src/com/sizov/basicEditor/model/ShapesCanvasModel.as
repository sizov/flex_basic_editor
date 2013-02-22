package com.sizov.basicEditor.model
{

	import com.sizov.basicEditor.components.skinnableShape.RectangleSkinnableShape;
	import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;
	import com.sizov.basicEditor.components.skinnableShape.TexteSkinnableShape;
	import com.sizov.basicEditor.messages.ControlBarMessage;

	import mx.collections.ArrayCollection;

	/**
	 * This model controls ShapesCanvas view.
	 */

	[Bindable]
	public class ShapesCanvasModel
	{

		public var shapesDataProvider:ArrayCollection = new ArrayCollection();

		[MessageHandler]
		public function canvasMessageHandler(message:ControlBarMessage):void
		{
			switch (message.type) {
				case ControlBarMessage.ADD_SKINNABLE_RECTANGLE:
					addSkinnableShape(new RectangleSkinnableShape());
					break;
				case ControlBarMessage.ADD_SKINNABLE_TEXT:
					addSkinnableShape(new TexteSkinnableShape());
					break;
				case ControlBarMessage.CLEAR_CANVAS:
					clearCanvas();
					break;
			}
		}

		public function addSkinnableShape(skinnableShape:SkinnableShape):void
		{
			shapesDataProvider.addItem(skinnableShape);
		}

		public function clearCanvas():void
		{
			shapesDataProvider.removeAll();
		}

	}
}