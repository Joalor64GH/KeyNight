package keynight.states;

import sys.io.File;
import internal.Atlas;
import internal.Sprite;
import internal.State;

class TestState extends State
{
	var bf:Sprite;

	public function new()
	{
		super();

		bf = new Sprite();
		bf.frames = Atlas.fromSparrow(Rl.loadTexture("assets/images/BOYFRIEND.png"), File.getContent("assets/images/BOYFRIEND.xml"));
		add(bf);
	}
}
