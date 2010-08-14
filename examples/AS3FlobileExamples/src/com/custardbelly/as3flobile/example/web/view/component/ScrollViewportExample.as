package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.dropdown.DropDown;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.viewport.ScrollViewport;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class ScrollViewportExample extends Sprite
	{
		protected var _progressField:Label;
		
		public function ScrollViewportExample()
		{	
			var label:Label = new Label();
			label.text = "ScrollViewport Example:";
			label.autosize = true;
			addChild( label );
			
			_progressField = new Label();
			_progressField.text = "Loading...";
			_progressField.y = 330;
			_progressField.autosize = true;
			addChild( _progressField );
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoadComplete );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, handleLoadProgress );
			loader.load( new URLRequest( "snow_low.jpg" ) );
		}
		
		protected function handleLoadProgress( evt:ProgressEvent ):void
		{
			_progressField.text = "Loading Image... " + ( int( evt.bytesLoaded / evt.bytesTotal ) * 100 ).toString() + "%"	
		}
		
		protected function handleLoadComplete( evt:Event ):void
		{
			( evt.target as LoaderInfo ).removeEventListener( Event.COMPLETE, handleLoadComplete );
			( evt.target as LoaderInfo ).removeEventListener( ProgressEvent.PROGRESS, handleLoadProgress );
			
			var bitmap:Bitmap = ( evt.target as LoaderInfo ).content as Bitmap;
			var content:Sprite = new Sprite();
			content.addChild( bitmap );
			content.cacheAsBitmap = true;
			
			var viewport:ScrollViewport = new ScrollViewport();
			viewport.y = 20;
			viewport.width = 300;
			viewport.height = 300;
			viewport.content = content;
			addChild( viewport );
			
			var dropDown:DropDown = new DropDown();
			dropDown.y = 200;
			dropDown.dataProvider = [{label:"item 1sd fds f sdf dsfdsfdsf ds"}, {label:"item 2"}, {label:"item 3"}, {label:"item 4"}, {label:"item 5"}, {label:"item 6"}, {label:"item 7"},
										{label:"item 8"}, {label:"item 9"}, {label:"item 10"}, {label:"item 11"}, {label:"item 12"}, {label:"item 13"}, {label:"item 14"}]
			addChild( dropDown );
		}
	}
}