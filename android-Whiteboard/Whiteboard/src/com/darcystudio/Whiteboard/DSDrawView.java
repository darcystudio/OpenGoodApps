package com.darcystudio.Whiteboard;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Join;
import android.graphics.Path;
import android.graphics.Paint.Cap;
import android.graphics.PorterDuff;
//import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.util.Log;
//import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

public class DSDrawView extends View
{
	int width = 1280;
	int height = 800;
	Bitmap bitmap;
	Path path;
	int touchCount;
	Rect rect;

	
	String buttonMode;

	public DSDrawView(Context context)
	{
		super(context);
		//this.setBackgroundColor(Color.WHITE);

		DSApplication app = (DSApplication)context.getApplicationContext();
		Log.d("Whiteboard", "w = " + app.screenWidth + " h = " + app.screenHeight);
		width = app.screenWidth;
		height = app.screenHeight;
		
		bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);

		//Canvas canvas = new Canvas(bitmap);

		// canvas.drawColor(Color.WHITE);

		// Paint paint = new Paint();
		// paint.setStyle(Paint.Style.STROKE);
		// paint.setStrokeWidth(32);
		// paint.setAntiAlias(true);
		// paint.setStrokeCap(Cap.ROUND);
		// paint.setStrokeJoin(Join.ROUND);
		//
		// paint.setColor(Color.BLUE);
		// canvas.drawCircle(500, 300, 200, paint);
		//
		//
		// paint.setColor(Color.GREEN);
		// paint.setAlpha(50);
		// canvas.drawLine(300, 300, 700, 300, paint);

		// Path path = new Path();
		// path.moveTo(500, 100);
		// path.lineTo(500, 500);

		// PorterDuffColorFilter filter = new PorterDuffColorFilter(Color.BLACK,
		// PorterDuff.Mode.CLEAR);
		// paint.setColorFilter(filter);
		// paint.setXfermode(new PorterDuffXfermode(Mode.SRC));

		// paint.setColor(Color.RED);
		// paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
		// paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
		// paint.setColor(Color.TRANSPARENT);

		// BitmapShader bitmapShader = new BitmapShader(null, null, null);
		// paint.setShader(bitmapShader);

		// canvas.drawPath(path, paint);

		// paint.setXfermode(null);

		path = null;
		rect = new Rect();
		rect.set(0, 0, 1280, 800);
		// this.invalidate(rect);
		// this.invalidate();

