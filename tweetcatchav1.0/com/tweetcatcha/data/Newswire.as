﻿package com.tweetcatcha.data {	import com.tweetcatcha.data.objects.NewsItem;	import com.tweetcatcha.data.objects.Tweet;		import flash.events.EventDispatcher;	import flash.events.Event;	import flash.events.ProgressEvent;	import flash.events.IOErrorEvent;		import flash.net.URLLoader;	import flash.net.URLRequest;		public class Newswire extends EventDispatcher {		private var _SCRIPT_LOC		:String = "http://localhost:8888/Tweetcatcha/getData/";		private var _FILE_NAME		:String = "getNewswiresAndTweets.php";		private var _loader			:URLLoader;		private var _date			:String;		private var _minTweets		:int = 50;		private var _newsItemsLimit	:int = 100;		private var _xml			:XML;		private var _totalTweets	:uint = 0;				public var newsItems		:Vector.<NewsItem>;				public function Newswire( $scriptLoc:String = "", $newsItemsLimit:int = 400, $minTweets:int = 20) {			if ($scriptLoc != "" && $scriptLoc != null) {				_SCRIPT_LOC = $scriptLoc;			}			_minTweets = $minTweets;			_newsItemsLimit = $newsItemsLimit;		}				public function load($date:String = "", $minTweets:int = -1):void {			if ($date == "") {				throw new Error("Must pass a date into the Newswire load function! IE 2009-11-31");			}						newsItems = new Vector.<NewsItem>(0,0);			// date format 2009-11-31 //			_date = $date;			if ($minTweets > -1) _minTweets = $minTweets;						if (_loader) _cleanLoader();						_loader = new URLLoader();			_loader.addEventListener( Event.COMPLETE, _onXMLLoaded, false, 0, true);			_loader.addEventListener( ProgressEvent.PROGRESS, _onXMLProgress, false, 0, true);			_loader.addEventListener( IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);			_loader.load( new URLRequest( _SCRIPT_LOC+_FILE_NAME+"?date="+_date+"&limit="+_newsItemsLimit+"&minTweets="+_minTweets) );			trace("Newswire :: load : url = "+ _SCRIPT_LOC+_FILE_NAME+"?date="+_date+"&limit="+_newsItemsLimit+"&minTweets="+_minTweets);			trace("Newswire :: load : begin Loading for "+_date+", this is going to take a while");		}				private function _onXMLLoaded($e:Event):void {			trace("Newswire :: _onXMLLoaded : xml has finally loaded");			_xml = new XML( $e.target.data );			trace("\nNewswire :: _onXMLLoaded : _xml = "+_xml);			_totalTweets = 0;			for (var i:uint = 0; i < _xml.news_item.length(); i++) {				var nNode:XML = _xml.news_item[i];				_totalTweets += nNode.tweets.@total;								var newsItem:NewsItem = new NewsItem(nNode.headline, 													 nNode.@url, 													 nNode.section, 													 nNode.summary, 													 nNode.updatedTime,													 nNode.createdTime,													 nNode.pubDate,													 nNode.byline,													 i													 );								for (var j:int = 0; j < nNode.tweets.tweet.length(); j++) {					var tNode:XML = nNode.tweets.tweet[j];					var tweet:Tweet = new Tweet(tNode.tweet_id,												  tNode.tweet_from_user_id,												  tNode.tweet_from_user,												  tNode.tweet_profile_image_url,												  tNode.tweet_created_at,												  tNode.tweet_text,												  i,												  j												);					tweet.hourDiff = tNode.@hourDiff;					tweet.minDiff = tNode.@minDiff;										newsItem.addTweet( tweet );				}								newsItems.push( newsItem );							}			Constants.setNewswireTotalTweets(_totalTweets);			Constants.setNewswireTotalHeadlines(newsItems.length);			dispatchEvent( $e );		}		private function _onXMLProgress($e:ProgressEvent):void {			dispatchEvent( $e );		}		private function _onIOError($e:IOErrorEvent):void {			dispatchEvent( $e );		}				private function _cleanLoader():void {			if (_loader) {				_loader.removeEventListener(Event.COMPLETE, _onXMLLoaded);				_loader.removeEventListener(ProgressEvent.PROGRESS, _onXMLProgress);				_loader.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);				_loader = null;			}		}					}}