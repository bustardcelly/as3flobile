/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: Picker.as</p>
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
package com.custardbelly.as3flobile.controls.picker
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
	import com.custardbelly.as3flobile.controls.list.IScrollListDelegate;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListLayout;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	import com.custardbelly.as3flobile.model.BoxPadding;
	import com.custardbelly.as3flobile.skin.PickerSkin;
	import com.custardbelly.as3flobile.util.DisplayPositionSearch;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Picker extends AS3FlobileComponent implements IScrollListDelegate
	{
		protected var _selectionBar:Shape;
		
		protected var _columns:Vector.<IScrollListContainer>;
		protected var _scrollBank:PickerScrollBank;
		protected var _columnWidthCache:Vector.<Number>;
		protected var _columnSeperatorLength:int;
		
		protected var _selectedItemOffsetForCompare:Number;
		
		protected var _itemHeight:int;
		protected var _delegate:IPickerSelectionDelegate;
		protected var _dataProvider:Vector.<PickerColumn>;
		
		/**
		 * Constructor.
		 */
		public function Picker() { super(); }
		
		/**
		 * Static method to create a new instance of Picker control filled with target IPickerSelectionDelegate. 
		 * @param delegate IPickerSelectionDelegate
		 * @return Picker
		 */
		public static function initWithDelegate( delegate:IPickerSelectionDelegate ):Picker
		{
			var picker:Picker = new Picker();
			picker.delegate = delegate;
			return picker;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			// My size.
			_width = 300;
			_height = 180;
			// Default item height in each column list.
			_itemHeight = 48;
			
			// Picker scroll bank is a bank to retrieve and return IScrollContainer instance as needed.
			_scrollBank = new PickerScrollBank();
			// Create empty vectors.
			_columns = new Vector.<IScrollListContainer>();
			_columnWidthCache = new Vector.<Number>();
			// Set seperation length
			_columnSeperatorLength = 4;
			// Update BoxPadding model.
			updatePadding( 4, 4, 4, 4 );
			// SKin it.
			_skin = new PickerSkin();
			_skin.target = this;
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			_selectionBar = new Shape();
			addChild( _selectionBar );
		}
		
		/**
		 * @private
		 * 
		 * Delegate function to determine if an item resides above or below the position. 
		 * @param item DisplayObject
		 * @param position Number
		 * @return Boolean
		 * @see #DisplayPositionSearch
		 */
		protected function compareItemPosition( item:DisplayObject, position:Number ):Boolean
		{
			// Use the offset to determine correct range position.
			return (item.y - _selectedItemOffsetForCompare < position) && (item.y + item.height + _selectedItemOffsetForCompare < position);
		}
		
		/**
		 * @private
		 * 
		 * Delegate function to determine if an item lies within the position on the display. 
		 * @param item DisplayObject
		 * @param position Number
		 * @return Boolean
		 * @see #DisplayPositionSearch
		 */
		protected function isWithinRange( item:DisplayObject, position:Number ):Boolean
		{
			// Use the offset to determine correct range position.
			return (item.y - _selectedItemOffsetForCompare <= position) && (item.y + item.height + _selectedItemOffsetForCompare >= position);
		}
		
		/**
		 * @private 
		 * 
		 * Validates the list of PickerColumn data.
		 */
		protected function invalidateDataProvider():void
		{
			// Returns columns to bank.
			returnColumns();
			// Empty column widht cache for layout.
			emptyColumnWidthCache();
			
			// Add scroll columns.
			var i:int;
			var length:int = _dataProvider.length;
			var columnList:IScrollListContainer;
			for( i = 0; i < length; i++ )
			{
				columnList = getNewColumnList( _dataProvider[i] );
				addChildAt( columnList as DisplayObject, 0 );
				_columns[i] = columnList;
			}
			// Fill column width cache for layout.
			fillColumnWidthCache();
			// Update padding and display.
			updatePaddingOnColumnLists();
			updateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the cross-scroll item height.
		 */
		protected function invalidateItemHeight():void
		{
			var i:int = _columns.length
			var list:IScrollListContainer;
			while( --i > -1 )
			{
				list = _columns[i];
				setListLayoutItemHeight( list, _itemHeight );	
			}
			// Update padding and display.
			updatePaddingOnColumnLists();
			updateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Validates a column list replacement. 
		 * @param index uint
		 */
		protected function invalidateColumn( index:uint ):void
		{
			if( _columns.length < index - 1 ) return;
			_columns[index].dataProvider = _dataProvider[index].data;
		}
		
		/**
		 * @inherit
		 */
		override protected function invalidateSize():void
		{
			// Update box padding for each scroll list.
			updatePaddingOnColumnLists();
			super.invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Updates the box padding for each scroll list. This is needed as the list should scroll to the target of the selection bar, not to position and height of this control.
		 */
		protected function updatePaddingOnColumnLists():void
		{
			var offset:int = ( _height - _itemHeight ) * 0.5;
			var i:int = _columns.length;
			var layout:IScrollListLayout;
			var padding:BoxPadding;
			while( --i > -1 )
			{
				layout = _columns[i].layout;
				padding = layout.padding;
				padding.left = 0;
				padding.right = 0;
				padding.top = offset;
				padding.bottom = offset;
				layout.padding = padding;
			}
		}
		
		/**
		 * @private
		 * 
		 * Returns a new IScrollListContainer instance filled with necessary properties.
		 * @param column PickerColumn
		 * @return IScrollListContainer
		 */
		protected function getNewColumnList( column:PickerColumn ):IScrollListContainer
		{
			var list:IScrollListContainer = _scrollBank.getScrollListContainer();
			list.dataProvider = column.data;
			list.itemRenderer = column.itemRenderer;
			list.layout = column.layout;
			list.delegate = this;
			list.seperatorLength = 1;
			list.padding = getDefaultColumnListPadding( list.padding );
			list.selectionEnabled = false;
			setListLayoutItemHeight( list, _itemHeight );
			return list;
		}
		
		protected function getDefaultColumnListPadding( padding:BoxPadding ):BoxPadding
		{
			padding.left = padding.right = 0;
			padding.top = padding.bottom = 0;
			return padding;
		}
		
		/**
		 * @private
		 * 
		 * Sets the item height on a target IScrollListContainer instance. 
		 * @param list IScrollListContainer
		 * @param itemHeight int
		 */
		protected function setListLayoutItemHeight( list:IScrollListContainer, itemHeight:int ):void
		{
			if( list.layout != null )
			{
				if( list.layout is IScrollListVerticalLayout )
				{
					( list.layout as IScrollListVerticalLayout ).itemHeight = itemHeight;
				}
			}
		}
		
		/**
		 * @private 
		 * 
		 * Returns all column list to the bank.
		 */
		protected function returnColumns():void
		{
			var column:IScrollListContainer;
			while( _columns.length > 0 )
			{
				column = _columns.shift()
				if( contains( column as DisplayObject ) )
				{
					removeChild( column as DisplayObject );
				}
				_scrollBank.returnScrollListContainer( column );
			}
		}
		
		/**
		 * @private 
		 * 
		 * Empties cached width of columns based on their given PickerColumn model.
		 */
		protected function emptyColumnWidthCache():void
		{
			while( _columnWidthCache.length > 0 )
				_columnWidthCache.shift();
		}
		
		/**
		 * @private 
		 * 
		 * Fills cached width of columns based on their given PickerColumn model.
		 */
		protected function fillColumnWidthCache():void
		{
			var i:int;
			var length:int = _dataProvider.length;
			for( i = 0; i < length; i++ )
			{
				_columnWidthCache[i] = _dataProvider[i].width;
			}
		}
		
		/**
		 * @private
		 * 
		 * Returns the associated PickerColumn data from a traget IScrollListContainer instance. 
		 * @param list IScrollListContainer
		 * @return PickerColumn
		 */
		protected function getPickerColumnFromList( list:IScrollListContainer ):PickerColumn
		{
			var i:int = _columns.length;
			while( --i > -1 )
			{
				if( _columns[i] == list ) break;
			}
			return ( _dataProvider ) ? _dataProvider[i] : null;
		}
		
		/**
		 * @copy IScrollListDelegate#listDidStartScroll()
		 */
		public function listDidStartScroll( list:IScrollListContainer, position:Point ):void
		{
			// Only concerned with the end of scroll at the moment.
		}
		/**
		 * @copy IScrollListDelegate#listDidScroll()
		 */
		public function listDidScroll( list:IScrollListContainer, position:Point ):void
		{
			// Only concerned with the end of scroll at the moment.
		}
		/**
		 * @copy IScrollListDelegate#listDidEndScroll()
		 */
		public function listDidEndScroll( list:IScrollListContainer, position:Point ):void
		{
			// Update selected item offset based on list seperator.
			//	This offset is used to determine the display range of an item based on position.
			//	since the seperator can be any given number, we need an offset for that range.
			_selectedItemOffsetForCompare = list.seperatorLength * 0.5;
			// We are basing the center of this display as the target position to search fro selected index.
			var center:Number = -position.y + ( _height * 0.5 );
			// Find selected index using compare.
			var index:int = DisplayPositionSearch.findCellIndexInPosition( list.renderers, center, compareItemPosition, isWithinRange );
			// Scroll to the position of the index.
			list.scrollPositionToIndex( index );
			// Notify delegate if available.
			if( _delegate ) _delegate.pickerSelectionDidChange( this, getPickerColumnFromList( list ), index ); 
		}
		/**
		 * @copy IScrollListDelegate#listSelectionChange()
		 */
		public function listSelectionChange( list:IScrollListContainer, selectedIndex:int ):void 
		{
			// we have disabled selection, so no need to handle it here. Recognized selection for each list will occur in listDidEndScroll().
		}
		
		/**
		 * Returns the background display for skinning. 
		 * @return Graphics
		 */
		public function get backgroundDisplay():Graphics
		{
			return graphics;
		}
		
		/**
		 * Returns the selection bar display for skinnning. 
		 * @return Shape
		 */
		public function get selectionBarDisplay():Shape
		{
			return _selectionBar;
		}
		
		/**
		 * Returns the current column scroll lists present. 
		 * @return IScrollListContainer
		 */
		public function get columnLists():Vector.<IScrollListContainer>
		{
			return _columns;
		}
		
		/**
		 * Returns the cached column list widths. 
		 * @return Vector.<Number>
		 */
		public function get columnWidths():Vector.<Number>
		{
			return _columnWidthCache;
		}
		
		/**
		 * Replaces the PickerColumn model on a column scroll list at the target index. 
		 * @param column PickerColumn
		 * @param index uint
		 */
		public function replaceColumnData( column:PickerColumn, index:uint ):void
		{
			if( index > _dataProvider.length ) return;
			
			_dataProvider.splice( index, 1, column );
			invalidateColumn( index );
		}
		
		/**
		 * Returns the selected index of a specific column list by target index. 
		 * @param columnIndex int The target column list at index.
		 * @return int The selected index of the column list.
		 */
		public function getSelectedIndex( columnIndex:int ):int
		{
			if( columnIndex > _columns.length - 1 ) return -1;
			
			return _columns[columnIndex].selectedIndex;
		}
		
		/**
		 * Sets and scrolls to position in column list at target index. 
		 * @param index int The desired selected index of the column list.
		 * @param columnIndex The index of the column list within this control.
		 * @return Boolean Flag of successfully selecting index.
		 */
		public function setSelectedIndex( index:int, columnIndex:int ):Boolean
		{
			if( columnIndex > _columns.length - 1 ) return false;
			
			var columnList:IScrollListContainer = _columns[columnIndex];
			columnList.scrollPositionToIndex( index );
			return true;
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		override public function dispose():void
		{
			super.dispose();
			
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			returnColumns();
			_scrollBank.dispose();
			
			_dataProvider = null;
			
			// Null reference to delegate.
			_delegate = null;
		}
		
		/**
		 * Accessor/Modifier for the seperation space between column lists. 
		 * @return 
		 * 
		 */
		public function get columnSeperatorLength():int
		{
			return _columnSeperatorLength;
		}
		public function set columnSeperatorLength(value:int):void
		{
			if( _columnSeperatorLength == value ) return;
			
			_columnSeperatorLength = value;
			updateDisplay();
		}
		
		
		
		/**
		 * Accessor/Modifier for the item height of the layout for each column scroll list. 
		 * @return int
		 */
		public function get itemHeight():int
		{
			return _itemHeight;
		}
		public function set itemHeight( value:int ):void
		{
			if( _itemHeight == value ) return;
			
			_itemHeight = value;
			invalidateItemHeight();
		}
		
		/**
		 * Accessor/Modifier for the IPickerSelectionDelegate client to be notified of change in selection. 
		 * @return IPickerSelectionDelegate 
		 */
		public function get delegate():IPickerSelectionDelegate
		{
			return _delegate;
		}
		public function set delegate( value:IPickerSelectionDelegate ):void
		{
			_delegate = value;
		}
		
		/**
		 * Accessor/Modifier for the list of PickerColumn models used to create and display lists within the Picker control. 
		 * @return Vector.<PickerColumn>
		 */
		public function get dataProvider():Vector.<PickerColumn>
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Vector.<PickerColumn>):void
		{
			if( _dataProvider == value ) return;
			
			_dataProvider = value;
			invalidateDataProvider();
		}
	}
}
import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
import com.custardbelly.as3flobile.controls.list.ScrollList;
import com.custardbelly.as3flobile.controls.list.layout.IScrollListLayout;
import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;

class PickerScrollBank
{
	protected var _bank:Vector.<IScrollListContainer>;
	protected var _layoutBank:Vector.<IScrollListLayout>;
	
	/**
	 * PickerScrollBank is an internal class to manage a bank of IScrollListContainer instances.
	 */
	public function PickerScrollBank()
	{
		_bank = new Vector.<IScrollListContainer>();
	}
	
	/**
	 * Returns the default IScrollListLayout instance for an IScrollListContainer. 
	 * @return IScrollListLayout
	 */
	protected function getScrollListLayout():IScrollListLayout
	{
		var layout:IScrollListLayout = new ScrollListVerticalLayout();
		return layout;
	}
	
	/**
	 * Returns and optional creates an instance of IScrollListContainer from the bank. 
	 * @return IScrollListContainer
	 */
	public function getScrollListContainer():IScrollListContainer
	{
		var list:IScrollListContainer;
		if( _bank.length == 0 )
		{
			list = new ScrollList();
			list.layout = getScrollListLayout();
			_bank.push( list );
		}
		return _bank.shift();
	}
	
	/**
	 * Returns an IScrollListContainer to the bank. 
	 * @param list IScrollListContainer
	 */
	public function returnScrollListContainer( list:IScrollListContainer ):void
	{
		_bank.push( list );
	}
	
	/**
	 * Empties the bank and performs any cleanup.
	 */
	public function dispose():void
	{
		var list:IScrollListContainer;
		while( _bank.length > 0 )
		{
			list = _bank.shift();
			list.dispose()
			list = null;
		}
	}
}