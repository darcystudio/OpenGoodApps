package com.darcystudio.Clock;



import java.util.Calendar;

import android.os.BatteryManager;
import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Menu;
import android.view.Window;
import android.view.WindowManager;
//import android.view.View;
//import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.RelativeLayout;

//public class MainActivity extends Activity implements OnTouchListener
public class MainActivity extends Activity
{

	ImageView timeText;
	ImageView hourHand;
	ImageView minuteHand;
	ImageView secondHand;
	//ImageView sunMoonPlate;
	//ImageView cityPlate;
	//ImageView watchBody;
	
	int currentSecondRotation;
	int currentMinuteRotation;
	int currentHourRotation;
	//int currentSunMoonPlateRotation;
	//int currentCityPlateRotation;
	
	
	float scale;
	
	Handler timeHandler;
	int startTime;
	
	int r0;
	int r1;
	int r2;
	int r3;
	int hourOffset;
	long touchTime;
	
	
	//SoundPool soundPool;
	//int daSoundID;
	//int dsSoundID;
	
	
	boolean isInBackground;
	boolean isDestroyed;
	
	boolean idleTimerDisabled;
	int batteryStatus;
	int batteryLevel;
	
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		
		this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		idleTimerDisabled = true;
		batteryStatus = 0;
		batteryLevel = 0;
		
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		
		
