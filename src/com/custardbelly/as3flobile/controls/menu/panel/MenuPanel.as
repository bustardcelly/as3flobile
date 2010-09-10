/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MenuPanel.as</p>
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
package com.custardbelly.as3flobile.controls.menu.panel
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.menu.MenuItem;
	import com.custardbelly.as3flobile.controls.menu.layout.GridMenuLayout;
	import com.custardbelly.as3flobile.controls.menu.layout.IMenuLayout;
	import com.custardbelly.as3flobile.controls.menu.renderer.DefaultMenuItemRenderer;
	import com.custardbelly.as3flobile.controls.menu.renderer.IMenuItemRenderer;
	import com.custardbelly.as3flobile.controls.menu.renderer.IMenuItemSelectionDelegate;
	import com.custardbelly.as3flobile.controls.shape.Divider;
	import com.custardbelly.as3flobile.enum.DimensionEnum;
	import com.custardbelly.as3flobile.skin.ISkin;
	import com.custardbelly.as3flobile.skin.MenuPanelSkin;
	import com.custardbelly.as3flobile.util.IObjectPool;
	import com.custardbelly.as3flobile.util.ObjectPool;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * MenuPanel is a base class for the menu and submenu displays within a composite Menu control. 
	 * @author toddanderson
	 */
	public class MenuPanel extends AS3FlobileComponent implements IMenuPanelDisplay, IMenuItemSelectionDelegate
	{
		protected var _items:Vector.<IMenuItemRenderer>;
		protected var _rendererPool:IObjectPool;
		protected var _skinPool:IObjectPool;
		
		protected var _dividers:Vector.<Divider>;
		protected var _dividerPool:IObjectPool;
		
		protected var _itemWidth:int;
		protected var _itemHeight:int;
		
		protected var _layout:IMenuLayout;
		protected var _itemRenderer:String;
		protected var _itemRendererSkin:String;
		protected var _maximumItemDisplayAmount:uint;
		protected var _selectionDelegate:IMenuPanelSelectionDelegate;
		protected var _dataProvider:Vector.<MenuItem>;
		
		/**
		 * Constructor.
		 */
		public function MenuPanel() { super(); }
		
		/**
		 * Static util method for convenience creation of a MenuPanel with target selection delegate. 
		 * @param selectionDelegate IMenuPanelSelectionDelegate
		 * @return MenuPanel
		 */
		static public function initWithSelectionDelegate( selectionDelegate:IMenuPanelSelectionDelegate ):MenuPanel
		{
			var panel:MenuPanel = new MenuPanel();
			panel.selectionDelegate = selectionDelegate;
			return panel;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			// Default dimensions to undefined, the menu panel will resize its height based on layout content dimensions.
			_width = DimensionEnum.UNDEFINED;
			_height = DimensionEnum.UNDEFINED;
			
			_itemWidth = DimensionEnum.UNDEFINED;
			_itemHeight = 50;
			
			// Default maximum display amount.
			_maximumItemDisplayAmount = 6;
			
			// Set padding from edges of stage. default.
			updatePadding( 5, 0, 5, 0 );
			
			// Default layout target.
			_layout = new GridMenuLayout();
			_layout.target = this;
			_layout.itemWidth = _itemWidth;
			_layout.itemHeight = _itemHeight;
			
			// Skin
			_skin = new MenuPanelSkin();
			_skin.target = this;
			
			// Supply default item renderer for menu.
			_itemRenderer = getQualifiedClassName( DefaultMenuItemRenderer );
			// Pools.
			_rendererPool = new ObjectPool( _itemRenderer );
			
			// Dividers.
			_dividers = new Vector.<Divider>();
			_dividerPool = new ObjectPool( getQualifiedClassName( Divider ) );
		}
		
		/**
		 * @private
		 * 
		 * Validates the layout target for display of child items. 
		 * @param oldValue IMenuLayout The old IMenuLayout if available.
		 * @param newValue IMenuLayout The new IMenuLayout.
		 */
		protected function invalidateLayout( oldValue:IMenuLayout, newValue:IMenuLayout ):void
		{
			// If we previously had a layout that differs, dispose of it.
			if( oldValue )
				oldValue.dispose();
			
			// Set up new layout target.
			_layout = newValue;
			_layout.target = this;
			_layout.itemWidth = _itemWidth;
			_layout.itemHeight = _itemHeight;
			// Update display with new layout.
			updateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Validates the item renderer instance to use for display of model. 
		 * @param oldValue String The old fully-qualified class name of the item renderer.
		 * @param newValue String The new fully-qualified class name of the item renderer.
		 * 
		 */
		protected function invalidateItemRenderer( oldValue:String, newValue:String ):void
		{
			// If we had a previous value of an item renderer, clear from factory.
			if( oldValue != null ) 
			{
				_rendererPool.flush();
			}
			_rendererPool = new ObjectPool( newValue );
			
			// Update the display based on new item renderer.
			_itemRenderer = newValue;
			invalidateDataProvider();
		}
		
		protected function invalidateItemRendererSkin( oldValue:String, newValue:String ):void
		{
			// If we had previous value, clear pool.
			if( oldValue != null )
			{
				_skinPool.flush();
			}
			// Update pool factory.
			_skinPool = new ObjectPool( newValue );
			// Update value.
			_itemRendererSkin = newValue;
			
			// If we have already created items, simply update their skins instead of running through full instantiation again.
			if( _items == null ) return;
			var i:int = _items.length;
			while( --i > -1 )
			{
				_items[i].skin = _skinPool.getInstance() as ISkin;	
			}
		}
		
		/**
		 * @private 
		 * 
		 * Validates the model list of MenuItems to renderer within this panel.
		 */
		protected function invalidateDataProvider():void
		{
			// Remove all previous children.
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			// If new model, fill items with data and add to the display.
			if( _dataProvider != null )
			{
				fillItems();
				var i:int;
				var length:int = _dataProvider.length;
				var item:IMenuItemRenderer;
				for( i = 0; i < length; i++ )
				{
					item = _items[i];
					item.data = _dataProvider[i];
					item.delegate = this;
					if( _skinPool ) item.skin = _skinPool.getInstance() as ISkin;
					addChild( item as DisplayObject );
				}
			}
			// Else just empty the items.
			else
			{
				emptyItems();
			}
			// Update the display.
			updateDisplay();
		}
		
		protected function invalidateItemSize():void
		{
			if( _layout == null ) return;
			
			_layout.itemWidth = _itemWidth;
			_layout.itemHeight = _itemHeight;
			updateDisplay();
		}
		
		/**
		 * @inherit
		 */
		override protected function invalidateEnablement( oldValue:Boolean, newValue:Boolean ):void
		{
			super.invalidateEnablement( oldValue, newValue );
			// Update enablement on held items.
			var i:int = _items.length;
			while( --i > -1 )
			{
				_items[i].enabled = _enabled;
			}
		}
		
		/**
		 * @private 
		 * 
		 * Re-use already instantiated items to fill the list of display instances collected from the target item renderer factory.
		 */
		protected function fillItems():void
		{
			// If we have no items, lazy create.
			if( _items == null )
				_items = new Vector.<IMenuItemRenderer>();
			
			// Grow to maximum items.
			while( _items.length < _dataProvider.length )
				_items[_items.length] = _rendererPool.getInstance() as IMenuItemRenderer;
			
			// Shrink to maximum items.
			var item:IMenuItemRenderer;
			while( _items.length > _dataProvider.length )
			{
				item = _items.pop();
				_rendererPool.returnInstance( item );
			}
		}
		
		/**
		 * @private 
		 * 
		 * Empties items from list and returns items to factory for re-use.
		 */
		protected function emptyItems():void
		{
			if( _items == null ) return;
			
			var item:IMenuItemRenderer;
			while( _items.length > 0 )
			{
				item = _items.pop();
				if( _skinPool ) _skinPool.returnInstance( item.skin );
				_rendererPool.returnInstance( item );
			}
		}
		
		/**
		 * @inherit 
		 * @param evt Event
		 */
		override protected function handleAddedToStage( evt:Event ):void
		{
			super.handleAddedToStage( evt );
			
			// If we have not explicitly set the width for a menu,
			//	once added to stage, assume the width of stage minus padding.
			if( _width == DimensionEnum.UNDEFINED )
				_width = stage.stageWidth - ( _padding.left + _padding.right );
			// Update display.
			updateDisplay();
		}
		
		/**
		 * @inherit
		 */
		override protected function updateDisplay():void
		{
			// Retrun dividers to pool.
			while( _dividers.length > 0 )
			{
				_dividerPool.returnInstance( _dividers.pop() );
			}
			// Use the target layout to layout the children.
			if( _layout != null )
			{
				_layout.updateDisplay( _width, _height );
				_height = _layout.getContentHeight();
			}
			// Update othe parts fo display based on dimensions derived from layout target.
			super.updateDisplay();
		}
		
		/**
		 * @copy IMenuLayoutTarget#addDivider()
		 */
		public function addDivider():Divider
		{
			var divider:Divider = _dividerPool.getInstance() as Divider;
			_dividers[_dividers.length] = divider;
			addChild( divider );
			return divider;
		}
		
		/**
		 * @copy IMenuItemSelectionDelegate#menuItemSelected()
		 */
		public function menuItemSelected( item:MenuItem, view:IMenuItemRenderer ):void
		{
			// If selection delegate present, notify.
			if( _selectionDelegate )
				_selectionDelegate.menuPanelItemSelected( this, item, view );
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			// Remove all children.
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			// Clear items from from memory and return to factory.
			emptyItems();
			
			// Dispose of layout target.
			_layout.dispose();
			_layout = null;
			
			// Clear divider pool.
			while( _dividers.length > 0 )
			{
				_dividerPool.returnInstance( _dividers.pop() );
			}
			_dividerPool.dispose();
			_dividerPool = null;
			
			// Dispose of item factory.
			_rendererPool.dispose();
			_rendererPool = null;
			
			// Dispose of skin pool.
			if( _skinPool )
			{
				_skinPool.dispose();
				_skinPool = null;
			}
			
			// Null references.
			_items = null;
			_dataProvider = null;
		}
		
		/**
		 * @copy IMenuPanelDisplay#backgroundDisplay
		 */
		public function get backgroundDisplay():Graphics
		{
			return graphics;
		}
		
		/**
		 * Returns the list of item renderers created based on model. 
		 * @return Vector.<IMenuItemRenderer>
		 */
		public function get items():Vector.<IMenuItemRenderer>
		{
			return _items;
		}
		
		/**
		 * Accessor/Modifier for the maximum display amount of items renderers. The attribute is used in detemrining the layout of item renderer children. 
		 * @return uint
		 */
		public function get maximumItemDisplayAmount():uint
		{
			return _maximumItemDisplayAmount;
		}
		public function set maximumItemDisplayAmount(value:uint):void
		{
			_maximumItemDisplayAmount = value;
		}
		
		/**
		 * Accessor/Modifier for the fully-qualified class name of the item renderer to display each item from the model. 
		 * @return String Default is com.custardbell.as3flobile.menu.renderer.DefaultMenuItemRenderer
		 * @see DefaultMenuItemRenderer
		 */
		public function get itemRenderer():String
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:String):void
		{
			if( _itemRenderer == value ) return;
			
			invalidateItemRenderer( _itemRenderer, value );
		}
		
		/**
		 * Accessor/Modifier for the fully-qualified class name of the item renderer skin to display each item from the model. 
		 * @return String Default is com.custardbell.as3flobile.skin.MenuItemRendererSkin
		 * @see MenuItemRendererSkin
		 */
		public function get itemRendererSkin():String
		{
			return _itemRendererSkin;
		}
		public function set itemRendererSkin(value:String):void
		{
			if( _itemRendererSkin == value ) return;
			
			invalidateItemRendererSkin( _itemRendererSkin, value );
		}
		
		/**
		 * Accessor/Modifier for the default height of each child item for layout. 
		 * @return int
		 */
		public function get itemHeight():int
		{
			return _itemHeight;
		}
		public function set itemHeight(value:int):void
		{
			if( _itemHeight == value ) return;
			
			_itemHeight = value;
			invalidateItemSize();
		}
		
		/**
		 * Accessor/Modifier for the default width of each child item for layout. 
		 * @return int
		 */
		public function get itemWidth():int
		{
			return _itemWidth;
		}
		public function set itemWidth(value:int):void
		{
			if( _itemWidth == value ) return;
			
			_itemWidth = value;
			invalidateItemSize();
		}
		
		/**
		 * Accessor/Modifier for the target IMenuLayout to position child item renderers within the panel. 
		 * @return IMenuLayout Default is GridMenuLayout
		 * @see GridMenuLayout
		 */
		public function get layout():IMenuLayout
		{
			return _layout;
		}
		public function set layout( value:IMenuLayout ):void
		{
			if( _layout == value ) return;
			
			invalidateLayout( _layout, value );
		}	
		
		/**
		 * Accessor/Modifier for the model list of MenuItems. 
		 * @return Vector.<MenuItem>
		 */
		public function get dataProvider():Vector.<MenuItem>
		{
			return _dataProvider;
		}
		public function set dataProvider( value:Vector.<MenuItem> ):void
		{
			if( _dataProvider == value ) return;
			
			_dataProvider = value;
			invalidateDataProvider();
		}

		/**
		 * Accessor/Modifier for the client requesting notification on change to selection within this panel. 
		 * @return IMenuPanelSelectionDelegate
		 */
		public function get selectionDelegate():IMenuPanelSelectionDelegate
		{
			return _selectionDelegate;
		}
		public function set selectionDelegate(value:IMenuPanelSelectionDelegate):void
		{
			_selectionDelegate = value;
		}
	}
}