/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: Label.as</p>
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
package com.custardbelly.as3flobile.controls.label
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.label.renderer.ILabelRenderer;
	import com.custardbelly.as3flobile.controls.label.renderer.MultilineLabelRenderer;
	import com.custardbelly.as3flobile.controls.label.renderer.TruncationLabelRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	import mx.controls.Text;
	
	/**
	 * Label is a textual base component utilizing the Flash Text Engine to render a single or multiple line of text. 
	 * @author toddanderson
	 */
	public class Label extends AS3FlobileComponent
	{
		protected var _textElement:TextElement;
		
		protected var _text:String;
		protected var _format:ElementFormat;
		
		protected var _truncate:Boolean = true;
		protected var _truncationText:String = "...";
		
		protected var _autosize:Boolean;
		protected var _multiline:Boolean;
		
		protected var _renderer:ILabelRenderer;
		protected var _truncationRenderer:ILabelRenderer;
		protected var _multilineRenderer:ILabelRenderer;
		protected var _rendererWidth:int;
		protected var _rendererHeight:int;
		
		/**
		 * Constructor.
		 */
		public function Label()
		{
			initialize();
		}
		
		/**
		 * @private 
		 * 
		 * Initializes necessary properties.
		 */
		protected function initialize():void
		{	
			_width = 100;
			_height = 20;
			
			_format = new ElementFormat( new FontDescription("DroidSans") );
			_format.breakOpportunity = BreakOpportunity.NONE;
			_format.fontSize = 14;
			
			_textElement = new TextElement();
			
			_truncationRenderer = new TruncationLabelRenderer( this );
			_multilineRenderer = new MultilineLabelRenderer( this );
			_renderer = _truncationRenderer;
		}
		
		/**
		 * @private 
		 * 
		 * Validates the textual content and its formatting.
		 */
		protected function invalidateTextDisplay():void
		{
			_textElement.text = _text;
			_textElement.elementFormat = _format;
			
			_rendererWidth = ( _autosize && !_multiline ) ? 0 : _width;
			_rendererHeight = ( _autosize ) ? 0 : _height;
			_renderer.render( _textElement, _rendererWidth, _rendererHeight );
			
			// update held height.
			if( _autosize && numChildren > 0 )
			{
				var bounds:Rectangle = getBounds(this);
				var lastChild:TextLine = getChildAt( numChildren - 1 ) as TextLine;
				_width = bounds.width;
				_height = bounds.height + ( lastChild.ascent - lastChild.descent );
			}
		}
		
		/**
		 * @private 
		 * 
		 * Validate the scrollable area of the content.
		 */
		override protected function invalidateSize():void
		{
			invalidateTextDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Updates the renderer state used for display layout. 
		 * @param renderer ILabelRenderer
		 */
		protected function setRendererState( renderer:ILabelRenderer ):void
		{
			_renderer = renderer;
		}
		
		/**
		 * Performs any cleanup.
		 */
		public function dispose():void
		{
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			_format = null;
			
			_truncationRenderer.dispose();
			_truncationRenderer = null;
			
			_renderer = null;
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
			if( _text != null ) invalidateTextDisplay();
		}
		
		/**
		 * Accessor/Modifier for the textual content represented within truncation. Default is '...' 
		 * @return String
		 */
		public function get truncationText():String
		{
			return _truncationText;
		}
		public function set truncationText( value:String ):void
		{
			if( _truncationText == value ) return;
			
			_truncationText = value;
			_truncationRenderer.truncationText = _truncationText;
			if( _truncate ) invalidateTextDisplay();
		}

		/**
		 * Accessor/Modifier flag to truncate text on render. 
		 * @return Boolean
		 */
		public function get truncate():Boolean
		{
			return _truncate;
		}
		public function set truncate(value:Boolean):void
		{
			if( _truncate == value ) return;
			
			_truncate = value;
			setRendererState( _truncationRenderer );
			if( _text != null ) invalidateTextDisplay();
		}

		/**
		 * Accessor/Modifier of autosize flag for render. 
		 * @return Boolean
		 */
		public function get autosize():Boolean
		{
			return _autosize;
		}
		public function set autosize(value:Boolean):void
		{
			_autosize = value;
			if( _text != null ) invalidateTextDisplay();
		}

		/**
		 * Accessor/Modifier flag to display multiple lines. 
		 * @return Boolean
		 */
		public function get multiline():Boolean
		{
			return _multiline;
		}
		public function set multiline(value:Boolean):void
		{
			if( _multiline == value ) return;
		
			_multiline = value;
			setRendererState( _multilineRenderer );
			if( _text != null ) invalidateTextDisplay();	
		}
	}
}