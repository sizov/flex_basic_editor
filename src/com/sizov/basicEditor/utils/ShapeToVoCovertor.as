package com.sizov.basicEditor.utils {

    import com.sizov.basicEditor.components.IShapeFactory;
    import com.sizov.basicEditor.components.ShapeTypes;
    import com.sizov.basicEditor.components.skinnableShape.RectangleSkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.SkinnableShape;
    import com.sizov.basicEditor.components.skinnableShape.TextSkinnableShape;
    import com.sizov.basicEditor.vo.ShapeVo;

    import mx.collections.ArrayCollection;

//TODO: Move convertion to canvas
    public class ShapeToVoCovertor {

        public static function getVoFromVisuals(shapesCollection:ArrayCollection):ArrayCollection {
            var result:ArrayCollection = new ArrayCollection();

            for each (var skinnableShape:SkinnableShape in shapesCollection) {
                var shapeVo:ShapeVo = new ShapeVo();

                //TODO:move to factory util
                if (skinnableShape is TextSkinnableShape) {
                    shapeVo.type = ShapeTypes.TEXT_SHAPE;
                }
                else if (skinnableShape is RectangleSkinnableShape) {
                    shapeVo.type = ShapeTypes.RECTANGLE_SHAPE;
                }

                shapeVo.height = skinnableShape.height;
                shapeVo.width = skinnableShape.width;
                shapeVo.x = skinnableShape.x;
                shapeVo.y = skinnableShape.y;

                if (skinnableShape is TextSkinnableShape) {
                    shapeVo.text = TextSkinnableShape(skinnableShape).text;
                }

                result.addItem(shapeVo);
            }

            return result;
        }

        public static function getVisualsFromVo(shapeVoCollection:ArrayCollection, shapeFactory:IShapeFactory):ArrayCollection {
            var result:ArrayCollection = new ArrayCollection();
            for each (var shapeVo:ShapeVo in shapeVoCollection) {
                var skinnableShape:SkinnableShape = shapeFactory.createSkinnableShape(shapeVo.type);

                skinnableShape.x = shapeVo.x;
                skinnableShape.y = shapeVo.y;
                skinnableShape.width = shapeVo.width;
                skinnableShape.height = shapeVo.height;

                if (skinnableShape is TextSkinnableShape) {
                    TextSkinnableShape(skinnableShape).text = shapeVo.text;
                }

                result.addItem(skinnableShape);
            }

            return result;
        }
    }
}
