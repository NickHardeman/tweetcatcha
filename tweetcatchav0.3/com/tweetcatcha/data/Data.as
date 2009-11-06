﻿package com.tweetcatcha.data {		import flash.display.MovieClip;	import flash.events.*;	import flash.net.URLLoader;	import flash.net.URLRequest;		import com.tweetcatcha.data.Newswire;	import com.tweetcatcha.data.BackTweet;		public class Data extends MovieClip {				//newswire		private var newswire:Newswire;				//news items		private var newsItems:Array = [];				//fire loaded event when news items are loaded		public static const NEWS_ITEMS_LOADED	:String = "newsItemsLoaded";		public static const TWEETS_LOADED		:String = "xmlIsLoaded";				//backtweet object		private var backtweet:BackTweet;				//constructor		public function Data() {			//create new newswire object			newswire = new Newswire();		}				//load the data		public function loadData():void {			trace("loading 360 news items");			newswire.load();			newswire.addEventListener(Newswire.LOADED, _newsItemsLoaded);		}				//newitems loaded		public function _newsItemsLoaded($e:Event):void {			//trace("news loaded");			newsItems = newswire.getNewsItems;			newswire.removeEventListener(Newswire.LOADED, _newsItemsLoaded);			dispatchEvent( new Event(NEWS_ITEMS_LOADED) );						//create new backtweet object			backtweet = new BackTweet();			//send all the news items to the backtweet class and let it deal with it			backtweet.init(newsItems);		}				//return all the news items		public function get getNewsItems():Array {			return newsItems;		}	}}