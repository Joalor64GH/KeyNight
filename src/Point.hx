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
	var _vector:Rl.Vector2;

	public var x(get, set):Float;
	public var y(get, set):Float;

	public function get_x():Float
	{
		return _vector.x;
	}

	public function get_y():Float
	{
		return _vector.y;
	}

	public function set_x(value:Float)
	{
		return (_vector.x = value);
	}

	public function set_y(value:Float)
	{
		return (_vector.y = value);
	}

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		_vector = Rl.Vector2.create(x, y);
	}

	public function getRaylib():Rl.Vector2
	{
		return _vector;
	}

	public inline function set(x:Float = 0, y:Float = 0)
	{
		_vector.x = x;
		_vector.y = y;
		return this;
	}

	public inline function add(x:Float = 0, y:Float = 0)
	{
		_vector.x += x;
		_vector.y += y;
		return this;
	}

	public inline function subtract(x:Float = 0, y:Float = 0)
	{
		_vector.x -= x;
		_vector.y -= y;
		return this;
	}

	public inline function multiply(x:Float = 0, y:Float = 0)
	{
		_vector.x *= x;
		_vector.y *= y;
		return this;
	}

	public inline function divide(x:Float = 0, y:Float = 0)
	{
		_vector.x /= x;
		_vector.y /= y;
		return this;
	}
}
