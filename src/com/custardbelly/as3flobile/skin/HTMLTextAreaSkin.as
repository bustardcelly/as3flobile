/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: HTMLTextAreaSkin.as</p>
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
package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.text.HTMLTextArea;
	
	import flash.display.Shape;
	
	/**
	 * HTMLTextAreaSkin is the base class for skinning a HTMLTextArea control. 
	 * @author toddanderson
	 */
	public class HTMLTextAreaSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function HTMLTextAreaSkin() { super(); }
		
		/**
		 * Clears the skinning operations.
		 */
		override protected function clearDisplay():void
		{
			var textAreaTarget:HTMLTextArea = ( _target as HTMLTextArea );
			var background:Shape = textAreaTarget.backgroundDisplay;
			background.graphics.clear();
		}
		
		/**
		 * @private
		 * 
		 * updates the look and feel of the background display of the target HTMLTextArea. 
		 * @param display Shape
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Shape, width:int, height:int ):void
		{
			display.graphics.clear();
			display.graphics.lineStyle( 2, 0x999999, 1, true, "normal", "square", "miter" );
			display.graphics.drawRect( 0, 0, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var textAreaTarget:HTMLTextArea = ( _target as HTMLTextArea );
			updateBackground( textAreaTarget.backgroundDisplay, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var textAreaTarget:HTMLTextArea = ( _target as HTMLTextArea );
			updateBackground( textAreaTarget.backgroundDisplay, width, height );
		}
	}
}