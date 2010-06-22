/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: TextArea.as</p>
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
package com.custardbelly.as3flobile.controls.text
{
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewport;
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewportDelegate;
	import com.custardbelly.as3flobile.controls.viewport.ScrollViewport;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	/**
	 * TextArea is a scrollable area of static textual content. 
	 * @author toddanderson
	 */
	public class TextArea extends Sprite implements IScrollViewportDelegate
	{
		protected var _viewport:IScrollViewport;
		
		protected var _block:TextBlock;
		protected var _lineHolder:TextAreaLineHolder;
		protected var _numLines:int;
		protected var _linePositions:Vector.<int>;
		
		protected var _text:String;
		protected var _format:ElementFormat;
		protected var _scrollPosition:Point;
		protected var _maximumScrollPosition:int;
		
		protected var _width:int = 100;
		protected var _height:int = 100;
		protected var _delegate:ITextAreaDelegate;
		
		/**
		 * Constructor.
		 */
		public function TextArea() 
		{
			initialize();
			createChildren();
		}
		
		/**
		 * @private 
		 * 
		 * Initializes necessary properties.
		 */
		protected function initialize():void
		{	
			_format = new ElementFormat( new FontDescription("Arial") );
			_format.fontSize = 12;
			
			_block = new TextBlock();
			
			_linePositions = new Vector.<int>(1);
		}
		
		/**
		 * @private 
		 * 
		 * Creates and adds necessary children to the display list.
		 */
		protected function createChildren():void
		{
			_lineHolder = new TextAreaLineHolder();
			
			_viewport = new ScrollViewport();
			_viewport.delegate = this;
			_viewport.width = _width;
			_viewport.height = _height;
			_viewport.content = _lineHolder;
			addChild( _viewport as DisplayObject );
		}
		
		/**
		 * @private 
		 * 
		 * Validates the textual content and its formatting.
		 */
		protected function invalidateTextDisplay():void
		{
			_lineHolder.clear();
			
			// Use TextBlock factory to create TextLines and add to the display.
			_block.content = new TextElement( _text, _format );
			_numLines = 0;
			var line:TextLine = _block.createTextLine( null, _width );
			var ypos:int = 0;
			while( line )
			{
				ypos += line.height;
				line.y = ypos;
				
				_lineHolder.addChild( line );
				_linePositions[_numLines] = ypos;
				
				ypos += ( line.ascent - line.descent )
				
				_numLines++;
				// Get next line from factory.
				line = _block.createTextLine( line, _width );
			}
			
			// Update dimensions and viewport.
			_lineHolder.width = _width;
			_lineHolder.height = ypos;
			_viewport.refresh();
			
			// Update maximum scroll position.
			_maximumScrollPosition = ( _lineHolder.height < _height ) ? 0 : _lineHolder.height - _height;
		}
		
		/**
		 * @private 
		 * 
		 * Validate the scrollable area of the content.
		 */
		protected function invalidateSize():void
		{
			invalidateTextDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the scroll position within the viewport set by the user directly.
		 */
		protected function invalidateScrollPosition():void
		{
			if( _viewport.context )
				_viewport.context.position = _scrollPosition;
		}
		
		/**
		 * @copy IScrollViewportDelegate#scrollViewDidStart()
		 */
		public function scrollViewDidStart( position:Point ):void
		{
			_scrollPosition = position;
			if( _delegate ) _delegate.textAreaDidScroll( this, position );
		}
		/**
		 * @copy IScrollViewportDelegate#scrollViewDidAnimate()
		 */
		public function scrollViewDidAnimate( position:Point ):void
		{
			_scrollPosition = position;
			if( _delegate ) _delegate.textAreaDidScroll( this, position );
		}
		/**
		 * @copy IScrollViewportDelegate#scrollViewDidEnd()
		 */
		public function scrollViewDidEnd( position:Point ):void
		{
			_scrollPosition = position;
			if( _delegate ) _delegate.textAreaDidScroll( this, position );
		}
		
		/**
		 * Performs any cleanup.
		 */
		public function dispose():void
		{
			_linePositions = null;
			
			_viewport.dispose();
			_viewport = null;
			
			_lineHolder.clear();
			_lineHolder = null;
				
			_format = null;
			_block = null;
			
			_delegate = null;
		}
		
		/**
		 * Positions the content at the top of the line specified at the index within the content. 
		 * @param index int
		 */
		public function scrollToLine( index:int ):void
		{
			if( index > _linePositions.length - 1 ) index = 0;
			
			// Limit position.
			var ypos:int = -_linePositions[index];
			ypos = ( ypos < _maximumScrollPosition ) ? _maximumScrollPosition : ypos;
			// Update scroll position.
			if( _scrollPosition )
			{
				_scrollPosition.y = ypos	
			} 
			else
			{
				_scrollPosition = new Point( 0, ypos );	
			}
			// Invoke invalidation.
			invalidateScrollPosition();
		}

		/**
		 * Returns the number of lines created from the textual content. 
		 * @return int
		 */
		public function get numLines():int
		{
			return _numLines;
		}
		
		/**
		 * Accessor/Modifier for the textual content to display. 
		 * @return String
		 */
		public function get text():String
		{
			return _text;
		}
		public function set text( value:String ):void
		{
			if( _text == value ) return;
			
			_text = value;
			invalidateTextDisplay();
			if( _delegate ) _delegate.textAreaTextChange( this, _text );
		}
		
		/**
		 * Accessor/Modifier for the element formatting of the textual content. 
		 * @return ElementFormat
		 */
		public function get format():ElementFormat
		{
			return _format;
		}
		public function set format(value:ElementFormat):void
		{
			if( _format == value ) return;
			
			_format = value;
			invalidateTextDisplay();
		}
		
		/**
		 * Accessor/Modifier for the coordinate position of the content within the viewport based on its top/left position. 
		 * @return Point
		 */
		public function get scrollPosition():Point
		{
			return _scrollPosition;
		}
		public function set scrollPosition( value:Point ):void
		{
			if( _scrollPosition == value ) return;
			
			_scrollPosition = value;
			invalidateScrollPosition();
		}

		/**
		 * Accessor/Modifier for the width of this display. 
		 * @return Number
		 */
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if( _width == value ) return;
			
			_width = value;
			_viewport.width = _width;
			invalidateSize();
		}

		/**
		 * Accessor/Modifier for the height of this display. 
		 * @return Number
		 */
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if( _height == value ) return;
			
			_height = value;
			_viewport.height = _height;
			invalidateSize();
		}
		
		/**
		 * Accessor/Modifier for the delegate instance to notify on change. 
		 * @return ITextAreaDelegate
		 */
		public function get delegate():ITextAreaDelegate
		{
			return _delegate;
		}
		public function set delegate(value:ITextAreaDelegate):void
		{
			_delegate = value;
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;
/**
 * @private
 * 
 * TextAreaLineHolder is an extension of Sprite that holds dimension values representing width and height. This is so not to scale the Sprite,
 * and is used as the basis for scrolling in the viewport based on content dimensions. 
 * @author toddanderson
 */
class TextAreaLineHolder extends Sprite
{
	protected var _background:Shape;
	protected var _width:int = 0;
	protected var _height:int = 0;
	
	/**
	 * Constructor.
	 */
	public function TextAreaLineHolder() 
	{
		_background = new Shape();
		addChild( _background );
	}

	/**
	 * @private 
	 * 
	 * Validates the size.
	 */
	protected function invalidateSize():void
	{
		// Redraw false background.
		_background.graphics.clear();
		_background.graphics.beginFill( 0, 0 );
		_background.graphics.drawRect( 0, 0, _width, _height );
		_background.graphics.endFill();
	}
	
	/**
	 * Clears the textual content of the display.
	 */
	public function clear():void
	{
		var i:int = numChildren;
		while( --i > 0 )
		{
			removeChildAt( i );
		}
	}
	
	/**
	 * Accessor/Modifier for the preferred width of the display. 
	 * @return Number
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
	 * Accessor/Modifier for the preferred height of the display. 
	 * @return Number
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
}