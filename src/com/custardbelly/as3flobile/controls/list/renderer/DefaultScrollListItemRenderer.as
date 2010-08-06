/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: DefaultScrollListItemRenderer.as</p>
 * <p>Version: 0.1</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */
package com.custardbelly.as3flobile.controls.list.renderer
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	/**
	 * DefaultScrollListItemRenderer is the default item renderer for a IScrollListContainer.
	 * The recognize object model for the data supplied to this class is {label:"your label"}. The label property of the object model is represented textually.
	 * @author toddanderson
	 */
	public class DefaultScrollListItemRenderer extends AS3FlobileComponent implements IScrollListItemRenderer
	{
		private static const STATE_UNLOCKED:uint = 0;
		private static const STATE_LOCKED:uint = 1;
		
		protected var _background:Shape;
		protected var _block:TextBlock;
		
		protected var _format:ElementFormat;
		protected var _color:uint = 0xFFFFFF;
		protected var _selectedColor:uint = 0xDDDDDD;
		
		protected var _selected:Boolean;
		
		protected var _isDirty:Boolean;
		protected var _currentState:uint = DefaultScrollListItemRenderer.STATE_UNLOCKED;
		protected var _useVariableWidth:Boolean;
		protected var _useVariableHeight:Boolean;
		
		protected var _data:Object;
		
		protected var _padding:int;
		
		/**
		 * Constructor.
		 */
		public function DefaultScrollListItemRenderer()
		{
			initialize();
			createChildren();
		}
		
		/**
		 * @private 
		 * 
		 * Initializes any proper data for composition.
		 */
		protected function initialize():void
		{
			this.cacheAsBitmap = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			_width = 100;
			_height = 20;
			
			_padding = 3;
			
			_format = new ElementFormat( new FontDescription( "DroidSans" ) );
			_format.fontSize = 14;
			_block = new TextBlock();
		}
		
		/**
		 * @private 
		 * 
		 * Creates any required display children.
		 */
		protected function createChildren():void
		{
			_background = new Shape();
			addChild( _background );
		}
		
		/**
		 * @private
		 * 
		 * Validates a property and forwards along method invocation based on current state. 
		 * @param handler Function
		 * @param args ...
		 */
		protected function invalidateProperty( handler:Function, ...args ):void
		{
			var isUnlocked:Boolean = _currentState == DefaultScrollListItemRenderer.STATE_UNLOCKED;
			if( isUnlocked )
				handler.apply( this, args );
			else
				_isDirty = true;
		}
		
		/**
		 * @private 
		 * 
		 * Validates the supplied data and updates the display.
		 */
		protected function invalidateData():void
		{
			// If no data and this was called in response to a property change, move on.
			if( _data == null ) return;
			
			var i:int = numChildren;
			while( --i > 0 )
			{
				removeChildAt( i );
			}
			
			// Use TextBlock factory to create TextLines and add to the display.
			_block.content = new TextElement( _data.label, _format );
			var w:int = ( _useVariableWidth ) ? 1000000 : _width - ( _padding * 2 );
			var line:TextLine = _block.createTextLine( null, w );
			var offset:int = 3;
			var maxLineWidth:int = 0;
			var ypos:int = _padding;
			while( line )
			{
				ypos += line.height;
				line.y = int(ypos);
				line.x = _padding;
				addChild( line );
				
				ypos += ( line.ascent - line.descent )
				
				// If using variable height, reassign height to new height of line.
				if( _useVariableHeight ) _height = ypos;
				// Hold reference for widest line to be used to determine true width if using variable dimensions.
				maxLineWidth = line.width > maxLineWidth ? line.width : maxLineWidth;
				// Get next line from factory.
				line = _block.createTextLine( line, w );
			} 
			// If using variable width, reassign width property to largest line.
			if( _useVariableWidth ) _width = maxLineWidth;
			
			_isDirty = false;
			invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the size determined from #invalidateData.
		 */
		override protected function invalidateSize():void
		{
			invalidateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the display based on determined propeties from #invalidateData
		 */
		protected function invalidateDisplay():void
		{
			_background.graphics.clear();
			_background.graphics.beginFill( ( _selected ) ? _selectedColor : _color );
			_background.graphics.drawRect( 0, 0, _width, _height );
		}
		
		/**
		 * @private
		 * 
		 * Updates the current state.  
		 * @param oldState uint
		 * @param newState uint
		 */
		protected function handleStateChange( oldState:uint, newState:uint ):void
		{
			_currentState = newState;
			
			// If properties have changed, run an update.
			if( _currentState == DefaultScrollListItemRenderer.STATE_UNLOCKED && _isDirty )
				invalidateData();
		}
		
		/**
		 * @copy IScrollListItemRenderer#lock()
		 */
		public function lock():void
		{
			handleStateChange( _currentState, DefaultScrollListItemRenderer.STATE_LOCKED );
		}
		
		/**
		 * @copy IScrollListItemRenderer#unlock() 
		 * 
		 */
		public function unlock():void
		{
			handleStateChange( _currentState, DefaultScrollListItemRenderer.STATE_UNLOCKED );
		}
		
		/**
		 * @copy IScrollListItemRenderer#selected
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected( value:Boolean ):void
		{
			if( _selected == value ) return;
			
			_selected = value;
			invalidateProperty( invalidateData );
		}
		
		/**
		 * @copy IScrollListItemRenderer#width
		 */
		override public function set width( value:Number ):void
		{
			if( _width == value ) return;
			
			_width = value;
			invalidateProperty( invalidateData );
		}
		
		/**
		 * @copy IScrollListItemRenderer#height
		 */
		override public function set height( value:Number ):void
		{
			if( _height == value ) return;
			
			_height = value;
			invalidateProperty( invalidateData );
		}
		
		/**
		 * @copy IScrollListItemRenderer#useVariableHeight
		 */
		public function get useVariableHeight():Boolean
		{
			return _useVariableHeight;
		}
		public function set useVariableHeight( value:Boolean ):void
		{
			if( _useVariableHeight == value ) return;
			
			_useVariableHeight = value;
			invalidateProperty( invalidateData );
		}
		
		/**
		 * @copy IScrollListItemRenderer#useVariableWidth
		 */
		public function get useVariableWidth():Boolean
		{
			return _useVariableWidth;
		}
		public function set useVariableWidth( value:Boolean ):void
		{
			if( _useVariableWidth == value ) return;
			
			_useVariableWidth = value;
			invalidateProperty( invalidateData );
		}
		
		/**
		 * @copy IScrollListItemRenderer#data
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data( value:Object ):void
		{
			if( _data == value ) return;
			
			_data = value;	
			invalidateProperty( invalidateData );
		}

		/**
		 * Accessor/Modifier for the offset set padding between the instance's edge and the default content label. Default is 3. 
		 * @return String
		 */
		public function get padding():int
		{
			return _padding;
		}
		public function set padding(value:int):void
		{
			_padding = value;
		}

	}
}