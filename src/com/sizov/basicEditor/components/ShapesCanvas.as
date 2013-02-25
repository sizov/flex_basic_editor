package com.sizov.basicEditor.components {

    import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.TextSkinnableShape;
    import com.sizov.basicEditor.events.SkinnableShapeEvent;
    import com.sizov.basicEditor.skins.ShapesCanvasSkin;
    import com.sizov.basicEditor.utils.ShapesCanvasModes;

    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import mx.collections.ArrayCollection;
    import mx.core.IVisualElement;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.managers.IFocusManagerComponent;

    import spark.components.SkinnableContainer;

    public class ShapesCanvas extends SkinnableContainer implements IFocusManagerComponent {

        private static const MIN_SHAPE_WIDTH:Number = 10;
        private static const MIN_SHAPE_HEIGHT:Number = 10;

        public var shapeFactory:IShapeFactory;

        //TODO: use state pattern and call mouse events on state
        public var mode:String;

        public function ShapesCanvas() {
            super();

            setStyle("skinClass", ShapesCanvasSkin);

            addEventListener(SkinnableShapeEvent.MOUSE_DOWN, shapeMouseDownHandler);
            addEventListener(SkinnableShapeEvent.SELECTION_CHANGE, shapeSelectionChangeHandler);

            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }

        private function get selectedShape():SkinnableShape {
            for each (var shape:SkinnableShape in dataProvider) {
                if (shape.selected) {
                    return shape;
                }
            }
            return null;
        }


        override protected function focusOutHandler(event:FocusEvent):void {
            super.focusOutHandler(event);

            //deselect currently selected shapes in case it's not a text frame in editing mode
            var focusedComponent:IFocusManagerComponent = focusManager.getFocus();
            var currentSelectedShape:SkinnableShape = selectedShape;

            var textEditingInProcess:Boolean = (currentSelectedShape is TextSkinnableShape) &&
                    TextSkinnableShape(currentSelectedShape).textInput == focusedComponent;

            if (currentSelectedShape && !textEditingInProcess) {
                currentSelectedShape.selected = false;
            }
        }

        override protected function keyUpHandler(event:KeyboardEvent):void {
            super.keyUpHandler(event);

            if (event.keyCode == 46 && mode == ShapesCanvasModes.DELETE) {
                var selectedObjectIndex:int = dataProvider.getItemIndex(selectedShape);
                dataProvider.removeItemAt(selectedObjectIndex);
            }
        }


        /*==============================================================*/
        /* Mouse Events */
        /*==============================================================*/
        private var canvasDownX:Number;
        private var canvasDownY:Number;

        private var mouseInteractionShape:SkinnableShape;
        private var mouseInteractionShapeDownX:Number;
        private var mouseInteractionShapeDownY:Number;

        private var pendingNewShapeCreation:Boolean;

        private function mouseDownHandler(event:MouseEvent):void {
            var localCanvasPoint:Point = globalToLocal(new Point(event.stageX, event.stageY));

            canvasDownX = localCanvasPoint.x;
            canvasDownY = localCanvasPoint.y;

            //deselect other shapes
            var currentSelectedShape:SkinnableShape = selectedShape;
            if (currentSelectedShape && mouseInteractionShape != currentSelectedShape) {
                currentSelectedShape.selected = false;
            }

            if (mode == ShapesCanvasModes.CREATE_OR_EDIT) {
                //if not interacting with shape - let's schedule creation
                if (!mouseInteractionShape) {
                    pendingNewShapeCreation = true;
                }
                //user mouse is over existing shape, he can only edit it - no need to control mouse move
                else {
                    mouseInteractionShape = null;
                    return;
                }
            }

            //if in resize/move mode and user is not interacting with any shape - no need to control mouse move
            else if (mode == ShapesCanvasModes.RESIZE_OR_MOVE && !mouseInteractionShape) {
                return;
            }

            //if in delete mode - no need to control mouse move
            else if (mode == ShapesCanvasModes.DELETE) {
                return;
            }

            if (mouseInteractionShape) {
                var shapeLocalPoint:Point = mouseInteractionShape.globalToLocal(new Point(event.stageX, event.stageY));
                mouseInteractionShapeDownX = shapeLocalPoint.x;
                mouseInteractionShapeDownY = shapeLocalPoint.y;
            }

            stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
        }

        protected function stageMouseMoveHandler(event:MouseEvent):void {
            switch (mode) {

                case ShapesCanvasModes.CREATE_OR_EDIT:
                    if (pendingNewShapeCreation) {
                        pendingNewShapeCreation = false;
                        handleShapeCreation(event);
                    }
                    resizeInteractionShape(event);
                    break;

                case ShapesCanvasModes.RESIZE_OR_MOVE:
                    if (mouseInteractionShape.resizeRequested) {
                        resizeInteractionShape(event);
                    }
                    else {
                        moveInteractionShape(event);
                    }

                    break;
                default:
                    return;
            }
        }

        private function handleShapeCreation(event:MouseEvent):void {
            mouseInteractionShape = shapeFactory.createSkinnableShape(ShapeTypes.TEXT_SHAPE);
            mouseInteractionShape.x = canvasDownX;
            mouseInteractionShape.y = canvasDownY;

            var shapeLocalPoint:Point = mouseInteractionShape.globalToLocal(new Point(event.stageX, event.stageY));
            mouseInteractionShapeDownX = shapeLocalPoint.x;
            mouseInteractionShapeDownY = shapeLocalPoint.y;

            dataProvider.addItem(mouseInteractionShape);
        }

        protected function stageMouseUpHandler(event:MouseEvent):void {
            mouseInteractionShape = null;
            mouseInteractionShapeDownX = NaN;
            mouseInteractionShapeDownY = NaN;
            pendingNewShapeCreation = false;

            stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
        }

        private function moveInteractionShape(event:MouseEvent):void {
            if (!mouseInteractionShape) return;

            var localCanvasPoint:Point = globalToLocal(new Point(event.stageX, event.stageY));

            mouseInteractionShape.x = localCanvasPoint.x - mouseInteractionShapeDownX;
            mouseInteractionShape.y = localCanvasPoint.y - mouseInteractionShapeDownY;
        }

        private function resizeInteractionShape(event:MouseEvent):void {
            if (!mouseInteractionShape) return;

            var localCanvasPoint:Point = globalToLocal(new Point(event.stageX, event.stageY));

            var shapeWidth:Number = localCanvasPoint.x - mouseInteractionShape.x;
            var shapeHeight:Number = localCanvasPoint.y - mouseInteractionShape.y;

            if (shapeWidth < MIN_SHAPE_WIDTH) {
                shapeWidth = MIN_SHAPE_WIDTH;
            }

            if (shapeHeight < MIN_SHAPE_HEIGHT) {
                shapeHeight = MIN_SHAPE_HEIGHT;
            }

            mouseInteractionShape.width = shapeWidth;
            mouseInteractionShape.height = shapeHeight;
        }

        /*==============================================================*/
        /* Shape Events */
        /*==============================================================*/
        private function shapeSelectionChangeHandler(event:SkinnableShapeEvent):void {
            event.stopPropagation();

            var targetShape:SkinnableShape = event.target as SkinnableShape;

            //deselect other shapes
            var currentSelectedShape:SkinnableShape = selectedShape;
            if (targetShape.selected && targetShape != currentSelectedShape) {
                currentSelectedShape.selected = false;
            }
        }

        private function shapeMouseDownHandler(event:SkinnableShapeEvent):void {
            mouseInteractionShape = event.target as SkinnableShape;
        }

        /*==============================================================*/

        override protected function commitProperties():void {
            if (dataProviderChanged) {

                removeAllElements();

                for each (var object:Object in dataProvider) {
                    addElement(object as IVisualElement);
                }

                addDataProviderListener();
                dataProviderChanged = false;
            }

            super.commitProperties();
        }

        /*==============================================================*/
        /* Dataprovider */
        /*==============================================================*/

        private var _dataProvider:ArrayCollection;
        private var dataProviderChanged:Boolean;

        [Bindable("dataProviderChanged")]
        [Inspectable(category="Data")]
        /**
         *  The data provider for this Shapes.
         */
        public function get dataProvider():ArrayCollection {
            return _dataProvider;
        }

        public function set dataProvider(value:ArrayCollection):void {
            if (_dataProvider == value) return;

            // listener will be added by commitProperties()
            removeDataProviderListener();

            _dataProvider = value;
            dataProviderChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("dataProviderChanged"));
        }

        private function addDataProviderListener():void {
            if (_dataProvider) {
                _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler, false, 0, true);
            }
        }

        private function removeDataProviderListener():void {
            if (_dataProvider) {
                _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
            }
        }

        /**
         *  Called when contents within the dataProvider changes.  We will catch certain
         *  events and update our children based on that.
         */
        protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void {
            switch (event.kind) {
                case CollectionEventKind.ADD:
                    adjustAfterAdd(event.items);
                    break;
                case CollectionEventKind.REMOVE:
                    adjustAfterRemove(event.items);
                    break;
                case CollectionEventKind.RESET:
                    removeDataProviderListener();
                    dataProviderChanged = true;
                    invalidateProperties();
                    break;
            }
        }

        protected function adjustAfterAdd(items:Array):void {
            for each (var shape:SkinnableShape in items) {
                //item might have been added in creation phase
                if (!contains(shape)) {
                    addElement(shape);
                }
            }

            //deselect other shapes if added one is selected (applicable to last added shape)
            var currentSelectedShape:SkinnableShape = selectedShape;
            if (shape.selected && currentSelectedShape) {
                currentSelectedShape.selected = false;
            }
        }

        protected function adjustAfterRemove(items:Array):void {
            for each (var object:Object in items) {
                removeElement(object as IVisualElement);
            }
        }
    }
}