/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BaseToggleSwitchStrategy.as</p>
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
package com.custardbelly.as3flobile.controls.toggle.context
{
	import com.custardbelly.as3flobile.controls.toggle.IToggleSwitch;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * BaseToggleSwitchStrategy is a strategy to manage the position and animation of a toggle switch. 
	 * @author toddanderson
	 */
	public class BaseToggleSwitchStrategy implements IToggleSwitchStrategy
	{
		protected var _toggleTarget:IToggleSwitch;
		protected var _bounds:Rectangle;
		protected var _thumb:InteractiveObject;
		
		protected var _width:Number;
		protected var _halfWidth:Number;
		
		protected var _leftThumbPosition:Number;
		protected var _rightThumbPosition:Number;
		
		protected var _previousX:Number;
		protected var _targetX:Number;
		protected var _velocityX:Number;
		protected var _isAnimating:Boolean;
		
		private static const DAMP:Number = 0.985;
		private static const VECTOR_MIN:int = 3;
		private static const VECTOR_MAX:int = 50;
		
		/**
		 * Constructor.
		 */
		public function BaseToggleSwitchStrategy() {}
		
		/**
		 * @private
		 * 
		 * Initializes the instance with any necessary property values.
		 */
		protected function initialize():void
		{
			_width = _bounds.width;
			_halfWidth = _width * 0.5;
			
			_leftThumbPosition = 0;
			_rightThumbPosition = _width - _thumb.width;
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of a target switch. 
		 * @param value Number
		 */
		protected function updatePosition( value:Number ):void
		{
			_thumb.x += value - _previousX;
			_previousX = value;
			
			limitPosition();
		}
		
		/**
		 * @private 
		 * 
		 * Limits the position of a target switch.
		 */
		protected function limitPosition():void
		{
			if( _thumb.x < _leftThumbPosition )
			{
				_thumb.x = _leftThumbPosition;
			}
			else if( _thumb.x > _rightThumbPosition )
			{
				_thumb.x = _rightThumbPosition;
			}
		}
		
		/**
		 * @private
		 * 
		 * Determines the velocity at which to reach a desired position. 
		 * @param value Number
		 */
		protected function placePosition( value:Number ):void
		{
			// Polarize the thumb position.
			var xpos:Number = ( value > _halfWidth ) ? _rightThumbPosition : _leftThumbPosition;
			_targetX = xpos;
			
			// Get the velocty vector for the thumb from its current position to target position.
			var velocity:Number =  (xpos - _thumb.x) * .25;
			var absoluteVelocity:Number = ( velocity > 0 ) ? velocity : -velocity;
			if( absoluteVelocity >= BaseToggleSwitchStrategy.VECTOR_MAX )
			{
				velocity *= BaseToggleSwitchStrategy.VECTOR_MAX / absoluteVelocity;
			}
			_velocityX = velocity;
			startAnimation();
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
				_toggleTarget.addEventListener( Event.ENTER_FRAME, animate, false, 0, true );
				_isAnimating = true;
			}
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of a target switch. 
		 * @param evt Event Default null. Can be used as an event handler or called directly.
		 */
		protected function animate( evt:Event = null ):void
		{
			_thumb.x += _velocityX;
			limitPosition();
			
			if( _velocityX == 0 )
			{	
				_thumb.x = _targetX;
				endAnimation();
				return;
			}
			
			_velocityX *= BaseToggleSwitchStrategy.DAMP;
			var absoluteVelocity:Number = ( _velocityX > 0 ) ? _velocityX : -_velocityX;
			if( absoluteVelocity < BaseToggleSwitchStrategy.VECTOR_MIN )
			{
				_velocityX = 0;
			}
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
				_toggleTarget.removeEventListener( Event.ENTER_FRAME, animate, false );
				_isAnimating = false;
			}
			
			if( updateSelection )
			{
				_toggleTarget.selectedIndex = ( _thumb.x == _rightThumbPosition ) ? 1 : 0;
			}
		}
		
		/**
		 * @copy IToggleSwitchStrategy#selecteIndex()
		 */
		public function selectIndex( value:uint ):void
		{
			var xpos:Number = ( value == 1 ) ? _rightThumbPosition : _leftThumbPosition;
			if( _thumb.x == xpos ) return;
			
			endAnimation( false );
			placePosition( xpos );
		}
		
		/**
		 * @copy IToggleSwitchStrategy#click()
		 */
		public function click( position:Point ):void
		{
			endAnimation( false );
			placePosition( position.x );
		}
		
		/**
		 * @copy IToggleSwitchStrategy#start()
		 */
		public function start( position:Point ):void
		{
			endAnimation( false );
			_previousX = position.x;
		}
		
		/**
		 * @copy IToggleSwitchStrategy#move()
		 */
		public function move( position:Point ):void
		{
			updatePosition( position.x );
		}
		
		/**
		 * @copy IToggleSwitchStrategy#end()
		 */
		public function end( position:Point ):void
		{
			placePosition( position.x );
		}
		
		/**
		 * @copy IToggleSwitchStrategy#mediate()
		 */
		public function mediate( target:IToggleSwitch ):void
		{
			_toggleTarget = target;
			_thumb = target.thumbTarget;
			_bounds = target.toggleBounds;
			initialize();
		}
		
		/**
		 * @copy IToggleSwitchStrategy#unmediate()
		 */
		public function unmediate():void
		{
			endAnimation();
			_toggleTarget = null;
			_thumb = null;
		}
	}
}