/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: TargetScrollAdaptor.as</p>
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
package com.custardbelly.as3flobile.controls.viewport.adaptor
{
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewportDelegate;
	import com.custardbelly.as3flobile.model.IDisposable;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * TargetScrollAdaptor assumes scrolling animation of a target display based on a target position.
	 * Typically this is used by a IScrollViewportStrategy to move content along the axes toward a target.
	 * IScrollViewportStrategy mainly handles a 'loose' scrolling based on user gesture and is not focused on finding a specific position.
	 * This hopes to alleviate that responsibility. 
	 * @author toddanderson
	 */
	public class TargetScrollAdaptor implements ITargetScrollAdaptor
	{
		protected var _velocityX:Number;
		protected var _velocityY:Number;
		protected var _targetPositionX:int;
		protected var _targetPositionY:int;
		
		protected var _isAnimating:Boolean;
		
		protected var _content:DisplayObject;
		protected var _coordinate:Point;
		protected var _delegate:IScrollViewportDelegate;
		
		/**
		 * Constructor.
		 */
		public function TargetScrollAdaptor() {}
		
		/**
		 * @private 
		 * 
		 * Starts the animation loop.
		 */
		protected function startAnimate():void
		{
			// Add handlers.
			if( _content )
			{
				_isAnimating = true;
				_content.removeEventListener( Event.ENTER_FRAME, animate, false );
				_content.addEventListener( Event.ENTER_FRAME, animate, false, 0, true );
			}
			// Notify delegate.
			if( _isAnimating && _delegate )
			{
				_delegate.scrollViewDidStart( _coordinate );
			}
		}
		
		/**
		 * @private 
		 * 
		 * Stops the animation.
		 */
		protected function stopAnimate():void
		{
			// Remove handlers.
			if( _content ) 
			{
				_content.removeEventListener( Event.ENTER_FRAME, animate, false );	
			}
			_isAnimating = false;
		}
		
		/**
		 * @private
		 * 
		 * The animation loop to move the target scroll display toward the target position. 
		 * @param evt Event
		 */
		protected function animate( evt:Event = null ):void
		{
			// Basic easing toward target position.
			_velocityX = ( _targetPositionX - _coordinate.x ) * 0.42;
			_velocityY = ( _targetPositionY - _coordinate.y ) * 0.42;
			
			var absVelX:Number = ( _velocityX > 0 ) ? _velocityX : -_velocityX;
			var absVelY:Number = ( _velocityY > 0 ) ? _velocityY : -_velocityY;
			if( absVelX < 0.75 && absVelY < 0.75 )
			{
				_coordinate.x = _targetPositionX;
				_coordinate.y = _targetPositionY;
				_velocityX = 0;
				_velocityY = 0;
			}
			// Update current positon with velocity.
			_coordinate.x += _velocityX;
			_coordinate.y += _velocityY;
			
			// Set the position of target content along the x, y axis.
			_content.x = _coordinate.x;
			_content.y = _coordinate.y;
			
			// Notify delegate of animation.
			if( _delegate )
			{
				_delegate.scrollViewDidAnimate( _coordinate );
			}
			
			// If we ain't moving, we ain't moving.
			if( _velocityX == 0 && _velocityY == 0 )
			{
				stopAnimate();
				// If we have stopped animating, notify delegate.
				if( _delegate )
				{
					_delegate.scrollViewDidEnd( _coordinate );
				}
			}
		}
		
		/**
		 * @copy ITargetScrollAdaptor#scrollToPosition()
		 */
		public function scrollToPosition( targetPosition:Point, currentPosition:Point, content:DisplayObject, delegate:IScrollViewportDelegate ):void
		{
			_content = content;
			_delegate = delegate;
			_coordinate = currentPosition;
			_targetPositionX = targetPosition.x;
			_targetPositionY = targetPosition.y;
			
			startAnimate();
		}
		
		/**
		 * @copy ITargetScrollAdaptor#stop()
		 */
		public function stop():void
		{
			if( _isAnimating ) stopAnimate();	
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		public function dispose():void
		{
			stop();
			_content = null;
			_delegate = null;
		}
	}
}