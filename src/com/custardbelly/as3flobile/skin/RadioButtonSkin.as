/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: RadioButtonSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.radiobutton.RadioButton;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.enum.BoxPositionEnum;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;

	/**
	 * RadioButtonSkin is a basic skin for a RadioButton control. 
	 * @author toddanderson
	 */
	public class RadioButtonSkin extends Skin
	{
		protected var _normalLabelFormat:ElementFormat;
		protected var _selectedLabelFormat:ElementFormat;
		
		/**
		 * Constructor.
		 */
		public function RadioButtonSkin() 
		{ 
			super();
			_normalLabelFormat = new ElementFormat( new FontDescription( "DroidSans" ), 14 );
			_selectedLabelFormat = new ElementFormat( new FontDescription( "DroidSans" ), 14, 0x668014 );
		}
		
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
			const maxSize:int = 34;
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
			var isSelected:Boolean = _target.skinState == BasicStateEnum.SELECTED;
			if( !isSelected )
				display.format = _normalLabelFormat;
			else
				display.format = _selectedLabelFormat;
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
			var radioTarget:RadioButton = ( _target as RadioButton );
			var radioDisplay:ToggleButton = radioTarget.radioDisplay;
			var labelDisplay:Label = radioTarget.labelDisplay;
			var labelPlacement:int = radioTarget.labelPlacement;
			
			// update label width.
			labelDisplay.width = width - radioDisplay.width - offset;
			// Update placement along x axis.
			if( labelPlacement == BoxPositionEnum.LEFT )
			{
				labelDisplay.x = 0;
				radioDisplay.x = labelDisplay.x + labelDisplay.measuredWidth + offset;
			}
			else
			{
				radioDisplay.x = 0;
				labelDisplay.x = radioDisplay.x + radioDisplay.width + offset;
			}
			
			// Update placement along y-axis.
			radioDisplay.y = ( height - radioDisplay.height ) * 0.5;
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
			
			var radioTarget:RadioButton = ( _target as RadioButton );
			initializeBoxToggle( radioTarget.radioDisplay, width, height );
			updateLabelDisplay( radioTarget.labelDisplay, width, height );
			updatePosition( width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var radioTarget:RadioButton = ( _target as RadioButton );
			updateLabelDisplay( radioTarget.labelDisplay, width, height );
			updatePosition( width, height );
		}
	}
}