		this.init();
	}

	
	@Override
	protected void onDestroy()
	{
		isDestroyed = true;
		
		// TODO Auto-generated method stub
		super.onDestroy();
	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	
	public void init()
	{
		
		RelativeLayout layout = (RelativeLayout)findViewById(R.id.mainLayout);
		layout.setBackgroundColor(Color.BLACK);
		
		
		DSCustomLayout customLayout = (DSCustomLayout)findViewById(R.id.customLayout);
		
		
		DisplayMetrics dm = new DisplayMetrics();
    	this.getWindowManager().getDefaultDisplay().getMetrics(dm);
    	Log.d("Screen", String.valueOf(dm.widthPixels));
    	Log.d("Screen", String.valueOf(dm.heightPixels));
    	//scale = (float)dm.widthPixels/320;
    	int w = dm.widthPixels;
    	int h = dm.heightPixels;
    	int size = 768;
    	size = (w < h) ? w : h;
    	int left = (w-size)/2;
    	int top = (h-size)/2;
    	
    	
    	//hourHand = (ImageView)this.findViewById(R.id.hourHand);
    	//minuteHand = (ImageView)this.findViewById(R.id.minuteHand);
    	//secondHand = (ImageView)this.findViewById(R.id.secondHand);
    	//sunMoonPlate = (ImageView)this.findViewById(R.id.sunMoonPlate);
    	//cityPlate = (ImageView)this.findViewById(R.id.cityPlate);
        //watchBody = (ImageView)this.findViewById(R.id.watchBody);
    	timeText = new ImageView(this);
    	hourHand = new ImageView(this);
    	minuteHand = new ImageView(this);
    	secondHand = new ImageView(this);
    	
    	timeText.setImageResource(R.drawable.timetext); 
    	hourHand.setImageResource(R.drawable.hourhand);
    	minuteHand.setImageResource(R.drawable.minutehand);
    	secondHand.setImageResource(R.drawable.secondhand);
    	
    	timeText.layout(left, top, left+size, top+size);
    	hourHand.layout(left, top, left+size, top+size);
    	minuteHand.layout(left, top, left+size, top+size);
    	secondHand.layout(left, top, left+size, top+size);
    	
    	customLayout.addView(timeText);
    	customLayout.addView(hourHand);
    	customLayout.addView(minuteHand);
    	customLayout.addView(secondHand);    	
    	
    	
    	
    	Calendar date = Calendar.getInstance();
    	int seconds = date.get(Calendar.SECOND);
    	int minutes = date.get(Calendar.MINUTE);
    	int hours = date.get(Calendar.HOUR_OF_DAY);
    	
    	int secondRotation = seconds*6;
    	int minuteRotation = minutes*6;
    	int hourRotation = (hours%12)*30 + 30*minutes/60;
    	//int sunMoonPlateRotation = -1*((hours)%24)*15;
    	
    	
        RotateAnimation hourAnimation;
        hourAnimation = new RotateAnimation(0, hourRotation, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        hourAnimation.setDuration(100);
        hourAnimation.setFillAfter(true);
        hourHand.startAnimation(hourAnimation);
        
        RotateAnimation minuteAnimation;
        minuteAnimation = new RotateAnimation(0, minuteRotation, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        minuteAnimation.setDuration(100);
        minuteAnimation.setFillAfter(true);
        minuteHand.startAnimation(minuteAnimation);
        
        RotateAnimation secondAnimation;
        secondAnimation = new RotateAnimation(0, secondRotation, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        secondAnimation.setDuration(100);
        secondAnimation.setFillAfter(true);
        secondHand.startAnimation(secondAnimation);
        
        
        //RotateAnimation sunMoonPlateAnimation;
        //sunMoonPlateAnimation = new RotateAnimation(0, sunMoonPlateRotation, scale*30, scale*30);
        //sunMoonPlateAnimation.setDuration(100);
        //sunMoonPlateAnimation.setFillAfter(true);
        //sunMoonPlate.startAnimation(sunMoonPlateAnimation);
        
        currentSecondRotation = secondRotation;
    	currentMinuteRotation = minuteRotation;
    	currentHourRotation = hourRotation;
    	//currentSunMoonPlateRotation = sunMoonPlateRotation;
    	
    	
    	
    	//int timezoneOffset = date.get(Calendar.ZONE_OFFSET);
    	//int timeZone = (timezoneOffset/60/60/1000);
    	//int cityPlateRotation = -1*timeZone*15;
    	//RotateAnimation cityPlateAnimation;
    	//cityPlateAnimation = new RotateAnimation(0, cityPlateRotation, scale*137, scale*137);
    	//cityPlateAnimation.setDuration(100);
    	//cityPlateAnimation.setFillAfter(true);
        //cityPlate.startAnimation(cityPlateAnimation);
		//currentCityPlateRotation = cityPlateRotation;
		//hourOffset = 0;
		
    	//cityPlate.setOnTouchListener(this);
    	
    	
    	Log.d("Init", String.valueOf(seconds));
    	Log.d("Init", String.valueOf(minutes));
    	Log.d("Init", String.valueOf(hours));
    	//Log.d("Init", String.valueOf(timezoneOffset));
        
        timeHandler = new Handler();
        startTime = 0;
        timeHandler.postDelayed(updateTime, 1000);
        
        
        //soundPool = new SoundPool(2, AudioManager.STREAM_MUSIC, 0);
		//daSoundID = soundPool.load(this, R.raw.sound_da, 1);
		//dsSoundID = soundPool.load(this, R.raw.sound_ds, 1);
		
		
		isInBackground = false;
		isDestroyed = false;
		
	}
	
	
	
	private Runnable updateTime = new Runnable()
    {
    	public void run()
    	{
    		if(isDestroyed == true)
    		{
    			return;
    		}
    		
    		if(isInBackground == true)
    		{
    			timeHandler.postDelayed(updateTime, 1000);
    			return;
    		}
    		
    		Calendar date = Calendar.getInstance();
        	int seconds = date.get(Calendar.SECOND);
        	int minutes = date.get(Calendar.MINUTE);
        	int hours = date.get(Calendar.HOUR_OF_DAY);
        	
        	int secondRotation = seconds*6;
        	int minuteRotation = minutes*6;
        	int hourRotation = (hours%12)*30 + 30*minutes/60;
        	//int sunMoonPlateRotation = -1*((hours)%24)*15;
        	
  
            RotateAnimation hourAnimation;
            hourAnimation = new RotateAnimation(currentHourRotation, hourRotation + hourOffset, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
            hourAnimation.setDuration(0);
            hourAnimation.setFillBefore(true);
            hourAnimation.setFillAfter(true);
            hourHand.startAnimation(hourAnimation);
            
            RotateAnimation minuteAnimation;
            minuteAnimation = new RotateAnimation(currentMinuteRotation, minuteRotation, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
            minuteAnimation.setDuration(0);
            minuteAnimation.setFillBefore(true);
            minuteAnimation.setFillAfter(true);
            minuteHand.startAnimation(minuteAnimation);
            
            RotateAnimation secondAnimation;
            secondAnimation = new RotateAnimation(currentSecondRotation, secondRotation, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
            secondAnimation.setDuration(0);
            secondAnimation.setFillBefore(true);
            secondAnimation.setFillAfter(true);
            secondHand.startAnimation(secondAnimation);
            
            //RotateAnimation sunMoonPlateAnimation;
            //sunMoonPlateAnimation = new RotateAnimation(currentSunMoonPlateRotation, sunMoonPlateRotation - hourOffset/2, scale*30, scale*30);
            //sunMoonPlateAnimation.setDuration(0);
            //sunMoonPlateAnimation.setFillBefore(true);
            //sunMoonPlateAnimation.setFillAfter(true);
            //sunMoonPlate.startAnimation(sunMoonPlateAnimation);
            
            
            currentSecondRotation = secondRotation;
        	currentMinuteRotation = minuteRotation;
        	currentHourRotation = hourRotation + hourOffset;
        	//currentSunMoonPlateRotation = sunMoonPlateRotation - hourOffset/2;
            
            timeHandler.postDelayed(updateTime, 1000);
            
      
            //soundPool.play(daSoundID, 0.1f, 0.1f, 0, 0, 1.0f);
            
            
            startTime++;
            
            if(startTime%60 == 0)
            {
                if(idleTimerDisabled == true)
                {
                     
                    if(batteryStatus == 0)
                    {
                        if(batteryLevel < 20)
                        {
                            //[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                            //this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                        	getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                        	idleTimerDisabled = false;
                        }
                    }
                    
                }
                else
                {
                	
                    if(batteryStatus == 1 ||
                       batteryLevel > 20)
                    {
                        //[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                    	getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                        idleTimerDisabled = true;
                    }
                    
                }
            }
    	}
    };

    
    
//	@Override
//	public boolean onTouch(View v, MotionEvent event) {
//		// TODO Auto-generated method stub
//		//Log.d("touch", String.valueOf(event.getX()));
//		//Log.d("touch", String.valueOf(event.getY()));
//		
//		
//		float x = event.getX();
//		float y = event.getY();
//		
//		if(event.getAction() == MotionEvent.ACTION_DOWN)
//		{
//			Log.d("touch", "began");
//			r0 = currentCityPlateRotation;
//			r3 = hourOffset;
//			r1 = (int) (Math.atan2((y - 137), (x - 137))*180/Math.PI+450);
//			
//			touchTime = Calendar.getInstance().getTimeInMillis();
//		}
//		else if(event.getAction() == MotionEvent.ACTION_MOVE)
//		{
//			
//			long newTouchTime = Calendar.getInstance().getTimeInMillis();
//			if(newTouchTime - touchTime < 20)
//			{
//				Log.d("touch", "pass");
//				return true;
//			}
//			touchTime = newTouchTime;
//			
//			
//			
//			Log.d("touch", "moved");
//			
//			r2 = (int) (Math.atan2((y - 137), (x - 137))*180/Math.PI+450);
//
//			
//			int h1 = currentHourRotation/30+12;
//			
//			
//			
//			int cityPlateRotation = r0 + r2 - r1;
//			RotateAnimation cityPlateAnimation;
//	    	cityPlateAnimation = new RotateAnimation(currentCityPlateRotation, cityPlateRotation, scale*137, scale*137);
//	    	cityPlateAnimation.setDuration(0);
//	    	cityPlateAnimation.setFillAfter(true);
//	        cityPlate.startAnimation(cityPlateAnimation);
//	        currentCityPlateRotation = cityPlateRotation;
//	        
//	        
//	       
//			hourOffset = r3 -1*(r2-r1)*2;
//			
//		
//			Calendar date = Calendar.getInstance();
//        	int minutes = date.get(Calendar.MINUTE);
//        	int hours = date.get(Calendar.HOUR_OF_DAY);
//        	
//        	int hourRotation = (hours%12)*30 + (minutes/60)*30;
//        	int sunMoonPlateRotation = -1*((hours)%24)*15;
//        	
//            RotateAnimation hourAnimation;
//            hourAnimation = new RotateAnimation(currentHourRotation, hourRotation + hourOffset, scale*90, scale*90);
//            hourAnimation.setDuration(0);
//            hourAnimation.setFillBefore(true);
//            hourAnimation.setFillAfter(true);
//            hourHand.startAnimation(hourAnimation);
//            
//            
//            RotateAnimation sunMoonPlateAnimation;
//            sunMoonPlateAnimation = new RotateAnimation(currentSunMoonPlateRotation, sunMoonPlateRotation - hourOffset/2, scale*30, scale*30);
//            sunMoonPlateAnimation.setDuration(0);
//            sunMoonPlateAnimation.setFillBefore(true);
//            sunMoonPlateAnimation.setFillAfter(true);
//            sunMoonPlate.startAnimation(sunMoonPlateAnimation);
//            
//            
//        	currentHourRotation = hourRotation + hourOffset;
//        	currentSunMoonPlateRotation = sunMoonPlateRotation - hourOffset/2;
//			
//			
//			
//			int h2 = currentHourRotation/30+12;
//			if(h1 != h2)
//			{
//        		soundPool.play(daSoundID, 1.0f, 1.0f, 0, 0, 1.0f);	
//        	}
//			
//		}
//		else if(event.getAction() == MotionEvent.ACTION_UP)
//		{
//			Log.d("touch", "ended");
//		}
//		else
//		{
//			return false;
//		}
//		
//		return true;
//	}


	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		
		isInBackground = true;
		
		
	}


	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		
		isInBackground = false;
		
		IntentFilter filter = new IntentFilter();
		filter.addAction(Intent.ACTION_BATTERY_CHANGED);
		this.registerReceiver(broadcastReceiver, filter);
	}
	
	
	private BroadcastReceiver broadcastReceiver = new BroadcastReceiver()
	{

		@Override
		public void onReceive(Context arg0, Intent arg1)
		{
			String action = arg1.getAction();
			if(action.equals(Intent.ACTION_BATTERY_CHANGED))
			{
				int status = arg1.getIntExtra("status", 0);
				int level = arg1.getIntExtra("level", 0);
				
				switch(status)
				{
				case BatteryManager.BATTERY_STATUS_UNKNOWN:
					batteryStatus = 0;
					break;
				case BatteryManager.BATTERY_STATUS_CHARGING:
					batteryStatus = 1;
					break;
				case BatteryManager.BATTERY_STATUS_DISCHARGING:
					batteryStatus = 1;
					break;
				case BatteryManager.BATTERY_STATUS_NOT_CHARGING:
					batteryStatus = 0;
					break;
				case BatteryManager.BATTERY_STATUS_FULL:
					batteryStatus = 1;
					break;
				}
				
				batteryLevel = level;
				
				Log.d("Battery", "batteryStatus = " + batteryStatus);
				Log.d("Battery", "batteryLevel = " + batteryLevel);
			}
		}
	};

}
