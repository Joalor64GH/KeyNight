package internal;

class Basic
{
	public var alive:Bool = true;
	public var exists:Bool = true;

	public var active:Bool = true;
	public var visible:Bool = true;

	public function new() {}

	public function kill()
	{
		alive = false;
		exists = false;
	}

	public function revive()
	{
		alive = true;
		exists = true;
	}

	public function destroy()
	{
		exists = false;
	}

	public function update(dt:Float) {}

	public function draw() {}
}
