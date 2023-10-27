package internal;

class Game
{
	public static var width(default, null):Int;
	public static var height(default, null):Int;

	public static var state(default, null):State;
	static var _nextState:Void->State;

	public static function init(width:Int, height:Int, windowTitle:String, FPS:Int, initialState:Void->State)
	{
		Game.width = width;
		Game.height = height;

		Rl.initWindow(width, height, windowTitle);
		Rl.setTargetFPS(60);

		state = initialState();

		while (!Rl.windowShouldClose())
		{
			if (_nextState != null)
			{
				state.destroy();
				state = _nextState();

				_nextState = null;
			}

			state.update(Rl.getFrameTime());

			Rl.beginDrawing();
			Rl.clearBackground(Rl.Colors.BLACK);

			state.draw();

			Rl.endDrawing();
		}

		Rl.closeWindow();
	}

	public static function switchState(state:Void->State)
	{
		_nextState = state;
	}
}
