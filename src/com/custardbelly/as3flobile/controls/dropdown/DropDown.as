/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: DropDown.as</p>
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
package com.custardbelly.as3flobile.controls.dropdown
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
	import com.custardbelly.as3flobile.controls.list.ScrollList;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	import com.custardbelly.as3flobile.skin.DropDownSkin;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.events.GenericEvent;
	
	/**
	 * DownDown is a mutli-button control exposing a list control to select items from. 
	 * @author toddanderson
	 */
	public class DropDown extends AS3FlobileComponent
	{
		protected static const STATE_CLOSED:int = 0;
		protected static const STATE_OPENED:int = 1;
		
		protected var _labelButton:Button;
		protected var _arrowButton:Button;
		protected var _dropDownList:ScrollList;
		
		protected var _currentState:int;
		
		protected var _defaultLabel:String;
		protected var _dropDownWidth:int;
		protected var _dropDownHeight:int;
		
		protected var _selectedIndex:int;
		protected var _dataProvider:Array;
		
		protected var _selectionChange:DeluxeSignal;
		protected var _selectionEvent:GenericEvent;
		
		/**
		 * Constructor.
		 */
		public function DropDown() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_width = 160;
			_height = 48;
			
			_defaultLabel = "Select";
			
			_selectedIndex = -1;
			
			_skin = new DropDownSkin();
			_skin.target = this;
			
			_selectionChange = new DeluxeSignal( this );
			_selectionEvent = new GenericEvent();
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			_labelButton = new Button();
			_labelButton.label = _defaultLabel;
			addChild( _labelButton );
			
			_arrowButton = new Button();
			_arrowButton.label = ">";
			addChild( _arrowButton );
			
			_arrowButton.height = _height;
			_arrowButton.width = 40;
			
			_labelButton.height = _height;
			_labelButton.width = _width - _arrowButton.width;
		}
		
		/**
		 * @inherit
		 */
		override protected function addDisplayHandlers():void
		{
			_labelButton.addEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false, 0, true );
			_arrowButton.addEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false, 0, true );
		}
		
		/**
		 * @inherit
		 */
		override protected function removeDisplayHandlers():void
		{
			_labelButton.removeEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false );
			_arrowButton.removeEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false );
		}
		
		/**
		 * @private
		 * 
		 * Lazy creates and returns the dropdown ScrollList instance. 
		 * @return ScrollList
		 */
		protected function getDropDownList():ScrollList
		{
			if( _dropDownList == null )
			{
				var layout:IScrollListVerticalLayout = new ScrollListVerticalLayout();
				layout.itemHeight = 48;
				_dropDownList = ScrollList.initWithScrollRect( new Rectangle( 0, 0, _dropDownWidth, _dropDownHeight ) );
				_dropDownList.selectionChange.add( listSelectionChange );
				_dropDownList.layout = layout;
			}
			return _dropDownList;
		}
		
		/**
		 * @private 
		 * 
		 * Adds the dropdown list to the display.
		 */
		protected function addDropDownList():void
		{
			if( _dropDownList == null || !contains( _dropDownList ) )
				addChild( getDropDownList() );
		}
		
		/**
		 * @private
		 * 
		 * Removes the dropdown list from the display.
		 */
		protected function removeDropDownList():void
		{
			if( _dropDownList != null && contains( _dropDownList ) )
				removeChild( _dropDownList );
		}
		
		/**
		 * @private 
		 * 
		 * Validates the size of the drop down list control.
		 */
		protected function invalidateDropDownSize():void
		{
			var list:ScrollList = getDropDownList();
			list.width = _dropDownWidth;
			list.height = _dropDownHeight;
		}
		
		/**
		 * @private 
		 * 
		 * Validates the textual content of the default label.
		 */
		protected function invalidateDefaultLabel():void
		{
			// if in state with default label ->
			_labelButton.label = _defaultLabel;
		}
		
		/**
		 * @private 
		 * 
		 * Validates the supplied data for the dropdown list control.
		 */
		protected function invalidateDataProvider():void
		{
			var list:ScrollList = getDropDownList();
			list.dataProvider = _dataProvider;
		}
		
		/**
		 * @private 
		 * 
		 * Validates the selected index within the dropdon list control.
		 */
		protected function invalidateSelectedIndex():void
		{
			var list:ScrollList = getDropDownList();
			list.selectedIndex = _selectedIndex;
			// Update label button to selection or default.
			_labelButton.label = ( _selectedIndex >= 0 && _selectedIndex < _dataProvider.length ) ? _dataProvider[_selectedIndex].label : _defaultLabel;
			// Notify delegate.
			_selectionChange.dispatch( _selectionEvent );
		}
		
		/**
		 * @private
		 * 
		 * Sets the internal state of the control as either being open with dropdown list on the display list, or closed with the dropdown list off the display list. 
		 * @param state int
		 */
		protected function setCurrentState( state:int ):void
		{
			if( _currentState == state ) return;
			
			_currentState = state;
			if( _currentState == DropDown.STATE_OPENED )
				addDropDownList();
			else
				removeDropDownList();
		}
		
		/**
		 * @private 
		 * 
		 * Toggles the internal state of the control.
		 * @see #setCurrentState()
		 */
		protected function toggleState():void
		{
			setCurrentState( _currentState == DropDown.STATE_CLOSED ? DropDown.STATE_OPENED : DropDown.STATE_CLOSED );
		}
		
		/**
		 * @private
		 * 
		 * Event hanlder for click on any of the multi-button display to toggle the state. 
		 * @param evt MouseEvent
		 */
		protected function handleButtonTriggerClick( evt:MouseEvent ):void
		{
			var list:ScrollList = getDropDownList();
			list.y = _height;
			toggleState();
		}
		
		/**
		 * @private
		 * 
		 * Signal handler for change in selection.
		 * @param evt GenericEvent
		 */
		protected function listSelectionChange( evt:GenericEvent ):void 
		{
			var list:IScrollListContainer = evt.target as IScrollListContainer;
			this.selectedIndex = list.selectedIndex;
			closeDropDown();
		}
		
		/**
		 * Opens the dropdown list control.
		 */
		public function openDropDown():void
		{
			setCurrentState( DropDown.STATE_OPENED );
		}
		/**
		 * Closes the dropdown list control.
		 */
		public function closeDropDown():void
		{
			setCurrentState( DropDown.STATE_CLOSED );
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			// Remove all children from the display list.
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			// Clear out label button.
			_labelButton.dispose();
			_labelButton = null;
			
			// Clear out arrow button.
			_arrowButton.dispose();
			_arrowButton = null;
			
			// Clear out drop down.
			if( _dropDownList )
			{
				_dropDownList.dispose();
				_dropDownList = null;
			}
			
			_selectionChange.removeAll();
			_selectionChange = null;
			_selectionEvent = null;
		}
		
		/**
		 * Returns signal reference for change in selection. 
		 * @return DeluxeSignal
		 */
		public function selectionChange():DeluxeSignal
		{
			return _selectionChange;
		}
		
		/**
		 * Returns the label button display instance. 
		 * @return Button
		 */
		public function get labelButtonDisplay():Button
		{
			return _labelButton;
		}
		
		/**
		 * Returns the arrow button display instance. 
		 * @return Button
		 */
		public function get arrowButtonDisplay():Button
		{
			return _arrowButton;
		}
		
		/**
		 * Returns the drop down list display instance. 
		 * @return ScrollList
		 */
		public function get dropDownListDisplay():ScrollList
		{
			return getDropDownList();
		}

		/**
		 * Accessor/Modifier for the default textual content of the label display when a selection is not present in the dropdown list control. 
		 * @return String
		 */
		public function get defaultLabel():String
		{
			return _defaultLabel;
		}
		public function set defaultLabel(value:String):void
		{
			if( _defaultLabel == value ) return;
			
			_defaultLabel = value;
			invalidateDefaultLabel();
		}
		
		/**
		 * Accessor/Modifier for the desired width of the dropdown list control. 
		 * @return int
		 */
		public function get dropDownWidth():int
		{
			return _dropDownWidth;
		}
		public function set dropDownWidth(value:int):void
		{
			if( _dropDownWidth == value ) return;
			
			_dropDownWidth = value;
			invalidateDropDownSize();
		}
		
		/**
		 * Accessor/Modifier for the desired height of the dropdown list control. 
		 * @return int
		 */
		public function get dropDownHeight():int
		{
			return _dropDownHeight;
		}
		public function set dropDownHeight(value:int):void
		{
			if( _dropDownHeight == value ) return;
			
			_dropDownHeight = value;
			invalidateDropDownSize();
		}

		/**
		 * Accessor/Modifier for the selected index within the dropdown list control. 
		 * @return int
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			if( _selectedIndex == value ) return;
			
			_selectedIndex = value;
			invalidateSelectedIndex();
		}
		
		/**
		 * Accessor/Modifier for the selection item within the dropdown list control. 
		 * @return Object
		 */
		public function get selectedItem():Object
		{
			var list:ScrollList = getDropDownList();
			return list.selectedItem;
		}
		public function set selectedItem( value:Object ):void
		{
			var list:ScrollList = getDropDownList();
			list.selectedItem = value;
		}
		
		/**
		 * Accessor/Modifier for the data provider of the dropdown list control. 
		 * @return Array
		 */
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Array):void
		{
			if( _dataProvider == value ) return;
			
			_dataProvider = value;
			invalidateDataProvider();
		}
	}
}