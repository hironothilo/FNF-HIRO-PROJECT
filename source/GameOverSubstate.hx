package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.util.FlxStringUtil;
import flixel.group.FlxGroup.FlxTypedGroup;
import flash.system.System;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var timebarGameOver:FlxBar;

	var stopplz:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	var restartbutton:FlxSprite;
	var timebarprogress:Float = 0;
	var icon:HealthIcon;

	var timeelapsed:Int = 0;
	var fulltime:Float = 0;
	var curSelected = 0;
	var timeTxt:FlxText;
	var hitbox:FlxSprite;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuItemsOG:Array<String> = ['Retry', 'Exit to menu', 'Quit Game'];

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		timeelapsed = PlayState.instance.timefloat;
		fulltime = Math.floor(PlayState.instance.songLength / 1000);

		timeTxt = new FlxText(0, FlxG.height * 0.75, 400, "", 40);
		timeTxt.screenCenter(X);
		timeTxt.cameras = [PlayState.instance.camgameover];
		timeTxt.setFormat(Paths.font("phantommuff.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.text = '${FlxStringUtil.formatTime(timeelapsed, false)} / ${FlxStringUtil.formatTime(fulltime, false)}';
		add(timeTxt);

		restartbutton = new FlxSprite().loadGraphic(Paths.image('restart'));
		restartbutton.frames = Paths.getSparrowAtlas('restart');
		restartbutton.scale.set(0.5, 0.5);
		restartbutton.screenCenter(X);
		restartbutton.cameras = [PlayState.instance.camgameover];
		restartbutton.y = -75;
		restartbutton.scrollFactor.set();
		restartbutton.animation.addByPrefix('bumping', 'restart?', 24, false);
		if (!isEnding) restartbutton.animation.play('bumping');
		add(restartbutton);

		boyfriend = new Boyfriend(x, y, characterName);
		boyfriend.x += 60;
		boyfriend.y += 320;
		if(characterName == 'hiro-dead') boyfriend.y -= 80;
		if(characterName == 'peak-dead') {
			boyfriend.y -= 380;
			boyfriend.x -= 270;
		}
		add(boyfriend);

		timebarGameOver = new FlxBar(0, 0, LEFT_TO_RIGHT, Math.round(FlxG.width / 2), 15, this,
			'timebarprogress', 0, 1);
		timebarGameOver.scrollFactor.set();
		timebarGameOver.createFilledBar(0xFF000000, FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
		timebarGameOver.numDivisions = 2000; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timebarGameOver.alpha = 0;
		timebarGameOver.cameras = [PlayState.instance.camgameover];
		timebarGameOver.x = FlxG.width / 2 - timebarGameOver.width / 2;
		timebarGameOver.y = FlxG.height * 0.85;
		add(timebarGameOver);

		hitbox = new FlxSprite().loadGraphic(Paths.image('boxgameover'));
		hitbox.scale.set(0.4, 0.5);
		hitbox.x = FlxG.width * 0.45;
		hitbox.screenCenter(Y);
		hitbox.cameras = [PlayState.instance.camgameover];
		hitbox.scrollFactor.set();
		hitbox.alpha = 0;
		add(hitbox);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...menuItemsOG.length)
		{
			var menuTxt = new FlxText(0, 0, 1080, "", 16);
			menuTxt.cameras = [PlayState.instance.camgameover];
			menuTxt.setFormat(Paths.font("phantommuff.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			menuTxt.scrollFactor.set();
			menuTxt.text = menuItemsOG[i];
			menuTxt.x = FlxG.width * 0.45 + (hitbox.width - menuTxt.width) / 2 - (i * 25) + 20;
			menuTxt.y = hitbox.height / 2 + ((hitbox.height / 8) * i) - 30;
			menuTxt.alpha = 0;
			menuTxt.ID = i;
			menuItems.add(menuTxt);
			FlxTween.tween(menuTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut, startDelay: 0.5});
		}

		icon = new HealthIcon(boyfriend.healthIcon, false);
		icon.y = timebarGameOver.y - 70;
		icon.cameras = [PlayState.instance.camgameover];
		icon.x = timebarGameOver.x / 2 + icon.width / 2;
		icon.alpha = 0;
		add(icon);

		camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		FlxG.sound.play(Paths.sound(deathSoundName));
		Conductor.changeBPM(100);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
		FlxTween.tween(timebarGameOver, {alpha: 1}, 0.5, {ease: FlxEase.circOut, startDelay: 0.5});
		FlxTween.tween(icon, {alpha: 1}, 0.5, {ease: FlxEase.circOut, startDelay: 0.5});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut, startDelay: 0.5});
		FlxTween.tween(hitbox, {alpha: 1}, 0.5, {ease: FlxEase.circOut, startDelay: 0.5});
		changeItem();
	}

	var isFollowingAlready:Bool = false;
	var numtween:FlxTween;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var mult:Float = FlxMath.lerp(1, icon.scale.x, CoolUtil.boundTo(1 - (elapsed * 7), 0, 1));
		numtween = FlxTween.tween(this, {timebarprogress: PlayState.instance.songPercent}, 2, {ease:FlxEase.sineOut, startDelay: 1});
		//icon.x = timebarGameOver.x + (timebarGameOver.width * (FlxMath.remapToRange(timebarGameOver.percent, 0, 100, 100, 0) * 0.01) - (icon.width - 20));
		icon.scale.set(mult, mult);
		FlxTween.tween(icon, {x: (timebarGameOver.x + PlayState.instance.songPercent * timebarGameOver.width - icon.width / 2)}, 1.25, {startDelay: 0.75});

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (controls.UI_UP_P && !stopplz)
		{
			changeItem(-1);
		}
		if (controls.UI_DOWN_P && !stopplz)
		{
			changeItem(1);
		}

		if (controls.ACCEPT && !stopplz){
			var daChoice:String = menuItemsOG[curSelected];
			stopplz = true;
			switch (daChoice)
			{
				case 'Retry':
					endBullshit();
				case 'Exit to menu':
					FlxG.sound.music.stop();
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					WeekData.loadTheFirstEnabledMod();
					if (PlayState.isStoryMode)
						MusicBeatState.switchState(new StoryMenuState());
					else
						MusicBeatState.switchState(new FreeplayState());

					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
				case 'Quit Game':
					PlayState.instance.camgameover.fade(FlxColor.BLACK, 2);
					FlxG.sound.music.fadeOut(1.5, 0);
					new FlxTimer().start(2, function(tmr:FlxTimer){
						System.exit(0);
					});
			}
		}

		if (boyfriend.animation.curAnim.name == 'firstDeath')
		{
			if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
				isFollowingAlready = true;
			}

			if (boyfriend.animation.curAnim.finished && !playingDeathSound)
			{
				if (PlayState.SONG.stage == 'tank')
				{
					playingDeathSound = true;
					coolStartDeath(0.2);
					
					var exclude:Array<Int> = [];
					//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

					FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
						if(!isEnding)
						{
							FlxG.sound.music.fadeIn(0.2, 1, 4);
						}
					});
				}
				else
				{
					coolStartDeath();
				}
				boyfriend.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();
		if (!isEnding) {
			restartbutton.animation.play('bumping');
			icon.scale.set(1.3, 1.3);
		}

		//FlxG.log.add('beat');
	}

	function changeItem(huh:Int = 0)
		{
			curSelected += huh;
	
			if (curSelected >= menuItemsOG.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItemsOG.length - 1;
	
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.scale.set(0.95, 0.95);
				spr.color = 0x00FFFFFF;
				if (spr.ID == curSelected){
					spr.scale.set(1, 1);
					spr.color = 0x0033FF00;
				}
			});
		}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			remove(restartbutton);
			restartbutton = new FlxSprite().loadGraphic(Paths.image('Click-restart'));
			restartbutton.frames = Paths.getSparrowAtlas('Click-restart');
			restartbutton.scale.set(0.5, 0.5);
			restartbutton.screenCenter(X);
			restartbutton.cameras = [PlayState.instance.camgameover];
			restartbutton.y = -50;
			restartbutton.scrollFactor.set();
			restartbutton.animation.addByPrefix('finish', 'restart click', 24, false);
			add(restartbutton);
			restartbutton.animation.play('finish');
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			PlayState.instance.camgameover.fade(FlxColor.BLACK, 2);
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}
