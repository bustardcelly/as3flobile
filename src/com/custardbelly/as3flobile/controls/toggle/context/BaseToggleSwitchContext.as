/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BaseToggleSwitchContext.as</p>
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
	 * BaseToggleSwitchContext is a base context to manage a IToggleSwitch based on a strategy. 
	 * @author toddanderson
	 */
	public class BaseToggleSwitchContext implements IToggleSwitchContext
	{
		protected var _isActive:Boolean;
		protected var _toggleTarget:IToggleSwitch;
		protected var _strategy:IToggleSwitchStrategy;
		
		/**
		 * Constructor. 
		 * @param strategy IToggleSwitchStrategy
		 */
		public function BaseToggleSwitchContext( strategy:IToggleSwitchStrategy )
		{
			_strategy = strategy;
		}
		
		/**
		 * @copy IToggleSwitchContext#initialize()
		 */
		public function initialize( target:IToggleSwitch ):void
		{
			_toggleTarget = target;
		}
		
		/**
		 * @copy IToggleSwitchContext#update()
		 */
		public function update():void
		{
			if( _isActive )
			{
				_strategy.mediate( _toggleTarget );
			}
		}
		
		/**
		 * @copy IToggleSwitchContext#updateSelectedIndex()
		 */
		public function updateSelectedIndex( value:uint ):void
		{
			if( _isActive )
			{
				_strategy.selectIndex( value );
			}
		}
		
		/**
		 * @copy IToggleSwitchContext#activate()
		 */
		public function activate():void
		{
			_isActive = true;
			update();
		}
		
		/**
		 * @copy IToggleSwitchContext#deactivate()
		 */
		public function deactivate():void
		{
			_isActive = false;
			_strategy.unmediate();
		}
		
		/**
		 * @copy IToggleSwitchContext#dispose()
		 */
		public function dispose():void
		{
			deactivate();
		}
		
		/**
		 * @copy IToggleSwitchContext#strategy
		 */
		public function get strategy():IToggleSwitchStrategy
		{
			return _strategy;
		}
		public function set strategy( value:IToggleSwitchStrategy ):void
		{
			_strategy = value;
		}
	}
}