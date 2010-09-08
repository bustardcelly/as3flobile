/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BaseSliderContext.as</p>
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

	/**
	 * BaseSliderContext is a base context to manage a ISlider based on a strategy. 
	 * @author toddanderson
	 */
	public class BaseSliderContext implements ISliderContext
	{
		protected var _isActive:Boolean;
		protected var _sliderTarget:ISlider;
		protected var _strategy:ISliderStrategy;
		
		/**
		 * Constructor. 
		 * @param strategy ISliderStrategy
		 */
		public function BaseSliderContext( strategy:ISliderStrategy )
		{
			_strategy = strategy;
		}
		
		/**
		 * @copy ISliderContext#initialize()
		 */
		public function initialize( target:ISlider ):void
		{
			_sliderTarget = target;
		}
		
		/**
		 * @copy ISliderContext#update()
		 */
		public function update():void
		{
			if( _isActive )
			{
				_strategy.mediate( _sliderTarget );
			}
		}
		
		/**
		 * @copy ISliderContext#activate()
		 */
		public function activate():void
		{
			_isActive = true;
			update();
		}
		/**
		 * @copy ISliderContext#deactivate()
		 */
		public function deactivate():void
		{
			_isActive = false;
			_strategy.unmediate();
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		public function dispose():void
		{
			deactivate();
			_strategy = null;
		}

		/**
		 * @copy ISliderContext#strategy
		 */
		public function get strategy():ISliderStrategy
		{
			return _strategy;
		}
		public function set strategy( value:ISliderStrategy ):void
		{
			_strategy = value;
		}
	}
}