package ui;

import flixel.addons.effects.FlxTrail;
import flixel.animation.FlxAnimation;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;

/**
 * FlxTrail but it uses delta time.
 * @author Rozebud :]
 */
class DeltaTrail extends #if (flixel < "5.7.0") FlxSpriteGroup #else FlxSpriteContainer #end
{
	public var target(default, null):FlxSprite;
	public var xEnabled:Bool = true;
	public var yEnabled:Bool = true;
	public var rotationsEnabled:Bool = true;
	public var scalesEnabled:Bool = true;
	public var framesEnabled:Bool = true;
	var _counter:Int = 0;
	var _trailLength:Int = 0;
	var _graphic:FlxGraphicAsset;
	var _transp:Float = 1;
	var _difference:Float;

	var _recentPositions:Array<FlxPoint> = [];
	var _recentAngles:Array<Float> = [];
	var _recentScales:Array<FlxPoint> = [];
	var _recentFrames:Array<Int> = [];
	var _recentFlipX:Array<Bool> = [];
	var _recentFlipY:Array<Bool> = [];
	var _recentAnimations:Array<FlxAnimation> = [];
	var _spriteOrigin:FlxPoint;
	var _timer:Float = 0;
	var timerMax:Float;
	
	public function new(Target:FlxSprite, ?Graphic:FlxGraphicAsset, Length:Int = 10, Delay:Float = 3 / 60, Alpha:Float = 0.4, Diff:Float = 0.05):Void
	{
			super();

			_spriteOrigin = FlxPoint.get().copyFrom(Target.origin);

			// Sync the vars
			target = Target;
			_graphic = Graphic;
			_transp = Alpha;
			_difference = Diff;

			// Create the initial trailsprites
			increaseLength(Length);
			solid = false;
			timerMax = Delay;
	}

	override public function update(elapsed:Float):Void
	{
		// Count the frames
		_timer += elapsed;

		// Update the trail in case the intervall and there actually is one.
		if (_timer >= timerMax && _trailLength >= 1)
		{
			_timer = 0;

			// Push the current position into the positons array and drop one.
			var spritePosition:FlxPoint = null;
			if (_recentPositions.length == _trailLength)
			{
				spritePosition = _recentPositions.pop();
			}
			else
			{
				spritePosition = FlxPoint.get();
			}

			if (target.exists)
			{
				spritePosition.set(target.x - target.offset.x, target.y - target.offset.y);
				_recentPositions.unshift(spritePosition);
	
				// Also do the same thing for the Sprites angle if rotationsEnabled
				if (rotationsEnabled)
				{
					cacheValue(_recentAngles, target.angle);
				}
	
				// Again the same thing for Sprites scales if scalesEnabled
				if (scalesEnabled)
				{
					var spriteScale:FlxPoint = null; // sprite.scale;
					if (_recentScales.length == _trailLength)
					{
						spriteScale = _recentScales.pop();
					}
					else
					{
						spriteScale = FlxPoint.get();
					}
	
					spriteScale.set(target.scale.x, target.scale.y);
					_recentScales.unshift(spriteScale);
				}
	
				// Again the same thing for Sprites frames if framesEnabled
				if (framesEnabled && _graphic == null)
				{
					cacheValue(_recentFrames, target.animation.frameIndex);
					cacheValue(_recentFlipX, target.flipX);
					cacheValue(_recentFlipY, target.flipY);
					cacheValue(_recentAnimations, target.animation.curAnim);
				}
	
				// Now we need to update the all the Trailsprites' values
				var trailSprite:FlxSprite;
	
				for (i in 0..._recentPositions.length)
				{
					trailSprite = members[i];
					trailSprite.x = _recentPositions[i].x;
					trailSprite.y = _recentPositions[i].y;
	
					// And the angle...
					if (rotationsEnabled)
					{
						trailSprite.angle = _recentAngles[i];
						trailSprite.origin.x = _spriteOrigin.x;
						trailSprite.origin.y = _spriteOrigin.y;
					}
	
					// the scale...
					if (scalesEnabled)
					{
						trailSprite.scale.x = _recentScales[i].x;
						trailSprite.scale.y = _recentScales[i].y;
					}
	
					// and frame...
					if (framesEnabled && _graphic == null)
					{
						trailSprite.animation.frameIndex = _recentFrames[i];
						trailSprite.flipX = _recentFlipX[i];
						trailSprite.flipY = _recentFlipY[i];
	
						trailSprite.animation.curAnim = _recentAnimations[i];
					}
	
					// Is the trailsprite even visible?
					trailSprite.exists = true;
				}
			}
		}
		super.update(elapsed);
	}

	override public function destroy():Void
	{
		FlxDestroyUtil.putArray(_recentPositions);
		FlxDestroyUtil.putArray(_recentScales);

		_recentAngles = null;
		_recentPositions = null;
		_recentScales = null;
		_recentFrames = null;
		_recentFlipX = null;
		_recentFlipY = null;
		_recentAnimations = null;
		_spriteOrigin = null;

		target = null;
		_graphic = null;

		super.destroy();
	}

	function cacheValue<Dynamic>(array:Array<Dynamic>, value:Dynamic)
	{
		array.unshift(value);
		FlxArrayUtil.setLength(array, _trailLength);
	}

	public function resetTrail():Void
	{
		_recentPositions.splice(0, _recentPositions.length);
		_recentAngles.splice(0, _recentAngles.length);
		_recentScales.splice(0, _recentScales.length);
		_recentFrames.splice(0, _recentFrames.length);
		_recentFlipX.splice(0, _recentFlipX.length);
		_recentFlipY.splice(0, _recentFlipY.length);
		_recentAnimations.splice(0, _recentAnimations.length);

		for (i in 0...members.length)
		{
			if (members[i] != null)
			{
				members[i].exists = false;
			}
		}
	}

	public function increaseLength(Amount:Int):Void
	{
		// Can't create less than 1 sprite obviously
		if (Amount <= 0)
		{
			return;
		}

		_trailLength += Amount;

		// Create the trail sprites
		for (i in 0...Amount)
		{
			var trailSprite = new FlxSprite(0, 0);

			if (_graphic == null)
			{
				trailSprite.loadGraphicFromSprite(target);
			}
			else
			{
				trailSprite.loadGraphic(_graphic);
			}
			trailSprite.exists = false;
			trailSprite.active = false;
			add(trailSprite);
			trailSprite.alpha = _transp;
			_transp -= _difference;
			trailSprite.solid = solid;

			if (trailSprite.alpha <= 0)
			{
				trailSprite.kill();
			}
		}
	}

	public function changeGraphic(Image:Dynamic):Void
	{
		_graphic = Image;

		for (i in 0..._trailLength)
		{
			members[i].loadGraphic(Image);
		}
	}
	public function changeValuesEnabled(Angle:Bool, X:Bool = true, Y:Bool = true, Scale:Bool = true):Void
	{
		rotationsEnabled = Angle;
		xEnabled = X;
		yEnabled = Y;
		scalesEnabled = Scale;
	}
}