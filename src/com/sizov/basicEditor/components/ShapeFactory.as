/**
 * Created with IntelliJ IDEA.
 * User: vsyzov
 * Date: 23.02.13
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
package com.sizov.basicEditor.components {

    import com.sizov.basicEditor.components.skinnableShape.RectangleSkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.TextSkinnableShape;

    public class ShapeFactory implements IShapeFactory {

        public function createSkinnableShape(type:String):SkinnableShape {
            switch (type) {
                case ShapeTypes.TEXT_SHAPE:
                    return new TextSkinnableShape();
                    break;
                case ShapeTypes.RECTANGLE_SHAPE:
                    return new RectangleSkinnableShape();
                    break;
                default:
                    return null;
            }
        }
    }
}
