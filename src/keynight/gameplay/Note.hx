package keynight.gameplay;

import internal.Assets;
import internal.Sprite;

class Note extends Sprite
{
	public var time(default, null):Float;

	public function new(time:Float)
	{
		super();

		this.time = time;

		load(Assets.getTexture("note"));
	}
}
