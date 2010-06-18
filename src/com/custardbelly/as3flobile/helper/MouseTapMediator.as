/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MouseTapMediator.as</p>
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
package com.custardbelly.as3flobile.helper
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * MouseTapMediator is an ITapMediator implementation that handles mouse events as tap gestures from an interactive display object. 
	 * @author toddanderson
	 */
	public class MouseTapMediator extends TapMediator
	{
		protected var _startX:Number;
		protected var _startY:Number;
		protected var _length:int = 3;
		
		/**
		 * Constructor. 
		 * @param threshold int The maximum amount of time in milliseconds that relates to the time for a tap gesture. 
		 */
		public function MouseTapMediator( threshold:int = 700 )
		{
			super( threshold );
		}
		
		/**
		 * @inherit
		 */
		override protected function handleTouchBegin( evt:Event ):void
		{
			var mouseEvent:MouseEvent = ( evt as MouseEvent );
			_startX = mouseEvent.stageX;
			_startY = mouseEvent.stageY;
			super.handleTouchBegin( evt );
		}
		
		/**
		 * @inherit
		 */
		override protected function handleTouchEnd( evt:Event ):void
		{
			var mouseEvent:MouseEvent = ( evt as MouseEvent );
			var x:int = mouseEvent.stageX - _startX;
			var y:int = mouseEvent.stageY - _startY;
			var len:int = Math.sqrt( x * x + y * y );
			
			if( len < _length )
				super.handleTouchEnd( evt );
		}
		
		/**
		 * @inherit
		 */
		override public function mediateTapGesture( display:InteractiveObject, handler:Function ):void
		{
			super.mediateTapGesture( display, handler );
			// Use MouseEvents to recognize tap gesture.
			display.addEventListener( MouseEvent.MOUSE_DOWN, handleTouchBegin, false, 100, true );
			display.addEventListener( MouseEvent.MOUSE_UP, handleTouchEnd, false, 100, true );
		}
		
		/**
		 * @inherit
		 */
		override public function unmediateTapGesture( display:InteractiveObject ):void
		{
			super.unmediateTapGesture( display );
			display.removeEventListener( MouseEvent.MOUSE_DOWN, handleTouchBegin, false );
			display.removeEventListener( MouseEvent.MOUSE_UP, handleTouchEnd, false );
		}
	}
}