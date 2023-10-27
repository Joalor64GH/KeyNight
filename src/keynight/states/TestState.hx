package keynight.states;

import internal.Sprite;
import internal.State;

class TestState extends State
{
	var bf:Sprite;

	public function new()
	{
		super();

		bf = new Sprite().load(Rl.loadTexture("assets/images/BOYFRIEND.png"));
		add(bf);
	}
}
