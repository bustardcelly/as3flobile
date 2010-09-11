package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.button.IButtonDelegate;
	import com.custardbelly.as3flobile.controls.button.IToggleButtonDelegate;
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.list.ScrollList;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListHorizontalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListHorizontalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	
	import flash.display.Sprite;
	
	public class ScrollListExample extends Sprite implements IToggleButtonDelegate, IButtonDelegate
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
			
			label = new Label();
			label.multiline = true;
			label.autosize = true;
			label.width = 300;
			label.y = 30;
			label.text = "A ScrollList control is a list that reponds to mouse/touch gestures to traverse through a list of items.";
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
			_list.y = 90;
			_list.layout = _verticalLayout
			addChild( _list );
			
			_list.dataProvider = getList( 40 );
			
			var button:Button = Button.initWithDelegate( this );
			button.label = "switch layout";
			button.x = 0;
			button.y = 400;
			addChild( button );
			
			var tbutton:ToggleButton = ToggleButton.initWithDelegate( this );
			tbutton.label = "toggle variable size";
			tbutton.x = 110;
			tbutton.y = 400;
			addChild( tbutton );
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
		
		public function buttonTapped( button:Button ):void
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
		
		public function toggleButtonSelectionChange( toggleButton:ToggleButton, selected:Boolean ):void
		{
			_isVariableSize = selected;
			_verticalLayout.useVariableHeight = _isVariableSize;
			_horizontalLayout.useVariableWidth = _isVariableSize;
		}
	}
}