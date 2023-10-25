import Rl;

class Main
{
	static function main()
	{
		Rl.initWindow(1280, 720, "KeyNight");

		while (!Rl.windowShouldClose())
		{
			Rl.beginDrawing();
			Rl.clearBackground(Rl.Colors.WHITE);
			Rl.drawText("Congrats! You created your first window!", 190, 200, 20, Rl.Colors.LIGHTGRAY);
			Rl.endDrawing();
		}

		Rl.closeWindow();
	}
}
