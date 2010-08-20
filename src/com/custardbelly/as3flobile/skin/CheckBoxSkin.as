/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: CheckBoxSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.checkbox.CheckBox;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.enum.BoxPositionEnum;

	/**
	 * CheckBoxSkin is the base class for skinning a CheckBox control. 
	 * @author toddanderson
	 */
	public class CheckBoxSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function CheckBoxSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Updates the box toggle display on the target. 
		 * @param display ToggleButton
		 * @param width int
		 * @param height int
		 */
		protected function initializeBoxToggle( display:ToggleButton, width:int, height:int ):void
		{
			const maxSize:int = 28;
			var size:int = ( height > maxSize ) ? maxSize : height;
			display.width = size;
			display.height = size;
		}
		
		/**
		 * @private
		 * 
		 * Updates the label display on the target. 
		 * @param display Label
		 * @param width int
		 * @param height int
		 */
		protected function updateLabelDisplay( display:Label, width:int, height:int ):void
		{
			
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of displays within the target. 
		 * @param width int
		 * @param height int
		 */
		protected function updatePosition( width:int, height:int ):void
		{
			const offset:int = 10;
			var checkBoxTarget:CheckBox = ( _target as CheckBox );
			var boxDisplay:ToggleButton = checkBoxTarget.boxDisplay;
			var labelDisplay:Label = checkBoxTarget.labelDisplay;
			var labelPlacement:int = checkBoxTarget.labelPlacement;
						
			labelDisplay.width = width - boxDisplay.width - offset;
			if( labelPlacement == BoxPositionEnum.LEFT )
			{
				labelDisplay.x = 0;
				boxDisplay.x = labelDisplay.x + labelDisplay.measuredWidth + offset;
			}
			else
			{
				boxDisplay.x = 0;
				labelDisplay.x = boxDisplay.x + boxDisplay.width + offset;
			}
			
			boxDisplay.y = ( height - boxDisplay.height ) * 0.5;
			if( labelDisplay.height > height )
			{
				labelDisplay.y = 0;	
			}
			else
			{
				labelDisplay.y = ( height - labelDisplay.measuredHeight ) * 0.5;
			}
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var checkBoxTarget:CheckBox = ( _target as CheckBox );
			initializeBoxToggle( checkBoxTarget.boxDisplay, width, height );
			updateLabelDisplay( checkBoxTarget.labelDisplay, width, height );
			updatePosition( width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var checkBoxTarget:CheckBox = ( _target as CheckBox );
			updateLabelDisplay( checkBoxTarget.labelDisplay, width, height );
			updatePosition( width, height );
		}
	}
}