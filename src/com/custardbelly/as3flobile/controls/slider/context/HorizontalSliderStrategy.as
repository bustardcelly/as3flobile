/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: HorizontalSliderStrategy.as</p>
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
package com.custardbelly.as3flobile.controls.slider.context
{
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * HorizontalSliderStrategy is a concrete implementation of BaseSliderStrategy to position displays of a slider control along the x-axis. 
	 * @author toddanderson
	 */
	public class HorizontalSliderStrategy extends BaseSliderStrategy
	{
		protected var _width:Number;
		protected var _leftLimitPosition:Number;
		protected var _rightLimitPosition:Number;
		
		protected var _velocityX:Number;
		protected var _previousX:Number;
		protected var _targetX:Number;
		
		protected var _pointCache:Point;
		
		/**
		 * Constructor.
		 */
		public function HorizontalSliderStrategy() 
		{ 
			super();
			_pointCache = new Point( 0, 0 );
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			_width = _bounds.width;
			_leftLimitPosition = 0;
			_rightLimitPosition = _width - _thumb.width;
		}
		
		/**
		 * @inherit
		 */
		override protected function limitPosition():Boolean
		{
			_rightLimitPosition = _width - _thumb.width;
			// Limit the position of the thumb along the x-axis.
			if( _thumb.x < _leftLimitPosition )
			{
				_thumb.x = _leftLimitPosition;
				return true;
			}
			else if( _thumb.x > _rightLimitPosition )
			{
				_thumb.x = _rightLimitPosition;
				return true;
			}
			return false;
		}
		
		/**
		 * @private 
		 * 
		 * Notify target of change to position value.
		 */
		protected function commitPosition():void
		{
			_pointCache.x = _thumb.x;
			_sliderTarget.commitOnPositionChange( _pointCache );
		}
		
		/**
		 * @inherit
		 */
		override protected function updatePosition( xpos:Number, ypos:Number ):void
		{
			// Update along the x-axis.
			_thumb.x += xpos - _previousX;
			// Limit.
			var hasLimit:Boolean = limitPosition();
			if( !hasLimit ) _previousX = xpos;
			// Commit.
			commitPosition();
		}
		
		/**
		 * @inherit
		 */
		override protected function placePosition( xpos:Number, ypos:Number ):void
		{
			_targetX = xpos - ( _thumb.width * 0.5 );
			_velocityX = 0;
			startAnimation();
		}
		
		/**
		 * @inherit
		 */
		override protected function animate( evt:Event = null ):void
		{
			// Basic easing toward target position.
			_velocityX = ( _targetX - _thumb.x ) * 0.42;
			
			var absVelX:Number = ( _velocityX > 0 ) ? _velocityX : -_velocityX;
			if( absVelX < 0.75 )
			{
				_thumb.x = _targetX;
				_velocityX = 0;
			}
			// Update current positon with velocity.
			_thumb.x += _velocityX;
			// If we ain't moving, we ain't moving.
			var hasLimit:Boolean = limitPosition();
			if( _velocityX == 0 || hasLimit )
			{
				endAnimation();
			}
		}
		
		/**
		 * @inherit
		 */
		override protected function endAnimation( updateSelection:Boolean = true ):void
		{
			super.endAnimation( updateSelection );
			if( updateSelection )
			{
				commitPosition(); 
			}
		}
		
		/**
		 * @inherit
		 */
		override public function start( position:Point ):void
		{
			super.start( position );
			// Mark previous as start.
			_previousX = position.x;
		}
		
		/**
		 * @inherit
		 */
		override public function move( position:Point ):void
		{
			updatePosition( position.x, position.y );
		}
		
		/**
		 * @inherit
		 */
		override public function end( position:Point ):void
		{
			super.end( position );
			commitPosition();
		}
	}
}