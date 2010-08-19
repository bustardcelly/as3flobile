/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleButton.as</p>
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
package com.custardbelly.as3flobile.controls.button
{
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.skin.ToggleButtonSkin;
	
	import flash.events.MouseEvent;

	/**
	 * ToggleButton is a Button extension that manages the state of being selected or toggled. 
	 * @author toddanderson
	 */
	public class ToggleButton extends Button
	{
		protected var _currentState:int;
		protected var _delegate:IToggleButtonDelegate;
		
		/**
		 * Constructor.
		 */
		public function ToggleButton() { super(); }
		
		/**
		 * Static util method to create a new instance of ToggleButton with specified IToggleButtonDelegate reference. 
		 * @param delegate IToggleButtonDelegate
		 * @return ToggleButton
		 */
		public static function initWithDelegate( delegate:IToggleButtonDelegate ):ToggleButton
		{
			var button:ToggleButton = new ToggleButton();
			button.delegate = delegate;
			return button;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_skin = new ToggleButtonSkin();
			_skin.target = this;
		}
		
		/**
		 * @inherit
		 */
		override protected function addDisplayHandlers():void
		{
			addEventListener( MouseEvent.CLICK, handleToggleClick, false, 0, true );
		}
		
		/**
		 * @inherit
		 */
		override protected function removeDisplayHandlers():void
		{
			removeEventListener( MouseEvent.CLICK, handleToggleClick, false );
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
			
			if( _delegate )
				_delegate.toggleButtonSelectionChange( this, value );
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
		protected function handleToggleClick( evt:MouseEvent ):void
		{
			this.selected = !this.selected;
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			_delegate = null;
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

		/**
		 * Accessor/Modifier for IToggleButtonDelegate instance that requires notification of change to toggle state. 
		 * @return IToggleButtonDelegate
		 */
		public function get delegate():IToggleButtonDelegate
		{
			return _delegate;
		}
		public function set delegate(value:IToggleButtonDelegate):void
		{
			_delegate = value;
		}
	}
}