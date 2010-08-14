package com.custardbelly.as3flobile.controls.dropdown
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
	import com.custardbelly.as3flobile.controls.list.IScrollListDelegate;
	import com.custardbelly.as3flobile.controls.list.ScrollList;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	import com.custardbelly.as3flobile.skin.DropDownSkin;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DropDown extends AS3FlobileComponent implements IScrollListDelegate
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
		
		public function DropDown()
		{
			super();
			initialize();
			createChildren();
			initializeDisplay();
			updateDisplay();
		}
		
		protected function initialize():void
		{
			_width = 160;
			_height = 40;
			
			_dropDownWidth = 160;
			_dropDownHeight = 160;
			
			_defaultLabel = "Select";
			
			_selectedIndex = -1;
			
			_skin = new DropDownSkin();
			_skin.target = this;
		}
		
		protected function createChildren():void
		{
			_labelButton = new Button();
			_labelButton.label = _defaultLabel;
			_labelButton.addEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false, 0, true );
			addChild( _labelButton );
			
			_arrowButton = new Button();
			_arrowButton.label = ">";
			_arrowButton.addEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false, 0, true );
			addChild( _arrowButton );
			
			_arrowButton.height = _height;
			_arrowButton.width = 40;
			
			_labelButton.height = _height;
			_labelButton.width = _width - _arrowButton.width;
		}
		
		protected function getDropDownList():ScrollList
		{
			if( _dropDownList == null )
			{
				var layout:IScrollListVerticalLayout = new ScrollListVerticalLayout();
				layout.itemHeight = 40;
				_dropDownList = ScrollList.initWithScrollRectAndDelegate( new Rectangle( 0, 0, _dropDownWidth, _dropDownHeight ), this );
				_dropDownList.layout = layout;
			}
			return _dropDownList;
		}
		
		protected function addDropDownList():void
		{
			if( _dropDownList == null || !contains( _dropDownList ) )
				addChild( getDropDownList() );
		}
		
		protected function removeDropDownList():void
		{
			if( _dropDownList != null && contains( _dropDownList ) )
				removeChild( _dropDownList );
		}
		
		protected function invalidateDropDownSize():void
		{
			var list:ScrollList = getDropDownList();
			list.width = _dropDownWidth;
			list.height = _dropDownHeight;
		}
		
		protected function invalidateDefaultLabel():void
		{
			// if in state with default label ->
			_labelButton.label = _defaultLabel;
		}
		
		protected function invalidateDataProvider():void
		{
			var list:ScrollList = getDropDownList();
			list.dataProvider = _dataProvider;
		}
		
		protected function invalidateSelectedIndex():void
		{
			var list:ScrollList = getDropDownList();
			list.selectedIndex = _selectedIndex;
			_labelButton.label = ( _selectedIndex >= 0 && _selectedIndex < _dataProvider.length ) ? _dataProvider[_selectedIndex].label : _defaultLabel;
		}
		
		protected function setCurrentState( state:int ):void
		{
			if( _currentState == state ) return;
			
			_currentState = state;
			if( _currentState == DropDown.STATE_OPENED )
				addDropDownList();
			else
				removeDropDownList();
		}
		
		protected function toggleState():void
		{
			setCurrentState( _currentState == DropDown.STATE_CLOSED ? DropDown.STATE_OPENED : DropDown.STATE_CLOSED );
		}
		
		protected function handleButtonTriggerClick( evt:MouseEvent ):void
		{
			var list:ScrollList = getDropDownList();
			list.y = _height;
			toggleState();
		}
		
		/**
		 * @copy IScrollListDelete#listDidStartScroll()
		 */
		public function listDidStartScroll( list:IScrollListContainer, position:Point ):void {}
		/**
		 * @copy IScrollListDelete#listDidScroll()
		 */
		public function listDidScroll( list:IScrollListContainer, position:Point ):void {}
		/**
		 * @copy IScrollListDelete#listDidEndScroll()
		 */
		public function listDidEndScroll( list:IScrollListContainer, position:Point ):void {}
		/**
		 * @copy IScrollListDelete#listSelectionChange()
		 */
		public function listSelectionChange( list:IScrollListContainer, selectedIndex:int ):void 
		{
			this.selectedIndex = selectedIndex;
			closeDropDown();
		}
		
		public function openDropDown():void
		{
			setCurrentState( DropDown.STATE_OPENED );
		}
		public function closeDropDown():void
		{
			setCurrentState( DropDown.STATE_CLOSED );
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			_labelButton.removeEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false );
			_labelButton.dispose();
			_labelButton = null;
			
			_arrowButton.removeEventListener( MouseEvent.CLICK, handleButtonTriggerClick, false );
			_arrowButton.dispose();
			_arrowButton = null;
			
			if( _dropDownList )
			{
				_dropDownList.dispose();
				_dropDownList = null;
			}
		}
		
		public function get labelButtonDisplay():Button
		{
			return _labelButton;
		}
		
		public function get arrowButtonDisplay():Button
		{
			return _arrowButton;
		}
		
		public function get dropDownListDisplay():ScrollList
		{
			return getDropDownList();
		}

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