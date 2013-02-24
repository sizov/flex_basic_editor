package com.sizov.basicEditor.commands {

    import com.sizov.basicEditor.messages.ServiceMessage;
    import com.sizov.basicEditor.services.IShapesService;

    import mx.collections.ArrayCollection;

    public class SaveShapesCommand {

        [Inject]
        public var shapesService:IShapesService;

        public function execute(message:ServiceMessage):void {
            var shapesToSave:ArrayCollection = message.data as ArrayCollection;
            shapesService.responder = message.responder;
            shapesService.save(shapesToSave);
        }
    }
}
