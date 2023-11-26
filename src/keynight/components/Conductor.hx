package keynight.components;

import internal.Basic;

class Conductor extends Basic {
	public var music(default, null):Rl.Music;
	public var position(get, never):Float;

	public var bpm(default, set):Float;
	public var crotchet(default, null):Float;
	public var currentBeat(default, null):Int = 1;

	var lastBeat:Float = 0;

	public function get_position():Float {
		return Rl.getMusicTimePlayed(music) * 1000;
	}

	public function set_bpm(value:Float):Float {
		crotchet = 60 / bpm;
		return (bpm = value);
	}

	public function new(music:Rl.Music, bpm:Float) {
		super();
		this.music = music;
		this.bpm = bpm;
	}

	public function play() {
		if (!Rl.isMusicStreamPlaying(music)) {
			lastBeat = 0;
			Rl.playMusicStream(music);
		}
	}

	override function update(dt:Float) {
		if (position > lastBeat + crotchet) {
			currentBeat++;
			lastBeat += crotchet;
		}
	}

	override function destroy() {
		Rl.pauseMusicStream(music);
		music = null;

		super.destroy();
	}
}
