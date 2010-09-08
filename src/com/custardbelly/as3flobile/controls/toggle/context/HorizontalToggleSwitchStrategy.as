/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: HorizontalToggleSwitchStrategy.as</p>
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
package com.custardbelly.as3flobile.controls.toggle.context
{
	import com.custardbelly.as3flobile.controls.slider.context.BaseSliderStrategy;
	import com.custardbelly.as3flobile.controls.slider.context.HorizontalSliderStrategy;
	import com.custardbelly.as3flobile.controls.toggle.IToggleSwitch;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * HorizontalToggleSwitchStrategy manages the position and animation of toggling an IToggleSwitch control along the x-axis. 
	 * @author toddanderson
	 */
	public class HorizontalToggleSwitchStrategy extends HorizontalSliderStrategy implements IToggleSwitchStrategy
	{
		protected var _halfWidth:Number;
		
		/**
		 * Constructor.
		 */
		public function HorizontalToggleSwitchStrategy() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			// Override to fill value used for placement and animation.
			_halfWidth = _width * 0.5;
		}
		
		/**
		 * @inherit
		 */
		override protected function placePosition( xpos:Number, ypos:Number ):void
		{
			// Override Polarize the thumb position.
			var targetX:Number = ( xpos > _halfWidth ) ? _rightLimitPosition : _leftLimitPosition;
			_targetX = targetX;
			_velocityX = 0;
			startAnimation();
		}
		
		/**
		 * @inherit
		 */
		override protected function updatePosition( xpos:Number, ypos:Number ):void
		{
			// Override to not commit position value. Not needed in a toggle switch when moving from one polar value to another.
			_thumb.x += xpos - _previousX;
			// Limit.
			var hasLimit:Boolean = limitPosition();
			if( !hasLimit ) _previousX = xpos;
		}
	
		/**
		 * @copy ISliderStrategy#end()
		 */
		override public function end( position:Point ):void
		{
			// Override to animate to position on end.
			placePosition( position.x, position.y );
		}
		
		/**
		 * @copy IToggleSwitchStrategy#selecteIndex()
		 */
		public function selectIndex( value:uint ):void
		{
			var xpos:Number = ( value == 1 ) ? _rightLimitPosition + 1 : _leftLimitPosition - 1;
			if( _thumb.x == xpos ) return;
			
			endAnimation( false );
			placePosition( xpos, 0 );
		}
	}
}