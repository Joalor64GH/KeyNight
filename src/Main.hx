class Main
{
	static function main()
	{
		Rl.initWindow(1280, 720, "KeyNight");
		Rl.setTargetFPS(60);

		var image = Rl.loadTexture("assets/images/cat.jpg");
		var spr = new Sprite().load(image);

		while (!Rl.windowShouldClose())
		{
			Rl.beginDrawing();
			Rl.clearBackground(Rl.Colors.BLACK);

			spr.draw();

			Rl.endDrawing();
		}

		Rl.closeWindow();
	}
}
