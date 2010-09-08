/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: TapMediator.as</p>
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
package com.custardbelly.as3flobile.helper
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * TapMediator is am ITapMediator implementation to manage the time between the start and end of an event considered as a tap gesture. 
	 * @author toddanderson
	 */
	public class TapMediator implements ITapMediator
	{
		protected var _startTime:int;
		protected var _threshold:int;
		protected var _isMediating:Boolean;
		protected var _tapDisplay:InteractiveObject;
		protected var _tapHandler:Function;
		
		/**
		 * Constructor. 
		 * @param threshold int The maximum amount of time in milliseconds that relates to the time for a tap gesture.
		 */
		public function TapMediator( threshold:int = 500 ) 
		{
			_threshold = threshold;
		}
		
		/**
		 * @private
		 * 
		 * Event handler for the start of a touch event. Templated method to manage time between gestures to be used and/or overridden in subclass. 
		 * @param evt Event
		 */
		protected function handleTouchBegin( evt:Event ):void
		{
			_startTime = getTimer();
		}
		
		/**
		 * @private
		 * 
		 * Event handle for end of a touch event. Templated method to manage time between gestures to be used and/or overridden in subclass. 
		 * @param evt Event
		 */
		protected function handleTouchEnd( evt:Event ):void
		{
			if( getTimer() - _startTime <= _threshold )
			{
				_tapHandler.apply( this, [evt] );
			}
		}
		
		/**
		 * @copy ITapMediator#mediateTapGesture()
		 */
		public function mediateTapGesture( display:InteractiveObject, gestureHandler:Function ):void
		{
			_tapDisplay = display;
			_tapHandler = gestureHandler;
			_isMediating = true;
		}
		
		/**
		 * @copy ITapMediator#unmediateTapGesture()
		 */
		public function unmediateTapGesture( display:InteractiveObject ):void
		{
			_tapHandler = null;
			_tapDisplay = null;
			_isMediating = false;
		}
		
		/**
		 * @copy ITapMediator#isMediating()
		 */
		public function isMediating( display:InteractiveObject ):Boolean
		{
			return _isMediating && ( display == _tapDisplay );
		}
	}
}