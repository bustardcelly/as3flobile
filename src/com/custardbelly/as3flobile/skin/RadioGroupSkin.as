/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: RadioGroupSkin.as</p>
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
package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.radiobutton.RadioButton;
	import com.custardbelly.as3flobile.controls.radiobutton.RadioGroup;
	import com.custardbelly.as3flobile.model.BoxPadding;
	
	import flash.display.Graphics;

	/**
	 * RadioGroupSkin is a base skin class for a RadioGroup control. 
	 * @author toddanderson
	 */
	public class RadioGroupSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function RadioGroupSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Updates the background display of the target control. 
		 * @param display Graphics
		 * @param width int
		 * @param height int
		 */
		protected function updateBackgroundDisplay( display:Graphics, width:int, height:int ):void
		{
			display.clear();
			display.lineStyle( 2, 0xAAAAAA );
			display.drawRoundRect( 0, 0, width, height, 5, 5 );
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of displays within the target control. 
		 * @param width int
		 * @param height int
		 */
		protected function updateLayout( width:int, height:int ):void
		{
			// *Note: height is disregarded as the content of radio buttons deterines the height of the control.
			const itemOffset:int = 10;
			var padding:BoxPadding = _target.padding;
			var xpos:int = padding.left;
			var ypos:int = padding.top;
			var radioGroup:RadioGroup = ( _target as RadioGroup );
			var items:Vector.<RadioButton> = radioGroup.items;
			var i:int;
			var length:int = items.length;
			if( length > 0 )
			{
				var radio:RadioButton;
				for( i = 0; i < length; i++ )
				{
					radio = items[i];
					radio.width = width - padding.left - padding.right;
					radio.x = xpos;
					radio.y = ypos;
					ypos += radio.height + itemOffset;
				}
				
				height = ypos + padding.bottom;
			}
			updateBackgroundDisplay( radioGroup.backgroundDisplay, width, ypos );
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var radioGroup:RadioGroup = ( _target as RadioGroup );
			updateLayout( width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var radioGroup:RadioGroup = ( _target as RadioGroup );
			updateLayout( width, height );
		}
	}
}