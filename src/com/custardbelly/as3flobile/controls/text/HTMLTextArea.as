/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: HTMLTextArea.as</p>
 * <p>Version: 0.3.2</p>
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
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewport;
	import com.custardbelly.as3flobile.controls.viewport.ScrollViewport;
	import com.custardbelly.as3flobile.controls.viewport.context.IScrollViewportContext;
	import com.custardbelly.as3flobile.skin.HTMLTextAreaSkin;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.osflash.signals.Signal;
	
	/**
	 * HTMLTextArea is a control to display HTML mark-up textual content. Internally the textual display is a TextField. 
	 * The Flash Text Engine (FTE) does not support styling of content based on mark-up, hence the slower rendering TextField is used to support such capabilities. 
	 * If not rendering HTML content, consider using TextArea which uses the FTE for faster rendering. 
	 * 
	 * @see com.custardbelly.as3flobile.controls.text.TextArea
	 * @author toddanderson
	 */
	public class HTMLTextArea extends AS3FlobileComponent
	{
		protected var _background:Shape;
		protected var _field:TextField;
		protected var _viewport:IScrollViewport;
		
		protected var _text:String;
		protected var _format:TextFormat;
		protected var _scrollContext:IScrollViewportContext;
		protected var _scrollPosition:Point;
		
		protected var _textChange:Signal;
		protected var _scrollChange:Signal;
		
		/**
		 * Constructor.
		 */
		public function HTMLTextArea() { super(); }
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_width = 100;
			_height = 100;
			
			_format = new TextFormat( "Arial", 14 );
			
			updatePadding( 5, 5, 5, 5 );
			
			_skin = new HTMLTextAreaSkin();
			_skin.target = this;
			
			_textChange = new Signal( String );
			_scrollChange = new Signal( Point );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			var horizPadding:int = ( _padding.left + _padding.right );
			var vertPadding:int = ( _padding.top + _padding.bottom );
			var w:int = _width - horizPadding;
			var h:int = _height - vertPadding;
				
			_background = new Shape();
			addChild( _background );
			
			_field = new TextField();
			_field.selectable = false;
			_field.multiline = true;
			_field.wordWrap = true;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.type = TextFieldType.DYNAMIC;
			_field.defaultTextFormat = _format;
			_field.width = w;
			
			_viewport = new ScrollViewport();
			_viewport.scrollStart.add( scrollViewScrollChange );
			_viewport.scrollChange.add( scrollViewScrollChange );
			_viewport.scrollEnd.add( scrollViewScrollChange );
			_viewport.width = w;
			_viewport.height = h;
			_viewport.x = _padding.left;
			_viewport.y = _padding.top;
			_viewport.content = _field;
			addChild( _viewport as DisplayObject );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function invalidateSize():void
		{
			var horizPadding:int = ( _padding.left + _padding.right );
			var vertPadding:int = ( _padding.top + _padding.bottom );
			_viewport.width = _width - horizPadding;
			_viewport.height = _height - vertPadding;
			_viewport.x = _padding.left;
			_viewport.y = _padding.top;
			// Fit field to viewport.
			_field.width = _viewport.width;
			
			super.invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the textual content to display.
		 */
		protected function invalidateText():void
		{
			_field.htmlText = _text;
			_viewport.refresh();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the text format to apply to the field.
		 */
		protected function invalidateFormat():void
		{
			_field.defaultTextFormat = _format;
			_field.setTextFormat( _format );
			_viewport.refresh();
		}
		
		/**
		 * @private
		 * 
		 * Validates the IScrollViewportContext implementation applied to this instance.
		 */
		protected function invalidateScrollContext():void
		{
			// If we have a viewport set, apply the new context.
			if( _viewport != null )
			{
				_viewport.context = _scrollContext;
			}
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
		 * @private
		 * 
		 * Signal handler for change in scroll position from viewport. 
		 * @param position Point
		 */
		protected function scrollViewScrollChange( position:Point ):void
		{
			_scrollPosition = position;
			_scrollChange.dispatch( position );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			super.dispose();
			
			_viewport.dispose();
			_viewport = null;
			
			_format = null;
			
			_textChange.removeAll();
			_textChange = null;
			
			_scrollChange.removeAll();
			_scrollChange = null;
		}
		
		/**
		 * Returns signal reference for change in scroll. 
		 * @return Signal Signal( Point )
		 */
		public function get scrollChange():Signal
		{
			return _scrollChange;
		}
		/**
		 * Returns signal reference for change in textual content. 
		 * @return Signal Signal( String )
		 */
		public function get textChange():Signal
		{
			return _textChange;
		}
		
		/**
		 * Accessor for the background display for a ISkin instance targeting this control. 
		 * @return Shape
		 */
		public function get backgroundDisplay():Shape
		{
			return _background;
		}
		
		/**
		 * Accessor/Modifier for the textual content to display. Assuming HTML mark-up and applying to internal TextField htmlText property. If not HTML mark-up, consider using TextArea instead. 
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
			invalidateText();
			_textChange.dispatch( _text );
		}
		
		/**
		 * Accessor/Modifier for the TextFormat to apply to the internal text field. 
		 * @return TextFormat
		 */
		public function get format():TextFormat
		{
			return _format;
		}
		public function set format( value:TextFormat ):void
		{
			if( _format == value ) return;
			
			_format = value;
			invalidateFormat();
		}	
		
		/**
		 * Accessor/Modifier for embedded font renderering in the internal textfield. 
		 * @return Boolean
		 */
		public function get embedFonts():Boolean
		{
			return _field.embedFonts;
		}
		public function set embedFonts( value:Boolean ):void
		{
			if( _field.embedFonts == value ) return;
			
			_field.embedFonts = value;
			_viewport.refresh();
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
		 * Accessor/Modifier for the viewport context that manages user gestures and animation of display. 
		 * @return IScrollViewportContext
		 */
		public function get scrollContext():IScrollViewportContext
		{
			return _scrollContext;
		}
		public function set scrollContext( value:IScrollViewportContext ):void
		{
			if( _scrollContext == value ) return;
			
			_scrollContext = value;
			invalidateScrollContext();
		}
	}
}