/**
 * Created with IntelliJ IDEA.
 * User: vsyzov
 * Date: 24.02.13
 * Time: 12:54
 * To change this template use File | Settings | File Templates.
 */
package com.sizov.basicEditor.services {

    import flash.net.SharedObject;

    import mx.collections.ArrayCollection;
    import mx.rpc.IResponder;
    import mx.rpc.events.ResultEvent;

    public class SharedObjectsShapesService implements IShapesService {

        private static const NAMESPACE:String = "com.sizov.baseEditor";
        private static const SHAPES_FIELD:String = "shapes";

        private var _responder:IResponder;
        public function set responder(responder:IResponder):void {
            _responder = responder;
        }

        public function load():void {
            var sharedObject:SharedObject = SharedObject.getLocal(NAMESPACE);
            var loadedShapes:Array = sharedObject.data[SHAPES_FIELD];

            returnResult(new ArrayCollection(loadedShapes));
        }

        public function save(shapes:ArrayCollection):void {
            var sharedObject:SharedObject = SharedObject.getLocal(NAMESPACE);
            sharedObject.clear();

            if (shapes && shapes.length > 0) {
                sharedObject.data[SHAPES_FIELD] = shapes.source;
                sharedObject.flush();
            }

            returnResult(null);
        }

        private function returnResult(data:Object):void {
            var resultEvent:ResultEvent =
                    new ResultEvent(ResultEvent.RESULT, false, true, data);

            if (_responder) {
                _responder.result(resultEvent);
            }
        }
    }
}
