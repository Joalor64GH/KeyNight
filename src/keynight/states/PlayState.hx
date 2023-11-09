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

	var music:Rl.Music;

	var receptors:Group<Sprite>;
	var notes:Group<Note>;

	public function new()
	{
		super();

		music = Assets.getMusic("testSong");

		receptors = new Group<Sprite>();
		add(receptors);

		final separation:Int = 140;
		for (i in 0...4)
		{
			var receptor:Sprite = new Sprite(Game.width / 4 + separation * i + separation / 3, 25).load(Assets.getTexture("receptor"));
			receptor.angle = noteRotations[i];
			receptors.add(receptor);
		}

		notes = new Group<Note>();
		add(notes);

		notes.add(new Note(12800.0, 0));
		notes.add(new Note(13199.999, 1));
		notes.add(new Note(13599.999, 2));
		notes.add(new Note(13999.999, 3));

		Rl.playMusicStream(music);
	}

	override function update(dt:Float)
	{
		super.update(dt);

		for (note in notes.members)
		{
			if (note.alive)
			{
				note.x = receptors.members[note.column].x;
				note.y = 25 - ((Rl.getMusicTimePlayed(music) * 1000) - note.time);
				note.angle = noteRotations[note.column];
			}
		}
	}
}
