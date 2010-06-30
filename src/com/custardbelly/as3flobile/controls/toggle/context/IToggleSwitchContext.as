/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IToggleSwitchContext.as</p>
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

	/**
	 * IToggleSwitchContext provides a context for an IToggleSwitchStrategy instance to track the position of a switch.  
	 * @author toddanderson
	 */
	public interface IToggleSwitchContext
	{
		/**
		 * Initializes the context with an IToggleSwitch instance. 
		 * @param target IToggleSwitch
		 */
		function initialize( target:IToggleSwitch ):void;
		/**
		 * Runs an update based on the nw selected index of the IToggleSwitch target. 
		 * @param value uint
		 */
		function updateSelectedIndex( value:uint ):void;
		/**
		 * Updates the context and strategy.
		 */
		function update():void;
		/**
		 * Activates the context and strategy.
		 */
		function activate():void;
		/**
		 * Deactivates the context and strategy.
		 */
		function deactivate():void;
		/**
		 * Performs any cleanup.
		 */
		function dispose():void;
		
		/**
		 * Accessor/Modifier to the IToggleSwitchStrategy that manages a switch position. 
		 * @return IToggleSwitchStrategy
		 */
		function get strategy():IToggleSwitchStrategy;
		function set strategy( value:IToggleSwitchStrategy ):void;
	}
}