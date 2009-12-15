﻿package com.tweetcatcha.visual {	import flash.events.Event;	import flash.events.MouseEvent;	import com.reintroducing.events.CustomEvent;		import com.caurina.transitions.*;		import com.tweetcatcha.data.Constants;	import com.NickHardeman.utils.MathUtils;		import flash.display.MovieClip;		// used for the zooming and rotating of the canvas //		public class DreamweaverZoomView extends Dreamweaver {		protected var _headlinBtnHolda		:MovieClip;		protected var _tweetsHolda			:MovieClip;				protected var _zoomInDiam			:Number = 30;				public function DreamweaverZoomView() {					}				override public function setup():void {			super.setup();			_headlinBtnHolda = MovieClip(_circleClip.getChildByName("headlineBtnHolda"));			_tweetsHolda = _mc.tweetsHolda_mc;			var zoomBtn:MovieClip = MovieClip(_circleClip.getChildByName("circleContent_mc")).zoomBtn;			zoomBtn.addEventListener(MouseEvent.CLICK, _onZoomClick, false, 0, true);			zoomBtn.buttonMode = true;		}				private function _onZoomClick($e:MouseEvent):void {			dispatchEvent( new CustomEvent(Constants.ZOOM_IN_CLICK,										   {headlineID:_activeHeadlineID, 										   baseAngle:_headlineBtns[_activeHeadlineID].baseAngle}, true ) );		}		public function zoomIn($e:CustomEvent):void {			// _mc is Dreamweaver_mc on root timeline //			var tarX:Number = 35+_radius;			var tarY:Number = 35+_radius;			var dx:Number = _mc.x - _sw;			var dy:Number = _mc.y - _sh;			var tarAngle:Number = Math.atan2(dy, dx);			tarAngle = MathUtils.toDegrees( tarAngle );			var angle:Number = 180 + (tarAngle - $e.params.baseAngle);			trace("DreamweaverZoomView :: zoomIn : rotation = "+tarAngle);			Tweener.addTween( _mc, {x:tarX, y:tarY, time:.5, transition:"easeInOutCubic"});			Tweener.addTween(_headlinBtnHolda, {rotation:angle, time:.5, transition:"easeOutQuint"});			Tweener.addTween(_tweetsHolda, {rotation:angle, time:.5, transition:"easeOutQuint", 							 onComplete:_onZoomInPositionComplete});					}		private function _onZoomInPositionComplete():void {			_tcm.minRadius = _minRadius;			_tcm.addEventListener(Constants.ANIMATE_IN_COMPLETE, _onZoomInCirclesComplete, false, 0, true);			_tcm.animateCirclesIn();		}		private function _onZoomInCirclesComplete($e:CustomEvent):void {			_tcm.removeEventListener(Constants.ANIMATE_IN_COMPLETE, _onZoomInCirclesComplete);		}		private function _onZoomInComplete($e:CustomEvent):void {					}				public function zoomOut():void {					}	}}