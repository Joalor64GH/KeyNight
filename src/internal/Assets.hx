package internal;

import sys.io.File;

final class Assets
{
	public static final assetsPath:String = "./assets";

	public static final textures:TextureCache = new TextureCache();

	static inline function formatPath(id:String)
	{
		return '$assetsPath/$id';
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
