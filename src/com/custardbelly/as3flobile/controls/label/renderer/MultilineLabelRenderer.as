/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MultilineLabelRenderer.as</p>
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
	 * MultilineLabelRenderer is an ILabelRenderer implementation to render and display multiple lines of textual conent in a Label component. 
	 * @author toddanderson
	 */
	public class MultilineLabelRenderer implements ILabelRenderer
	{
		protected var _target:DisplayObjectContainer;
		protected var _block:TextBlock;
		protected var _textAlign:String;
		
		/**
		 * Constructor. 
		 * @param target DisplayObjectContainer The target container for the textual display.
		 */
		public function MultilineLabelRenderer( target:DisplayObjectContainer )
		{
			_target = target;
			_block = new TextBlock();
		}
		
		/**
		 * @copy ILabelRenderer#render()
		 */
		public function render( element:TextElement, width:int, height:int ):void
		{
			// Since we are working with multiline, update the format on the element to handle break opportunities.
			if( element.elementFormat.breakOpportunity != BreakOpportunity.AUTO )
			{
				var format:ElementFormat = element.elementFormat.clone();
				format.breakOpportunity = BreakOpportunity.AUTO;
				element.elementFormat = format;
			}
			
			// Remove children from target.
			while( _target.numChildren > 0 )
				_target.removeChildAt( 0 );
			
			// Create text lines.
			_block.content = element;
			var ypos:int;
			var maxWidth:int;
			var hasHeightLimit:Boolean = ( height != 0 );
			var lines:Vector.<TextLine> = new Vector.<TextLine>();
			var line:TextLine = _block.createTextLine( null, width );
			lineCreation: while( line )
			{
				ypos += line.textHeight;
				line.y = ypos;
				
				if( hasHeightLimit && ypos > height ) break lineCreation;
				
				ypos += line.descent;
				_target.addChild( line );
				
				// push for positioning.
				lines.push( line );
				maxWidth = ( maxWidth < line.width ) ? line.width : maxWidth;
				
				// Get next line from factory.
				line = _block.createTextLine( line, width );
			}
			
			// Position content.
			switch( _textAlign )
			{
				case TextFormatAlign.LEFT:
				default:
					while( lines.length > 0 )
						( lines.shift() as TextLine ).x = 0;
					break;
				case TextFormatAlign.CENTER:
					while( lines.length > 0 )
					{
						line = ( lines.shift() as TextLine );
						line.x = ( maxWidth - line.width ) / 2;
					}
					break;
				case TextFormatAlign.RIGHT:
					while( lines.length > 0 )
					{
						line = ( lines.shift() as TextLine );
						line.x = maxWidth - line.width;
					}
					break;
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
			return null;
		}
		public function set truncationText(value:String):void
		{
			// fall through. unneeded here.
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