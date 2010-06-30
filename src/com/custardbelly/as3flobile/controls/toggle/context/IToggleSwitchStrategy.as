/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IToggleSwitchStrategy.as</p>
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
	
	import flash.geom.Point;

	/**
	 * IToggleSwitchStrategy is a stategy to manage the position of a toggle switch. 
	 * @author toddanderson
	 */
	public interface IToggleSwitchStrategy
	{
		/**
		 * Starts a mediating session for events from IToggleSwitch. 
		 * @param target IToggleSwitch
		 */
		function mediate( target:IToggleSwitch ):void;
		/**
		 * Ends a mediating session for events form IToggleSwitch.
		 */
		function unmediate():void;
		
		/**
		 * Updates position based on selected index of IToggleSwitch target. 
		 * @param value uint
		 */
		function selectIndex( value:uint ):void;
		/**
		 * Responds to a click gesture. 
		 * @param position Point
		 */
		function click( position:Point ):void;
		/**
		 * Responds to the beginning of a sequence. 
		 * @param position Point
		 */
		function start( position:Point ):void;
		/**
		 * Responds to a change in sequence. 
		 * @param position Point
		 */
		function move( position:Point ):void;
		/**
		 * Responds to an end in a sequence. 
		 * @param position Point
		 */
		function end( position:Point ):void;
	}
}