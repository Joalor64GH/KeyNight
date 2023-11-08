package internal;

import sys.io.File;

final class Assets
{
	public static final assetsPath:String = "./assets";

	public static final music:MusicCache = new MusicCache();
	public static final sounds:SoundCache = new SoundCache();
	public static final textures:TextureCache = new TextureCache();

	public static inline function formatPath(id:String)
	{
		return '$assetsPath/$id';
	}

	public static function getMusic(id:String):Null<Rl.Music>
	{
		return music.get(formatPath('music/$id.ogg'));
	}

	public static function getSound(id:String):Null<Rl.Sound>
	{
		return sounds.get(formatPath('sounds/$id.ogg'));
	}

	public static function getTexture(id:String):Null<Rl.Texture2D>
	{
		return textures.get(formatPath('images/$id.png'));
	}

	// not cached because it's useless
	public static function getText(id:String):Null<String>
	{
		try
		{
			return File.getContent(formatPath(id));
		}
		catch (_)
		{
			return null;
		}
	}

	public static function clear()
	{
		textures.clear();
	}
}

class MusicCache extends AssetCache<Rl.Music>
{
	override function _loadAsset(id:String):Rl.Music
	{
		return Rl.loadMusicStream(id);
	}

	override function _unloadAsset(asset:Rl.Music)
	{
		Rl.unloadMusicStream(asset);
	}
}

class SoundCache extends AssetCache<Rl.Sound>
{
	override function _loadAsset(id:String):Rl.Sound
	{
		return Rl.loadSound(id);
	}

	override function _unloadAsset(asset:Rl.Sound)
	{
		Rl.unloadSound(asset);
	}
}

class TextureCache extends AssetCache<Rl.Texture2D>
{
	override function _loadAsset(id:String):Rl.Texture2D
	{
		return Rl.loadTexture(id);
	}

	override function _unloadAsset(asset:Rl.Texture2D)
	{
		Rl.unloadTexture(asset);
	}
}

class AssetCache<T>
{
	var _map:Map<String, T> = [];

	public function new() {}

	public function get(id:String):Null<T>
	{
		return _map.get(id) ?? cache(id);
	}

	public function clear()
	{
		for (key => asset in _map)
		{
			_unloadAsset(asset);
			_map.remove(key);
		}
	}

	public function cache(id:String, ?toCache:T):Null<T>
	{
		var asset:T = _map.get(id);
		if (asset != null)
			_unloadAsset(asset);

		asset = toCache ?? _loadAsset(id);
		_map.set(id, asset);

		return asset;
	}

	function _loadAsset(id:String):T
	{
		throw haxe.exceptions.NotImplementedException;
	}

	function _unloadAsset(asset:T) {}
}
