package com.sizov.basicEditor.utils {

    import mx.collections.ArrayList;

    public class ToolbarButtonData {

        public static const CREATE_AND_EDIT_BUTTON_DATA:Object = {label: "Text"};
        public static const RESIZE_AND_MOVE_BUTTON_DATA:Object = {label: "Move"};
        public static const DELETE_BUTTON_DATA:Object = {label: "Delete"};

        public static const DEFAULT_BUTTON_SET:ArrayList = new ArrayList([
            CREATE_AND_EDIT_BUTTON_DATA,
            RESIZE_AND_MOVE_BUTTON_DATA,
            DELETE_BUTTON_DATA
        ]);

        public static function getButtonDataByCanvasMode(canvasMode:String):Object {
            switch (canvasMode) {
                case ShapesCanvasModes.CREATE_AND_EDIT:
                    return ToolbarButtonData.CREATE_AND_EDIT_BUTTON_DATA;
                    break;
                case ShapesCanvasModes.RESIZE_AND_MOVE:
                    return ToolbarButtonData.RESIZE_AND_MOVE_BUTTON_DATA;
                    break;
                case ShapesCanvasModes.DELETE:
                    return ToolbarButtonData.DELETE_BUTTON_DATA;
                    break;
                default:
                    return null;
            }
        }

        public static function getCanvasModeByButtonData(buttonDataBar:Object):String {
            switch (buttonDataBar) {
                case ToolbarButtonData.CREATE_AND_EDIT_BUTTON_DATA:
                    return ShapesCanvasModes.CREATE_AND_EDIT;
                    break;
                case ToolbarButtonData.RESIZE_AND_MOVE_BUTTON_DATA:
                    return ShapesCanvasModes.RESIZE_AND_MOVE;
                    break;
                case ToolbarButtonData.DELETE_BUTTON_DATA:
                    return ShapesCanvasModes.DELETE;
                    break;
                default:
                    return null;
            }
        }
    }
}
