package internal;

final class Atlas {
	static inline function boundFrame(texture:Rl.Texture2D, frame:Frame) {
		final topRight = frame.sourceX + frame.sourceWidth;
		if (topRight > texture.width)
			frame.sourceWidth -= topRight - texture.width;

		final bottomLeft = frame.sourceY + frame.sourceHeight;
		if (bottomLeft > texture.height)
			frame.sourceHeight -= bottomLeft - texture.height;
	}

	public static function fromSparrow(texture:Rl.Texture2D, description:String):AtlasFrames {
		final xml = Xml.parse(description);
		final atlasFrames:AtlasFrames = {
			texture: texture,
			frames: []
		};

		var textureAtlasNode:Xml = null;
		for (child in xml.elements()) {
			if (child.nodeType == Element && child.nodeName == "TextureAtlas") {
				textureAtlasNode = child;
				break;
			}
		}
		if (textureAtlasNode == null) {
			trace("[Sparrow Atlas] Cannot find the TextureAtlas node.");
			return null;
		}

		for (child in textureAtlasNode.elements()) {
			final frame:Frame = {
				name: child.get("name"),
				sourceX: Std.parseFloat(child.get("x")),
				sourceY: Std.parseFloat(child.get("y")),
				sourceWidth: Std.parseFloat(child.get("width")),
				sourceHeight: Std.parseFloat(child.get("height")),
				width: 0,
				height: 0
			};

			var frameX:Float = Std.parseFloat(child.get("frameX"));
			if (!Math.isNaN(frameX) && frameX != 0)
				frame.offsetX = frameX;

			var frameY:Float = Std.parseFloat(child.get("frameY"));
			if (!Math.isNaN(frameY) && frameY != 0)
				frame.offsetY = frameY;

			var frameWidth:Float = Std.parseFloat(child.get("frameWidth"));
			if (!Math.isNaN(frameWidth) && frameWidth != 0)
				frame.width = frameWidth;
			else
				frame.width = frame.sourceWidth;

			var frameHeight:Float = Std.parseFloat(child.get("frameHeight"));
			if (!Math.isNaN(frameHeight) && frameHeight != 0)
				frame.height = frameHeight;
			else
				frame.height = frame.sourceHeight;

			boundFrame(texture, frame);

			atlasFrames.frames.push(frame);
		}

		return atlasFrames;
	}
}

typedef AtlasFrames = {
	texture:Rl.Texture2D,
	frames:Array<Frame>
}

typedef Frame = {
	name:String,
	sourceX:Float,
	sourceY:Float,
	sourceWidth:Float,
	sourceHeight:Float,
	width:Float,
	height:Float,
	?offsetX:Float,
	?offsetY:Float
}
