import states.TestState;

class Main
{
	static function main()
	{
		Game.init(1280, 720, "KeyNight", 60, TestState.new);
	}
}
