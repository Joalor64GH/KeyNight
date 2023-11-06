package keynight.states;

import internal.Game;
import internal.Group;
import internal.Assets;
import internal.Sprite;
import internal.State;
import keynight.gameplay.Note;

class PlayState extends State
{
	static final noteRotations:Array<Int> = [90, 0, 180, -90];

	var receptors:Group<Sprite>;
	var notes:Group<Note>;

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

		notes = new Group<Note>();
		add(notes);

		notes.add(new Note(25));
	}

	override function update(dt:Float) {
		super.update(dt);

		
	}
}
