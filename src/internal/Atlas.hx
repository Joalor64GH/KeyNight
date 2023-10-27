package internal;

class Atlas
{
	static inline function boundFrame(texture:Rl.Texture2D, frame:Frame)
	{
		var topRight:Float = frame.sourceX + frame.sourceWidth;
		if (topRight > texture.width)
			frame.sourceWidth -= topRight - texture.width;

		var bottomLeft:Float = frame.sourceY + frame.sourceHeight;
		if (bottomLeft > texture.height)
			frame.sourceHeight -= bottomLeft - texture.height;
	}

	public static function fromSparrow(texture:Rl.Texture2D, description:String):AtlasFrames
	{
		var xml:Xml = Xml.parse(description);
		var atlasFrames:AtlasFrames = {
			texture: texture,
			frames: []
		};

		for (child in xml.firstChild().elements())
		{
			var frame:Frame = {
				sourceX: Std.parseFloat(child.get("x")),
				sourceY: Std.parseFloat(child.get("y")),
				sourceWidth: Std.parseFloat(child.get("width")),
				sourceHeight: Std.parseFloat(child.get("height"))
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

			var frameHeight:Float = Std.parseFloat(child.get("frameHeight"));
			if (!Math.isNaN(frameHeight) && frameHeight != 0)
				frame.height = frameHeight;

			boundFrame(texture, frame);

			atlasFrames.frames.push(frame);
		}

		return atlasFrames;
	}
}

typedef AtlasFrames =
{
	texture:Rl.Texture2D,
	frames:Array<Frame>
}

typedef Frame =
{
	sourceX:Float,
	sourceY:Float,
	sourceWidth:Float,
	sourceHeight:Float,
	?offsetX:Float,
	?offsetY:Float,
	?width:Float,
	?height:Float
}
