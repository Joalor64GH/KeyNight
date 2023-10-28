package internal;

import Rl.Vector2;
import internal.Atlas;

using StringTools;

class Sprite extends Basic
{
	static var _rect:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);
	static var _rect2:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);
	static var originVector:Vector2 = Vector2.create(0, 0);

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

	public var animations(default, null):Map<String, Animation> = [];
	public var animation(default, null):Animation;
	public var animationPaused:Bool = false;
	public var animationFinished:Bool = false;

	public var animationFrame(default, set):Float = -1;
	public var frames(default, set):AtlasFrames;

	public function set_animationFrame(value:Float):Float
	{
		if (animationFrame >= 0 && frames != null)
		{
			var frame:Frame = animation.frames[Math.floor(value)];
			if (frame != null)
			{
				frameWidth = frame.width;
				frameHeight = frame.height;
			}
		}
		return (animationFrame = value);
	}

	public function set_frames(value:AtlasFrames):AtlasFrames
	{
		if (value != null)
		{
			frames = value;
			animationFrame = 0;

			width = frameWidth;
			height = frameHeight;
			centerOrigin();
		}
		else
			animationFrame = -1;

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
		offset.set((width - frameWidth) / -2, (height - frameHeight) / -2);
	}

	public function centerOrigin()
	{
		origin.set(frameWidth / 2, frameHeight / 2);
	}

	public function centerOffsets()
	{
		offset.set((frameWidth - width) / 2, (frameHeight - height) / 2);
	}

	public function addAnimation(name:String, frames:Array<Int>, frameRate:Float = 30, looped:Bool = true, flipX:Bool = false, flipY:Bool = false)
	{
		var animation:Animation = {
			frames: [],
			frameRate: frameRate,
			looped: looped,
			flipX: flipX,
			flipY: flipY
		}

		for (i in frames)
		{
			var frame:Frame = this.frames.frames[i];
			if (frame != null)
				animation.frames.push(frame);
			else
				trace("[Animation] Frame " + i + " missing.");
		}

		if (animation.frames.length > 0)
			animations.set(name, animation);
	}

	static function sortByIndices(prefix:String, postfix:String):Frame->Frame->Int
	{
		return (a:Frame, b:Frame) -> Std.parseInt(a.name.substring(prefix.length, a.name.length - postfix.length))
			- Std.parseInt(b.name.substring(prefix.length, b.name.length - postfix.length));
	}

	public function addAnimationByPrefix(name:String, prefix:String, frameRate:Float = 30, looped:Bool = true, flipX:Bool = false, flipY:Bool = false)
	{
		var animation:Animation = {
			frames: [],
			frameRate: frameRate,
			looped: looped,
			flipX: flipX,
			flipY: flipY
		}

		for (frame in frames.frames)
		{
			if (frame.name.startsWith(prefix))
				animation.frames.push(frame);
		}

		if (animation.frames.length > 0)
		{
			animation.frames.sort(sortByIndices(prefix, ""));
			animations.set(name, animation);
		}
	}

	public function addAnimationByIndices(name:String, prefix:String, indices:Array<Int>, postfix:String = "", frameRate:Float = 30, looped:Bool = true,
			flipX:Bool = false, flipY:Bool = false)
	{
		var animation:Animation = {
			frames: [],
			frameRate: frameRate,
			looped: looped,
			flipX: flipX,
			flipY: flipY
		}

		var allFrames:Array<Frame> = [];
		for (frame in frames.frames)
		{
			if (frame.name.startsWith(prefix) && frame.name.endsWith(postfix))
				allFrames.push(frame);
		}

		allFrames.sort(sortByIndices(prefix, postfix));

		for (i in indices)
		{
			var frame = allFrames[i];
			if (frame != null)
				animation.frames.push(frame);
		}

		if (animation.frames.length > 0)
			animations.set(name, animation);
	}

	public function play(animName:String, force:Bool = false, frame:Int = 0)
	{
		var animationToPlay:Animation = animations.get(animName);

		if (!force && animation == animationToPlay)
		{
			animationPaused = false;
			animationFinished = false;
			return;
		}

		if (animationToPlay != null)
		{
			animation = animationToPlay;
			animationFrame = 0;
			animationPaused = false;
			animationFinished = false;
		}
		else
			trace("[Animation] Animation '" + animName + "' not found.");
	}

	public function pause()
	{
		if (animation != null && !animationFinished)
			animationPaused = true;
	}

	public function resume()
	{
		if (animation != null && !animationFinished)
			animationPaused = false;
	}

	public function stop()
	{
		if (animation != null)
		{
			animationPaused = true;
			animationFinished = true;
		}
	}

	public function finish()
	{
		if (animation != null)
		{
			stop();
			animationFrame = animation.frames.length - 1;
		}
	}

	override function update(dt:Float)
	{
		super.update(dt);

		if (animation != null && !animationPaused && !animationFinished)
		{
			animationFrame += dt * animation.frameRate;

			if (animationFrame >= animation.frames.length - 1)
			{
				if (animation.looped)
					animationFrame = 0;
				else
					animationFinished = true;
			}
		}
	}

	override function draw()
	{
		var frame:Frame = null;

		// source rectangle
		if (animationFrame < 0)
		{
			_rect.x = 0;
			_rect.y = 0;
			_rect.width = texture.width;
			_rect.height = texture.height;
		}
		else
		{
			frame = animation.frames[Math.floor(animationFrame)];
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

		var absScaleX:Float = Math.abs(scale.x);
		var absScaleY:Float = Math.abs(scale.y);

		// destination rectangle
		_rect2.x = x + origin.x - offset.x - (frame.offsetX ?? 0);
		_rect2.y = y + origin.y - offset.y - (frame.offsetY ?? 0);
		_rect2.width = _rect.width * absScaleX;
		_rect2.height = _rect.height * absScaleY;

		// apply flips to source rectangle
		if (sx < 0)
			_rect.width = -_rect.width;
		if (sy < 0)
			_rect.height = -_rect.height;

		// trace("source", _rect.x, _rect.y, _rect.width, _rect.height);
		// trace("dest", _rect2.x, _rect2.y, _rect2.width, _rect2.height);
		// trace("origin", origin.x, origin.y);

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

typedef Animation =
{
	frames:Array<Frame>,
	frameRate:Float,
	looped:Bool,
	flipX:Bool,
	flipY:Bool
}
