package com.custardbelly.as3flobile.example.web.view.component
{
	import com.bit101.components.PushButton;
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.list.ScrollList;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListHorizontalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListLayout;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListHorizontalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollListExample extends Sprite
	{
		protected var _list:ScrollList;
		protected var _verticalLayout:IScrollListVerticalLayout;
		protected var _horizontalLayout:IScrollListHorizontalLayout;
		
		protected var _isVariableSize:Boolean;
		protected var _layoutState:uint;
		
		private static const STATE_VERT:uint = 0;
		private static const STATE_HORIZ:uint = 1;
		
		public function ScrollListExample()
		{
			var label:Label = new Label();
			label.text = "ScrollList Example:";
			label.autosize = true;
			addChild( label );
				
			_verticalLayout = new ScrollListVerticalLayout();
			_verticalLayout.itemHeight = 60;
			_verticalLayout.useVariableHeight = false;
			
			_horizontalLayout = new ScrollListHorizontalLayout();
			_horizontalLayout.itemWidth = 100;
			_horizontalLayout.useVariableWidth = false;
			
			_layoutState = ScrollListExample.STATE_VERT;
			
			_list = new ScrollList();
			_list.width = 300;
			_list.height = 300;
			_list.y = 30;
			_list.layout = _verticalLayout
			addChild( _list );
			
			_list.dataProvider = getList( 40 );
			
			var button:Button = new Button();
			button.label = "switch layout";
			button.x = 0;
			button.y = 340;
			button.addEventListener( MouseEvent.CLICK, handleSwitchLayout );
			addChild( button );
			
//			button = new Button();
//			button.label = "toggle variable size";
//			button.x = 110;
//			button.y = 340;
//			button.addEventListener( MouseEvent.CLICK, handleVariableSize );
//			addChild( button );
		}
		
		protected function randomRange( min:int, max:int ):int
		{
			return Math.random() * (max - min + 1) + min;
		}
		
		protected function getList( length:int ):Array
		{
			var arr:Array = new Array( length );
			for( var i:int = 0; i < length; i++ )
			{
				arr[i] = {label:"Item Renderer " + ( i + 1 ).toString()};
			}
			return arr;
		}
		
		protected function handleSwitchLayout( evt:Event ):void
		{
			_layoutState = ( _layoutState == ScrollListExample.STATE_VERT ) ? ScrollListExample.STATE_HORIZ : ScrollListExample.STATE_VERT;
			if( _layoutState == ScrollListExample.STATE_HORIZ )
			{
				_list.layout = _horizontalLayout;
			}
			else
			{
				_list.layout = _verticalLayout;
			}
		}
		
		protected function handleVariableSize( evt:Event ):void
		{
			_isVariableSize = !_isVariableSize;
			_verticalLayout.useVariableHeight = _isVariableSize;
			_horizontalLayout.useVariableWidth = _isVariableSize;
		}
	}
}