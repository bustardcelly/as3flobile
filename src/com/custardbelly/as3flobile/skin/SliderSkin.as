/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: SliderSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.slider.ISlider;
	import com.custardbelly.as3flobile.controls.slider.Slider;
	import com.custardbelly.as3flobile.controls.toggle.ToggleSwitch;
	import com.custardbelly.as3flobile.enum.OrientationEnum;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	/**
	 * SliderSkin is the base class for skinning a Slider control. 
	 * @author toddanderson
	 */
	public class SliderSkin extends Skin
	{	
		/**
		 * Constructor.
		 */
		public function SliderSkin() { super(); }
		
		protected function getThumbWidth( target:Slider, width:int, height:int ):int
		{
			var thumbSize:int = target.thumbSize;
			// If vertical orientation return based on height.
			if( target.orientation == OrientationEnum.VERTICAL )
				return width;
			// Default based on horizontal.
			return ( thumbSize < 0 ) ? width * 0.5 : thumbSize;
		}
		
		protected function getThumbHeight( target:Slider, width:int, height:int ):int
		{
			var thumbSize:int = target.thumbSize;
			// If vertical orientation return based on height.
			if( target.orientation == OrientationEnum.VERTICAL )
				return ( thumbSize < 0 ) ? target.height * 0.5 : thumbSize;
			// Default based on horizontal.
			return height;
		}
		
		/**
		 * @private
		 * 
		 * Updates the background display for the slider control. 
		 * @param display Graphics
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			display.clear();
			display.beginFill( 0x666666 );
			display.lineStyle( 2, 0xAAAAAA, 1, true, "normal", "square", "miter" );
			display.drawRect( 0, 0, width, height );
			display.endFill();
		}
		
		/**
		 * @private
		 * 
		 * Updates the thumb display for the slider control. 
		 * @param display Sprite
		 * @param width int
		 * @param height int
		 */
		protected function updateThumb( display:Sprite, thumbWidth:int, thumbHeight:int ):void
		{
			const lineSize:int = 2;
			const offset:int = 1;
			display.graphics.clear();
			display.graphics.beginFill( 0xAAAAAA );
			display.graphics.drawRect( 0, 0, thumbWidth, thumbHeight );
			display.graphics.endFill();
			display.graphics.lineStyle( lineSize, 0x666666, 1, true, "normal", "square", "miter" );
			display.graphics.moveTo( thumbWidth - offset, offset );
			display.graphics.lineTo( thumbWidth - offset, thumbHeight - offset );
			display.graphics.lineTo( offset, thumbHeight - offset);
			display.graphics.lineStyle( lineSize, 0xCCCCCC, 1, true, "normal", "square", "miter" );
			display.graphics.moveTo( offset, thumbHeight - offset );
			display.graphics.lineTo( offset, offset );
			display.graphics.lineTo( thumbWidth - offset, offset );
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var sliderTarget:Slider = ( _target as Slider );
			var thumbWidth:int = getThumbWidth( sliderTarget, width, height );
			var thumbHeight:int = getThumbHeight( sliderTarget, width, height );
			
			updateBackground( sliderTarget.backgroundDisplay, width, height );
			updateThumb( sliderTarget.thumbDisplay, thumbWidth, thumbHeight );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var sliderTarget:Slider = ( _target as Slider );
			var thumbWidth:int = getThumbWidth( sliderTarget, width, height );
			var thumbHeight:int = getThumbHeight( sliderTarget, width, height );
			
			updateBackground( sliderTarget.backgroundDisplay, width, height );
			updateThumb( sliderTarget.thumbDisplay, thumbWidth, thumbHeight );
		}
	}
}