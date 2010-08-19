/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleButtonSkin.as</p>
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
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	
	import flash.display.Graphics;

	/**
	 * ToggleButtonSkin is a skin that updates the display of a Button based on its skin state of selection. 
	 * @author toddanderson
	 */
	public class ToggleButtonSkin extends ButtonSkin
	{
		/**
		 * Constructor.
		 */
		public function ToggleButtonSkin() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			if( display == null ) return;
			
			var isSelected:Boolean = _target.skinState == BasicStateEnum.SELECTED;
			var color:uint = ( isSelected ) ? 0xCCCCCC : 0xFFFFFF;
			var topLeftColor:uint = ( isSelected ) ? 0xAAAAAA : 0x666666;
			var bottomRightColor:uint = ( isSelected ) ? 0x666666 : 0xAAAAAA;
			
			display.clear();
			display.beginFill( color );
			display.drawRect( 0, 0, width, height );
			display.endFill();
			display.lineStyle( 2, topLeftColor, 1, true, "normal", "square", "miter" );
			display.moveTo( width, 0 );
			display.lineTo( width, height );
			display.lineTo( 0, height );
			display.lineStyle( 2, bottomRightColor, 1, true, "normal", "square", "miter" );
			display.moveTo( 0, height );
			display.lineTo( 0, 0 );
			display.lineTo( width, 0 );
		}
	}
}