		touchCount = 0;
		buttonMode = "pen1";
	}

	@Override
	protected void onDraw(Canvas canvas)
	{
		super.onDraw(canvas);

		// Log.d("DSDrawView", "onDraw");
		// canvas.drawColor(Color.TRANSPARENT);
		// canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR);

		/*
		 * Paint paint = new Paint(); paint.setStyle(Paint.Style.STROKE);
		 * paint.setStrokeWidth(32); paint.setAntiAlias(true);
		 * paint.setStrokeCap(Cap.ROUND); paint.setColor(Color.BLUE);
		 * canvas.drawCircle(500, 300, 200, paint);
		 * 
		 * paint.setColor(Color.GREEN); paint.setAlpha(50); canvas.drawLine(300,
		 * 300, 700, 300, paint);
		 * 
		 * 
		 * Path path = new Path(); path.moveTo(500, 100); path.lineTo(500, 500);
		 * 
		 * //PorterDuffColorFilter filter = new
		 * PorterDuffColorFilter(Color.BLACK, PorterDuff.Mode.CLEAR);
		 * //paint.setColorFilter(filter); //paint.setXfermode(new
		 * PorterDuffXfermode(Mode.SRC));
		 * 
		 * paint.setColor(Color.RED); paint.setXfermode(new
		 * PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
		 * 
		 * //paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
		 * //paint.setColor(Color.TRANSPARENT);
		 * 
		 * //BitmapShader bitmapShader = new BitmapShader(null, null, null);
		 * //paint.setShader(bitmapShader);
		 * 
		 * canvas.drawPath(path, paint);
		 */

		// Rect bounds = canvas.getClipBounds();
		canvas.drawBitmap(bitmap, 0, 0, null);
		// canvas.drawBitmap(bitmap, bounds, bounds, null);
		// Paint bitmapPaint = new Paint();
		// bitmapPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.));
		// canvas.drawBitmap(bitmap, bounds, bounds, bitmapPaint);

		if (path == null)
		{
			return;
		}

		if (buttonMode == "pen1")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.BLACK);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "pen2")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.BLUE);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "pen3")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.GREEN);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "pen4")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.RED);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "lighter1")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.DKGRAY);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "lighter2")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.BLUE);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "lighter3")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.GREEN);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "lighter4")
		{
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.RED);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "eraser")
		{
			/*
			 * Paint paint = new Paint(); paint.setStyle(Paint.Style.STROKE);
			 * paint.setStrokeWidth(32); paint.setAntiAlias(true);
			 * paint.setStrokeCap(Cap.ROUND); paint.setStrokeJoin(Join.ROUND);
			 * paint.setColor(Color.DKGRAY); canvas.drawPath(path, paint);
			 */
		}
		else if (buttonMode == "clearAll")
		{

		}
		else
		{

		}

	}

	@Override
	public boolean onTouchEvent(MotionEvent event)
	{
		// TODO Auto-generated method stub

		// Log.d("DSDrawView", "onTouchEvent " + event.getX() + ", " +
		// event.getY());

		switch (event.getAction())
		{
		case MotionEvent.ACTION_DOWN:
			touchDown(event.getX(), event.getY());
			break;

		case MotionEvent.ACTION_MOVE:
			touchMove(event.getX(), event.getY());
			break;

		case MotionEvent.ACTION_UP:
			touchUp(event.getX(), event.getY());
			break;
		}

		// return super.onTouchEvent(event);
		return true;
	}

	void touchDown(float x, float y)
	{
		path = new Path();
		path.moveTo(x, y);

		int dx = 10;
		if (buttonMode == "pen1" ||
			buttonMode == "pen2" ||
			buttonMode == "pen3" ||
			buttonMode == "pen4")
		{
			dx = 6;
		}
		else if (buttonMode == "lighter1" ||
				 buttonMode == "lighter2" ||
				 buttonMode == "lighter3" ||
				 buttonMode == "lighter4")
		{
			dx = 32;
		}
		else if (buttonMode == "eraser")
		{
			dx = 128;
		}
		else if (buttonMode == "clearAll")
		{
			dx = 1;
			this.clearAll();
			return;
		}
		else
		{
			
		}
		
		// this.invalidate();
		int left = (int) (x - dx);
		int top = (int) (y - dx);
		int right = (int) (x + dx);
		int bottom = (int) (y + dx);
		rect.set(left, top, right, bottom);
		this.invalidate(rect);

	}

	void touchMove(float x, float y)
	{
		path.lineTo(x, y);

		if (buttonMode == "pen1" ||
			buttonMode == "pen2" ||
			buttonMode == "pen3" ||
			buttonMode == "pen4")
		{

		}
		else if (buttonMode == "lighter1" ||
				 buttonMode == "lighter2" ||
				 buttonMode == "lighter3" ||
				 buttonMode == "lighter4")
		{

		}
		else if (buttonMode == "eraser")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(128);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.DKGRAY);
			paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
			canvas.drawPath(path, paint);
		}
		else if (buttonMode == "clearAll")
		{

		}
		else
		{

		}
		
		
		int dx = 10;
		if (buttonMode == "pen1" ||
			buttonMode == "pen2" ||
			buttonMode == "pen3" ||
			buttonMode == "pen4")
		{
			dx = 6;
		}
		else if (buttonMode == "lighter1" ||
				 buttonMode == "lighter2" ||
				 buttonMode == "lighter3" ||
				 buttonMode == "lighter4")
		{
			dx = 32;
		}
		else if (buttonMode == "eraser")
		{
			dx = 128;
		}
		else if (buttonMode == "clearAll")
		{
			dx = 1;
		}
		else
		{
			
		}

		// this.invalidate();
		int left = (int) (x - dx);
		int top = (int) (y - dx);
		int right = (int) (x + dx);
		int bottom = (int) (y + dx);
		// rect.set(left, top, right, bottom);
		rect.left = (rect.left > left) ? left : rect.left;
		rect.top = (rect.top > top) ? top : rect.top;
		rect.right = (rect.right > right) ? rect.right : right;
		rect.bottom = (rect.bottom > bottom) ? rect.bottom : bottom;
		this.invalidate(rect);

	}

	void touchUp(float x, float y)
	{
		path.lineTo(x, y);

		if (buttonMode == "pen1")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.BLACK);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "pen2")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.BLUE);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "pen3")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.GREEN);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "pen4")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(6);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.RED);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "lighter1")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.DKGRAY);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "lighter2")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.BLUE);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "lighter3")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.GREEN);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "lighter4")
		{
			Canvas canvas = new Canvas(bitmap);
			Paint paint = new Paint();
			paint.setStyle(Paint.Style.STROKE);
			paint.setStrokeWidth(32);
			paint.setAntiAlias(true);
			paint.setStrokeCap(Cap.ROUND);
			paint.setStrokeJoin(Join.ROUND);
			paint.setColor(Color.RED);
			paint.setAlpha(128);
			canvas.drawPath(path, paint);
			path = null;
		}
		else if (buttonMode == "eraser")
		{
			
//			Canvas canvas = new Canvas(bitmap); 
//			Paint paint = new Paint();
//			paint.setStyle(Paint.Style.STROKE); 
//			paint.setStrokeWidth(128);
//			paint.setAntiAlias(true); 
//			paint.setStrokeCap(Cap.ROUND);
//			paint.setStrokeJoin(Join.ROUND); 
//			paint.setColor(Color.DKGRAY);
//			paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
//			canvas.drawPath(path, paint);
			 
			path = null;
		}
		else if (buttonMode == "clearAll")
		{

		}
		else
		{

		}

		// //this.invalidate();
		// int left = (int)(x - 20);
		// int top = (int)(y - 20);
		// int right = (int)(x + 20);
		// int bottom = (int)(y + 20);
		// //rect.set(left, top, right, bottom);
		// rect.left = (rect.left > left) ? left : rect.left;
		// rect.top = (rect.top > top) ? top : rect.top;
		// rect.right = (rect.right > right) ? rect.right : right;
		// rect.bottom = (rect.bottom > bottom) ? rect.bottom : bottom;
		// this.invalidate(rect);

		touchCount++;

		// if(touchCount%3 == 0)
		// {
		// buttonMode = "pen";
		// }
		// else if(touchCount%3 == 1)
		// {
		// buttonMode = "lighter";
		// }
		// else if(touchCount%3 == 2)
		// {
		// buttonMode = "eraser";
		// }
	}
	
	
	void clearAll()
	{
		bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		this.invalidate();
	}
	

}
