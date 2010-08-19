/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleSwitchSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.toggle.ToggleSwitch;
	
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;

	/**
	 * ToggleSwitchSkin is the base class for skinning a ToggleSwitch control. 
	 * @author toddanderson
	 */
	public class ToggleSwitchSkin extends Skin
	{
		protected var _defaultLabelFormat:ElementFormat;
		
		/**
		 * Constructor.
		 */
		public function ToggleSwitchSkin() { super(); }
		
		/**
		 * Returns the default format for the label displays of the toggle control. Lazy creation. 
		 * @return ElementFormat
		 */
		protected function getDefaultLabelFormat():ElementFormat
		{
			if( _defaultLabelFormat == null )
			{
				_defaultLabelFormat = new ElementFormat( new FontDescription( "DroidSans" ) );
				_defaultLabelFormat.color = 0xEEEEEE;
				_defaultLabelFormat.fontSize = 18;
			}
			return _defaultLabelFormat;
		}
		
		/**
		 * @private
		 * 
		 * Updates the background display for the toggle control 
		 * @param display Sprite
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Sprite, width:int, height:int ):void
		{
			display.graphics.clear();
			display.graphics.beginFill( 0x666666 );
			display.graphics.lineStyle( 2, 0xAAAAAA, 1, true, "normal", "square", "miter" );
			display.graphics.drawRect( 0, 0, width, height );
			display.graphics.endFill();
		}
		
		/**
		 * @private
		 * 
		 * Updates the thumb display for the toggle control. 
		 * @param display Sprite
		 * @param width int
		 * @param height int
		 */
		protected function updateThumb( display:Sprite, width:int, height:int ):void
		{
			var halfWidth:int = width * 0.5;
			display.graphics.clear();
			display.graphics.beginFill( 0xAAAAAA );
			display.graphics.drawRect( 0, 0, halfWidth, height );
			display.graphics.endFill();
			display.graphics.lineStyle( 2, 0x666666, 1, true, "normal", "square", "miter" );
			display.graphics.moveTo( halfWidth - 1, 1 );
			display.graphics.lineTo( halfWidth - 1, height );
			display.graphics.lineTo( 1, height - 1 );
			display.graphics.lineStyle( 2, 0xCCCCCC, 1, true, "normal", "square", "miter" );
			display.graphics.moveTo( 1, height - 1 );
			display.graphics.lineTo( 1, 1 );
			display.graphics.lineTo( halfWidth - 1, 1 );
		}
		
		/**
		 * @private
		 * 
		 * Updates the label display for the toggle control. 
		 * @param leftLabel Label
		 * @param rightLabel Label
		 * @param width int
		 * @param height int
		 */
		protected function updateLabels( leftLabel:Label, rightLabel:Label, width:int, height:int ):void
		{
			var toggleTarget:ToggleSwitch = ( _target as ToggleSwitch );
			var format:ElementFormat = ( toggleTarget.format ) ? toggleTarget.format : getDefaultLabelFormat();
			var padding:int = toggleTarget.labelPadding;
			leftLabel.format = format;
			rightLabel.format = format;
			leftLabel.x = padding;
			rightLabel.x = width - rightLabel.width - padding;
			leftLabel.y = ( height - leftLabel.height ) * 0.5;
			rightLabel.y = ( height - rightLabel.height ) *0.5;
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var toggleTarget:ToggleSwitch = ( _target as ToggleSwitch ); 
			updateBackground( toggleTarget.backgroundDisplay, width, height );
			updateThumb( toggleTarget.thumbDisplay, width, height );
			updateLabels( toggleTarget.leftLabelDisplay, toggleTarget.rightLabelDisplay, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var toggleTarget:ToggleSwitch = ( _target as ToggleSwitch ); 
			updateBackground( toggleTarget.backgroundDisplay, width, height );
			updateThumb( toggleTarget.thumbDisplay, width, height );
			updateLabels( toggleTarget.leftLabelDisplay, toggleTarget.rightLabelDisplay, width, height );
		}
	}
}