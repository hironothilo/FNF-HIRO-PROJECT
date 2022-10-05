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

//"Static access to instance field (varible) is not allowed" mean you stupid go read kade version lol

using StringTools;

class ResultState extends MusicBeatState
{
    var accuracynumbertest:Int = 0;
    var score:Int = 0;
    var misses:Int = 0;
    var topcombo:Int = 0;
    var rank:String = "F";
    var FC:String = "";
    var accuracytxt:FlxText;
    var epicnum:Int = 0;
    var sicknum:Int = 0;
    var goodnum:Int = 0;
    var badnum:Int = 0;
    var shitnum:Int = 0;
    var numscoregroup:FlxGroup = new FlxGroup();

    var backtoomenu:Bool = false;

    var bgmoveing:Int = 1;

    var numtween:FlxTween;
    var transGradient:FlxSprite;
    var anothertransGradient:FlxSprite;
    var transBlack:FlxSprite;
    var anothertransBlack:FlxSprite;
    var bg1:FlxSprite;
    var bg2:FlxSprite;

    public static var ratingStuff:Array<Dynamic> = [
		['F', 0.1], //From 0.01% to 9%
		['E', 0.60], //From 50% to 59%
		['D', 0.70], //From 60% to 68%
		['C', 0.80], //69% to 69.99%
		['B', 0.85], //From 70% to 75%
		['A-', 0.90], //From 76% to 80%
		['A', 0.93], //From 80% to 85%
		['A+', 0.9650], //From 86% to 89%
        ['S-', 0.99], //From 90% to 92%
        ['S', 0.9950], //From 93% to 94%
        ['S+', 0.9970], //From 95% to 96%
        ['SS-', 0.9980], //From 97% to 98%
        ['SS', 0.9990], //From 99%-99.49%
        ['SS+', 0.99950], //From 99.5%-99.89%
        ['X-', 0.99980], //From 99.9%-99.94%
		['X', 0.999935],//From 99.95%-99.9935%
		['PERFECT', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

    override function create()
    {
        /*bg = new FlxBackdrop(Paths.image('menuDesat'), 0.2, 0, true, true);
        bg.velocity.set(-100, -100);
        add(bg);*/
        bg1 = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg1.x = 0;
        bg1.updateHitbox();
        add(bg1);

        bg2 = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg2.x = bg1.width;
        bg2.updateHitbox();
        add(bg2);

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

        FC = PlayState.instance.ratingFC;

        DiscordClient.changePresence("Result Screen", null);

        accuracytxt = new FlxText(12, 12, 0, "", 6);
        accuracytxt.scrollFactor.set();
		accuracytxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(accuracytxt);
        
        super.create();

        if(!backtoomenu) numtween = FlxTween.tween(this, {accuracynumbertest: PlayState.instance.resultaccuracy * 100}, Math.floor(PlayState.instance.resultaccuracy / 10), {ease:FlxEase.sineOut});
    }

    override function update(elapsed:Float)
    {
        var accuracynumbertruenow:Float = accuracynumbertest / 100;
        updateaccuracy(accuracynumbertruenow);

        if(bg1.x == 0){
            bg2.x = 1280;
            FlxTween.tween(bg1, {x: -1280}, 4);
            FlxTween.tween(bg2, {x: 0}, 4);
        }
        if(bg2.x == 0){
            bg1.x = 1280;
            FlxTween.tween(bg2, {x: -1280}, 4);
            FlxTween.tween(bg1, {x: 0}, 4);
        }
        //idk how FlxBackdrop is bug :(

        score =  Math.floor(FlxMath.lerp(score, PlayState.instance.songScore, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        misses =  Math.floor(FlxMath.lerp(misses, PlayState.instance.songMisses, CoolUtil.boundTo(elapsed * 48,0, 1)));
        topcombo =  Math.floor(FlxMath.lerp(topcombo, PlayState.instance.highestCombo, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        epicnum = Math.floor(FlxMath.lerp(epicnum, PlayState.instance.epics, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        sicknum = Math.floor(FlxMath.lerp(sicknum, PlayState.instance.sicks, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        goodnum = Math.floor(FlxMath.lerp(goodnum, PlayState.instance.goods, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        badnum = Math.floor(FlxMath.lerp(badnum, PlayState.instance.bads, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        shitnum = Math.floor(FlxMath.lerp(shitnum, PlayState.instance.shits, CoolUtil.boundTo(elapsed * 48, 0, 1)));

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

        accuracytxt.text = 'accuracy = ${accuracynumbertest/100} %
        \nscore = ${score}
        \nmisses = ${misses}
        \nhighestCombo = ${topcombo}
        \nRanking = ${rank} [${FC}]
        \nepic = ${epicnum}                         sick = ${sicknum}
        \ngood = ${goodnum}                         bad = ${badnum}
        \nshit = ${shitnum}
        ';

        var accepted = controls.ACCEPT && backtoomenu;
        if(!accepted && controls.ACCEPT)
        {
            numtween.cancel();
            accuracynumbertest = Math.ceil(PlayState.instance.resultaccuracy * 100);
        }
        if(accepted)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            MusicBeatState.switchState(new FreeplayState());
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        }
    }

    function updateaccuracy(accuracy:Float)
    {
        var placement:String = Std.string(accuracy);

        var coolText:FlxText = new FlxText(0,0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;

        var accuracyarray:Array<String> = [];
        var accuracyarraytwo:Array<String> = Std.string(Math.floor(accuracy)).split("");

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

        var rankingpicturre:FlxSprite = new FlxSprite().loadGraphic(Paths.image('rankings/${rank}'));
        rankingpicturre.scale.set(0.86, 0.86);
        
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
        numscoregroup.add(rankingpicturre);

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
            numscoregroup.add(numScore);
        }

        if(accuracy != PlayState.instance.resultaccuracy) FlxG.sound.play(Paths.sound('scrollMenu'));
        else
        {
            backtoomenu = true;
        }
    }
}