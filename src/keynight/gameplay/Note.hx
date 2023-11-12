package keynight.gameplay;

import internal.Assets;
import internal.Sprite;

class Note extends Sprite
{
	static var holdSprite:Sprite = new Sprite();

	public var time(default, null):Float;
	public var column(default, null):Int;
	public var holdLength:Int = 0;

	public function new(time:Float, column:Int, holdLength:Int = 0)
	{
		super();

		this.time = time;
		this.column = column;
		this.holdLength = holdLength;

		load(Assets.getTexture("note"));
	}

	override function draw()
	{
		if (holdLength > 0)
		{
			holdSprite.load(Assets.getTexture("hold"));

			var startY:Float = height / 2;
			for (i in 0...holdLength)
			{
				if (i == holdLength - 1)
					holdSprite.load(Assets.getTexture("hold-end"));

				holdSprite.x = x + (width - holdSprite.width) / 2;
				holdSprite.y = y + startY;
				startY += holdSprite.height;

				holdSprite.draw();
			}
		}

		super.draw();
	}
}
