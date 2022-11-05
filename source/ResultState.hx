package;

import flixel.group.FlxGroup;
import Discord.DiscordClient;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;
import flixel.system.FlxSound;

//"Static access to instance field (varible) is not allowed" mean you stupid go read kade version lol

using StringTools;

class ResultState extends MusicBeatState
{
    var accuracynumbertest:Int = 0;
    var scorenum:Int = 0;
    var missesnum:Int = 0;
    var topcombonum:Int = 0;
    var rank:String = "F";
    var anotherrank:String = "G";
    var FC:String = "";
    var accuracytxt:FlxText;
    var epicnum:Int = 0;
    var sicknum:Int = 0;
    var goodnum:Int = 0;
    var badnum:Int = 0;
    var shitnum:Int = 0;
    var numscoregroup:FlxGroup = new FlxGroup();

    var rankingpicturre:FlxSprite;

    var backtoomenu:Bool = false;
    var ratingfinish:Bool = false;

    var countnum:Int = 0;

    var numtween:FlxTween;
    var transGradient:FlxSprite;
    var anothertransGradient:FlxSprite;
    var transBlack:FlxSprite;
    var anothertransBlack:FlxSprite;
    var bg1:FlxSprite;
    var bg2:FlxSprite;

    var flash:FlxSprite;
    var whitetransGradient:FlxSprite;

    var pitchshit:Array<Float> = [0.7, 0.8, 0.85, 0.9, 0.95, 1, 1.05, 1.1, 1.15];

    public static var ratingStuff:Array<Dynamic> = [
		['F', 0.50], //From 0.01% to 9% SHIT PART
		['E', 0.60], //From 50% to 59% BAD PART
		['D', 0.70], //From 60% to 68%
		['C', 0.80], //69% to 69.99% GOOD PART
		['B', 0.85], //From 70% to 75%
		['A-', 0.90], //From 76% to 80% SICK PART
		['A', 0.93], //From 80% to 85%
		['A+', 0.9650], //From 86% to 89%
        ['S-', 0.99], //From 90% to 92% SICK GOLD
        ['S', 0.9950], //From 93% to 94%
        ['S+', 0.9970], //From 95% to 96%
        ['SS-', 0.9980], //From 97% to 98%
        ['SS', 0.9990], //From 99%-99.49%
        ['SS+', 0.99950], //From 99.5%-99.89%
        ['X-', 0.99980], //From 99.9%-99.94% EPIC PART
		['X', 1],//From 99.95%-99.9935% //lol sorry apro
		['PERFECT', 1] //The value on this one isn't used actually, since Perfect is always "1" EPIC GOLD
	];

    override function create()
    {
        bg1 = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg1.x = 0;
        bg1.updateHitbox();
        add(bg1);

        bg2 = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg2.x = bg1.width;
        bg2.updateHitbox();
        add(bg2);

        flash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        flash.alpha = 0;
		add(flash);

        transGradient = FlxGradient.createGradientFlxSprite(FlxG.width, Math.floor(FlxG.height / 2), [FlxColor.BLACK, 0x0]);
        transGradient.y += 100;
		transGradient.scrollFactor.set();
		add(transGradient);

        anothertransGradient = FlxGradient.createGradientFlxSprite(FlxG.width, Math.floor(FlxG.height / 2), [0x0, FlxColor.BLACK]);
        anothertransGradient.y += FlxG.height / 2 - 100;
		anothertransGradient.scrollFactor.set();
		add(anothertransGradient);

        transBlack = new FlxSprite().makeGraphic(FlxG.width, 100, FlxColor.BLACK);
		transBlack.scrollFactor.set();
        transBlack.y = Math.floor(transGradient.y - 100);
		add(transBlack);

        anothertransBlack = new FlxSprite().makeGraphic(FlxG.width, 100, FlxColor.BLACK);
		anothertransBlack.scrollFactor.set();
        anothertransBlack.y = FlxG.height - 100;
		add(anothertransBlack);

        whitetransGradient = FlxGradient.createGradientFlxSprite(Math.floor(FlxG.height / 12), Math.floor(FlxG.width), [FlxColor.WHITE, 0x0]);
		whitetransGradient.angle = 90;
        whitetransGradient.screenCenter(Y);
        whitetransGradient.x = 200;
        whitetransGradient.alpha = 0;
        add(whitetransGradient);

        FC = PlayState.instance.ratingFC;

        DiscordClient.changePresence("Result Screen", null);

        accuracytxt = new FlxText(12, 12, 0, "", 6);
        accuracytxt.scrollFactor.set();
		accuracytxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(accuracytxt);
        
        super.create();

        var expwant:Int = 0;
        expwant = Math.round((PlayState.instance.songScore / 2500) + (PlayState.instance.resultaccuracy / 4) + (PlayState.instance.funkyround * 5));
        trace(expwant);

        if(!backtoomenu) numtween = FlxTween.tween(this, {accuracynumbertest: PlayState.instance.resultaccuracy * 100}, Math.floor(PlayState.instance.resultaccuracy / 10), {ease:FlxEase.sineOut});
    }

