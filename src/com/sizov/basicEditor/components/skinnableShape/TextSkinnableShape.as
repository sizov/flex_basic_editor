package com.sizov.basicEditor.components.skinnableShape {

    import com.sizov.basicEditor.skins.TextSkin;

    public class TextSkinnableShape extends SkinnableShape {

        [Bindable]
        public var text:String = "Dummy text";

        public function TextSkinnableShape() {
            setStyle("skinClass", TextSkin);
        }
    }
}
