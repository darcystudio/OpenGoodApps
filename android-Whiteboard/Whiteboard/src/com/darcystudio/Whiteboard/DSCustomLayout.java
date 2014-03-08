package com.darcystudio.Whiteboard;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

public class DSCustomLayout extends ViewGroup
{

	// private int width = 1280;
	// private int height = 800;
	//private float scale = 5.0f;

	public DSCustomLayout(Context context)
	{
		super(context);
	}

	public DSCustomLayout(Context context, AttributeSet attrs)
	{
		super(context, attrs, 0);
	}

	public DSCustomLayout(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);
	}

	public void init(View view)
	{
		Log.d("DSCustomLayout", "init");

		// for(int i=0;i<this.getChildCount();i++)
		// {
		// //View child = this.getChildAt(i);
		//
		// //int w = child.getMeasuredWidth();
		// //int h = child.getMeasuredHeight();
		//
		// Log.d("DSCustomLayout", "init()");
		// }

		this.addView(view, 0);
		//this.scrollTo(0, 300);
		//scale = 5.0f;
		//this.invalidate();
		
		this.setBackgroundColor(Color.WHITE);
		
	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b)
	{
		Log.d("DSCustomLayout", "onLayout");
		// int w = r - l;
		// int h = b - t;

		// int count = this.getChildCount();

		for (int i = 0; i < this.getChildCount(); i++)
		{
			View child = getChildAt(i);

			if (i == 0)
			{
				child.layout(0, 0, 0 + 1280, 0 + 800);
			}
			else
			{
				child.layout(30, 140 + 70 * i, 30 + 60, 140 + 70 * i + 60);
			}
		}

	}

	@Override
	public void onDraw(Canvas canvas)
	{
		//canvas.scale(scale, scale);
		super.onDraw(canvas);
	}

}
