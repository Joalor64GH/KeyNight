class Main
{
	static function main()
	{
		Rl.initWindow(1280, 720, "KeyNight");
		Rl.setTargetFPS(60);

		var image = Rl.loadTexture("assets/images/cat.jpg");
		var point = Point.get();

		while (!Rl.windowShouldClose())
		{
			Rl.beginDrawing();
			Rl.clearBackground(Rl.Colors.BLACK);

			Rl.drawTexture(image, Math.floor(1280 / 2 - image.width / 2), Math.floor(720 / 2 - image.height / 2), Rl.Colors.WHITE);
			Rl.drawText(point.x + " " + point.y, 800, 500, 20, Rl.Colors.WHITE);

			Rl.endDrawing();
		}

		Rl.closeWindow();
	}
}
