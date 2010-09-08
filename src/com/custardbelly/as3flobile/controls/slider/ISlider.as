/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ISlider.as</p>
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
package com.custardbelly.as3flobile.controls.slider
{
	import com.custardbelly.as3flobile.controls.slider.context.ISliderContext;
	
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * ISlider represents a slider control whose position and animation based on value is managed by a ISliderStrategy. 
	 * @author toddanderson
	 */
	public interface ISlider extends IEventDispatcher
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
		function get sliderBounds():Rectangle;
		/**
		 * Runs a refresh on the control due to a change in properties or child properties.
		 * @param Point
		 */
		function commitOnPositionChange( position:Point ):void;
	}
}