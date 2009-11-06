﻿/*This class loads all the news items from newswire, creates and returns the objects*/package com.tweetcatcha.data {		import flash.display.MovieClip;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.events.Event;	import flash.display.MovieClip;	import flash.events.IOErrorEvent;		import com.tweetcatcha.data.objects.NewsItem;		public class Newswire extends MovieClip {		public static const LOADED	:String = "xmlIsLoaded";				private const API_KEY:String = "cc79503c84c6fc36e8e6fd848827a201:17:59190453";		private var _offset:uint = 20;		private var _idIncrement = 0;				//variables for the xml		private var _xml:XML;		private var url:String;		private var loader:URLLoader = new URLLoader();				//newsitem		//private var newsItem:NewsItem;		private var newsItems:Array = [];						//constructor		public function Newswire() {			loader.addEventListener(Event.COMPLETE, _onXMLLoaded, false, 0, true);			loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOErrorEvent, false, 0, true);		}				public function load():void {			url = "http://api.nytimes.com/svc/news/v2/all/last24hours.xml?offset=" + _offset + "&api-key=" + API_KEY;			//trace(url);			loader.load(new URLRequest(url));		}				//xml loaded		public function _onXMLLoaded($e:Event):void {			_xml = new XML($e.target.data);			//trace(_xml);			parseXML();		}				//on IO error		public function _onIOErrorEvent($e:IOErrorEvent):void {			trace("loaded");			_xml = new XML($e.target.data);			//trace(_xml);			parseXML();			loader.removeEventListener(Event.COMPLETE, _onXMLLoaded);			loader.removeEventListener(Event.COMPLETE, _onIOErrorEvent);			dispatchEvent( new Event(LOADED) );		}				//parse xml and create newsitem objects		public function parseXML():void {			var allItems:XMLList = _xml.results.news_item;			//trace("this is the items" + allItems.length());			//for each (var tempXML:XML in allItems) {			for (var i:uint = 0; i < allItems.length(); i++) {				var _headline = allItems[i].headline;				var _url = allItems[i].@url;				var _section = allItems[i].section;				var _summary = allItems[i].summary;				var _updatedTime = allItems[i].updated;				var _createdTime = allItems[i].created;				var _pubDate = allItems[i].pubdate;								//create a news item object				var newsItem:NewsItem = new NewsItem(_headline, 													 _url, 													 _section, 													 _summary, 													 _updatedTime,													 _createdTime,													 _pubDate,													 _idIncrement													 );								//push the object into the array				//newsItems[newsItem.ID] = newsItem;				newsItems[newsItem.ID] = newsItem;				//trace(newsItems[newsItem.ID].ID + " " + newsItem.headline);				//increment the id				_idIncrement++;			}									//increment the offset			if (_offset < 20) {				_offset += 20;				load();			} else {				//remove the listeners				loader.removeEventListener(Event.COMPLETE, _onXMLLoaded);				loader.removeEventListener(Event.COMPLETE, _onIOErrorEvent);				//dispatch event				dispatchEvent( new Event(LOADED) );			}		}				//return the objects		public function get getNewsItems():Array {			return newsItems;		}			}}