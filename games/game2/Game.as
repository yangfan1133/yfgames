﻿package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.*;
	import flash.ui.Mouse;

	public class Game extends flash.display.MovieClip
	{
		public static const STATE_INIT:int = 10;
		public static const STATE_PLAY:int = 20;
		public static const STATE_END_GAME:int = 30;
		public var gameState:int = 0;
		public var score:int = 0;
		public var chances:int = 0;
		public var bg:MovieClip;
		public var enemies:Array;
		public var player:MovieClip;
		public var level:Number = 0;
		public var scoreLabel:TextField = new TextField();
		public var levelLabel:TextField = new TextField();
		public var chancesLabel:TextField = new TextField();
		public var scoreText:TextField = new TextField();
		public var levelText:TextField = new TextField();
		public var chancesText:TextField = new TextField();
		public const SCOREBOARD_Y:Number = 380;

		public function Game()
		{
			addEventListener(Event.ENTER_FRAME, gameLoop);//游戏状态检测
			bg = new BackImage();
			addChild(bg);//背景
			
			Mouse.hide();
			
			scoreLabel.text = "Score:";
			levelLabel.text = "Level:";
			chancesLabel.text = "Misses:"
			scoreText.text = "0";
			levelText.text = "1";
			chancesText.text = "0";
			scoreLabel.y = SCOREBOARD_Y;
			levelLabel.y = SCOREBOARD_Y;
			chancesLabel.y = SCOREBOARD_Y;
			scoreText.y = SCOREBOARD_Y;
			levelText.y = SCOREBOARD_Y;
			chancesText.y = SCOREBOARD_Y;
			scoreLabel.x = 5;
			scoreText.x = 50;
			chancesLabel.x = 105;
			chancesText.x = 155;
			levelLabel.x = 205;
			levelText.x = 260;
			
			addChild(scoreLabel);
			addChild(levelLabel);
			addChild(chancesLabel);
			addChild(scoreText);
			addChild(levelText);
			addChild(chancesText);
			gameState = STATE_INIT;
		}

		public function gameLoop(e:Event):void
		{
			switch (gameState)
			{
				case STATE_INIT:
					initGame();
					break;
				case STATE_PLAY:
					playGame();
					break;
				case STATE_END_GAME:
					endGame();
					break;
			}
		}

		public function initGame():void
		{
			score = 0;
			chances = 0;
			player = new PlayerImage();
			enemies = new Array();
			level = 1;
			levelText.text = level.toString();
			addChild(player);
			player.startDrag(true, new Rectangle(0, 0, 550, 400));
			gameState = STATE_PLAY;
		}

		public function playGame():void
		{
			player.rotation += 15;
			makeEnemies();
			moveEnemies();
			testCollisions();
			testForEnd();
		}

		public function makeEnemies():void
		{
			var chance:Number = Math.floor(Math.random() * 100);
			var tempEnemy:MovieClip;
			if (chance < 2 + level)
			{
				tempEnemy = new EnemyImage()
				tempEnemy.speed = 3 + level;
				tempEnemy.gotoAndStop(Math.floor(Math.random() * 5) + 1);
				tempEnemy.y = 435;
				tempEnemy.x = Math.floor(Math.random() * 515);//气球x坐标
				addChild(tempEnemy);
				enemies.push(tempEnemy);
			}
		}

		public function moveEnemies():void
		{
			var tempEnemy:MovieClip;
			for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				tempEnemy.y -= tempEnemy.speed;
				if (tempEnemy.y < -35)//飞到顶端外，气球逃脱
				{
					chances++;
					chancesText.text = chances.toString();
					enemies.splice(i, 1);
					removeChild(tempEnemy);
				}
			}
		}

		public function testCollisions():void
		{
			var sound:Sound = new Pop();
			var tempEnemy:MovieClip;
			for (var i:int = enemies.length - 1; i >= 0; i--)
			{
				tempEnemy = enemies[i];
				if (tempEnemy.hitTestObject(player))
				{
					score++;
					scoreText.text = score.toString();
					sound.play();
					enemies.splice(i, 1);
					removeChild(tempEnemy);
				}
			}
		}

		public function testForEnd():void
		{
			if (chances >= 5)
			{
				gameState = STATE_END_GAME;
			}
			else if (score > level * 20)
			{
				level++;
				levelText.text = level.toString();
			}
		}

		public function endGame():void
		{
			for (var i:int = 0; i < enemies.length; i++)
			{
				removeChild(enemies[i]);
			}
			enemies = [];
			player.stopDrag();
		}
	}
}