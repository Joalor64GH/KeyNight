package internal;

@:forward abstract Point(BasePoint) to BasePoint from BasePoint
{
	static var _pool:Group<BasePoint> = new Group<BasePoint>();

	public static function get(x:Float = 0, y:Float = 0):Point
	{
		var point:BasePoint = _pool.recycle(BasePoint);
		point.set(x, y);
		return point;
	}

	public inline function new(x:Float = 0, y:Float = 0)
	{
		this = new BasePoint(x, y);
	}

	@:noCompletion
	@:op(A + B)
	private static inline function addOp(a:Point, b:Point)
	{
		return new Point(a.x + b.x, a.y + b.y);
	}

	@:noCompletion
	@:op(A += B)
	private static inline function addEqualOp(a:Point, b:Point)
	{
		return a.add(b.x, b.y);
	}

	@:noCompletion
	@:op(A - B)
	private static inline function subtractOp(a:Point, b:Point)
	{
		return new Point(a.x - b.x, a.y - b.y);
	}

	@:noCompletion
	@:op(A -= B)
	private static inline function subtractEqualOp(a:Point, b:Point)
	{
		return a.subtract(b.x, b.y);
	}

	@:noCompletion
	@:op(A * B)
	private static inline function multiplyOp(a:Point, b:Point)
	{
		return new Point(a.x * b.x, a.y * b.y);
	}

	@:noCompletion
	@:op(A *= B)
	private static inline function multiplyEqualOp(a:Point, b:Point)
	{
		return a.multiply(b.x, b.y);
	}

	@:noCompletion
	@:op(A / B)
	private static inline function divideOp(a:Point, b:Point)
	{
		return new Point(a.x / b.x, a.y / b.y);
	}

	@:noCompletion
	@:op(A /= B)
	private static inline function divideEqualOp(a:Point, b:Point)
	{
		return a.divide(b.x, b.y);
	}
}

class BasePoint extends Basic
{
	/**
	 * Internal vector that holds the coordinates of the point.
	 */
	public var vector(default, null):Rl.Vector2;

	public var x(get, set):Float;
	public var y(get, set):Float;

	public function get_x():Float
	{
		return vector.x;
	}

	public function get_y():Float
	{
		return vector.y;
	}

	public function set_x(value:Float)
	{
		return (vector.x = value);
	}

	public function set_y(value:Float)
	{
		return (vector.y = value);
	}

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		vector = Rl.Vector2.create(x, y);
	}

	override function destroy()
	{
		super.destroy();
		vector = null;
	}

	public inline function set(x:Float = 0, y:Float = 0)
	{
		vector.x = x;
		vector.y = y;
		return this;
	}

	public inline function add(x:Float = 0, y:Float = 0)
	{
		vector.x += x;
		vector.y += y;
		return this;
	}

	public inline function subtract(x:Float = 0, y:Float = 0)
	{
		vector.x -= x;
		vector.y -= y;
		return this;
	}

	public inline function multiply(x:Float = 0, y:Float = 0)
	{
		vector.x *= x;
		vector.y *= y;
		return this;
	}

	public inline function divide(x:Float = 0, y:Float = 0)
	{
		vector.x /= x;
		vector.y /= y;
		return this;
	}
}
