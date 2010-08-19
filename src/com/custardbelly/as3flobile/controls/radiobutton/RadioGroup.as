/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: RadioGroup.as</p>
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
package com.custardbelly.as3flobile.controls.radiobutton
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.skin.RadioGroupSkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	
	/**
	 * RadioGroup is a mutli-radiobutton control that manages selection across multiple RadioButton instances. 
	 * @author toddanderson
	 */
	public class RadioGroup extends AS3FlobileComponent implements IRadioButtonDelegate
	{
		protected var _background:Shape;
		
		protected var _selectedIndex:int;
		
		protected var _delegate:IRadioGroupDelegate;
		protected var _dataProvider:Vector.<RadioButton>;
		
		/**
		 * Constructor.
		 */
		public function RadioGroup() { super(); }
		
		/**
		 * Static util function to create a new instance of RadioGroup with an IRadioGroupDelegate reference. 
		 * @param delegate IRadioGroupDelegate
		 * @return RadioGroup
		 */
		static public function initWithDelegate( delegate:IRadioGroupDelegate ):RadioGroup
		{
			var group:RadioGroup = new RadioGroup();
			group.delegate = delegate;
			return group;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			// *Note: 	The height properrty is regardless in this context.
			//			The height will be updated once the group is filled with content.
			updatePadding( 10, 10, 10, 10 );
			
			_skin = new RadioGroupSkin();
			_skin.target = this;
			
			_selectedIndex = -1;
			
			_dataProvider = new Vector.<RadioButton>();
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_background = new Shape();
			addChild( _background );
		}
		
		/**
		 * @private 
		 * 
		 * Validates the list of RadioButton instances to manage.
		 */
		protected function invalidateDataProvider():void
		{
			// Remove previous buttons.
			removePreviousRadioButtons();
			
			// Add buttons to the display.
			var i:int = _dataProvider.length;
			var radio:RadioButton;
			while( --i > -1 )
			{
				radio = _dataProvider[i];
				radio.delegate = this;
				addChildAt( radio, 1 );
			}
			// DEfault to first item selected.
			this.selectedIndex = 0;
			// Update display.
			invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the selected index across the RadioButton instance in this control.
		 */
		protected function invalidateSelectedIndex():void
		{
			// Unselect.
			unselectRadioButtons( _selectedIndex );
			// Notify delegate.
			if( _delegate )
				_delegate.radioGroupSelectionChange( this, getRadioButtonAtIndex( _selectedIndex ), _selectedIndex );
		}
		
		/**
		 * @inherit
		 */
		override protected function invalidateSize():void
		{
			super.invalidateSize();
			
			// Update actual height. Any supplied height is disregarded as the full content height is based on its child radio displays and padding.
			if( _dataProvider && _dataProvider.length > 0 )
			{
				var radio:RadioButton = _dataProvider[_dataProvider.length - 1];
				var ypos:int = radio.y;
				_height = ypos + _padding.top + _padding.bottom;
			}
		}
		
		/**
		 * @private 
		 * 
		 * Removes all RadioButtons on the display list.
		 */
		protected function removePreviousRadioButtons():void
		{
			while( numChildren > 1 )
				removeChildAt( 1 );
		}
		
		/**
		 * @private
		 * 
		 * Unselects RadioButtons based on the specified selected index. 
		 * @param index int
		 */
		protected function unselectRadioButtons( index:int ):void
		{
			var i:int = _dataProvider.length;
			var radio:RadioButton;
			while( --i > -1 )
			{
				radio = _dataProvider[i];
				radio.selected = ( i == index );
			}
		}
		
		/**
		 * @private
		 * 
		 * Returns the RadioButton at the specified index.
		 * @param index int
		 * @return RadioButton
		 */
		protected function getRadioButtonAtIndex( index:int ):RadioButton
		{
			if( index > _dataProvider.length - 1 ) return null;
			return _dataProvider[index];
		}
		
		/**
		 * @private
		 * 
		 * Retunrns the elemental index at which the specified RadioButton resides. 
		 * @param radioButton RadioButton
		 * @return int
		 */
		protected function getRadioButtonIndex( radioButton:RadioButton ):int
		{
			var i:int = _dataProvider.length;
			var radio:RadioButton;
			while( --i > -1 )
			{
				radio = _dataProvider[i];
				if( radio == radioButton ) return i;
			}
			return 0;
		}
		
		/**
		 * IRadioButtonDelegate implementation. 
		 * @param radioButton RadioButton
		 * @param selected Boolean
		 */
		public function radioButtonSelectionChange( radioButton:RadioButton, selected:Boolean ):void
		{
			// If there is a new selection, update the selected RadioButtons.
			if( selected )
			{
				var index:int = getRadioButtonIndex( radioButton );
				this.selectedIndex = index;
			}
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			_background = null;
			_delegate = null;
		}
		
		/**
		 * Returns the background display for skinning. 
		 * @return Graphics.
		 */
		public function get backgroundDisplay():Graphics
		{
			return _background.graphics;
		}
		
		/**
		 * Returns the current RadioButton list. 
		 * @return Vector.<RadioButton>
		 */
		public function get items():Vector.<RadioButton>
		{
			return _dataProvider;
		}

		/**
		 * Accessor/Modifier for the client that requires notification of changes form this control. 
		 * @return IRadioGroupDelegate
		 */
		public function get delegate():IRadioGroupDelegate
		{
			return _delegate;
		}
		public function set delegate( value:IRadioGroupDelegate ):void
		{
			_delegate = value;
		}

		/**
		 * Accessor/Modifier for the selected index of the RadioButton instance within this control. 
		 * @return int
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex( value:int ):void
		{
			if( _selectedIndex == value ) return;
			
			_selectedIndex = value;
			invalidateSelectedIndex();
		}
		
		/**
		 * Accessor/Modifier for the list of RadioButton instances to display and manage within this control. 
		 * @return Vector.<RadioButton>
		 */
		public function get dataProvider():Vector.<RadioButton>
		{
			return _dataProvider;
		}
		public function set dataProvider( value:Vector.<RadioButton> ):void
		{
			if( _dataProvider == value ) return;
			
			_dataProvider = value;
			invalidateDataProvider();
		}
	}
}