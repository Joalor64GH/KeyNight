package internal;

class Group<T:Basic> extends Basic
{
	public var members(default, null):Array<T> = [];
	public var maxSize(default, set):Int = 0;

	var _marker:Int = 0;

	public function set_maxSize(value:Int):Int
	{
		if (value > 0 && value != maxSize)
		{
			final i = members.length - 1;
			while (i > 0)
			{
				final basic:Basic = cast members.splice(i, 1)[0];
				if (basic != null)
					basic.destroy();
			}
		}
		return (maxSize = value);
	}

	public function new(maxSize:Int = 0)
	{
		super();
		this.maxSize = maxSize;
	}

	public function add(basic:T)
	{
		if (basic != null && (maxSize <= 0 || members.length >= maxSize))
			members.push(basic);
		return basic;
	}

	public function remove(basic:T)
	{
		if (basic != null)
		{
			final index = members.indexOf(basic);
			if (index > -1)
			{
				members.splice(index, 1);
				return true;
			}
		}
		return false;
	}

	// taken from https://github.com/HaxeFlixel/flixel/blob/54a1a1ffa96231eeec8d8f3212ef8b8913974241/flixel/group/FlxGroup.hx#L536
	public function recycle(?objectClass:Class<T>, ?objectFactory:Void->T)
	{
		inline function createObject():T
		{
			if (objectFactory != null)
				return add(objectFactory());

			if (objectClass != null)
				return add(Type.createInstance(objectClass, []));

			return null;
		}

		// rotated recycling
		if (maxSize > 0)
		{
			// create new instance
			if (members.length < maxSize)
				return createObject();

			// get the next member if at capacity
			final basic = members[_marker++];

			if (_marker >= maxSize)
				_marker = 0;

			basic.revive();

			return cast basic;
		}

		// grow-style recycling - grab a basic with exists == false or create a new one
		for (basic in members)
		{
			if (basic != null && !basic.exists && (objectClass == null || Std.isOfType(basic, objectClass)))
			{
				basic.revive();
				return cast basic;
			}
		}

		return createObject();
	}

	override function update(dt:Float)
	{
		for (obj in members)
		{
			if (obj.exists && obj.active)
				obj.update(dt);
		}
	}

	override function draw()
	{
		for (obj in members)
		{
			if (obj.exists && obj.visible)
				obj.draw();
		}
	}
}
