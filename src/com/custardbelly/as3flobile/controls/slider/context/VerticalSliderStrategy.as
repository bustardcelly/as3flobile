/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: VerticalSliderStrategy.as</p>
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
	 * VerticalSliderStrategy is a concrete implementation of BaseSliderStrategy to position displays of a slider control along the y-axis. 
	 * @author toddanderson
	 */
	public class VerticalSliderStrategy extends BaseSliderStrategy
	{
		protected var _height:Number;
		protected var _topLimitPosition:Number;
		protected var _bottomLimitPosition:Number;
		
		protected var _velocityY:Number;
		protected var _previousY:Number;
		protected var _targetY:Number;
		
		protected var _pointCache:Point;
		
		/**
		 * Constructor.
		 */
		public function VerticalSliderStrategy() 
		{ 
			super();
			_pointCache = new Point( 0, 0 );
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			_height = _bounds.height;
			_topLimitPosition = 0;
			_bottomLimitPosition = _height - _thumb.height;
		}
		
		/**
		 * @inherit
		 */
		override protected function limitPosition():Boolean
		{
			_bottomLimitPosition = _height - _thumb.height;
			// Limit the position of the thumb along the y-axis.
			if( _thumb.y < _topLimitPosition )
			{
				_thumb.y = _topLimitPosition;
				return true;
			}
			else if( _thumb.y > _bottomLimitPosition )
			{
				_thumb.y = _bottomLimitPosition;
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
			_pointCache.y = _thumb.y;
			_sliderTarget.commitOnPositionChange( _pointCache );
		}
		
		/**
		 * @inherit
		 */
		override protected function updatePosition( xpos:Number, ypos:Number ):void
		{
			// Update along the y-axis.
			_thumb.y += ypos - _previousY;
			// Limit.
			var hasLimit:Boolean = limitPosition();
			if( !hasLimit ) _previousY = ypos;
			// Commit/
			commitPosition();
		}
		
		/**
		 * @inherit
		 */
		override protected function placePosition( xpos:Number, ypos:Number ):void
		{
			_targetY = ypos - ( _thumb.height * 0.5 );
			_velocityY = 0;
			startAnimation();
		}
		
		/**
		 * @inherit
		 */
		override protected function animate( evt:Event = null ):void
		{
			// Basic easing toward target position.
			_velocityY = ( _targetY - _thumb.y ) * 0.42;
			
			var absVelY:Number = ( _velocityY > 0 ) ? _velocityY : -_velocityY;
			if( absVelY < 0.75 )
			{
				_thumb.y = _targetY;
				_velocityY = 0;
			}
			// Update current positon with velocity.
			_thumb.y += _velocityY;
			// If we ain't moving, we ain't moving.
			var hasLimit:Boolean = limitPosition();
			if( _velocityY == 0 || hasLimit )
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
			_previousY = position.y;
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