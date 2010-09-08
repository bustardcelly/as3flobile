/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ITapMediator.as</p>
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

	/**
	 * ITapMediator mediates handling a tap gesture from a interactive object. A tap gesture can take on different contexts dependant on target device. 
	 * @author toddanderson
	 */
	public interface ITapMediator
	{
		/**
		 * Initiates a session of mediating a tap gesture event.
		 * @param display InteractiveObject The interactive display object that dispatches events recognized as a tap.
		 * @param gestureHandler Function The delegate handler once the tap gesture is recieved.
		 */
		function mediateTapGesture( display:InteractiveObject, gestureHandler:Function ):void;
		/**
		 * Ends a session of mediating a tap gesture event. 
		 * @param display InteractiveObject The interactive display object of which to stop mediating tap events from.
		 */
		function unmediateTapGesture( display:InteractiveObject ):void;
		/**
		 * Returns flag of medaiting a tap gesture with the target display. 
		 * @param display InteractiveObject
		 * @return Boolean
		 */
		function isMediating( display:InteractiveObject ):Boolean
	}
}