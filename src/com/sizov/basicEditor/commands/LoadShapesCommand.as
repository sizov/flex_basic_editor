package com.sizov.basicEditor.commands {

    import com.sizov.basicEditor.messages.ServiceMessage;
    import com.sizov.basicEditor.services.IShapesService;

    public class LoadShapesCommand {

        [Inject]
        public var shapesService:IShapesService;

        public function execute(message:ServiceMessage):void {
            shapesService.responder = message.responder;
            shapesService.load();
        }
    }
}
