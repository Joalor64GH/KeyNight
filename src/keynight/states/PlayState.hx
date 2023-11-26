package keynight.states;

import internal.Game;
import internal.Group;
import internal.Assets;
import internal.Sprite;
import internal.State;
import keynight.components.Conductor;
import keynight.gameplay.Note;

class PlayState extends State {
	static final noteRotations:Array<Int> = [90, 0, 180, -90];

	var conductor:Conductor;

	var receptors:Group<Sprite>;
	var notes:Group<Note>;

	public function new() {
		super();

		conductor = new Conductor(Assets.getMusic("testSong"), 150);

		final bg = new Sprite().load(Assets.getTexture("bg"));
		bg.alpha = 0.3;
		add(bg);

		receptors = new Group<Sprite>();
		add(receptors);

		final separation = 140;
		for (i in 0...4) {
			final receptor = new Sprite(Game.width / 4 + separation * i + separation / 3, 25).load(Assets.getTexture("receptor"));
			receptor.angle = noteRotations[i];
			receptors.add(receptor);
		}

		// cache hold textures
		Assets.getTexture("hold");
		Assets.getTexture("hold-end");

		notes = new Group<Note>();
		add(notes);

		notes.add(new Note(400, 0, 3));
		notes.add(new Note(435, 1, 3));
		notes.add(new Note(470, 2, 3));
		notes.add(new Note(500, 3, 3));

		conductor.play();
	}

	override function update(dt:Float) {
		super.update(dt);

		final time = conductor.position;
		for (note in notes.members) {
			if (note.alive) {
				final receptor = receptors.members[note.column];
				note.x = receptor.x;
				note.y = receptor.y - (time - note.time);
				note.angle = noteRotations[note.column];
			}
		}
	}
}
