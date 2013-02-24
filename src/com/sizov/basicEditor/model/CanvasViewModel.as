package com.sizov.basicEditor.model {

    import com.sizov.basicEditor.components.IShapeFactory;
    import com.sizov.basicEditor.messages.ServiceMessage;
    import com.sizov.basicEditor.messages.ToolbarActionMessage;
    import com.sizov.basicEditor.utils.ShapeToVoCovertor;

    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.rpc.Responder;
    import mx.rpc.events.ResultEvent;

    /**
     * This model controls ShapesCanvas view.
     */

    [Bindable]
    public class CanvasViewModel {

        [MessageDispatcher]
        public var dispatcher:Function;

        public var shapesCollection:ArrayCollection = new ArrayCollection();

        [Inject]
        public var shapesFactory:IShapeFactory;

        public var canvasMode:String;

        [MessageHandler]
        public function canvasMessageHandler(message:ToolbarActionMessage):void {
            switch (message.type) {
                case ToolbarActionMessage.CLEAR_CANVAS:
                    clearCanvas();
                    break;
                case ToolbarActionMessage.SET_MODE:
                    canvasMode = message.data as String;
                    break;
                case ToolbarActionMessage.SAVE:
                    saveShapes();
                    break;
                default :
                    return;
            }
        }

        public function clearCanvas():void {
            shapesCollection.removeAll();
        }

        public function loadShapes():void {
            var serviceMessage:ServiceMessage = new ServiceMessage(ServiceMessage.LOAD_SHAPES);
            serviceMessage.responder = new Responder(loadShapesResultHandler, loadShapesFaultHandler);
            dispatcher(serviceMessage);
        }

        private function loadShapesResultHandler(result:Object):void {
            var shapesVoCollection:ArrayCollection = ResultEvent(result).result as ArrayCollection;
            shapesCollection = ShapeToVoCovertor.getVisualsFromVo(shapesVoCollection, shapesFactory);
        }

        private function loadShapesFaultHandler(fault:Object):void {
            Alert.show("Error loading shapes");
        }

        private function saveShapes():void {
            var serviceMessage:ServiceMessage = new ServiceMessage(ServiceMessage.SAVE_SHAPES,
                    ShapeToVoCovertor.getVoFromVisuals(shapesCollection));
            serviceMessage.responder = new Responder(saveShapesResultHandler, saveShapesFaultHandler);
            dispatcher(serviceMessage);
        }

        private function saveShapesResultHandler(result:Object):void {
        }

        private function saveShapesFaultHandler(fault:Object):void {
            Alert.show("Error saving shapes");
        }
    }
}