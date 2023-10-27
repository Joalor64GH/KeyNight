package states;

class TestState extends State
{
	var cat:Sprite;

	public function new()
	{
		super();

		cat = new Sprite().load(Rl.loadTexture("assets/images/cat.jpg"));
		cat.flipX = cat.flipY = true;
		add(cat);
	}

	override function update(dt:Float)
	{
		super.update(dt);
		cat.angle += 3 * dt;
	}
}
