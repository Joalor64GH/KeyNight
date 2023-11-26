package internal;

import internal.Atlas;

using StringTools;

class Sprite extends Basic {
	// for rendering
	static final _rect:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);
	static final _rect2:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);
	static final _renderOrigin:Rl.Vector2 = Rl.Vector2.create(0, 0);
	static final _renderColor:Rl.Color = Rl.Color.create(255, 255, 255, 255);

	public var x:Float;
	public var y:Float;
	public var angle:Float = 0;

	public var flipX:Bool = false;
	public var flipY:Bool = false;
	public var alpha:Float = 1;

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

	public function set_animationFrame(value:Float):Float {
		if (animation != null) {
			final frame = animation.frames[Math.floor(value)];
			if (frame != null) {
				frameWidth = frame.width;
				frameHeight = frame.height;
			}
		}
		return (animationFrame = value);
	}

	public function set_frames(value:AtlasFrames):AtlasFrames {
		if (value != null) {
			frames = value;
			animationFrame = 0;

			final frame = frames.frames[0];
			width = frameWidth = frame.width;
			height = frameHeight = frame.height;
			centerOrigin();
		} else
			animationFrame = -1;

		return value;
	}

	public function new(x:Float = 0, y:Float = 0) {
		super();

		this.x = x;
		this.y = y;
	}

	public function load(texture:Rl.Texture2D) {
		this.texture = texture;

		width = frameWidth = texture.width;
		height = frameHeight = texture.height;

		centerOrigin();

		return this;
	}

	public function updateHitbox() {
		width = frameWidth * Math.abs(scale.x);
		height = frameHeight * Math.abs(scale.y);
		centerOrigin();
		offset.set((width - frameWidth) / -2, (height - frameHeight) / -2);
	}

	public function setGraphicSize(width:Float = 0, height:Float = 0) {
		if (width <= 0 && height <= 0)
			return;

		final newScaleX = width / frameWidth;
		final newScaleY = height / frameHeight;
		scale.set(newScaleX, newScaleY);

		if (width <= 0)
			scale.x = newScaleY;
		else if (height <= 0)
			scale.y = newScaleX;
	}

	public function centerOrigin() {
		origin.set(frameWidth / 2, frameHeight / 2);
	}

	public function centerOffsets() {
		offset.set((frameWidth - width) / 2, (frameHeight - height) / 2);
	}

	public function addAnimation(name:String, frames:Array<Int>, frameRate:Float = 30, looped:Bool = true, flipX:Bool = false, flipY:Bool = false) {
		final animation:Animation = {
			frames: [],
			frameRate: frameRate,
			looped: looped,
			flipX: flipX,
			flipY: flipY
		}

		for (i in frames) {
			var frame:Frame = this.frames.frames[i];
			if (frame != null)
				animation.frames.push(frame);
			else
				trace("[Animation] Frame " + i + " missing.");
		}

		if (animation.frames.length > 0)
			animations.set(name, animation);
	}

	static function sortByIndices(prefix:String, postfix:String):Frame->Frame->Int {
		return (a:Frame, b:Frame) -> Std.parseInt(a.name.substring(prefix.length, a.name.length - postfix.length))
			- Std.parseInt(b.name.substring(prefix.length, b.name.length - postfix.length));
	}

	public function addAnimationByPrefix(name:String, prefix:String, frameRate:Float = 30, looped:Bool = true, flipX:Bool = false, flipY:Bool = false) {
		final animation:Animation = {
			frames: [],
			frameRate: frameRate,
			looped: looped,
			flipX: flipX,
			flipY: flipY
		}

		for (frame in frames.frames) {
			if (frame.name.startsWith(prefix))
				animation.frames.push(frame);
		}

		if (animation.frames.length > 0) {
			animation.frames.sort(sortByIndices(prefix, ""));
			animations.set(name, animation);
		}
	}

	public function addAnimationByIndices(name:String, prefix:String, indices:Array<Int>, postfix:String = "", frameRate:Float = 30, looped:Bool = true,
			flipX:Bool = false, flipY:Bool = false) {
		final animation:Animation = {
			frames: [],
			frameRate: frameRate,
			looped: looped,
			flipX: flipX,
			flipY: flipY
		}

		final allFrames:Array<Frame> = [];
		for (frame in frames.frames) {
			if (frame.name.startsWith(prefix) && frame.name.endsWith(postfix))
				allFrames.push(frame);
		}

		allFrames.sort(sortByIndices(prefix, postfix));

		for (i in indices) {
			final frame = allFrames[i];
			if (frame != null)
				animation.frames.push(frame);
		}

		if (animation.frames.length > 0)
			animations.set(name, animation);
	}

	public function play(animName:String, force:Bool = false, frame:Int = 0) {
		final animationToPlay = animations.get(animName);

		if (!force && animation == animationToPlay) {
			animationPaused = false;
			animationFinished = false;
			return;
		}

		if (animationToPlay != null) {
			animation = animationToPlay;
			animationFrame = 0;
			animationPaused = false;
			animationFinished = false;
		} else
			trace("[Animation] Animation '" + animName + "' not found.");
	}

	public function pause() {
		if (animation != null && !animationFinished)
			animationPaused = true;
	}

	public function resume() {
		if (animation != null && !animationFinished)
			animationPaused = false;
	}

	public function stop() {
		if (animation != null) {
			animationPaused = true;
			animationFinished = true;
		}
	}

	public function finish() {
		if (animation != null) {
			stop();
			animationFrame = animation.frames.length - 1;
		}
	}

	override function update(dt:Float) {
		super.update(dt);

		if (animation != null && !animationPaused && !animationFinished) {
			animationFrame += dt * animation.frameRate;

			if (animationFrame >= animation.frames.length - 1) {
				if (animation.looped)
					animationFrame = 0;
				else
					animationFinished = true;
			}
		}
	}

	override function draw() {
		if (scale.x != 0 && scale.y != 0 && alpha > 0) {
			var frame:Frame = null;

			_renderOrigin.x = origin.x;
			_renderOrigin.y = origin.y;

			// source rectangle
			if (frames == null) {
				_rect.x = 0;
				_rect.y = 0;
				_rect.width = texture.width;
				_rect.height = texture.height;
			} else {
				frame = animation != null ? animation.frames[Math.floor(animationFrame)] : frames.frames[0];

				if (frame.offsetX != null)
					_renderOrigin.x += frame.offsetX;
				if (frame.offsetY != null)
					_renderOrigin.y += frame.offsetY;

				_rect.x = frame.sourceX;
				_rect.y = frame.sourceY;
				_rect.width = frame.sourceWidth;
				_rect.height = frame.sourceHeight;
			}

			// destination rectangle
			_rect2.x = x + origin.x - offset.x;
			_rect2.y = y + origin.y - offset.y;
			_rect2.width = _rect.width * Math.abs(scale.x);
			_rect2.height = _rect.height * Math.abs(scale.y);

			// apply flips to source rectangle
			if ((flipX ? -scale.x : scale.x) < 0)
				_rect.width = -_rect.width;
			if ((flipY ? -scale.y : scale.y) < 0)
				_rect.height = -_rect.height;

			// set render alpha
			_renderColor.a = cast Math.min(255 * alpha, 255);

			// draw the sprite
			Rl.drawTexturePro(frame != null ? frames.texture : texture, _rect, _rect2, _renderOrigin, angle, _renderColor);
		}
	}

	override function destroy() {
		super.destroy();

		scale.kill();
		origin.kill();
		offset.kill();
		scale = null;
		origin = null;
		offset = null;
	}
}

typedef Animation = {
	frames:Array<Frame>,
	frameRate:Float,
	looped:Bool,
	flipX:Bool,
	flipY:Bool
}
