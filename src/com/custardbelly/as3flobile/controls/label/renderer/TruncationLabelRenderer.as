/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: TruncationLabelRenderer.as</p>
 * <p>Version: 0.3</p>
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
package com.custardbelly.as3flobile.controls.label.renderer
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormatAlign;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	/**
	 * TruncationLabelRenderer is an ILabelRenderer implementation that handles truncating text with defined breadcrumb characters. 
	 * @author toddanderson
	 */
	public class TruncationLabelRenderer implements ILabelRenderer
	{
		protected var _target:DisplayObjectContainer;
		protected var _block:TextBlock;
		
		protected var _truncationText:String;
		protected var _textAlign:String;
		
		/**
		 * Constructor. 
		 * @param target DisplayObjectContainer The target container to add textual display to.
		 * @param truncText String The breadcrumb text to add if truncating.
		 */
		public function TruncationLabelRenderer( target:DisplayObjectContainer, truncText:String = "..." )
		{
			_target = target;
			_truncationText = truncText;
			_block = new TextBlock();
		}
		
		/**
		 * @copy ILabelRenderer#render()
		 */
		public function render( element:TextElement, width:int, height:int ):void
		{
			// Since we are dealing witha  single line of text, update the break opportunity.
			if( element.elementFormat.breakOpportunity != BreakOpportunity.NONE )
			{
				var format:ElementFormat = element.elementFormat.clone();
				format.breakOpportunity = BreakOpportunity.NONE;
				element.elementFormat = format;
			}
			
			// Remove all children from target.
			while( _target.numChildren > 0 )
				_target.removeChildAt( 0 );
			
			// Create the single text line.
			_block.content = element;
			var text:String = element.text;
			var targetWidth:int = ( width == 0 ) ? 1000000 : width;
			var line:TextLine = _block.createTextLine( null, targetWidth );
			// Check for need of truncation.
			if( text && line.atomCount < text.length ) 
			{
				element.text = text.substring( 0, line.atomCount - 3 ) + _truncationText;
				_block.content = element;
				line = _block.createTextLine( null, targetWidth );
			}
			// Add text line to target.
			if( line )
			{
				line.y = line.height;
				// Position content.
				switch( _textAlign )
				{
					case TextFormatAlign.LEFT:
					default:
						line.x = 0;
						break;
					case TextFormatAlign.CENTER:
						line.x = ( width == 0 ) ? 0 : ( width - line.width ) * 0.5;
						break;
					case TextFormatAlign.RIGHT:
						line.x = ( width == 0 ) ? 0 : ( width - line.width );
						break;
				}
				_target.addChild( line );
			}
		}
		
		/**
		 * @copy ILabelRenderer#dispose()
		 */
		public function dispose():void
		{	
			if( _block.firstLine && _block.lastLine )
				_block.releaseLines( _block.firstLine, _block.lastLine );
			_block = null;
			
			_target = null;
		}

		/**
		 * @copy ILabelRenderer#truncationText
		 */
		public function get truncationText():String
		{
			return _truncationText;
		}
		public function set truncationText(value:String):void
		{
			_truncationText = value;
		}

		/**
		 * @copy ILabelRenderer#textAlign
		 */
		public function get textAlign():String
		{
			return _textAlign;
		}
		public function set textAlign(value:String):void
		{
			_textAlign = value;
		}
	}
}