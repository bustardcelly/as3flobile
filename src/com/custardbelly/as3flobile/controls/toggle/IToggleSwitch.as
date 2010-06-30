/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IToggleSwitch.as</p>
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
package com.custardbelly.as3flobile.controls.toggle
{
	import com.custardbelly.as3flobile.controls.toggle.context.IToggleSwitchContext;
	
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	public interface IToggleSwitch extends IEventDispatcher
	{
		/**
		 * Returns a reference to the background target for IToggleContext to reference. 
		 * @return InteractiveObject
		 */
		function get backgroundTarget():InteractiveObject;
		/**
		 * Returns a reference to the thumb target for IToggleContext to reference. 
		 * @return InteractiveObject
		 */
		function get thumbTarget():InteractiveObject;
		/**
		 * Returns the bounding area of the togglable display.
		 * @return Rectangle
		 */
		function get toggleBounds():Rectangle;
		
		/**
		 * Accessor/Modifier for the selected index of the switch. Either 0 or 1. Default is 0.
		 * @return uint
		 */
		function get selectedIndex():uint;
		function set selectedIndex( value:uint ):void;
		
		/**
		 * Accessor/Modifier for the IToggleContext instance that handles user interaction. 
		 * @return IToggleContext
		 */
		function get toggleContext():IToggleSwitchContext;
		function set toggleContext( value:IToggleSwitchContext ):void;
		
		/**
		 * Accessor/Modifier for the IToggleSwitchDelegate that recieves notification of operations related to IToggleSwitch. 
		 * @return IToggleSwitchDelegate
		 */
		function get delegate():IToggleSwitchDelegate;
		function set delegate( value:IToggleSwitchDelegate ):void;
	}
}