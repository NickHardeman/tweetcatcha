﻿package com.tweetcatcha {		import flash.display.MovieClip;	import flash.events.*;		import com.tweetcatcha.data.Newswire;	import com.tweetcatcha.data.objects.NewsItem;	import com.tweetcatcha.data.objects.Tweet;	import com.tweetcatcha.data.Constants;	//import com.tweetcatcha.nav.MainNav;	import com.tweetcatcha.visual.Dreamweaver;		import com.tweetcatcha.events.TweetIDEvent;	import com.reintroducing.events.CustomEvent;		public class TweetCatcha extends MovieClip {				private var NW				:Newswire;		private var DW				:Dreamweaver;		//private var MN				:MainNav = new MainNav();				//constructor		public function TweetCatcha() {			NW = new Newswire();						DW = new Dreamweaver();			DW.mc = dreamweaver_mc;			//MN.mc = mainMenuHolda_mc;			DW.setup();						DW.onStageResize(stage.stageWidth, stage.stageHeight);			DW.addEventListener(Constants.HEADLINE_ID_SELECTED, _onHeadlineSelected, false, 0, true);						NW.addEventListener(Event.COMPLETE, _onNewswireLoaded, false, 0, true);			NW.load("2009-11-12", 60);		}				public function _onNewswireLoaded($e:Event):void {			trace("Total newsItems "+NW.newsItems.length);			//for (var i:int = 0; i < NW.newsItems.length; i++) {				//var ni:NewsItem = NW.newsItems[i];				//trace("\n\n\n****************************************************************");				//trace(ni.headline+" date: "+ni.month+"-"+ni.day+"-"+ni.year);				//trace("Tweets -------------------"+NW.newsItems[i].tweets.length);				//for (var j:int = 0; j < NW.newsItems[i].tweets.length; j++) {					//trace("          +"+NW.newsItems[i].tweets[j].user);				//}			//}						DW.reset();			DW.newsItems = NW.newsItems;			DW.configure();			DW.positionAllTweets();		}							public function _onHeadlineSelected($e:CustomEvent = null):void {			_onHeadlineClick( $e.params.ID );		}				public function _onHeadlineClick( $id:int ):void {			DW.headlineSelected( $id );		}				private function _onStageResize( $e:Event ):void {			DW.onStageResize($e.target.stageWidth, $e.target.stageHeight);			//MN.onStageResize($e.target.stageWidth, $e.target.stageHeight);		}				/*private function _onMouseMove($e:MouseEvent):void {			MN.checkMouse( mouseY );		}*/							}}