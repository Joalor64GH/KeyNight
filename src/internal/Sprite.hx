package internal;

import internal.Atlas;

class Sprite extends Basic
{
	static var _rect:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);
	static var _rect2:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);

	public var x:Float;
	public var y:Float;

	public var flipX:Bool = false;
	public var flipY:Bool = false;
	public var angle:Float = 0;

	public var width(default, null):Float;
	public var height(default, null):Float;

	public var frameWidth(default, null):Float;
	public var frameHeight(default, null):Float;

	public var scale(default, null):Point = Point.get(1, 1);

	public var origin(default, null):Point = Point.get();
	public var offset(default, null):Point = Point.get();

	public var texture(default, null):Rl.Texture2D;

	public var frameIndex(default, set):Null<Int>;
	public var frames(default, set):AtlasFrames;

	public function set_frameIndex(value:Null<Int>):Null<Int>
	{
		if (frames != null)
		{
			var frame:Frame = frames.frames[value];
			if (frame != null)
			{
				frameWidth = frame.width;
				frameHeight = frame.height;
			}
		}
		return (frameIndex = value);
	}

	public function set_frames(value:AtlasFrames):AtlasFrames
	{
		if (value != null)
		{
			frames = value;
			frameIndex = 0;

			width = frameWidth;
			height = frameHeight;
			centerOrigin();
		}
		else
			frameIndex = null;

		return value;
	}

	public function new(x:Float = 0, y:Float = 0)
	{
		super();

		this.x = x;
		this.y = y;
	}

	public function load(texture:Rl.Texture2D)
	{
		this.texture = texture;

		width = frameWidth = texture.width;
		height = frameHeight = texture.height;

		centerOrigin();

		return this;
	}

	public function updateHitbox()
	{
		width = frameWidth * Math.abs(scale.x);
		height = frameHeight * Math.abs(scale.y);
		centerOrigin();
		centerOffsets();
	}

	public function centerOrigin()
	{
		origin.set(frameWidth / 2, frameHeight / 2);
	}

	public function centerOffsets()
	{
		offset.set((frameWidth - width) / 2, (frameHeight - height) / 2);
	}

	override function draw()
	{
		var frame:Frame = null;

		// source rectangle
		if (frameIndex == null)
		{
			_rect.x = 0;
			_rect.y = 0;
			_rect.width = texture.width;
			_rect.height = texture.height;
		}
		else
		{
			frame = frames.frames[frameIndex];
			_rect.x = frame.sourceX;
			_rect.y = frame.sourceY;
			_rect.width = frame.sourceWidth;
			_rect.height = frame.sourceHeight;
		}

		// scaling
		var sx:Float = scale.x;
		var sy:Float = scale.y;

		if (flipX)
			sx = -sx;
		if (flipY)
			sy = -sy;

		// destination rectangle
		_rect2.x = x + origin.x - offset.x;
		_rect2.y = y + origin.y - offset.y;
		_rect2.width = width;
		_rect2.height = height;

		if (frame != null)
		{
			if (frame.offsetX != null)
				_rect2.x += frame.offsetX;
			if (frame.offsetY != null)
				_rect2.y += frame.offsetY;
		}

		// apply flips
		if (sx < 0)
			_rect.width = -_rect.width;
		if (sy < 0)
			_rect.height = -_rect.height;

		// draw the whole thing
		Rl.drawTexturePro(frame != null ? frames.texture : texture, _rect, _rect2, origin.vector, angle, Rl.Colors.WHITE);
	}

	override function destroy()
	{
		super.destroy();

		scale.kill();
		origin.kill();
		offset.kill();
		scale = null;
		origin = null;
		offset = null;
	}
}
