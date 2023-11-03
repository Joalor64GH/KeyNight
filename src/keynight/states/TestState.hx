package keynight.states;

import internal.Assets;
import internal.Atlas;
import internal.Sprite;
import internal.State;

class TestState extends State
{
	var test:Sprite;

	public function new()
	{
		super();

		test = new Sprite().load(Assets.getTexture("receptor"));
		add(test);
	}

	override function update(dt:Float)
	{
		super.update(dt);
		test.angle += 3 * dt;
	}
}
