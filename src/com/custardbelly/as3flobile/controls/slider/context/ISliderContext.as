/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ISliderContext.as</p>
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
package com.custardbelly.as3flobile.controls.slider.context
{
	import com.custardbelly.as3flobile.controls.slider.ISlider;
	import com.custardbelly.as3flobile.model.IDisposable;

	/**
	 * ISliderContext provides a context for an ISliderStrategy instance to track the position of a slider control.  
	 * @author toddanderson
	 */
	public interface ISliderContext extends IDisposable
	{
		/**
		 * Initializes the context with an ISlider instance. 
		 * @param target ISlider
		 */
		function initialize( target:ISlider ):void;
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
		 * Accessor/Modifier to the ISliderStrategy that manages a switch position. 
		 * @return ISliderStrategy
		 */
		function get strategy():ISliderStrategy;
		function set strategy( value:ISliderStrategy ):void;
	}
}