    override function update(elapsed:Float)
    {
        var accuracynumbertruenow:Float = accuracynumbertest / 100;
        updateaccuracy(accuracynumbertruenow);

        if(bg1.x == 0){
            bg2.x = 1280;
            FlxTween.tween(bg1, {x: -1280}, 16);
            FlxTween.tween(bg2, {x: 0}, 16);
        }
        if(bg2.x == 0){
            bg1.x = 1280;
            FlxTween.tween(bg2, {x: -1280}, 16);
            FlxTween.tween(bg1, {x: 0}, 16);
        }
        //idk how FlxBackdrop is bug :(

        scorenum = PlayState.instance.songScore;
        missesnum = PlayState.instance.songMisses;
        topcombonum =PlayState.instance.highestCombo;
        epicnum = PlayState.instance.epics;
        sicknum = PlayState.instance.sicks;
        goodnum = PlayState.instance.goods;
        badnum = PlayState.instance.bads;
        shitnum = PlayState.instance.shits;

        if(accuracynumbertest / 10000 >= 1)
        {
            rank = ratingStuff[ratingStuff.length-1][0]; //Uses last string
        }
        else
        {
            for (i in 0...ratingStuff.length-1)
            {
                if(accuracynumbertest / 10000 < ratingStuff[i][1])
                {
                    rank = ratingStuff[i][0];
                    break;
                }
            }
        }

        /*accuracytxt.text = 'accuracy = ${accuracynumbertest/100} %
        \nscore = ${score}
        \nmisses = ${misses}
        \nhighestCombo = ${topcombo}
        \nRanking = ${rank} [${FC}]
        \nepic = ${epicnum}                         sick = ${sicknum}
        \ngood = ${goodnum}                         bad = ${badnum}
        \nshit = ${shitnum}
        ';*/

        var accepted = controls.ACCEPT && backtoomenu;
        if(controls.ACCEPT)
        {
            numtween.cancel();
            rank = PlayState.instance.ratingName;
            switch(rank){
                case 'F':
                   ratingstring = 'shit';
                case 'E' | 'D' :
                    ratingstring = 'bad';
                case 'C' | 'B':
                    ratingstring = 'good';
                case 'A-' | 'A' | 'A+':
                    ratingstring = 'sick';
                case 'S-' | 'S' | 'S+' | 'SS-' | 'SS' | 'SS+':
                    ratingstring = 'sick-gold';
                case 'X-' | 'X':
                    ratingstring = 'epic';
                case 'PERFECT':
                    ratingstring = 'epic-gold';
            }
            accuracynumbertest = Math.floor(PlayState.instance.resultaccuracy * 100);
        }

        if(accepted)
        {
            if(PlayState.isStoryMode){
                if(PlayState.storyPlaylist.length <= 0){
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    MusicBeatState.switchState(new StoryMenuState());
                }
                else {
                    var difficulty:String = CoolUtil.getDifficultyFilePath();

                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);

				    PlayState.cancelMusicFadeTween();
				    LoadingState.loadAndSwitchState(new PlayState());
                }
            }
            else {
                FlxG.sound.play(Paths.sound('confirmMenu'));
                MusicBeatState.switchState(new FreeplayState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }
        }
    }

	public var vocals:FlxSound;
    var numcountpitch:Int = -1;
    var byebyenumshit:Bool = true;
    var accuracyarray:Array<String> = [];
    var accuracyarraytwo:Array<String> = [];
    var ratingstring:String = '';

