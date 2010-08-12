/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ButtonSkin.as</p>
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
package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.label.Label;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import flashx.textLayout.formats.TextAlign;

	/**
	 * ButtonSkin is the base class for skinning a Button control. 
	 * @author toddanderson
	 */
	public class ButtonSkin extends Skin
	{
		/**
		 * Constuctor.
		 */
		public function ButtonSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Performs initialization on the background display of target. 
		 * @param display Sprite
		 * @param width int
		 * @param height int
		 */
		protected function initializeBackground( display:Graphics, width:int, height:int ):void
		{
			updateBackground( display, width, height );
		}
		
		/**
		 * @private
		 * 
		 * Updates the background sisplay of target. 
		 * @param display Sprite
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			if( display == null ) return;
			
			display.clear();
			display.beginFill( 0xFFFFFF );
			display.drawRect( 0, 0, width, height );
			display.endFill();
			display.lineStyle( 2, 0x666666, 1, true, "normal", "square", "miter" );
			display.moveTo( width, 0 );
			display.lineTo( width, height );
			display.lineTo( 0, height );
			display.lineStyle( 2, 0xAAAAAA, 1, true, "normal", "square", "miter" );
			display.moveTo( 0, height );
			display.lineTo( 0, 0 );
			display.lineTo( width, 0 );
		}
		
		/**
		 * @private
		 * 
		 * Initializes label display of target. 
		 * @param label Label
		 * @param width int
		 * @param height int
		 * @param padding int
		 */
		protected function initializeLabel( label:Label, width:int, height:int, padding:int = 0 ):void
		{	
			var format:ElementFormat = label.format;
			if( format.fontDescription.fontName != "DroidSans-Bold" )
			{
				format = format.clone();
				var fontDesc:FontDescription = format.fontDescription.clone();
				fontDesc.fontName = "DroidSans-Bold";
				format.fontDescription = fontDesc;
				label.format = format;
			}
			label.textAlign = TextAlign.CENTER;
			updateLabel( label, width, height, padding );
		}
		
		/**
		 * @private
		 * 
		 * Updates label display of target. 
		 * @param label Label
		 * @param width int
		 * @param height int
		 * @param padding int
		 */
		protected function updateLabel( label:Label, width:int, height:int, padding:int = 0 ):void
		{
			if( label == null ) return;
			
			label.width = width - ( padding * 2 );
			label.x = ( width - label.width ) / 2;
			label.y = ( height - label.height ) / 2;
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var buttonTarget:Button = ( _target as Button );
			initializeBackground( buttonTarget.backgroundDisplay, width, height );
			initializeLabel( buttonTarget.labelDisplay, width, height, buttonTarget.labelPadding );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var buttonTarget:Button = ( _target as Button );
			updateBackground( buttonTarget.backgroundDisplay, width, height );
			updateLabel( buttonTarget.labelDisplay, width, height, buttonTarget.labelPadding );
		}
	}
}