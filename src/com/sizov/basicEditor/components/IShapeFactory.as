package com.sizov.basicEditor.components {

    import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;

    public interface IShapeFactory {

        function createSkinnableShape(type:String):SkinnableShape;

    }
}
