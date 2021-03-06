package com.efg.games.click
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	
	/**
	 * ...
	 * @author yangfan1122@gmail.com
	 */
	public class ClickGame extends Game
	{
		
		public static const GAME_OVER:String = "game over";
		public static const NEW_LEVEL:String = "new level";
		private var clicks:int = 0;
		private var gameLevel:int = 1;
		private var gameOver:Boolean = false;
		
		public function ClickGame()
		{
		}
		
		override public function newGame():void
		{
			clicks = 0;
			gameOver = false;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEvent);
			
			//在GameFrameWork监听
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_CLICKS, String(clicks)));
		}

		override public function newLevel():void //switchSystemState中调用
		{
			dispatchEvent(new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(gameLevel)));
		}

		override public function runGame():void
		{
			if (clicks >= 10)
			{
				gameOver = true;
			}
			checkforEndGame();
		}
		
		
		
		
		public function onMouseDownEvent(e:MouseEvent):void
		{
			clicks ++;
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_CLICKS, String(clicks)));
		}
		
		
		
		private function checkforEndGame():void
		{
			if (gameOver)
			{
				dispatchEvent(new Event(GAME_OVER));
			}
		}
		
		
	}
	
}