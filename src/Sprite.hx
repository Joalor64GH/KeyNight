class Sprite extends Basic
{
	static var _rect:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);
	static var _rect2:Rl.Rectangle = Rl.Rectangle.create(0, 0, 0, 0);

	public var x:Float;
	public var y:Float;

	public var width(default, null):Float = 0;
	public var height(default, null):Float = 0;

	public var scale(default, null):Point = Point.get(1, 1);

	public var origin(default, null):Point = Point.get();
	public var offset(default, null):Point = Point.get();

	public var texture:Rl.Texture2D;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();

		this.x = x;
		this.y = y;
	}

	public function load(texture:Rl.Texture2D)
	{
		this.texture = texture;

		width = texture.width;
		height = texture.height;

		centerOrigin();

		return this;
	}

	public function updateHitbox()
	{
		width = texture.width * Math.abs(scale.x);
		height = texture.height * Math.abs(scale.y);
		centerOrigin();
		centerOffsets();
	}

	public function centerOrigin()
	{
		origin.set(texture.width / 2, texture.height / 2);
	}

	public function centerOffsets()
	{
		offset.set((texture.width - width) / 2, (texture.height - height) / 2);
	}

	override function draw()
	{
		// source rectangle
		_rect.x = 0;
		_rect.y = 0;
		_rect.width = texture.width;
		_rect.height = texture.height;

		// destination rectangle
		_rect2.x = x + origin.x - offset.x;
		_rect2.y = y + origin.y - offset.y;
		_rect2.width = texture.width * scale.x;
		_rect2.height = texture.height * scale.y;

		Rl.drawTexturePro(texture, _rect, _rect2, origin.vector, 0, Rl.Colors.WHITE);
	}

	override function destroy()
	{
		super.destroy();

		scale.kill();
		offset.kill();
		scale = null;
		offset = null;
	}
}
