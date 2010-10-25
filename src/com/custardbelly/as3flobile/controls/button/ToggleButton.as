/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleButton.as</p>
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
package com.custardbelly.as3flobile.controls.button
{
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.skin.ToggleButtonSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;

	/**
	 * ToggleButton is a Button extension that manages the state of being selected or toggled. 
	 * @author toddanderson
	 */
	public class ToggleButton extends Button
	{
		protected var _currentState:int;
		
		protected var _toggle:DeluxeSignal;
		protected var _toggleEvent:GenericEvent;
		
		/**
		 * Constructor.
		 */
		public function ToggleButton() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_skin = new ToggleButtonSkin();
			_skin.target = this;
			
			_toggle = new DeluxeSignal( this );
			_toggleEvent = new GenericEvent();
		}
		
		/**
		 * @private
		 * 
		 * Toggles the current state based on flag. 
		 * @param value Boolean
		 */
		protected function toggleState( value:Boolean ):void
		{
			_currentState = value ? BasicStateEnum.SELECTED : BasicStateEnum.NORMAL;
			_skinState = _currentState;
			updateDisplay();
			
			_toggle.dispatch( _toggleEvent );
		}
		
		/**
		 * @private
		 * 
		 * Determines if current state is associated with flag. 
		 * @param value Boolean
		 * @return Boolean
		 */
		protected function isStateEqual( value:Boolean ):Boolean
		{
			if( value ) return _currentState == BasicStateEnum.SELECTED;
			else 		return _currentState == BasicStateEnum.NORMAL;
		}
		
		/**
		 * @private
		 * 
		 * Event handler for internal mouse click on this instance. 
		 * @param evt MouseEvent
		 */
		override protected function handleTap( evt:Event ):void
		{
			super.handleTap( evt );
			this.selected = !this.selected;
		}
		
		/**
		 * @inherit
		 */
		override protected function handleOut( evt:MouseEvent ):void
		{
			// prevent default. do nothing.
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			_toggle.removeAll();
			_toggle = null;
			_toggleEvent = null;
		}
		
		/**
		 * Returns signal reference for change in toggle. 
		 * @return DeluxeSignal
		 */
		public function get toggle():DeluxeSignal
		{
			return _toggle;
		}
		
		/**
		 * Accessor/Modifier for selection flag associate with current state. 
		 * @return Boolean
		 */
		public function get selected():Boolean
		{
			return ( _currentState == BasicStateEnum.SELECTED );
		}
		public function set selected( value:Boolean ):void
		{
			if( isStateEqual( value ) ) return;
			
			toggleState( value );
		}
	}
}