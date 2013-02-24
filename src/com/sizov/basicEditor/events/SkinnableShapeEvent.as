/**
 * Created with IntelliJ IDEA.
 * User: vsyzov
 * Date: 24.02.13
 * Time: 0:02
 * To change this template use File | Settings | File Templates.
 */
package com.sizov.basicEditor.events {

    import flash.events.Event;

    public class SkinnableShapeEvent extends Event {

        public static const SELECTION_CHANGE:String = "selectionChange";

        public function SkinnableShapeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):* {
            super(type, bubbles, cancelable);
        }

        override public function clone():Event {
            var clonedEvent:SkinnableShapeEvent = new SkinnableShapeEvent(type, bubbles, cancelable);
            return clonedEvent;
        }
    }
}
