/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: CancelableEvent.as</p>
 * <p>Version: 0.3</p>
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
package com.custardbelly.as3flobile.signal
{
	import org.osflash.signals.Signal;
	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;
	
	/**
	 * CancelableSignal provides a means to notify a client managing a signal if a client who has receieved the signal wishes to stop any further operations based on a modifier flag. 
	 * @author toddanderson
	 */
	public class CancelableSignal extends Signal
	{
		protected var _cancelled:Boolean;
		
		/**
		 * Constructor. 
		 * @param valueClasses ...rest
		 */
		public function CancelableSignal( ...valueClasses )
		{
			super( valueClasses );
		}
		
		/**
		 * Updates flag of being cancelled.
		 */
		public function preventDefault():void
		{
			_cancelled = true;
		}
		
		/**
		 * Resets default properties for re-use.
		 */
		public function reset():void
		{
			_cancelled = false;
		}
		
		/**
		 * Returns falg of having requested to be cancelled. 
		 * @return Boolean
		 */
		public function get cancelled():Boolean
		{
			return _cancelled;
		}
	}
}