package keynight.states;

import internal.Game;
import internal.Group;
import internal.Assets;
import internal.Sprite;
import internal.State;

class TestState extends State
{
	static final noteRotations:Array<Int> = [90, 0, 180, -90];

	var receptors:Group<Sprite>;

	public function new()
	{
		super();

		receptors = new Group<Sprite>();
		add(receptors);

		final separation:Int = 140;
		for (i in 0...4)
		{
			var note:Sprite = new Sprite(Game.width / 4 + separation * i + separation / 3, 25).load(Assets.getTexture("receptor"));
			note.angle = noteRotations[i];
			receptors.add(note);
		}
	}
}
