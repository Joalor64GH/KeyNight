package;

import internal.Game;
import keynight.states.PlayState;

final class Main
{
	static function main()
	{
		Game.init(1280, 720, "KeyNight", 60, PlayState.new);
	}
}
