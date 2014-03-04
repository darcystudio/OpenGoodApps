﻿package  {		import com.adobe.serialization.json.*;	import com.greensock.*;	import com.greensock.easing.*;	import com.greensock.loading.*;	import com.greensock.events.LoaderEvent;	import com.greensock.loading.display.ContentDisplay;		import flash.display.MovieClip;	import flash.display.StageDisplayState;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.events.MouseEvent;	import flash.net.navigateToURL;	import flash.net.URLRequest;		public class ClockApp extends MovieClip 	{				public var serverURL:String;		public var fullscreenButton:MovieClip;		public var doneButton:MovieClip;						public var clockMask:MovieClip;		public var clockAppIcon:MovieClip;		public var clock:MovieClip;				public var clockBackground:MovieClip;		public var clockTimeText:MovieClip;		public var clockHourHand:MovieClip;		public var clockMinuteHand:MovieClip;		public var clockSecondHand:MovieClip;						var clockAppIconImageLoader:ImageLoader;		var clockBackgroundImageLoader:ImageLoader;		var clockTimeTextImageLoader:ImageLoader;		var clockHourHandImageLoader:ImageLoader;		var clockMinuteHandImageLoader:ImageLoader;		var clockSecondHandImageLoader:ImageLoader;									public var timer:Timer;						public var watchDaSound:WatchDaSound;		public var watchDsSound:WatchDsSound;		public var schoolSound:SchoolSound;								public var r0:Number;		public var r1:Number;		public var r2:Number;		public var r3:Number;		public var hourOffset:Number;								public function ClockApp() 		{			if(this.loaderInfo.parameters["serverURL"] != null)			{				this.serverURL = this.loaderInfo.parameters["serverURL"];				trace(serverURL);			}			else			{				this.serverURL = "";				trace("serverURL = null");			}									if(fullscreenButton != null)			{				fullscreenButton.addEventListener(MouseEvent.CLICK, fullscreenButtonClick);			}						if(doneButton != null)			{				doneButton.addEventListener(MouseEvent.CLICK, doneButtonClick);			}									clockMask.visible = false;			clockMask.alpha = 0;			clockMask.scaleX = 0;			clockMask.scaleY = 0;						clockAppIcon.visible = false;			clockAppIcon.alpha = 0;			clockAppIcon.scaleX = 0;			clockAppIcon.scaleY = 0;						clock.visible = false;			clock.alpha = 0;			clock.scaleX = 0;			clock.scaleY = 0;									clockBackground = clock.clockBackground;			clockTimeText = clock.clockTimeText;			clockHourHand = clock.clockHourHand;			clockMinuteHand = clock.clockMinuteHand;			clockSecondHand = clock.clockSecondHand;						clockAppIcon.removeChildAt(0);			clockAppIconImageLoader = new ImageLoader("ClockAppIcon.png", {name:"ClockAppIcon.png", container:clockAppIcon, x:0, y:0, width:220, height:220, scaleMode:"proportionalInside", centerRegistration:true, noCache:true, onComplete:onImageLoad}); 			clockAppIconImageLoader.load();						TweenMax.to(clockAppIcon, 0.5, {delay:1.0, autoAlpha:1, scaleX:0.5, scaleY:0.5, ease:Strong.easeOut});			//clockAppIcon.addEventListener(MouseEvent.CLICK, appLaunch);			//init();			TweenMax.delayedCall(2.5, appLaunch);		}						public function appLaunch():void		{			TweenMax.to(clockAppIcon, 0.5, {autoAlpha:0, ease:Strong.easeOut});			//this.stage.color = 0x000000;						TweenMax.to(clock, 0.5, {delay:0.5, autoAlpha:1, scaleX:0.5, scaleY:0.5, ease:Strong.easeOut});			TweenMax.delayedCall(0.5, init);						//return;			clockBackground.removeChildAt(0);			clockTimeText.removeChildAt(0);			clockHourHand.removeChildAt(0);			clockMinuteHand.removeChildAt(0);			clockSecondHand.removeChildAt(0);						clockBackgroundImageLoader = new ImageLoader("ClockBackground.png", {name:"ClockBackground.png", container:clockTimeText, x:0, y:0, width:1280, height:720, scaleMode:"proportionalInside", centerRegistration:true, noCache:true, onComplete:onImageLoad}); 			clockBackgroundImageLoader.load();						clockTimeTextImageLoader = new ImageLoader("ClockTimeText.png", {name:"ClockTimeText.png", container:clockTimeText, x:0, y:0, width:720, height:720, scaleMode:"proportionalInside", centerRegistration:true, noCache:true, onComplete:onImageLoad}); 			clockTimeTextImageLoader.load();						clockHourHandImageLoader = new ImageLoader("ClockHourHand.png", {name:"ClockHourHand.png", container:clockHourHand, x:0, y:0, width:720, height:720, scaleMode:"proportionalInside", centerRegistration:true, noCache:true, onComplete:onImageLoad}); 			clockHourHandImageLoader.load();						clockMinuteHandImageLoader = new ImageLoader("ClockMinuteHand.png", {name:"ClockHinuteHand.png", container:clockMinuteHand, x:0, y:0, width:720, height:720, scaleMode:"proportionalInside", centerRegistration:true, noCache:true, onComplete:onImageLoad}); 			clockMinuteHandImageLoader.load();						clockSecondHandImageLoader = new ImageLoader("ClockSecondHand.png", {name:"ClockSecondHand.png", container:clockSecondHand, x:0, y:0, width:720, height:720, scaleMode:"proportionalInside", centerRegistration:true, noCache:true, onComplete:onImageLoad}); 			clockSecondHandImageLoader.load();		}						public function init()		{					var date:Date = new Date();						//trace(date.hours, date.minutes, date.seconds, date.timezoneOffset/60);						var secondRotation:Number = (date.seconds)*6;			var minuteRotation:Number = (date.minutes)*6;			var hourRotation:Number = (date.hours%12)*30 + (date.minutes/60)*30;			//var sunMoonPlateRotation:Number = -1*((date.hours)%24)*15;						clockHourHand.rotation = hourRotation;			clockMinuteHand.rotation = minuteRotation;			clockSecondHand.rotation = secondRotation;			//sunMoonPlate.rotation = sunMoonPlateRotation;												//var timeZone:Number = -1*(date.timezoneOffset/60);			//var cityPlateRotation:Number = -1*timeZone*15;			//cityPlate.rotation = cityPlateRotation;			//this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			hourOffset = 0;									watchDaSound = new WatchDaSound();			watchDsSound = new WatchDsSound();			schoolSound = new SchoolSound();			//schoolSound.play();									timer = new Timer(1000);			timer.addEventListener(TimerEvent.TIMER, updateTime);			timer.start();					}						function onImageLoad(event:LoaderEvent):void 		{			//clockSecondHand = event.target.content;		}						public function updateTime(event:TimerEvent):void		{			var date:Date = new Date();						//trace(date.hours, date.minutes, date.seconds);						var secondRotation:Number = (date.seconds)*6;			var minuteRotation:Number = (date.minutes)*6;			var hourRotation:Number = (date.hours%12)*30 + (date.minutes/60)*30;			//var sunMoonPlateRotation:Number = -1*((date.hours)%24)*15;									clockHourHand.rotation = hourRotation + hourOffset;			clockMinuteHand.rotation = minuteRotation;			clockSecondHand.rotation = secondRotation;			//sunMoonPlate.rotation = sunMoonPlateRotation - hourOffset/2;						//watchDsSound.play();						if(date.seconds == 0)			{				//schoolSound.play();  				if(date.minutes == 0 ||				   date.minutes == 25 ||				   date.minutes == 30 ||				   date.minutes == 55)				{					schoolSound.play();  				}			}		}								public function mouseDown(event:MouseEvent):void		{			//trace(event.stageX, event.stageY);			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);						//r0 = cityPlate.rotation;			r3 = hourOffset;			r1 = Math.atan2((event.stageY - 360), (event.stageX - 640))*180/Math.PI+450;			//trace(r1%360);						//hourOffset = 0;								}				public function mouseMove(event:MouseEvent):void		{			//trace(event.stageX, event.stageY);			r2 = Math.atan2((event.stageY - 360), (event.stageX - 640))*180/Math.PI+450;			//trace(r2%360);						var h1:int = clockHourHand.rotation/30+12;						//cityPlate.rotation = r0 + r2 - r1;						hourOffset = r3 -1*(r2-r1)*2;			var date:Date = new Date();			var hourRotation:Number = (date.hours%12)*30 + (date.minutes/60)*30;			//var sunMoonPlateRotation:Number = -1*((date.hours)%24)*15;			clockHourHand.rotation = hourRotation + hourOffset;			//sunMoonPlate.rotation = sunMoonPlateRotation - hourOffset/2;						//var h2:int = clockHourHand.rotation/30+12;			//if(h1 != h2)			//{			//	watchDaSound.play();				//}								}				public function mouseUp(event:MouseEvent):void		{			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);		}								public function fullscreenButtonClick(event:MouseEvent):void		{			if(stage.displayState == StageDisplayState.NORMAL)			{				stage.displayState = StageDisplayState.FULL_SCREEN;			}			else			{				stage.displayState = StageDisplayState.NORMAL;			}		}						public function doneButtonClick(event:MouseEvent):void		{			if(this.serverURL != "")			{				var urlRequest:URLRequest = new URLRequest(serverURL);				navigateToURL(urlRequest, "_self");			}		}							}	}