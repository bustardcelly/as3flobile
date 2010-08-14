package com.custardbelly.as3flobile.example.web.view
{
	import com.custardbelly.as3flobile.example.web.view.component.DropDownExample;
	import com.custardbelly.as3flobile.example.web.view.component.ScrollListExample;
	import com.custardbelly.as3flobile.example.web.view.component.ScrollViewportExample;
	import com.custardbelly.as3flobile.example.web.view.component.TextAreaExample;
	import com.custardbelly.as3flobile.example.web.view.component.ToggleSwitchExample;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class ComponentsPanel extends Sprite
	{
		protected var _displays:Vector.<String>; // Fully wualified classname.
		protected var _displayMap:Dictionary;
		protected var _currentDisplay:DisplayObject;
		protected var _selectedIndex:int;
		
		private var viewportexample:ScrollViewportExample; ScrollViewportExample;
		private var toggleswitchexample:ToggleSwitchExample; ToggleSwitchExample;
		private var textareaexample:TextAreaExample; TextAreaExample;
		private var scrolllistexample:ScrollListExample; ScrollListExample;
		private var dropdownexample:DropDownExample; DropDownExample;
		
		public function ComponentsPanel()
		{
			_displays = Vector.<String>(["com.custardbelly.as3flobile.example.web.view.component.ScrollViewportExample",
										"com.custardbelly.as3flobile.example.web.view.component.ScrollListExample",
										"com.custardbelly.as3flobile.example.web.view.component.TextAreaExample",
										"com.custardbelly.as3flobile.example.web.view.component.ToggleSwitchExample",
										"com.custardbelly.as3flobile.example.web.view.component.DropDownExample"]);
			_displayMap = new Dictionary( true );
			
			drawBackground();
			invalidateSelection();
		}
		
		protected function drawBackground():void
		{
			graphics.clear();
			graphics.beginFill( 0xEEEEEE );
			graphics.drawRoundRect( 0, 0, 320, 450, 5, 5 );
			graphics.endFill();
		}
		
		protected function getDisplay( className:String ):DisplayObject
		{
			if( _displayMap[className] == null )
			{
				var clazz:Class = getDefinitionByName( className ) as Class;
				var display:DisplayObject = new clazz() as DisplayObject;
				_displayMap[className] = display;
			}
			return _displayMap[className] as DisplayObject;
		}
		
		protected function invalidateSelection():void
		{
			if( _displays.length > _selectedIndex )
			{
				var display:DisplayObject = getDisplay( _displays[_selectedIndex] );
				if( display )
				{
					if( _currentDisplay ) removeChild( _currentDisplay );
					
					display.x = display.y = 10;
					addChild( display );
					_currentDisplay = display;
				}
			}
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex( value:int ):void
		{
			if( _selectedIndex == value ) return;
			
			_selectedIndex = value;
			invalidateSelection();
		}
	}
}