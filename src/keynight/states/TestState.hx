package keynight.states;

import sys.io.File;
import internal.Atlas;
import internal.Sprite;
import internal.State;

class TestState extends State
{
	var test:Sprite;

	public function new()
	{
		super();

		test = new Sprite(512, 40);
		test.frames = Atlas.fromSparrow(Rl.loadTexture("assets/images/gfDanceTitle.png"), File.getContent("assets/images/gfDanceTitle.xml"));
		test.addAnimationByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, true);
		test.play('danceLeft');
		add(test);
	}

	override function update(dt:Float) {
		super.update(dt);
		test.angle += 4 * dt;
	}
}
