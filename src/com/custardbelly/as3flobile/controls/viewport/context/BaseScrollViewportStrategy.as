/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BaseScrollViewportStrategy.as</p>
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
package com.custardbelly.as3flobile.controls.viewport.context
{
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewport;
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewportDelegate;
	import com.custardbelly.as3flobile.model.ScrollMark;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * BaseScrollViewportStrategy is the base strategy for managing the movement of content within a viewport along its x and y axes. 
	 * @author toddanderson
	 */
	public class BaseScrollViewportStrategy implements IScrollViewportStrategy
	{
		protected var _content:DisplayObject;
		protected var _bounds:Rectangle;
		protected var _delegate:IScrollViewportDelegate;
		
		protected var _currentScrollPositionX:Number = 0;
		protected var _currentScrollPositionY:Number = 0;
		protected var _scrollBoundsLeft:int;
		protected var _scrollBoundsRight:int;
		protected var _scrollBoundsTop:int;
		protected var _scrollBoundsBottom:int;
		protected var _scrollAreaWidth:int;
		protected var _scrollAreaHeight:int;
		protected var _isScrollableX:Boolean;
		protected var _isScrollableY:Boolean;
		
		protected var _thresholdX:Number;
		protected var _thresholdY:Number;
		protected var _velocityX:Number;
		protected var _velocityY:Number;
		
		protected var _marks:Vector.<ScrollMark>;
		protected var _markIndex:uint;
		
		protected var _coordinate:Point;
		
		protected var _framerate:int = 24;
		protected var _damp:Number;
		
		public static const DAMP:Number = 0.8;
		public static const THRESHOLD:Number = 0.01;
		public static const VECTOR_MIN:Number = 0.01;
		public static const VECTOR_MAX:int = 60;
		public static const VECTOR_MULTIPLIER:Number = 0.25;
		public static const RETURN_TIME:int = 85;
		public static const CAPACITY:uint = 20;
		
		/**
		 * Constructor.
		 */
		public function BaseScrollViewportStrategy() {}
		
		/**
		 * @private 
		 * 
		 * Initializes any necessary values usedin mediating and determining scroll.
		 */
		protected function initialize():void
		{
			_velocityX = _velocityY = 0;
			
			_scrollAreaWidth = _bounds.width - _bounds.x;
			_scrollAreaHeight = _bounds.height - _bounds.y;
			
			_isScrollableX = !isNaN( _content.width ) && ( _scrollAreaWidth < _content.width );
			_isScrollableY = !isNaN( _content.height ) && ( _scrollAreaHeight < _content.height );
			
			_scrollBoundsLeft = _bounds.x;
			_scrollBoundsTop = _bounds.y;
			_scrollBoundsRight =  _isScrollableX ? _scrollAreaWidth - _content.width : _scrollBoundsLeft;
			_scrollBoundsBottom = _isScrollableY ? _scrollAreaHeight - _content.height : _scrollBoundsTop;
			
			_damp = DAMP;
			_thresholdX = BaseScrollViewportStrategy.THRESHOLD * _bounds.width;
			_thresholdY = BaseScrollViewportStrategy.THRESHOLD * _bounds.height;
			
			// Create marks and fill with capacity.
			if( _marks == null )
				_marks = new Vector.<ScrollMark>( BaseScrollViewportStrategy.CAPACITY );
			
			var i:int;
			for( i = 0; i < BaseScrollViewportStrategy.CAPACITY; i++ )
			{
				_marks[i] = ScrollMark.getScrollMark( 0, 0, 0 );
			}
			
			// Crate coordinate point used in notify delegates of aniimation.
			if( _coordinate == null ) _coordinate = new Point();
			_coordinate.x = _currentScrollPositionX;
			_coordinate.y = _currentScrollPositionY;
		}
		
		/**
		 * @private
		 * 
		 * Validates the supplied position. 
		 * @param value Point
		 */
		protected function invalidatePosition( value:Point ):void
		{
			endAnimate();
			_velocityX = _velocityY = 0;
			_currentScrollPositionX = value.x;
			_currentScrollPositionY = value.y;
			animate();
		}
		
		/**
		 * @private
		 * 
		 * Adds a mark to the revolving list to be used to determine passing of time and distance between marks in a scroll operation. 
		 * @param x Number
		 * @param time Number
		 * @return ScrollMark
		 */
		protected function addMark( x:Number, y:Number, time:Number ):ScrollMark
		{
			var index:uint = _markIndex;
			
			if( ++_markIndex == BaseScrollViewportStrategy.CAPACITY )
				_markIndex = 0;
			
			_marks[index].x = x;
			_marks[index].y = y;
			_marks[index].time = time;
			return _marks[index];
		}
		
		/**
		 * @private
		 * 
		 * Returns the recently added mark to the revolving list. 
		 * @return ScrollMark
		 */
		protected function recentMark():ScrollMark
		{
			var index:uint = ( _markIndex == 0 ) ? _marks.length - 1 : _markIndex - 1;
			return _marks[index];
		}
		
		/**
		 * @private
		 * 
		 * Returns the crossover percentage between current time and the previous time values.
		 * @param value Length of time between current scroll mark and min passage of time.
		 * @param valueMin Previous time of scroll mark.
		 * @param valueMax Recent time of scroll mark.
		 * @param targetMin Minimum value.
		 * @param targetMax Maximum value.
		 * @return Number
		 */
		protected function linearMap( value:Number, valueMin:Number, valueMax:Number, targetMin:Number, targetMax:Number ):Number
		{
			var zeroValue:Number = value - valueMin;
			var maxRange:Number = valueMax - valueMin;
			var valueRange:Number = ( maxRange > 1 ) ? maxRange : 1;
			var targetRange:Number = targetMax - targetMin;
			var zeroTargetValue:Number = zeroValue * ( targetRange / valueRange );
			var targetValue:Number = zeroTargetValue + targetMin;
			return targetValue;
		}
		
		/**
		 * @private
		 * 
		 * Creates a new value point from a specified range of points based on crossover.
		 * @param from Number
		 * @param to Number
		 * @param percent Number
		 * @return Number
		 */
		protected function interpolate( from:Number, to:Number, percent:Number ):Number
		{
			return ( from * ( 1 - percent ) ) + ( to * percent );
		}
		
		/**
		 * @private
		 * 
		 * Limits the current position to the boundaries specified in the target viewport.
		 */
		protected function limitPosition():void
		{
			// limit position along the x-axis.
			if( _currentScrollPositionX > _scrollBoundsLeft )
			{
				_currentScrollPositionX = _scrollBoundsLeft;
			}
			else if( _currentScrollPositionX < _scrollBoundsRight )
			{
				_currentScrollPositionX = _scrollBoundsRight;
			}
			// limit position along the y-axis.
			if( _currentScrollPositionY > _scrollBoundsTop )
			{
				_currentScrollPositionY = _scrollBoundsTop;
			}
			else if( _currentScrollPositionY < _scrollBoundsBottom )
			{
				_currentScrollPositionY = _scrollBoundsBottom;
			}
		}
		
		/**
		 * @private 
		 * 
		 * Begins an animated sequence for scrolling.
		 */
		protected function startAnimate():void
		{
			// Use ENTER_FRAME to update position based on velocity.
			if( !_content.hasEventListener( Event.ENTER_FRAME ) )
			{
				_content.addEventListener( Event.ENTER_FRAME, animate, false, 0, true );
			}
		}
		
		/**
		 * @private 
		 * 
		 * Ends an animated sequence for scrolling.
		 */
		protected function endAnimate():void
		{
			// Remove enter frame handler.
			_content.removeEventListener( Event.ENTER_FRAME, animate, false );
			
			// Notify delegate of end.
			if( _delegate )
			{
				_coordinate.x = _currentScrollPositionX;
				_coordinate.y = _currentScrollPositionY;
				_delegate.scrollViewDidEnd( _coordinate );
			}
			
			// Remove previously held values on mark list.
			var i:int;
			var mark:ScrollMark;
			for( i = 0; i < BaseScrollViewportStrategy.CAPACITY; i++ )
			{
				mark = _marks[i];
				mark.x = mark.y = mark.time = 0;
			}
			_markIndex = 0;
		}
		
		/**
		 * @private
		 * 
		 * Handler for animation of scroll. May be invoked throuhg event system or directly. 
		 * @param evt Event
		 */
		protected function animate( evt:Event = null ):void
		{
			// Update current positon with velocity.
			_currentScrollPositionX += _velocityX;
			_currentScrollPositionY += _velocityY;
			
			// limit position along the x and y-axis.
			limitPosition();
			
			// Set the position of target content along the x, y axis.
			_content.x = _currentScrollPositionX;
			_content.y = _currentScrollPositionY;
			
			// IF we have stopped moving, stop moving.
			if( _velocityX == 0 && _velocityY == 0 ) return;
			// Notify delegate of animation.
			if( _delegate )
			{
				_coordinate.x = _currentScrollPositionX;
				_coordinate.y = _currentScrollPositionY;
				_delegate.scrollViewDidAnimate( _coordinate );
			}
			
			// Damp the velocity.
			_velocityX *= _damp;
			// If our velocity has gone below the minimum threshold of movement, stop.
			var velAbs:Number = ( _velocityX > 0.0 ) ? _velocityX : -_velocityX;
			if( velAbs < BaseScrollViewportStrategy.VECTOR_MIN )
			{
				_velocityX = 0;
			}
			
			_velocityY *= _damp;
			// If our velocity has gone below the minimum threshold of movement, stop.
			velAbs = ( _velocityY > 0.0 ) ? _velocityY : -_velocityY;
			if( velAbs < BaseScrollViewportStrategy.VECTOR_MIN )
			{
				_velocityY = 0;
			}
			
			// If we ain't moving, we ain't moving.
			if( _velocityX == 0 && _velocityY == 0 )
			{
				endAnimate();
			}
		}
		
		
		/**
		 * Starts the marking of touch movements and animation. 
		 * @param point Point
		 */
		public function start(point:Point):void
		{
			// Notify delegate of end.
			if( _delegate )
			{
				_coordinate.x = _currentScrollPositionX;
				_coordinate.y = _currentScrollPositionY;
				_delegate.scrollViewDidEnd( _coordinate );
			}
			
			// Start from the top.
			_velocityX = _velocityY = 0;
			_markIndex = 0;
			
			// Add mark to revolving list.
			addMark( point.x, point.y, getTimer() );
			
			// Notify the delegate of start.
			if( _delegate )
			{
				_coordinate.x = _currentScrollPositionX;
				_coordinate.y = _currentScrollPositionY;
				_delegate.scrollViewDidStart( _coordinate );
			}
		}
		
		/**
		 * Marks continually movement of touch gesture and moves the content along the x and y axis within the limit bounds. 
		 * @param point Point
		 */
		public function move(point:Point):void
		{
			// Grab reference to last mark.
			var previousMark:ScrollMark = recentMark();
			// Store reference to current mark.
			addMark( point.x, point.y, getTimer() );
			
			// * This method is simply a move of point along the x and y-axis, it is not a running update on animation,
			//		as such, we clamp down on velocity.
			
			// Update velocity and position.
			_velocityX = 0; 
			_velocityY = 0;
			_currentScrollPositionX += point.x - previousMark.x;
			_currentScrollPositionY += point.y - previousMark.y;
			
			// limit position along the x and y-axis.
			limitPosition();
			
			// Set the position of target content along the x, y axis.
			_content.x = _currentScrollPositionX;
			_content.y = _currentScrollPositionY;
			
			// Notify client of animate.
			if( _delegate )
			{
				_coordinate.x = _currentScrollPositionX;
				_coordinate.y = _currentScrollPositionY;
				_delegate.scrollViewDidAnimate( _coordinate );
			}
		}
		
		/**
		 * Ends the touch session which marks consequitive movements of the finger. 
		 * @param point Point
		 */
		public function end(point:Point):void
		{	
			const VECTOR_MULTIPLIER:Number = 0.25;
			const VECTOR_MAX:int = 60;
			
			var previousMark:ScrollMark = recentMark();
			var currentMark:ScrollMark = addMark( point.x, point.y, getTimer() );
			var currentMarkX:Number = currentMark.x;
			var currentMarkY:Number = currentMark.y;
			
			// Update position.
			_currentScrollPositionX += currentMarkX - previousMark.x;
			_currentScrollPositionY += currentMarkY - previousMark.y;
			limitPosition();
			
			// Find the most recent mark related to the crossover.
			var crossover:Number = currentMark.time - BaseScrollViewportStrategy.RETURN_TIME;
			var recentIndex:uint;
			var i:uint;
			var length:uint = _marks.length;
			var mark:ScrollMark;
			find: while( i++ < length - 1 )
			{
				mark = _marks[i];
				if( mark.time > crossover )
				{
					recentIndex  = i;
					break find;
				}
			}
			if( recentIndex == 0 ) recentIndex = 1;
			
			// Grab the two related marks based on the difference within time.
			var recentMark:ScrollMark = _marks[recentIndex];
			previousMark = _marks[int(recentIndex - 1)];
			// Determine the threshold and new point.
			var crossoverPercent:Number = linearMap( crossover, previousMark.time, recentMark.time, 0, 1 );
			var newPointX:Number = ( previousMark.x * ( 1 - crossoverPercent ) ) + ( recentMark.x * crossoverPercent );//interpolate( previousMark.x, recentMark.x, crossoverPercent );
			var newPointY:Number = ( previousMark.y * ( 1 - crossoverPercent ) ) + ( recentMark.y * crossoverPercent );//interpolate( previousMark.y, recentMark.y, crossoverPercent );
			var thresholdX:Number = currentMarkX - newPointX;
			var thresholdY:Number = currentMarkY - newPointY;
			var absoluteThreshold:Number = ( thresholdX > 0.0 ) ? thresholdX : -thresholdX;
			
			// If we haven't reach our threshold, our latest point is the current one.
			if( absoluteThreshold < _thresholdX )
			{
				newPointX = currentMarkX;
			}
			absoluteThreshold = ( thresholdY > 0.0 ) ? thresholdY : -thresholdY;
			if( absoluteThreshold < _thresholdY )
			{
				newPointY = currentMarkY;
			}
			// If we have determined that the newest point is the current one, then we have stopped animating.
			if( currentMarkX == newPointX && currentMarkY == newPointY )
			{
				endAnimate();
				return;
			}
			// Update the velocity.
			var velocityX:Number = thresholdX * VECTOR_MULTIPLIER;
			var velocityY:Number = thresholdY * VECTOR_MULTIPLIER;
			var absoluteVelocity:Number = ( velocityX > 0.0 ) ? velocityX : -velocityX;
			// If we have reached our max velocity, start slowing down.
			var factor:Number;
			if( absoluteVelocity >= VECTOR_MAX )
			{
				factor = VECTOR_MAX / absoluteVelocity;
				velocityX *= factor;
			}
			absoluteVelocity = ( velocityY > 0.0 ) ? velocityY : -velocityY;
			if( absoluteVelocity >= VECTOR_MAX )
			{
				factor = VECTOR_MAX / absoluteVelocity;
				velocityY *= factor;
			}
			_velocityX = velocityX;
			_velocityY = velocityY;
			
			// Start the animation session.
			startAnimate();
		}
		
		/**
		 * @copy IScrollViewportStrategy#mediate()
		 */
		public function mediate(viewport:IScrollViewport):void
		{
			// Hold refernces to properties on the IScrollViewport for ease of operations.
			_content = viewport.content;
			_bounds = viewport.scrollBounds;
			_delegate = viewport.delegate;
			// Return marks.
			if( _marks != null )
			{
				var i:int;
				var length:int = _marks.length;
				var mark:ScrollMark;
				for( i = 0; i < length; i++ )
				{
					mark = _marks[i];
					ScrollMark.returnScrollMark( mark );
				}
			}
			// If we have the minimum of what is needed, initialize.
			if( _content && _bounds )
				initialize();
		}
		
		/**
		 * @copy IScrollViewportStrategy#unmediate()
		 */
		public function unmediate():void
		{
			// Kill handlers.
			if( _content ) _content.removeEventListener( Event.ENTER_FRAME, animate, false );
			// Return marks.
			if( _marks != null )
			{
				var i:int;
				var length:int = _marks.length;
				var mark:ScrollMark;
				for( i = 0; i < length; i++ )
				{
					mark = _marks[i];
					ScrollMark.returnScrollMark( mark );
				}
			}
		}
		
		/**
		 * @copy IScrollViewportStrategy#position
		 */
		public function get position():Point
		{
			return _coordinate;
		}
		public function set position( value:Point ):void
		{
			invalidatePosition( value );
		}
	}
}