    function updateaccuracy(accuracy:Float)
    {
        var placement:String = Std.string(accuracy);

        var coolText:FlxText = new FlxText(0,0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;

        accuracyarray = [];
        accuracyarraytwo = Std.string(Math.floor(accuracynumbertest / 100)).split("");

        var numshitwtfbro:Int = Math.floor(accuracy * 100);
        if(numshitwtfbro >= 10000) accuracyarray.push(Std.string(Math.floor(numshitwtfbro / 10000) % 10));
        if(numshitwtfbro >= 1000) accuracyarray.push(Std.string(Math.floor(numshitwtfbro / 1000) % 10));
        if(numshitwtfbro >= 100) accuracyarray.push(Std.string(Math.floor(numshitwtfbro / 100) % 10));
        if(numshitwtfbro >= 10) {
            accuracyarray.push('.');
            accuracyarray.push(Std.string(Math.floor(numshitwtfbro / 10) % 10));
        }
        if(numshitwtfbro >= 0) accuracyarray.push(Std.string(Math.floor(numshitwtfbro / 1) % 10));

        var loopshit:Float = 0;
        var numScore:FlxSprite;
        
        numscoregroup.destroy();
		numscoregroup = new FlxGroup();
		add(numscoregroup);

        if(anotherrank != rank){
            if(rank == 'F' || rank == 'E' || rank == 'D'){
                bg1.color = 0x00FF33CC;
                bg2.color = 0x00FF33CC;
            }
            if(rank == 'C' || rank == 'B'){
                if(rank == 'C'){
                    flash.alpha = 1;
                    FlxTween.tween(flash, {alpha: 0}, 0.4);
                }
                bg1.color = 0x006666FF;
                bg2.color = 0x006666FF;
            }
            if(rank == 'A-' || rank == 'A' || rank == 'A+'){
                if(rank == 'A-'){
                    flash.alpha = 1;
                    FlxTween.tween(flash, {alpha: 0}, 0.4);
                }
                bg1.color = 0x00FF66CC;
                bg2.color = 0x00FF66CC;
            }
            if(rank == 'S-' || rank == 'S' || rank == 'S+'){
                if(rank == 'S-'){
                    flash.alpha = 1;
                    FlxTween.tween(flash, {alpha: 0}, 0.4);
                }
                bg1.color = 0x0066CC99;
                bg2.color = 0x0066CC99;
            }
            if(rank == 'SS-' || rank == 'SS' || rank == 'SS+'){
                if(rank == 'SS-'){
                    flash.alpha = 1;
                    FlxTween.tween(flash, {alpha: 0}, 0.4);
                }
                bg1.color = 0x0066FFCC;
                bg2.color = 0x0066FFCC;
            }
            if(rank == 'X-' || rank == 'X'){
                if(rank == 'X-'){
                    flash.alpha = 1;
                    FlxTween.tween(flash, {alpha: 0}, 0.4);
                }
                bg1.color = 0x00CC33CC;
                bg2.color = 0x00CC33CC;
            }
            if(rank == 'PERFECT'){
                flash.alpha = 1;
                FlxTween.tween(flash, {alpha: 0}, 0.4);
                bg1.color = 0x003333FF;
                bg2.color = 0x003333FF;
            }
            if(rank == 'E') numcountpitch = 0;
            if(rank == 'D') numcountpitch = 1;
            if(rank == 'C') numcountpitch = 2;
            if(rank == 'B') numcountpitch = 3;
            if(rank == 'A-') numcountpitch = 4;
            if(rank == 'S-') numcountpitch = 5;
            if(rank == 'SS-') numcountpitch = 6;
            if(rank == 'X-') numcountpitch = 7;
            if(rank == 'PERFECT') numcountpitch = 8;

            vocals = new FlxSound().loadEmbedded(Paths.sound('confirmMenu'));
            FlxG.sound.list.add(vocals);
            if(numcountpitch >= 0){
                vocals.pitch = pitchshit[numcountpitch];
                switch (rank){
                    case 'E' | 'D' | 'C' | 'B' | 'A-' | 'S-' | 'SS-' | 'X-' | 'PERFECT' :
                        vocals.play();
                }
            }
            remove(rankingpicturre);

            rankingpicturre = new FlxSprite().loadGraphic(Paths.image('rankings/${rank}'));
            rankingpicturre.scale.set(0.95, 0.95);
            FlxTween.tween(rankingpicturre.scale, {x: 0.86, y: 0.86}, 0.1);
            FlxTween.color(rankingpicturre, 0.4, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});

            if(rank == 'E' || rank == 'D' || rank == 'B') rankingpicturre.x += 50;
            if(rank == 'C') rankingpicturre.x += 35;
            if(rank == 'A' || rank == 'A+') rankingpicturre.x -= 25;
            if(rank == 'S-' || rank == 'S') rankingpicturre.x -= 35;
            if(rank == 'S+') rankingpicturre.x -= 40;
            if(rank == 'SS-' || rank == 'SS' || rank == 'SS+'|| rank == 'X-') rankingpicturre.x -= 40;
            if(rank == 'SS+') rankingpicturre.x -= 20;
            if(rank == 'X') rankingpicturre.x -= 100;
            if(rank == 'PERFECT') rankingpicturre.x -= 140;

            rankingpicturre.x += FlxG.height / 1.1 + 100;
            rankingpicturre.screenCenter(Y);
            if(rank == 'A+') rankingpicturre.y -= 25;
            if(rank == 'S+') rankingpicturre.y -= 40;
            if(rank == 'SS-') rankingpicturre.y -= 37.5;
            if(rank == 'SS') rankingpicturre.y -= 12.5;
            if(rank == 'SS+') rankingpicturre.y -= 40;
            if(rank == 'S') rankingpicturre.y += 25;
            rankingpicturre.antialiasing = ClientPrefs.globalAntialiasing;
            add(rankingpicturre);
            
            anotherrank = rank;
        }

        for (i in accuracyarray)
        {
            if(i=="."){
                i = "point";
            }
            numScore = new FlxSprite().loadGraphic(Paths.image('num' + Std.string(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * loopshit);
			numScore.x -= 40 * (accuracyarraytwo.length - 1);
            numScore.x += FlxG.height / 1.75;
            numScore.y -= FlxG.width / 5 + 40;

            numScore.updateHitbox();

            numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			if(i == "point") {
                numScore.x += 20;
                numScore.y += 20;
                numScore.setGraphicSize(Std.int(numScore.width * 0.65));
                loopshit -= 0.6;
            }
            loopshit++;
            if(accuracy == PlayState.instance.resultaccuracy && byebyenumshit) {
                add(numScore);
                FlxTween.tween(numScore, {alpha: 0}, 0.25, {ease: FlxEase.cubeInOut, onComplete: 
                function (twn:FlxTween){
                    remove(numScore);
                    byebyenumshit = false;
                }});
            }
            if(accuracy != PlayState.instance.resultaccuracy) numscoregroup.add(numScore);
        }

        if(countnum != Math.floor(accuracy)) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            countnum++;
        }
        if(accuracy == PlayState.instance.resultaccuracy)
        {
            rank = PlayState.instance.ratingName;
            switch(rank){
                case 'F':
                   ratingstring = 'shit';
                case 'E' | 'D' :
                    ratingstring = 'bad';
                case 'C' | 'B':
                    ratingstring = 'good';
                case 'A-' | 'A' | 'A+':
                    ratingstring = 'sick';
                case 'S-' | 'S' | 'S+' | 'SS-' | 'SS' | 'SS+':
                    ratingstring = 'sick-gold';
                case 'X-' | 'X':
                    ratingstring = 'epic';
                case 'PERFECT':
                    ratingstring = 'epic-gold';
            }
            backtoomenu = true;
            if(!ratingfinish) {
                giverating();
                addsomethingleft();
            }
        }
    }

    function giverating(){
        var rating:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ratingstring));
        //rating.loadGraphic(Paths.image(ratingstring));
        rating.antialiasing = ClientPrefs.globalAntialiasing;
        rating.screenCenter();
        rating.x -= FlxG.width / 4 + 75;
        rating.y -= FlxG.height / 4;

