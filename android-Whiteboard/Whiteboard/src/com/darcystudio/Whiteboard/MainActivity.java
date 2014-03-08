package com.darcystudio.Whiteboard;

import android.os.Bundle;
import android.app.Activity;
import android.graphics.Point;
import android.util.Log;
import android.view.Display;
import android.view.Menu;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;


public class MainActivity extends Activity
{

	private DSDrawView drawView;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		init();

		// DSDrawView drawView = new DSDrawView(this);
		// setContentView(drawView);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		// Inflate the menu; this adds items to the action bar if it is present.
		// getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

	void init()
	{
		Display display = getWindowManager().getDefaultDisplay();
		Point size = new Point();
		display.getSize(size);
		int width = size.x;
		int height = size.y;
		
		
		Log.d("Whiteboard", "w = " + width + " h = " + height);
		
		DSApplication app = (DSApplication)this.getApplicationContext();
		app.screenWidth = width;
		app.screenHeight = height;
		Log.d("Whiteboard", "w = " + app.screenWidth + " h = " + app.screenHeight);
		//Toast.makeText(this.getApplicationContext(), "w = " + app.screenWidth + " h = " + app.screenHeight, Toast.LENGTH_LONG).show();
		
		
		//RelativeLayout layout = (RelativeLayout)findViewById(R.id.myLayout);
		//DSDrawView drawView = new DSDrawView(this);
		// //drawView.setMinimumWidth(300);
		// //drawView.setMinimumHeight(300);
		// //drawView.invalidate();
		// //drawView.setBackgroundColor(Color.TRANSPARENT);
		//layout.addView(drawView, 0);
		
		//LinearLayout layout = (LinearLayout)findViewById(R.id.customLayout);
		//DSDrawView drawView = new DSDrawView(this);
		//layout.addView(drawView, 0);
		//drawView.layout(0, 0, 1280, 800);

		DSCustomLayout layout = (DSCustomLayout) findViewById(R.id.customLayout);
		drawView = new DSDrawView(this);
		layout.init(drawView);
	}
	
	
	public void onToolButtonClick(View view)
	{
		ImageButton button1 = (ImageButton)findViewById(R.id.button1);
		ImageButton button2 = (ImageButton)findViewById(R.id.button2);
		ImageButton button3 = (ImageButton)findViewById(R.id.button3);
		ImageButton button4 = (ImageButton)findViewById(R.id.button4);
		ImageButton button5 = (ImageButton)findViewById(R.id.button5);
		
		button1.setAlpha(255);
		button2.setAlpha(255);
		button3.setAlpha(255);
		button4.setAlpha(255);
		button4.setAlpha(255);
		button1.setImageResource(R.drawable.button1);
		button2.setImageResource(R.drawable.button2);
		button3.setImageResource(R.drawable.button3);
		button4.setImageResource(R.drawable.button4);
		button5.setImageResource(R.drawable.button5);
		
		
		ImageButton button = (ImageButton)view;
//		String name = button.getText().toString();
//		
//		if(name.equals("pen") == true)
//		{
//			drawView.buttonMode = "pen";
//		}
//		else if(name.equals("lighter") == true)
//		{
//			drawView.buttonMode = "lighter";
//		}
//		else if(name.equals("eraser") == true)
//		{
//			drawView.buttonMode = "eraser";
//		}
//		else if(name.equals("clear all") == true)
//		{
//			drawView.buttonMode = "clearAll";
//		}
//		else
//		{
//			
//		}
		
		switch(button.getId())
		{
		case R.id.button1:
			
			button.setImageResource(R.drawable.button1d);
			
			if(drawView.buttonMode == "pen1")
			{
				button.setAlpha(128);
				drawView.buttonMode = "lighter1";
				break;
			}
			
			drawView.buttonMode = "pen1";
			break;
			
		case R.id.button2:
			
			button.setImageResource(R.drawable.button2d);
			
			if(drawView.buttonMode == "pen2")
			{
				button.setAlpha(128);
				drawView.buttonMode = "lighter2";
				break;
			}
			
			drawView.buttonMode = "pen2";
			break;
			
		case R.id.button3:
			
			button.setImageResource(R.drawable.button3d);
			
			if(drawView.buttonMode == "pen3")
			{
				button.setAlpha(128);
				drawView.buttonMode = "lighter3";
				break;
			}
			
			drawView.buttonMode = "pen3";
			break;
			
		case R.id.button4:
			
			button.setImageResource(R.drawable.button4d);
			
			if(drawView.buttonMode == "pen4")
			{
				button.setAlpha(128);
				drawView.buttonMode = "lighter4";
				break;
			}
			
			drawView.buttonMode = "pen4";
			break;
			
		case R.id.button5:
			
			button.setImageResource(R.drawable.button5d);
			
			if(drawView.buttonMode == "eraser")
			{
				drawView.clearAll();
				break;
			}
			
			drawView.buttonMode = "eraser";
			break;
		default:
		}
			
	}

}
