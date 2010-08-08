/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollViewportMouseContext.as</p>
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
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ScrollViewportMouseContext is a context for scrolling strategy that bases its mediated user interaction for a scroll event using the mouse. 
	 * @author toddanderson
	 */
	public class ScrollViewportMouseContext extends BaseScrollViewportContext
	{
		protected var _point:Point;
		protected var _mouseTarget:Stage;
		
		protected var _viewportPoint:Point;
		protected var _viewportPosition:Point;
		protected var _viewportX:int;
		protected var _viewportY:int;
		protected var _viewportWidth:int;
		protected var _viewportHeight:int;
		
		protected var _startTime:int;
		protected var _tapThreshold:int = 500;
		
		/**
		 * Constructor. 
		 * @param strategy IScrollViewportStrategy The strategy to use during mediation of a scrolling seqeunce.
		 */
		public function ScrollViewportMouseContext(strategy:IScrollViewportStrategy)
		{
			super(strategy);
			_point = new Point();
		}
		
		/**
		 * @private 
		 * 
		 * Adds event handlers for targets representing a start and end to scrolling.
		 */
		protected function addTargetListeners():void
		{
			_mouseTarget.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true );
			_mouseTarget.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event handlers from targets representing a start and end to scrolling.
		 */
		protected function removeTargetListeners():void
		{
			if( !_mouseTarget ) return;
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove, false );
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false );
		}
		
		/**
		 * @private
		 * 
		 * Returns flag of coordinate point residing with the viewport bounds. 
		 * @param xpos Number
		 * @param ypos Number
		 * @return Boolean
		 */
		protected function isWithinViewportBounds( xpos:Number, ypos:Number ):Boolean
		{
			if( _viewportPosition == null ) 
			{
				_viewportPosition = ( _viewport as DisplayObject ).localToGlobal( _viewportPoint );
				_viewportX = _viewportPosition.x;
				_viewportY = _viewportPosition.y;
				_viewportWidth =  _viewportX + _viewport.width;
				_viewportHeight = _viewportY + _viewport.height;
			}
			return ( xpos > _viewportX && xpos < _viewportWidth ) && ( ypos > _viewportY && ypos < _viewportHeight );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for MOUSE_DOWN event which instrcuts the scrolling strategy to start. 
		 * @param evt MouseEvent
		 */
		protected function handleMouseDown( evt:MouseEvent ):void
		{
			_mouseTarget = ( evt.target as InteractiveObject ).stage;
			addTargetListeners();
			
			_point.x = _mouseTarget.mouseX;
			_point.y = _mouseTarget.mouseY;
			_strategy.start( _point );
			
			_startTime = getTimer();
			evt.updateAfterEvent();
		}
		
		/**
		 * Event handler for MOUSE_MOVE event which instructs the scrolling strategy to move. 
		 * @param evt MouseEvent
		 * 
		 */
		protected function handleMouseMove( evt:MouseEvent ):void
		{
			var targetX:Number = _mouseTarget.mouseX;
			var targetY:Number = _mouseTarget.mouseY;
			// NOTE: Taking out check for bounds for speed.
//			var isWithinBounds:Boolean = isWithinViewportBounds( targetX, targetY );
			
			_point.x = targetX;
			_point.y = targetY;
			_strategy.move( _point );
			
//			if( !isWithinBounds ) handleMouseUp( evt );
			evt.updateAfterEvent();
		}
		
		/**
		 * Event handler for MOUSE_UP event which instructs the scrolling strategy to end. 
		 * @param evt MouseEvent
		 */
		protected function handleMouseUp( evt:MouseEvent ):void
		{
			var withinTapThreshold:Boolean = ( getTimer() - _startTime <= _tapThreshold );
			removeTargetListeners();
			// If we haven't performed what is perceieved as a tap operation.
			if( !withinTapThreshold )
			{
				_point.x = _mouseTarget.mouseX;
				_point.y = _mouseTarget.mouseY;
			}
			_strategy.end( _point );
			_mouseTarget = null;
			evt.updateAfterEvent();
		}
		
		/**
		 * @inherit
		 */
		override public function initialize( viewport:IScrollViewport ):void
		{
			super.initialize( viewport );
			_viewportPoint = new Point( ( _viewport as DisplayObject ).x, ( _viewport as DisplayObject ).y );
		}
		
		/**
		 * @inherit
		 */
		override public function activate():void
		{
			super.activate();
			_viewport.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true );
		}
		
		/**
		 * @inherit
		 */
		override public function deactivate():void
		{
			super.deactivate();
			_viewport.removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false );
			removeTargetListeners();
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			_mouseTarget = null;
		}
	}
}