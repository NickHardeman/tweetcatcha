﻿package com.tweetcatcha.visual {		import flash.events.EventDispatcher;	import flash.events.Event;	import flash.events.MouseEvent;		import flash.display.MovieClip;		import com.tweetcatcha.data.objects.NewsItem;	import com.tweetcatcha.data.Constants;	import com.tweetcatcha.data.objects.Tweet;		import com.tweetcatcha.visual.TimeCircleManager;	import com.tweetcatcha.visual.TweetManager;		import com.NickHardeman.utils.MathUtils;		import com.reintroducing.events.CustomEvent;		import com.caurina.transitions.*;		public class Dreamweaver extends EventDispatcher {				private var _newsItems		:Vector.<NewsItem>;		// this movieclip is already on the stage, we just need to pass a ref //		private var _mc				:MovieClip;		private var _circleClip		:MovieClip;		// the width of the black circle, so we know where to place buttons //		private var _radius			:Number = 300 * .5;		private var _angleInc		:Number;		private var _headlineBtns	:Vector.<CircleHeadlineBtn>;				private var _sw				:Number;		private var _sh				:Number;				private var _tcm			:TimeCircleManager = new TimeCircleManager();		private var _tm				:TweetManager = new TweetManager();				private var _activeHeadlineID	:int = -1;		private var _prevHeadlineID		:int = -1;								public function set mc( $mc:MovieClip ):void {			_mc = $mc;			_circleClip = MovieClip(MovieClip(_mc.getChildByName("circleClip")));			_tcm.mc = ($mc.timeCirclesHolda_mc);			_tm.mc = ($mc.tweetsHolda_mc);		}				public function get activeID():int {			return _activeHeadlineID;		}				public function set newsItems($n:Vector.<NewsItem>) {			_newsItems = $n;		}				public function setup():void {			_tcm.minRadius = _radius + 10;			_tcm.setup();			_tm.setup();		}				public function configure():void {			trace(_newsItems.length);			_headlineBtns = new Vector.<CircleHeadlineBtn>();			_angleInc = 360/_newsItems.length;			var angle:Number = 0;			for (var i:int = 0; i < _newsItems.length; i++) {				var ni:NewsItem = _newsItems[i] as NewsItem;				// located in the library, under center circle pieces folder				var hb:CircleHeadlineBtn = new CircleHeadlineBtn();								angle = _angleInc * i;				hb.rotation = angle;				//hb.alpha = 1 - (i / 360);				hb.baseAngle = angle;				angle = MathUtils.toRadians( angle );				hb.x = Math.cos( angle ) * _radius;				hb.y = Math.sin( angle ) * _radius;								hb.ID = ni.ID;								hb.rec.height = 3;								hb.buttonMode = true;				hb.mouseChildren = false;								hb.alpha = .7;								hb.addEventListener(MouseEvent.ROLL_OVER, _onHeadlineBtnOver, false, 0, true);				hb.addEventListener(MouseEvent.ROLL_OUT, _onHeadlineBtnOut, false, 0, true);				hb.addEventListener(MouseEvent.CLICK, _onHeadlineBtnClick, false, 0, true);								// this is located in the movieclip on the timeline, behind the black circle //				MovieClip(_circleClip.getChildByName("headlineBtnHolda")).addChild( hb );				_headlineBtns.push( hb );							}					}				public function animateIn():void {					}		private function _onAnimateIn():void {			dispatchEvent(new Event(Constants.ANIMATE_IN_COMPLETE ));		}		public function animateOut():void {					}		private function _onAnimateOut():void {			dispatchEvent(new Event(Constants.ANIMATE_OUT_COMPLETE ));		}				public function reset():void {			var hBtnHolda:MovieClip = MovieClip(_circleClip.getChildByName("headlineBtnHolda"));			var totes:int = hBtnHolda.numChildren;			for (var i:int = 0; i < totes; i++) {				hBtnHolda.removeChildAt(0);			}		}				public function headlineSelected( $id:Number ):void {			var ni:NewsItem = _newsItems[$id];			var cc:MovieClip = MovieClip(_circleClip.getChildByName("circleContent_mc"));			Tweener.removeTweens(cc);			cc.title_txt.text = ni.headline;			var tt:String = String(ni.totalTweets);			if (ni.totalTweets == -1) tt = "Loading ...";			cc.total_txt.text = "Total Tweets: "+tt;			cc.summary_txt.text = ni.summary;						if (_activeHeadlineID > -1) 				_enableHeadlineBtn(_headlineBtns[_activeHeadlineID]);						_activeHeadlineID = $id;						_disableHeadlineBtn( _headlineBtns[$id] );			_shiftHeadlineBtns( _headlineBtns[$id] );			_headlineBtnOver( _headlineBtns[$id] );						//cc.title_txt.y = -100;			//cc.alpha = .3;			cc.rotation = MathUtils.lerp(Math.random(), 120, 200);			if (Math.random() > .5) cc.rotation *= -1;						Tweener.addTween(cc, {rotation:0, time:1, transition:"easeOutElastic"});			//Tweener.addTween(cc.title_txt, {y:-53, time:.3, transition:"easeOutCubic"});						_prevHeadlineID = _activeHeadlineID;		}				public function onStageResize( $w:Number, $h:Number ):void {			//trace("Width: "+$w);			_sw = $w;			_sh = $h;			_mc.x = _sw * .5;			_mc.y = _sh * .5;			_tcm.onStageResize($w, $h);			//_mc.y = _sh - _mc.hit_mc.height;			//_layoutMenu();		}				private function _onHeadlineBtnOver($e:MouseEvent):void {			var hb:CircleHeadlineBtn = $e.currentTarget as CircleHeadlineBtn;			_headlineBtnOver( hb );			_shiftHeadlineBtns( hb );		}				private function _headlineBtnOver($t:CircleHeadlineBtn):void {			if ( _activeHeadlineID > -1 ) { _headlineBtnOut(_headlineBtns[_activeHeadlineID]); }			Tweener.addTween($t.rec, {height:10, time:.3, transition:"easeOutCirc"});			Tweener.addTween($t, {alpha:1, time:.3, transition:"easeOutCirc"});		}				private function _onHeadlineBtnOut($e:MouseEvent):void {			_headlineBtnOut( $e.currentTarget as CircleHeadlineBtn );						if (_activeHeadlineID > -1) {				_shiftHeadlineBtns( _headlineBtns[_activeHeadlineID] );				_headlineBtnOver( _headlineBtns[_activeHeadlineID] );			}		}				private function _headlineBtnOut($t:CircleHeadlineBtn):void {			if ($t.rec.height != 3) {				Tweener.addTween($t.rec, {height:3, time:.3, transition:"easeOutCirc"});				Tweener.addTween($t, {alpha:.7, time:.3, transition:"easeOutCirc"});			}		}				private function _onHeadlineBtnClick($e:MouseEvent):void {			//_activeHeadlineID = $e.currentTarget.ID;			dispatchEvent( new CustomEvent(Constants.HEADLINE_ID_SELECTED, {ID:$e.currentTarget.ID}) );		}				private function _disableHeadlineBtn($t:CircleHeadlineBtn):void {			$t.removeEventListener(MouseEvent.ROLL_OUT, _onHeadlineBtnOut);			$t.buttonMode = false;			$t.mouseEnabled = false;		}		private function _enableHeadlineBtn($t:CircleHeadlineBtn):void {			$t.addEventListener(MouseEvent.ROLL_OUT, _onHeadlineBtnOut);			$t.buttonMode = true;			$t.mouseEnabled = true;		}				// onRollOver to move other btns out of the way //		private function _shiftHeadlineBtns($target:CircleHeadlineBtn = null):void {			var tarX:Number;			var tarY:Number;			for (var i:int = 0; i < _headlineBtns.length; i++) {				var hb:CircleHeadlineBtn = _headlineBtns[i] as CircleHeadlineBtn;				if ($target != null) {					var angleSpace:Number = 0;					if (_angleInc < 1.5) {						angleSpace = _angleInc * 2;					}										if (i > $target.ID) {						_headlineBtnOut(_headlineBtns[i]);						_headlineBtns[i].tarAngle = _headlineBtns[i].baseAngle + (angleSpace);					} else if (i < $target.ID) {						_headlineBtnOut(_headlineBtns[i]);						_headlineBtns[i].tarAngle = _headlineBtns[i].baseAngle - (angleSpace);					} else if (i == $target.ID) {						_headlineBtns[i].tarAngle = _headlineBtns[i].baseAngle;					}									} else {					_headlineBtns[i].tarAngle = _headlineBtns[i].baseAngle;				}				var angle:Number = MathUtils.toRadians( _headlineBtns[i].tarAngle );				tarX = Math.cos( angle ) * _radius;				tarY = Math.sin( angle ) * _radius;				if (hb.x != tarX) {					_headlineBtns[i].rotation = _headlineBtns[i].tarAngle;					Tweener.addTween(hb, {x:tarX, y:tarY, time:.3, transition:"easeOutCirc"});				}			}					}				// we only want to calculate time difference once, and then sort for ease and speed increase //		private function _sortByTimeDiffs():void {			for (var j:int = 0; j < _headlineBtns.length; j++) {				var ni:NewsItem = _newsItems[j];				//trace("\n\n----------------------------------------");				//trace(ni.headline);				for (var i:int = 0; i < _newsItems[j].tweets.length; i++) {					var tw:Tweet = _newsItems[j].tweets[i];					//trace("Dreamweaver :: onTweetsLoaded : newsItem time diff = "+tw.hourDiff+" hours and "+tw.minDiff+" minutes");				}							}		}				//load the tweet clips		public function positionAllTweets():void {						for (var j:int = 0; j < _headlineBtns.length; j++) {				var angleRad:Number = MathUtils.toRadians(_headlineBtns[j].baseAngle);				var ni:NewsItem = _newsItems[j];				_tm.lock();				for (var i:int = 0; i < _newsItems[j].tweets.length; i++) {					//trace("index of " + j + "tweet no. " + i + ": " + _newsItems[j].tweets[i].user);					var tw:Tweet = _newsItems[j].tweets[i];					var tarX:Number = _tcm.getRadiusForTime( tw.hourDiff, tw.minDiff );					//trace(tarX);					var angleDiff:Number = MathUtils.toRadians( MathUtils.randomRange(-1 * _angleInc * .25, _angleInc * .25) );					_tm.addTweet(tarX * Math.cos(angleRad+angleDiff), tarX * Math.sin(angleRad+angleDiff), tw);				}				_tm.unlock();			}		}											}}