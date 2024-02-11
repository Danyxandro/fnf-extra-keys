package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var char:String;
	public var isCustom:Bool = false;
	public var changeSize:Bool = true;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.char = char;
		//loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		/*animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('keen', [26, 27], 0, false, isPlayer);
		animation.add('bf-keen', [26, 27], 0, false, isPlayer);
		animation.add('keen-flying', [26, 27], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
		}*/

		switch(char){
			case 'daidem':
				var tex = Paths.getSparrowAtlas('daidem/IconAssets', 'shared');
				frames = tex;
				antialiasing = true;
				animation.addByPrefix('daidem', 'DaidemNormal0', 24, true, isPlayer);
				animation.addByPrefix('daidem-lose', 'DaidemLoosing0', 24, true, isPlayer);
				animation.addByPrefix('daidem-win', 'Daidem Winning', 24, true, isPlayer);
				changeSize = false;
				offset.y += 35;
				isCustom = true;
				animation.play("daidem");
			default:
				changeIcon(char, isPlayer);
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function changeIcon(char:String, isPlayer:Bool){
		if(sys.FileSystem.exists("assets/shared/images/characters/" + char + "/icon.png")){
			trace("agregado: " + char);
			var bitmap:openfl.display.BitmapData = openfl.display.BitmapData.fromFile("assets/shared/images/characters/" + char + "/icon.png");
			loadGraphic(bitmap, true, 150, Math.floor(height));
			animation.add(char, [0], 0, false, isPlayer);
			if(bitmap.width >= 450)
				animation.add(char + "-win", [2], 0, false, isPlayer);
			else
				animation.add(char + "-win", [0], 0, false, isPlayer);
			animation.add(char + "-lose", [1], 0, false, isPlayer);
			antialiasing = false;
			isCustom = true;
			animation.play(char);
		}else{
			loadGraphic(Paths.image('iconGrid'), true, 150, 150);

			antialiasing = true;
			animation.add(char, [10], 0, false, isPlayer);
			animation.add(char+'-win', [10], 0, false, isPlayer);
			animation.add(char+'-lose', [11], 0, false, isPlayer);
			//This is too tedious too
			animation.add('bf', [0], 0, false, isPlayer);
			animation.add('bf-win', [0], 0, false, isPlayer);
			animation.add('bf-lose', [1], 0, false, isPlayer);
			animation.add('bf-car', [0], 0, false, isPlayer);
			animation.add('bf-car-win', [0], 0, false, isPlayer);
			animation.add('bf-car-lose', [1], 0, false, isPlayer);
			animation.add('bf-christmas', [0], 0, false, isPlayer);
			animation.add('bf-christmas-win', [0], 0, false, isPlayer);
			animation.add('bf-christmas-lose', [1], 0, false, isPlayer);
			animation.add('bf-pixel', [21], 0, false, isPlayer);
			animation.add('bf-pixel-win', [21], 0, false, isPlayer);
			animation.add('bf-pixel-lose', [21], 0, false, isPlayer);
			animation.add('spooky', [2], 0, false, isPlayer);
			animation.add('spooky-win', [2], 0, false, isPlayer);
			animation.add('spooky-lose', [3], 0, false, isPlayer);
			animation.add('pico', [4], 0, false, isPlayer);
			animation.add('pico-win', [4], 0, false, isPlayer);
			animation.add('pico-lose', [5], 0, false, isPlayer);
			animation.add('mom', [6], 0, false, isPlayer);
			animation.add('mom-win', [6], 0, false, isPlayer);
			animation.add('mom-lose', [7], 0, false, isPlayer);
			animation.add('mom-car', [6], 0, false, isPlayer);
			animation.add('mom-car-win', [6], 0, false, isPlayer);
			animation.add('mom-car-lose', [7], 0, false, isPlayer);
			animation.add('tankman', [8], 0, false, isPlayer);
			animation.add('tankman-win', [8], 0, false, isPlayer);
			animation.add('tankman-lose', [9], 0, false, isPlayer);
			animation.add('face', [10], 0, false, isPlayer);
			animation.add('face-win', [10], 0, false, isPlayer);
			animation.add('face-lose', [11], 0, false, isPlayer);
			animation.add('dad', [12], 0, false, isPlayer);
			animation.add('dad-win', [12], 0, false, isPlayer);
			animation.add('dad-lose', [13], 0, false, isPlayer);
			animation.add('senpai', [22, 22], 0, false, isPlayer);
			animation.add('senpai-win', [22, 22], 0, false, isPlayer);
			animation.add('senpai-lose', [22, 22], 0, false, isPlayer);
			animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
			animation.add('senpai-angry-win', [22, 22], 0, false, isPlayer);
			animation.add('senpai-angry-lose', [22, 22], 0, false, isPlayer);
			animation.add('spirit', [23, 23], 0, false, isPlayer);
			animation.add('spirit-win', [23, 23], 0, false, isPlayer);
			animation.add('spirit-lose', [23, 23], 0, false, isPlayer);
			animation.add('bf-old', [14], 0, false, isPlayer);
			animation.add('bf-old-win', [14], 0, false, isPlayer);
			animation.add('bf-old-lose', [15], 0, false, isPlayer);
			animation.add('gf', [16], 0, false, isPlayer);
			animation.add('gf-win', [16], 0, false, isPlayer);
			animation.add('gf-lose', [16], 0, false, isPlayer);
			animation.add('gf-christmas', [16], 0, false, isPlayer);
			animation.add('gf-christmas-win', [16], 0, false, isPlayer);
			animation.add('gf-christmas-lose', [16], 0, false, isPlayer);
			animation.add('gf-pixel', [16], 0, false, isPlayer);
			animation.add('gf-pixel-win', [16], 0, false, isPlayer);
			animation.add('gf-pixel-lose', [16], 0, false, isPlayer);
			animation.add('parents-christmas', [17], 0, false, isPlayer);
			animation.add('parents-christmas-win', [17], 0, false, isPlayer);
			animation.add('parents-christmas-lose', [18], 0, false, isPlayer);
			animation.add('monster', [19], 0, false, isPlayer);
			animation.add('monster-win', [19], 0, false, isPlayer);
			animation.add('monster-lose', [20], 0, false, isPlayer);
			animation.add('monster-christmas', [19], 0, false, isPlayer);
			animation.add('monster-christmas-win', [19], 0, false, isPlayer);
			animation.add('monster-christmas-lose', [20], 0, false, isPlayer);
			animation.add('keen', [26], 0, false, isPlayer);
			animation.add('keen-win', [101], 0, false, isPlayer);
			animation.add('keen-lose', [27], 0, false, isPlayer);
			animation.add('bf-keen', [26], 0, false, isPlayer);
			animation.add('bf-keen-win', [101], 0, false, isPlayer);
			animation.add('bf-keen-lose', [27], 0, false, isPlayer);
			animation.add('keen-flying', [26], 0, false, isPlayer);
			animation.add('keen-flying-win', [101], 0, false, isPlayer);
			animation.add('keen-flying-lose', [27], 0, false, isPlayer);
			var mapping:Map<String,Array<Int>> = new Map<String,Array<Int>>();
			mapping.set('bf-tankman-pixel', [8, 9]);
			mapping.set('beat', [24, 25]);
			mapping.set('beat-neon', [24, 25]);
			mapping.set('bf-neon', [0, 1]);
			mapping.set('bf-cat', [0, 1]);
			mapping.set('bf-holding-gf', [0, 1]);
			mapping.set("crazy-GF", [16]);
			mapping.set('OJ', [28, 29]);
			mapping.set('whitty', [30, 31]);
			mapping.set('hex', [32, 33]);
			mapping.set('sarv', [34, 35]);
			mapping.set('ruv', [36, 37]);
			mapping.set('impostor', [38, 39]);
			mapping.set('agoti', [40, 41]);
			mapping.set('kapi', [42, 43]);
			mapping.set('sky', [44, 45]);
			mapping.set('sky-annoyed', [44, 45]);
			mapping.set('annie', [46, 47]);
			mapping.set('monika', [48, 49]);
			mapping.set('bob', [50, 51]);
			mapping.set('tabi', [52, 53]);
			mapping.set('garcello', [54, 55]);
			mapping.set('bluskys', [56, 57]);
			mapping.set('tricky', [58, 59]);
			mapping.set('impostor-black', [60, 61]);
			mapping.set('majin-sonic', [62, 63]);
			mapping.set('henry', [64, 65]);
			mapping.set('sarvente-lucifer', [66, 67]);
			mapping.set('selever', [68, 69]);
			mapping.set('ron', [70, 71]);
			mapping.set('eder-jr', [10, 11]);
			//mapping.set('daidem', [72, 73]);
			mapping.set('retrospecter', [74, 75]);
			mapping.set('sans', [76, 77]);
			mapping.set('speakers', [88, 89]);
			mapping.set('myra', [78, 79]);
			mapping.set('salad-fingers', [80, 81]);
			mapping.set('void', [82, 83]);
			mapping.set('cassette-girl', [84, 85]);
			mapping.set('sunday', [10, 11]);
			mapping.set('hank', [86, 87]);
			mapping.set('ex-tricky', [88, 89]);
			mapping.set('cassandra', [90, 91]);
			mapping.set('sky-mad', [92, 92]);
			mapping.set('mami', [93, 94]);
			mapping.set('tord', [95, 96]);
			mapping.set('nene', [97, 98]);
			mapping.set('kopek', [100, 99]);
			mapping.set('pico-minus', [4]);
			for(key in mapping.keys()){
				animation.add(key, [mapping.get(key)[0]], 0, false, isPlayer);
				animation.add(key + '-win', [mapping.get(key)[0]], 0, false, isPlayer);
				animation.add(key + '-lose', [mapping.get(key)[0]], 0, false, isPlayer);
				if(mapping.get(key).length > 1)
					animation.add(key + '-lose', [mapping.get(key)[1]], 0, false, isPlayer);
				if(mapping.get(key).length > 2)
					animation.add(key + '-win', [mapping.get(key)[2]], 0, false, isPlayer);
			}
			animation.play(char);

			switch(char)
			{
				case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel' | 'bf-tankman-pixel':
					antialiasing = false;
			}
		}
	}//Fin del changeIcon
}//Fin de la clase
