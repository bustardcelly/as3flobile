/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: RadioButtonToggleSkin.as</p>
 * <p>Version: 0.2</p>
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
	import com.custardbelly.as3flobile.controls.radiobutton.RadioButton;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	
	import flash.display.Graphics;

	/**
	 * RadioButtonToggleSkin is a base skin class for the toggle control on a RadioButton control. 
	 * @author toddanderson
	 */
	public class RadioButtonToggleSkin extends ToggleButtonSkin
	{
		/**
		 * Constructor.
		 */
		public function RadioButtonToggleSkin() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			if( display == null ) return;
			
			var size:int = ( ( width > height ) ? height : width ) * 0.5;
			var halfSize:int = size * 0.5;
			
			display.clear();
			if( _currentState == BasicStateEnum.SELECTED )
			{	
				display.beginFill( 0xEEEEEE );
				display.lineStyle( 2, 0x999999 );
				display.drawCircle( size, size, size );
				display.endFill();
				
				display.beginFill( 0xFF7F00 );
				display.lineStyle( 2, 0xDDDDDD );
				display.drawCircle( size, size, halfSize );
				display.endFill();
			}
			else
			{
				display.beginFill( 0xAAAAAA );
				display.lineStyle( 2, 0xCCCCCC );
				display.drawCircle( size, size, size );
				display.endFill();
			}
		}
	}
}