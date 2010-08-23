/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BaseSliderStrategy.as</p>
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
package com.custardbelly.as3flobile.controls.slider.context
{
	import com.custardbelly.as3flobile.controls.slider.ISlider;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * BaseSliderStrategy is a base/abstract class to mediate the position management of a slider control. 
	 * @author toddanderson
	 */
	public class BaseSliderStrategy implements ISliderStrategy
	{
		protected var _sliderTarget:ISlider;
		protected var _thumb:InteractiveObject;
		protected var _bounds:Rectangle;
		
		protected var _isAnimating:Boolean;
		
		protected static const DAMP:Number = 0.985;
		protected static const VECTOR_MIN:int = 3;
		protected static const VECTOR_MAX:int = 50;
		
		/**
		 * Constructor.
		 */
		public function BaseSliderStrategy() {}
		
		/**
		 * @private 
		 * 
		 * Initializes the mediating session.
		 */
		protected function initialize():void
		{
			// Abstract. Marked for override.
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of a target thumb. 
		 * @param value Number
		 */
		protected function updatePosition( xpos:Number, ypos:Number ):void
		{
			// Abstract. Marked for override.
		}
		
		/**
		 * @private 
		 * 
		 * Limits the position of a target thumb.
		 * @returns Boolean
		 */
		protected function limitPosition():Boolean
		{
			// Marked for override.
			return false;
		}
		
		/**
		 * @private
		 * 
		 * Determines the velocity at which to reach a desired position. 
		 * @param value Number
		 */
		protected function placePosition( xpos:Number, ypos:Number ):void
		{
			// Abstract. Marked for override.
		}
		
		/**
		 * @private 
		 * 
		 * Begins the animation to signal a change in position of the target switch.
		 */
		protected function startAnimation():void
		{
			if( !_isAnimating )
			{
				animate();
				_sliderTarget.addEventListener( Event.ENTER_FRAME, animate, false, 0, true );
				_isAnimating = true;
			}
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of a target thumb. 
		 * @param evt Event Default null. Can be used as an event handler or called directly.
		 */
		protected function animate( evt:Event = null ):void
		{
			// Abstract. Marked fro override.
		}
		
		/**
		 * @private
		 * 
		 * Ends an animation of positioning target switch. 
		 * @param updateSelection Boolean Flag to notify any clients of a change based on position.
		 */
		protected function endAnimation( updateSelection:Boolean = true ):void
		{
			if( _isAnimating )
			{
				_sliderTarget.removeEventListener( Event.ENTER_FRAME, animate, false );
				_isAnimating = false;
			}
		}
		
		/**
		 * @copy ISliderStrategy#click()
		 */
		public function click( position:Point ):void
		{
			endAnimation( false );
			placePosition( position.x, position.y );
		}
		
		/**
		 * @copy ISliderStrategy#start()
		 */
		public function start( position:Point ):void
		{
			endAnimation( false );
		}
		
		/**
		 * @copy ISliderStrategy#move()
		 */
		public function move( position:Point ):void
		{
			updatePosition( position.x, position.y );
		}
		
		/**
		 * @copy ISliderStrategy#end()
		 */
		public function end( position:Point ):void
		{
			updatePosition( position.x, position.y );
		}
		
		/**
		 * @copy ISliderStrategy#mediate()
		 */
		public function mediate( target:ISlider ):void
		{
			_sliderTarget = target;
			_thumb = target.thumbTarget;
			_bounds = target.sliderBounds;
			initialize();
		}
		
		/**
		 * @copy ISliderStrategy#unmediate()
		 */
		public function unmediate():void
		{
			endAnimation(false);
			_sliderTarget = null;
			_thumb = null;
		}
	}
}