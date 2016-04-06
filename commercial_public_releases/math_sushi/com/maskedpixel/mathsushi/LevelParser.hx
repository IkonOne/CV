package com.maskedpixel.mathsushi;

/**
 * ...
 * @author Erin M Gunn
 */

class LevelParser
{
	public var sets(default, null):Array<String>;
	public var levels(default, null):Hash<Array<Xml>>;

	public function new(xml:Xml)
	{
		_xml = xml;
		
		sets = new Array<String>();
		levels = new Hash<Array<Xml>>();
		var set:Xml;
		var level:Xml;
		for (set in _xml.firstElement().iterator())
		{
			if (set.nodeType != Xml.Element) continue;
			sets.push(set.nodeName);
			levels.set(set.nodeName, new Array<Xml>());
			
			for (level in set.iterator())
			{
				if (level.nodeType != Xml.Element) continue;
				levels.get(set.nodeName).push(level);
			}
		}
	}
	
	public function getLevelXml(set:Int, levelNum:Int):Xml
	{
		if (set < 0 || set >= sets.length) throw "Level set does not exist: " + Std.string(set);
		var setName:String = sets[set];
		if (levelNum < 0 || levelNum >= levels.get(setName).length) return null;
		return levels.get(setName)[levelNum];
	}
	
	public function exists(set:Int, levelNum:Int):Bool
	{
		if (set < 0 || set >= sets.length) return false;
		if (levelNum < 0 || levelNum >= levels.get(sets[set]).length) return false;
		return true;
	}
	
	private var _xml:Xml;
}