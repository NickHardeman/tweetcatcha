﻿package com.tweetcatcha.visual {	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.geom.Point;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Shape;	import flash.geom.Rectangle;	import flash.geom.Matrix;	import flash.events.MouseEvent;		import com.gskinner.utils.Rndm;	import com.NickHardeman.utils.MathUtils;	import com.reintroducing.events.CustomEvent;	import com.tweetcatcha.data.Constants;		import com.tweetcatcha.data.objects.Tweet;		import com.caurina.transitions.*;		public class TweetManager extends EventDispatcher {				private var _mc			:MovieClip;		public var _tweets		:Vector.<Vector.<TinyCircle> >		private var point		:Point;		private var xPos		:Number = 10;		private var yPos		:Number = 0;		private var line		:Bitmap;		private var lineBmd		:BitmapData;		private var _sw			:Number;		private var _sh			:Number;		private var shape		:Shape = new Shape();				Rndm.seed = 10;				public function setup( ):void {					}				public function setTotalNewsItems($i:int):void {			_tweets = new Vector.<Vector.<TinyCircle> >($i, true);			for (var i:int = 0; i < $i; i++) {				_tweets[i] = new Vector.<TinyCircle>();			}					}				public function onStageResize($w:Number, $h:Number) {			_sw = $w; _sh = $h;		}				public function addTweet($tarX:Number, $tarY:Number, $t:Tweet, $parentIndex:int, $index:int):void {			var tc:TinyCircle = new TinyCircle();			tc.x = $tarX;			tc.y = $tarY;			tc.tweet = $t;			//tc.cacheAsBitmap = true; // epic fail //			tc.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true);			tc.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);			tc.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true);			tc.parentIndex = $parentIndex;			tc.index = $index;			tc.largeBtn = false;			_tweets[$parentIndex].push(tc);			_mc.addChild(tc);		}				public function showTweets($parentIndex:int = -1):void {			for ( var i:int = 0; i < _tweets.length; i++) {				//trace("TweetManager :: setTotalNewsItems : _tweets = "+_tweets.length+" _tweets[i] = "+_tweets[i].length);				for (var j:int = 0; j < _tweets[i].length; j++) {					var tc:TinyCircle = _tweets[i][j];					if (i == $parentIndex) {						tc.visible = true;						tc.gotoAndStop("largeBtnOver");						tc.largeBtn = true;					} else {						tc.visible = false;					}				}			}		}				public function showAllTweets():void {			for ( var i:int = 0; i < _tweets.length; i++) {				for (var j:int = 0; j < _tweets[i].length; j++) {					var tc:TinyCircle = _tweets[i][j];					tc.visible = true;					tc.gotoAndStop(1);					tc.largeBtn = false;				}			}		}				public function onHeadlineClick($parentIndex:int):void {			for ( var i:int = 0; i < _tweets.length; i++) {				for (var j:int = 0; j < _tweets[i].length; j++) {					var tc:TinyCircle = _tweets[i][j];					if (i == $parentIndex) {						tc.gotoAndStop(10);					} else {						tc.gotoAndStop(1);					}				}			}		}								public function animateTweetZoom($parentIndex:int, $index:int, $x:Number, $y:Number):void {			Tweener.addTween(_tweets[$parentIndex][$index], {x:$x, y:$y, time:2, transition:"easeOutSine"});		}				public function reset():void {			var totes:int = _mc.numChildren;			for (var i:int = 0; i < totes; i++) {				var tc:TinyCircle = TinyCircle(_mc.getChildAt(0));				tc.removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);				tc.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);				tc.removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);				_mc.removeChildAt(0);			}		}				//tweet mouseover		public function _onMouseOver(event:MouseEvent):void {			if (event.target.largeBtn) {				event.target.buttonMode = true;				event.target.gotoAndPlay("largeBtnOver");			}		}				public function _onMouseDown(event:MouseEvent):void {			//trace(event.target.tweet.tweetText);			//populate tinyclip tweet text			//trace("largeBtn? = " + event.target.largeBtn);			if (event.target.largeBtn) {				if (!event.target.isClicked) {					var sb:SpeechBubble = new SpeechBubble();					sb.x = _mc.mouseX;					sb.y = _mc.mouseY;					sb.rollOverText.htmlText = event.target.tweet.tweetText;					sb.name = "" + event.target.tweet.ID + "";					sb.rotation = -1 * _mc.rotation;					sb.user = event.target.tweet.user;					//trace("profile image = " + event.target.tweet.profileImageUrl);					//trace("userid = " + event.target.tweet.userId);					//trace("user = " + event.target.tweet.user);					//trace("tweetId = " + event.target.tweet.tweetId);					event.target.isClicked = true;										var angle:Number = MathUtils.toRadians( _mc.rotation );										var cos:Number = Math.cos(angle);					var sin:Number = Math.sin(angle);										var worldX:Number = (cos * sb.x - sin * sb.y) + _mc.parent.x;					var worldY:Number = (cos * sb.y + sin * sb.x) + _mc.parent.y;										var x1:Number = worldX - _mc.parent.x;					var y1:Number = worldY - _mc.parent.y;					cos = Math.cos(-angle);					sin = Math.sin(-angle);										if (worldX + 400 > _sw) {						x1 = _sw - 400;					} else if (worldX < 100) {						x1 = 100;					}					if (worldY + 150 > _sh) {						y1 = _sh - 150;					} else if(worldY < 100) {						y1 = 100;					}										sb.x = (cos * x1 - sin * y1);					sb.y = (cos * y1 + sin * x1);										//event.target.parent.addChild(sb);					_mc.addChild( sb );					//trace("TweetManager :: _onMouseDown : _mc.name "+ _mc.rotation);					//dispatchEvent( new CustomEvent(Constants.ADD_CHILD, {worldX:worldX, worldY:worldY}, true) );				}			}		}				//tweet mouseout		public function _onMouseOut(event:MouseEvent):void {			//animate out tinyclip rollout			if (event.target.largeBtn) {				event.target.gotoAndPlay("largeBtnOut");				if (event.target.isClicked) {					event.target.parent.getChildByName("" + event.target.tweet.ID + "").animateOut();					event.target.isClicked = false;					//event.target.parent.removeChild(event.target.parent.getChildByName("" + event.target.tweet.ID + ""));				}			}		}				public function set mc($mc:MovieClip):void {			_mc = $mc;		}			}}