package com.sizov.basicEditor.services {

    import mx.collections.ArrayCollection;
    import mx.rpc.IResponder;

    public interface IShapesService {

        function load():void;
        function save(shapes:ArrayCollection):void;
        function set responder(responder:IResponder):void;

    }
}
