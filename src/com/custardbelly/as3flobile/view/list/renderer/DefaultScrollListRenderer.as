/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: DefaultScrollListRenderer.as</p>
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
package com.custardbelly.as3flobile.view.list.renderer
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	/**
	 * DefaultScrollListRenderer is the default item renderer for a IScrollListContainer.
	 * The recognize object model for the data supplied to this class is {label:"your label"}. The label property of the object model is represented textually.
	 * @author toddanderson
	 */
	public class DefaultScrollListRenderer extends Sprite implements IScrollListRenderer
	{
		protected var _background:Shape;
		protected var _block:TextBlock;
		
		protected var _format:ElementFormat;
		protected var _color:uint = 0xFFFFFF;
		protected var _selectedColor:uint = 0xDDDDDD;
		
		protected var _selected:Boolean;
		
		protected var _width:Number = 100;
		protected var _height:Number = 20;
		protected var _useVariableWidth:Boolean;
		protected var _useVariableHeight:Boolean;
		
		protected var _data:Object;
		
		/**
		 * Constructor.
		 */
		public function DefaultScrollListRenderer()
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
			
			_format = new ElementFormat( new FontDescription( "Arial" ) );
			_format.fontSize = 12;
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
		 * Validates the supplied data and updates the display.
		 */
		protected function invalidateData():void
		{
			var i:int = numChildren;
			while( --i > 0 )
			{
				removeChildAt( i );
			}
			
			// Use TextBlock factory to create TextLines and add to the display.
			_block.content = new TextElement( _data.label, _format );
			var w:Number = ( _useVariableWidth ) ? 1000000 : _width;
			var line:TextLine = _block.createTextLine( null, w );
			var offset:Number = 3;
			var maxLineWidth:Number = 0;
			var ypos:int = 0;
			while( line )
			{
				ypos += line.height;
				line.y = ypos;
				ypos += ( line.ascent - line.descent )
				addChild( line );
				
				// If using variable height, reassign height to new height of line.
				if( _useVariableHeight ) _height = ypos;
				// Hold reference for widest line to be used to determine true width if using variable dimensions.
				maxLineWidth = line.width > maxLineWidth ? line.width : maxLineWidth;
				// Get next line from factory.
				line = _block.createTextLine( line, w );
			} 
			// If using variable width, reassign width property to largest line.
			if( _useVariableWidth ) _width = maxLineWidth;
			
			invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the size determined from #invalidateData.
		 */
		protected function invalidateSize():void
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
		 * @copy IScrollListRenderer#selected
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected( value:Boolean ):void
		{
			if( _selected == value ) return;
			
			_selected = value;
			invalidateDisplay();
		}
		
		/**
		 * @copy IScrollListRenderer#width
		 */
		override public function get width():Number
		{
			return _width;
		}
		override public function set width( value:Number ):void
		{
			if( _width == value ) return;
			
			_width = value;
			invalidateSize();
		}
		
		/**
		 * @copy IScrollListRenderer#height
		 */
		override public function get height():Number
		{
			return _height;
		}
		override public function set height( value:Number ):void
		{
			if( _height == value ) return;
			
			_height = value;
			invalidateSize();
		}
		
		/**
		 * @copy IScrollListRenderer#useVariableHeight
		 */
		public function get useVariableHeight():Boolean
		{
			return _useVariableHeight;
		}
		public function set useVariableHeight( value:Boolean ):void
		{
			if( _useVariableHeight == value ) return;
			
			_useVariableHeight = value;
			if( _data ) invalidateData();
		}
		
		/**
		 * @copy IScrollListRenderer#useVariableWidth
		 */
		public function get useVariableWidth():Boolean
		{
			return _useVariableWidth;
		}
		public function set useVariableWidth( value:Boolean ):void
		{
			if( _useVariableWidth == value ) return;
			
			_useVariableWidth = value;
			if( _data ) invalidateData();
		}
		
		/**
		 * @copy IScrollListRenderer#data
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data( value:Object ):void
		{
			if( _data == value ) return;
			
			_data = value;	
			invalidateData();
		}
	}
}