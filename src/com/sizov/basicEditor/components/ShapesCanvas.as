package com.sizov.basicEditor.components {

    import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;
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

        public var shapeFactory:IShapeFactory;
        public var mode:String;

        public function ShapesCanvas() {
            super();

            setStyle("skinClass", ShapesCanvasSkin);

            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(SkinnableShapeEvent.SELECTION_CHANGE, shapeSelectionChangeHandler);
        }


        private function get selectedShapes():Array {
            var result:Array = [];

            for each (var shape:SkinnableShape in dataProvider) {
                if (shape.selected) {
                    result.push(shape);
                }
            }

            return result;
        }


        override protected function focusOutHandler(event:FocusEvent):void {
            super.focusOutHandler(event);

            deselectAllShapes();
        }

        override protected function keyUpHandler(event:KeyboardEvent):void {
            super.keyUpHandler(event);

            if (event.keyCode == 46 && mode == ShapesCanvasModes.DELETE) {
                dataProvider.disableAutoUpdate();

                for each (var selectedObject:Object in selectedShapes) {
                    var selectedObjectIndex:int = dataProvider.getItemIndex(selectedObject);
                    dataProvider.removeItemAt(selectedObjectIndex);
                }

                dataProvider.enableAutoUpdate();
            }
        }


        /*==============================================================*/
        /* Mouse Events */
        /*==============================================================*/
        private var canvasMouseDownX:Number;
        private var canvasMouseDownY:Number;
        private var selectedShapeMouseDownX:Number;
        private var selectedShapeMouseDownY:Number;

        private function mouseDownHandler(event:MouseEvent):void {
            canvasMouseDownX = event.localX;
            canvasMouseDownY = event.localY;

            if (selectedShapes && selectedShapes.length > 0) {
                var stageMousePoint:Point = new Point(event.stageX, event.stageY);
                var shapeLocalPoint:Point = SkinnableShape(selectedShapes[0]).globalToLocal(stageMousePoint);
                selectedShapeMouseDownX = shapeLocalPoint.x;
                selectedShapeMouseDownY = shapeLocalPoint.y;
            }

            stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
        }

        private var inCreationOfNewShape:Boolean;

        protected function stageMouseMoveHandler(event:MouseEvent):void {
            switch (mode) {
                case ShapesCanvasModes.CREATE_AND_EDIT:
                    inCreationOfNewShape = true;
                    break;
                case ShapesCanvasModes.RESIZE_AND_MOVE:
                    moveSelectedShapesWithMouse(event);
                    break;
                default:
                    return;
            }
        }

        private function shapeSelectionChangeHandler(event:SkinnableShapeEvent):void {
            event.stopPropagation();

            var targetShape:SkinnableShape = event.target as SkinnableShape;

            //deselect other shapes if current is selected
            if(targetShape.selected) {
                for each (var shape:SkinnableShape in selectedShapes) {
                    if (shape != targetShape) {
                        shape.selected = false;
                    }
                }
            }
        }

        private function deselectAllShapes():void {
            for each (var shape:SkinnableShape in selectedShapes) {
                shape.selected = false;
            }
        }

        protected function stageMouseUpHandler(event:MouseEvent):void {
            if (inCreationOfNewShape) {
                var stageMousePoint:Point = new Point(event.stageX, event.stageY);

                var localCanvasPoint:Point = globalToLocal(stageMousePoint);
                var localCanvasX:Number = localCanvasPoint.x;
                var localCanvasY:Number = localCanvasPoint.y;

                var shapeWidth:Number = localCanvasX/*event.localX*/ - canvasMouseDownX;
                var shapeHeight:Number = localCanvasY/*event.localY*/ - canvasMouseDownY;

                createShape(ShapeTypes.TEXT_SHAPE, canvasMouseDownX, canvasMouseDownY, shapeWidth, shapeHeight);

                inCreationOfNewShape = false;
            }

            stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
        }

        /*==============================================================*/

        private function moveSelectedShapesWithMouse(event:MouseEvent):void {
            var stageMousePoint:Point = new Point(event.stageX, event.stageY);

            var localCanvasPoint:Point = globalToLocal(stageMousePoint);
            var localCanvasX:Number = localCanvasPoint.x;
            var localCanvasY:Number = localCanvasPoint.y;

            for each (var shape:SkinnableShape in selectedShapes) {
                shape.x = localCanvasX - selectedShapeMouseDownX;
                shape.y = localCanvasY - selectedShapeMouseDownY;
            }
        }

        private function createShape(shapeType:String, shapeX:Number, shapeY:Number, shapeWidth:Number, shapeHeight:Number):void {
            var newShape:SkinnableShape = shapeFactory.createSkinnableShape(shapeType);

            newShape.x = shapeX;
            newShape.y = shapeY;
            newShape.width = shapeWidth;
            newShape.height = shapeHeight;

            newShape.selected = true;

            dataProvider.addItem(newShape);
        }

        protected function addShapes(shapes:ArrayCollection):void {
            for each (var object:Object in shapes) {
                addElement(object as IVisualElement);
            }
        }

        override protected function commitProperties():void {
            if (dataProviderChanged) {

                removeAllElements();

                addShapes(dataProvider);
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
                case CollectionEventKind.REPLACE:
                    adjustAfterReplace(event.items);
                    break;
                case CollectionEventKind.REMOVE:
                    adjustAfterRemove(event.items);
                    break;
                case CollectionEventKind.MOVE:
                    adjustAfterMove(event.items[0], event.location, event.oldLocation);
                    break;
                case CollectionEventKind.REFRESH:
                    removeDataProviderListener();
                    dataProviderChanged = true;
                    invalidateProperties();
                    break;
                case CollectionEventKind.RESET:
                    removeDataProviderListener();
                    dataProviderChanged = true;
                    invalidateProperties();
                    break;
                case CollectionEventKind.UPDATE:
                    break;
            }
        }

        protected function adjustAfterAdd(items:Array):void {
            for each (var object:Object in items) {
                addElement(object as IVisualElement);
            }

            //deselect other shapes if one is selected (applicable to last added)
            if(SkinnableShape(object).selected) {
                for each (var shape:SkinnableShape in selectedShapes) {
                    if (shape != SkinnableShape(object)) {
                        shape.selected = false;
                    }
                }
            }
        }

        protected function adjustAfterRemove(items:Array):void {
            for each (var object:Object in items) {
                removeElement(object as IVisualElement);
            }
        }

        protected function adjustAfterMove(item:Object, location:int, oldLocation:int):void {
            /*
             itemRemoved(item, oldLocation);
             itemAdded(item, location);
             resetRenderersIndices();
             */
        }

        protected function adjustAfterReplace(propertyChangeEvents:Array):void {
            /*
             var length:int=propertyChangeEvents.length;
             for (var i:int=length - 1; i >= 0; i--) {
             itemRemoved(propertyChangeEvents[i].oldValue, location + i);
             }

             for (i=length - 1; i >= 0; i--) {
             itemAdded(propertyChangeEvents[i].newValue, location);
             }
             */
        }
    }
}
