package keynight.gameplay;

import internal.Assets;
import internal.Sprite;

class Note extends Sprite
{
	public var time(default, null):Float;
	public var column(default, null):Int;

	public function new(time:Float, column:Int)
	{
		super();

		this.time = time;
		this.column = column;

		load(Assets.getTexture("note"));
	}
}
