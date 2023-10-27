package;

import internal.Game;
import keynight.states.TestState;

final class Main
{
	static function main()
	{
		Game.init(1280, 720, "KeyNight", 60, TestState.new);
	}
}