        var fcrating:FlxSprite = new FlxSprite();
        fcrating.loadGraphic(Paths.image('rankings/${FC}'));
        fcrating.antialiasing = ClientPrefs.globalAntialiasing;
        fcrating.scale.set(0.5, 0.5);
        fcrating.screenCenter();
        fcrating.x = rating.width;
        fcrating.y -= FlxG.height / 4;
        fcrating.alpha = 0;

        add(rating);
        rating.scale.set(5, 5);
        rating.alpha = 0;
        FlxTween.tween(rating, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut, startDelay: 0.5});
        FlxTween.tween(rating.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.cubeInOut, startDelay: 0.5, onComplete: 
            function (twn:FlxTween) {
                FlxG.cameras.shake(0.005, 0.25);
            }});
        
        if(FC != 'Clear') add(fcrating);
        FlxTween.tween(fcrating, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut, startDelay: 0.5});
        ratingfinish = true;
    }

    function addsomethingleft(){
        FlxTween.tween(whitetransGradient, {alpha: 1}, 0.25, {startDelay: 0.25});

        var pressenter:FlxText = new FlxText(0, 0, 0, "Press ENTER to continue", 40);
        pressenter.setFormat(Paths.font("phantommuff.ttf"), 40, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        pressenter.x = FlxG.width - pressenter.width - 25;
        pressenter.y = FlxG.height - 65;
        pressenter.alpha = 0;
        FlxTween.tween(pressenter, {alpha: 1}, 0.25, {startDelay: 0.25});
        add(pressenter);

        var placement:String = Std.string(accuracynumbertest / 100);

        var coolText:FlxText = new FlxText(0,0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;

        var loopshit:Float = 0;
        var scoreloopshit:Float = 0;
        var missloopshit:Float = 0;
        var topcomboloopshit:Float = 0;

        accuracyarray.push('percent');

        var score = new Alphabet(-15, FlxG.height / 1.75, 'score', true, false);
        var misses = new Alphabet(-15, FlxG.height / 1.4, 'misses', true, false);
        var top_combo = new Alphabet(-15, FlxG.height / 1.2, 'topcombo', true, false);
        score.x = FlxG.width / 12 - 50;
        misses.x = FlxG.width / 12 - 50;
        top_combo.x = FlxG.width / 12 - 50;
        score.scale.set(0.75, 0.75);
        misses.scale.set(0.75, 0.75);
        top_combo.scale.set(0.75, 0.75);
        score.alpha = 0;
        misses.alpha = 0;
        top_combo.alpha = 0;
        add(score);
        add(misses);
        add(top_combo);
        FlxTween.tween(score, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});
        FlxTween.tween(misses, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});
        FlxTween.tween(top_combo, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});

        var scorearray:Array<String> = Std.string(scorenum).split("");
        var missesarray:Array<String> = Std.string(missesnum).split("");
        var top_comboarray:Array<String> = Std.string(topcombonum).split("");

        for (i in scorearray){
            var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + Std.string(i)));
			numScore.x = coolText.x + (43 * scoreloopshit) + 100;
			numScore.x -= 40 * (scorearray.length - 1);
            numScore.y = score.y - 20;

            numScore.updateHitbox();

            numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
            scoreloopshit++;
            numScore.alpha = 0;
            add(numScore);
            FlxTween.tween(numScore, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});
        }
        for (i in missesarray){
            var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + Std.string(i)));
			numScore.x = coolText.x + (43 * missloopshit) + 100;
			numScore.x -= 40 * (missesarray.length - 1);
            numScore.y = misses.y - 20;

            numScore.updateHitbox();

            numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
            missloopshit++;
            numScore.alpha = 0;
            add(numScore);
            FlxTween.tween(numScore, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});
        }
        for (i in top_comboarray){
            var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + Std.string(i)));
			numScore.x = coolText.x + (43 * topcomboloopshit) + 100;
			numScore.x -= 40 * (top_comboarray.length - 1);
            numScore.y = top_combo.y - 20;

            numScore.updateHitbox();

            numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
            topcomboloopshit++;
            numScore.alpha = 0;
            add(numScore);
            FlxTween.tween(numScore, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});
        }
        for (i in accuracyarray){
            if(i=="."){
                i = "point";
            }
            if(i == 'percent'){
                loopshit += 0.25;
            }
            var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + Std.string(i)));
            numScore.screenCenter();
			numScore.x = coolText.x + (43 * loopshit);
			numScore.x -= 40 * (accuracyarraytwo.length - 1);

            numScore.updateHitbox();

            numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			if(i == "point") {
                numScore.x += 20;
                numScore.y += 20;
                numScore.setGraphicSize(Std.int(numScore.width * 0.65));
                loopshit -= 0.6;
            }
            loopshit++;
            numScore.alpha = 0;
            add(numScore);
            FlxTween.tween(numScore, {alpha: 1}, 0.25, {ease: FlxEase.cubeInOut});
        }
    }
}