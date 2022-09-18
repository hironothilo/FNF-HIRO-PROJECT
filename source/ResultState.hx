package;

import flixel.group.FlxGroup;
import Discord.DiscordClient;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

//"Static access to instance field (varible) is not allowed" mean you stupid go read kade version lol

using StringTools;

class ResultState extends MusicBeatState
{
    var accuracynumbertest:Float = 0;
    var score:Int = 0;
    var misses:Int = 0;
    var topcombo:Int = 0;
    var rank:String = "";
    var FC:String = "";
    var accuracytxt:FlxText;
    var epicnum:Int = 0;
    var sicknum:Int = 0;
    var goodnum:Int = 0;
    var badnum:Int = 0;
    var shitnum:Int = 0;
    var numscoregroup:FlxGroup = new FlxGroup();

    override function create()
    {    
        /*accuracynumber = FlxMath.lerp(accuracynumber, PlayState.resultaccuracy, CoolUtil.boundTo(elapsed * 8, 0, 1));
        score = PlayState.instance.songScore;
        misses = PlayState.instance.songMisses;
        topcombo = PlayState.instance.highestCombo;*/
        rank = PlayState.instance.ratingName;
        FC = PlayState.instance.ratingFC;

        DiscordClient.changePresence("Result Screen", null);

        accuracytxt = new FlxText(12, 12, 0, "", 6);
        accuracytxt.scrollFactor.set();
		accuracytxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(accuracytxt);
        ////accuracytxt.alpha = 0;
        //accuracytxt.x -= 50;

        /*accuracytxt.text = 'accuracy = ${accuracynumber} %
        \nscore = ${score}
        \nmisses = ${misses}
        \nhighestCombo = ${topcombo}
        \nRanking = ${rank} [${FC}]
        \nepic = ${PlayState.instance.epics}        sick = ${PlayState.instance.sicks}
        \ngood = ${PlayState.instance.goods}        bad = ${PlayState.instance.bads}
        \nshit = ${PlayState.instance.shits}
        ';*/
        
        //FlxTween.tween(accuracytxt, {x: accuracytxt.x + 50, alpha: 1}, 0.5);
        super.create();
    }

    override function update(elapsed:Float)
    {
        accuracynumbertest = Highscore.floorDecimal(FlxMath.lerp(accuracynumbertest, PlayState.instance.resultaccuracy * 100, CoolUtil.boundTo(elapsed * 2, 0, 1)), 2);
        var accuracynumbertruenow:Float = accuracynumbertest / 100;
        if(accuracynumbertruenow != accuracynumbertest / 100) updateaccuracy(accuracynumbertruenow);
        /*var accuracyarray:Array<String> = Std.string(accuracynumber).split("");
        for (i in accuracyarray)
        {
            if(i=="."){
                i = "point";
            }
            var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.string(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (28 * loopshit) + 180;
			numScore.x += ClientPrefs.comboOffset[0];
			numScore.y -= ClientPrefs.comboOffset[1];
			numScore.velocity.y -= FlxG.random.int(140, 175);
			numScore.visible = !ClientPrefs.hideHud;
			//trace(numScore.width);
			numScore.x -= 30 * (noteDiffarraytwo.length - 1);
        }*/
        
        score =  Math.ceil(FlxMath.lerp(score, PlayState.instance.songScore, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        misses =  Math.ceil(FlxMath.lerp(misses, PlayState.instance.songMisses, CoolUtil.boundTo(elapsed * 48,0, 1)));
        topcombo =  Math.ceil(FlxMath.lerp(topcombo, PlayState.instance.highestCombo, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        epicnum = Math.ceil(FlxMath.lerp(epicnum, PlayState.instance.epics, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        sicknum = Math.ceil(FlxMath.lerp(sicknum, PlayState.instance.sicks, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        goodnum = Math.ceil(FlxMath.lerp(goodnum, PlayState.instance.goods, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        badnum = Math.ceil(FlxMath.lerp(badnum, PlayState.instance.bads, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        shitnum = Math.ceil(FlxMath.lerp(shitnum, PlayState.instance.shits, CoolUtil.boundTo(elapsed * 48, 0, 1)));

        accuracytxt.text = 'accuracy = ${accuracynumbertruenow} %
        \nscore = ${score}
        \nmisses = ${misses}
        \nhighestCombo = ${topcombo}
        \nRanking = ${rank} [${FC}]
        \nepic = ${epicnum}                         sick = ${sicknum}
        \ngood = ${goodnum}                         bad = ${badnum}
        \nshit = ${shitnum}
        ';

        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            MusicBeatState.switchState(new FreeplayState());
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        }
    }
    function updateaccuracy(accuracy:Float)
    {
        var placement:String = Std.string(accuracy);

        var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;

        var accuracyarray:Array<String> = Std.string(accuracy).split("");
        var accuracyarraytwo:Array<String> = Std.string(Math.ceil(accuracy)).split("");

        var loopshit:Float = 0;
        var numScore:FlxSprite;
        
        numscoregroup.destroy();
		numscoregroup = new FlxGroup();
		add(numscoregroup);

        for (i in accuracyarray)
        {
            if(i=="."){
                i = "point";
            }
            numScore = new FlxSprite().loadGraphic(Paths.image('num' + Std.string(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * loopshit) - 150;
			if(accuracynumbertruenow != accuracynumbertest / 100) numScore.x -= 40 * (accuracyarraytwo.length - 1);

            numScore.updateHitbox();

            numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			if(i == "point") {
                numScore.x += 20;
                //numScore.y += 20;
                numScore.setGraphicSize(Std.int(numScore.width * 0.65));
                loopshit -= 0.4;
            }

            loopshit++;
            numscoregroup.add(numScore);
        }
    }
}