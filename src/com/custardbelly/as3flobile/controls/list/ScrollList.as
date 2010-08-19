/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollList.as</p>
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
package com.custardbelly.as3flobile.controls.list
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListLayout;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.renderer.DefaultScrollListItemRenderer;
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewport;
	import com.custardbelly.as3flobile.controls.viewport.IScrollViewportDelegate;
	import com.custardbelly.as3flobile.controls.viewport.ScrollViewport;
	import com.custardbelly.as3flobile.controls.viewport.context.BaseScrollViewportStrategy;
	import com.custardbelly.as3flobile.controls.viewport.context.IScrollViewportContext;
	import com.custardbelly.as3flobile.controls.viewport.context.ScrollViewportMouseContext;
	import com.custardbelly.as3flobile.helper.ITapMediator;
	import com.custardbelly.as3flobile.helper.MouseTapMediator;
	import com.custardbelly.as3flobile.helper.TapMediator;
	import com.custardbelly.as3flobile.model.BoxPadding;
	import com.custardbelly.as3flobile.skin.ScrollListSkin;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ScrollList is a display component that allows you to scroll through a list of items using a mouse or touch gesture. 
	 * @author toddanderson
	 */
	public class ScrollList extends AS3FlobileComponent implements IScrollViewportDelegate, IScrollListContainer, IScrollListLayoutTarget
	{	
		protected var _listHolder:ScrollListHolder;
		protected var _bounds:Rectangle;
		protected var _viewport:IScrollViewport;
		
		protected var _itemRenderer:String;
		protected var _tapMediator:ITapMediator;
		protected var _layout:IScrollListLayout;
		protected var _scrollContext:IScrollViewportContext;
		protected var _delegate:IScrollListDelegate;
		
		protected var _cells:Vector.<IScrollListItemRenderer>;
		protected var _cellAmount:int;
		
		protected var _seperatorLength:int;
		
		protected var _currentScrollPosition:Point;
		protected var _isScrolling:Boolean;
		
		protected var _selectionEnabled:Boolean;
		protected var _selectedRenderer:IScrollListItemRenderer;
		
		protected var _selectedIndex:int = -1;
		protected var _dataProvider:Array;
		
		/**
		 * Constructor.
		 */
		public function ScrollList()
		{
			// Get default scroll context.
			_scrollContext = getDefaultScrollContext();
			super();
		}
		
		/**
		 * Static factory method to create a new instance of ScrollList with default properties. 
		 * @param bounds Rectangle The rectangular area to be shown by the list.
		 * @param delegate IScrollListDelegate The delegate to be invoked as actions are performed.
		 * @return ScrollList
		 */
		public static function initWithScrollRectAndDelegate( bounds:Rectangle, delegate:IScrollListDelegate = null ):ScrollList
		{
			var list:ScrollList = new ScrollList();
			list.delegate = delegate;
			list.width = bounds.width;
			list.height = bounds.height;
			return list;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_width = 100; 
			_height = 100;
			
			updatePadding( 2, 2, 2, 2 );
			_seperatorLength = 2;
			_selectionEnabled = true;
			
			_bounds = new Rectangle( 0, 0, _width, _height );
			
			_currentScrollPosition = new Point( 0, 0 );
			
			_cells = new Vector.<IScrollListItemRenderer>()
			_itemRenderer = getQualifiedClassName( DefaultScrollListItemRenderer );
			
			_layout = getDefaultLayout();
			
			_skin = new ScrollListSkin();
			_skin.target = this;
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			// List holder will be managed by this ScrollList instance, but actually be on the display list of the viewport.
			createListHolderIfNotExist();
			_listHolder.mouseChildren = false;
			_listHolder.cacheAsBitmap = true;
			
			// Create the viewport and point to the list holder target.
			var horizPadding:int = ( _padding.left + _padding.right );
			var vertPadding:int = ( _padding.top + _padding.bottom );
			_viewport = new ScrollViewport();
			_viewport.delegate = this;
			_viewport.context = _scrollContext;
			_viewport.content = _listHolder;
			_viewport.width = _width - horizPadding;
			_viewport.height = _height - vertPadding;
			_viewport.x = _padding.left;
			_viewport.y = _padding.top;
			addChild( _viewport as DisplayObject );
			
			_tapMediator = getDefaultTapMediator( _listHolder, handleListTap );
		}
		
		/**
		 * @private
		 * 
		 * If not instantiated, creates an instance of a ScrollListHolder and returns the reference. 
		 * @return ScrollListHolder
		 */
		protected function createListHolderIfNotExist():ScrollListHolder
		{
			// Create if not exists.
			if( _listHolder == null )
				_listHolder = new ScrollListHolder();
			// Return instance.
			return _listHolder;
		}
		
		/**
		 * @private
		 * 
		 * Factory method to return default IScrollViewportContext implementation used. 
		 * @return IScrollViewportContext
		 */
		protected function getDefaultScrollContext():IScrollViewportContext
		{
			return new ScrollViewportMouseContext( new BaseScrollViewportStrategy() );
		}
		
		/**
		 * @private
		 * 
		 * Factory method to return default ITapMediator implementation used for tap gesture for list selection.
		 * @param display InteractiveObject The interactive display to listen for events on that represent a tap.
		 * @param tapHandler Function The handler method to invoke upon notification of a tap gesture.
		 * @return ITapMediator
		 */
		protected function getDefaultTapMediator( display:InteractiveObject, tapHandler:Function ):ITapMediator
		{
			return new MouseTapMediator();
		}
		
		/**
		 * @private
		 * 
		 * Factory method to return default IScrollListLayout used to display item renderers.
		 * @return IScrollListLayout
		 */
		protected function getDefaultLayout():IScrollListLayout
		{	
			var layout:IScrollListLayout = new ScrollListVerticalLayout();
			layout.target = this;
			( layout as IScrollListVerticalLayout ).itemHeight = 48;
			return layout;
		}
		
		/**
		 * @private 
		 * 
		 * Runs a refresh on the display.
		 */
		protected function refresh():void
		{
			// Reset content holder display.
			_currentScrollPosition = new Point( 0, 0 );
			_listHolder.x = _currentScrollPosition.x;
			_listHolder.y = _currentScrollPosition.y;
			
			// Unselect any selected item renderer instances.
			var selectedItemRenderer:IScrollListItemRenderer = ( _selectedIndex >= 0 ) ? _cells[_selectedIndex] : null;
			if( selectedItemRenderer )
				selectedItemRenderer.selected = false;
			
			// Run refresh on display.
			invalidateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the new size applied to this instance.
		 */
		override protected function invalidateSize():void
		{
			super.invalidateSize();
			
			var horizPadding:int = ( _padding.left + _padding.right );
			var vertPadding:int = ( _padding.top + _padding.bottom );
			// Set new scroll rect area.
			_bounds.width = _width - horizPadding;
			_bounds.height = _height - vertPadding;
			// Apply new values to the viewport instance.
			_viewport.width = _width - horizPadding;
			_viewport.height = _height - vertPadding;
			_viewport.x = _padding.left;
			_viewport.y = _padding.top;
			// Update visible dimensions on scroll list holder
			_listHolder.visibleWidth = _width - horizPadding;
			_listHolder.visibleHeight = _height - vertPadding;
			// Run refresh on display.
			invalidateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Validate the new data provider applied to this instance. 
		 * @param oldValue Array An Array of Object. The previously applied data provider (if available).
		 * @param newValue Array An Array of Object. The newly applied data provider.
		 */
		protected function invalidateDataProvider( oldValue:Array, newValue:Array ):void
		{
			// Hold easy reference to the amount of new data.
			_cellAmount = ( _dataProvider ) ? _dataProvider.length : 0;
			
			// If we had no old value, fill as normal.
			if( oldValue == null )
			{
				// Fills the cell list with factory created item renderers based on data provider.
				fillRendererQueue( _cells, _dataProvider.length );
			}
			// Else if we had an old value, determine if we need to shrink or grow our pool of cells.
			else if( oldValue.length != newValue.length )
			{
				// If there are more data representations of cells than previously, grow our pool.
				if( oldValue.length < newValue.length )
				{
					addToRendererQueue( _cells, newValue.length - oldValue.length );
				}
				// Else if there are less data representation of cells than previously, shrink our pool.
				else
				{
					removeFromRendererQueue( _cells, oldValue.length - newValue.length );
				}
			}
			// Run a refresh.
			refresh();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the new item renderer applied to this instance.
		 */
		protected function invalidateItemRenderer():void
		{
			// Remove cells from list.
			while( _cells.length > 0 )
				_cells.pop();
			
			// Fill cells in list.
			fillRendererQueue( _cells, ( _dataProvider ) ? _dataProvider.length : 0 );
			// Refresh.
			invalidateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Validates the IScrollViewportContext implementation applied to this instance.
		 */
		protected function invalidateScrollContext():void
		{
			// If we have a viewport set, apply the new context.
			if( _viewport != null )
			{
				_viewport.context = _scrollContext;
			}
		}
		
		/**
		 * @private
		 * 
		 * Validates the IScrollListLayout applied to this instance.
		 */
		protected function invalidateLayout():void
		{
			// Set the target to this instance.
			_layout.target = this;
			// Run refresh.
			refresh();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the current display.
		 */
		protected function invalidateDisplay():void
		{
			// Notify the layout of update to display.
			_layout.updateDisplay();
			// Set bounds of content holder.
			_listHolder.height = getContentHeight();
			_listHolder.width = getContentWidth();
			// Update the visual display.
			updateDisplay();
			// Run refresh on viewport.
			_viewport.refresh();
			// Show the cells based on display properties.
			showCells();
		}
		
		/**
		 * @private
		 * 
		 * Validates the selected item of this instance based on selected index.
		 */
		protected function invalidateSelection():void
		{
			// Unselect any previously selected item renderer(s).
			if( _selectedRenderer )
			{
				_selectedRenderer.selected = false;
				_selectedRenderer = null;
			}
			// Set selection on item renderer based on selected index.
			if( _selectedIndex >= 0 && _selectedIndex < _cells.length )
			{
				_selectedRenderer = _cells[_selectedIndex];
				_selectedRenderer.selected = true;
			}
		}
		
		/**
		 * @private 
		 * 
		 * Validates the ability to make a selction within the list.
		 */
		protected function invalidateSelectionEnablement():void
		{
			if( _tapMediator.isMediating( _listHolder ) ) 
			{
				if( _selectionEnabled )
				{
					_tapMediator.mediateTapGesture( _listHolder, handleListTap );
				}
				else
				{
					_tapMediator.unmediateTapGesture( _listHolder );
				}
			}
		}
		
		/**
		 * @private
		 * 
		 * Factory method to create the IScrollListItemRenderer instance based on the item renderer class. 
		 * @return IScrollListItemRenderer
		 */
		protected function createItemRenderer():IScrollListItemRenderer
		{
			var rendererClass:Class = getDefinitionByName( _itemRenderer ) as Class;
			var renderer:IScrollListItemRenderer = new rendererClass() as IScrollListItemRenderer;
			return renderer;
		}
		
		/**
		 * @private
		 * 
		 * Fills a list with IScrollListItemRenderer instances created from factory method on item renderer class. 
		 * @param queue Vector.<IScrolListRenderer> The list to fill with newly created instances of IScrollListItemRenderer.
		 * @param amount int The amount to add to the list.
		 * @see #createItemRenderer
		 */
		protected function fillRendererQueue( queue:Vector.<IScrollListItemRenderer>, amount:int ):void
		{
			var i:int = amount;
			var renderer:IScrollListItemRenderer;
			while( --i > -1 )
			{
				renderer = createItemRenderer();
				queue[queue.length] = renderer;
			}
		}
		
		/**
		 * @private
		 * 
		 * Appends item renderers to the list of IScrollListItemRenderer. 
		 * @param queue Vector.<IScrollListItemRenderer> The list to add a new instance to.
		 * @param amount int The amount of item renderer instances to add to the list.
		 * 
		 */
		protected function addToRendererQueue( queue:Vector.<IScrollListItemRenderer>, amount:int ):void
		{
			var length:int = queue.length + amount;
			while( queue.length < length )
				queue[queue.length] = createItemRenderer();
		}
		
		/**
		 * @private
		 * 
		 * Removes item renderes from the list of IScrollListItemRenderer. 
		 * @param queue Vector.<IScrollListItemRenderer> The list to remove instances from.
		 * @param amount int The amount of item renderer instances to remove.
		 */
		protected function removeFromRendererQueue( queue:Vector.<IScrollListItemRenderer>, amount:int ):void
		{
			var length:int = queue.length - amount;
			while( queue.length > length )
				queue.pop();
		}
		
		/**
		 * @private
		 * 
		 * Returns the height of the actual content within the list. This does not represent the height of content on the display list.
		 * This value represents the dimension vertically that can be scrolled to. 
		 * @return Number
		 */
		protected function getContentHeight():Number
		{
			return ( _layout ) ? _layout.getContentHeight() : _width;
		}
		
		/**
		 * @private
		 * 
		 * Returns the width of the actual content within the list. This does not represent the width of content on the display list.
		 * This value respresents the dimension horizontally that can be scrolled to. 
		 * @return Number
		 */
		protected function getContentWidth():Number
		{
			return ( _layout ) ? _layout.getContentWidth() : _height;
		}
		
		/**
		 * @private 
		 * 
		 * Shows the item renderer instances based on scroll position.
		 */
		protected function showCells():void
		{
			// Invoke layout to find cells within area based on scroll position.
			_layout.updateScrollPosition();
		}
		
		/**
		 * @inherit
		 */
		override protected function handleAddedToStage( evt:Event ):void
		{
			super.handleAddedToStage( evt );
			
			if( _selectionEnabled )
				_tapMediator.mediateTapGesture( _listHolder, handleListTap );
		}
		
		/**
		 * @inherit
		 */
		override protected function handleRemovedFromStage( evt:Event ):void
		{
			super.handleRemovedFromStage( evt );
			
			if( _tapMediator.isMediating( _listHolder ) ) 
				_tapMediator.unmediateTapGesture( _listHolder );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for tap gesture on content. Determines the selected index within the list. 
		 * @param evt Event
		 */
		protected function handleListTap( evt:Event ):void
		{
			var tapEvent:MouseEvent = evt as MouseEvent;
			var index:int = _layout.getChildIndexAtPosition( tapEvent.localX, tapEvent.localY );
			selectedIndex = index;
		}
		
		/**
		 * @copy IScrollListContainer#getRendererAt()
		 */
		public function getRendererAt( index:uint ):IScrollListItemRenderer
		{
			return _cells[index];
		}
		
		/**
		 * @copy IScrollListContainer#scrollPositionToIndex()
		 */
		public function scrollPositionToIndex( index:uint ):void
		{
			var position:Point = _layout.getPositionFromIndex( index );
			_viewport.scrollToPosition( position );
		}
		
		/**
		 * Adds an item renderer to the display. The IScrollListLayout instance uses this method to add an instance to the list display.
		 * Typically you will not call this method directly on a list unless from a IScrollListLayout instance managing the children of the display list. 
		 * @param renderer IScrollListItemRenderer
		 */
		public function addRendererToDisplay( renderer:IScrollListItemRenderer ):void
		{
			// Create the list holder if it doesn't exist. the layout can start populating its display list prior to being add to the stage.
			createListHolderIfNotExist();
			
			if( _listHolder.contains( renderer as DisplayObject ) )
				( renderer as DisplayObject ).visible = true;
			else
				_listHolder.addChild( renderer as DisplayObject );
		}
		
		/**
		 * Removes an item renderer from the display. The IScrollListLayout instance uses this method to remove an instance from the list display.
		 * Typically you will not call this method directly on a list unless from a IScrollListLayout instance managing the children of the display list. 
		 * @param renderer IScrollListItemRenderer
		 */
		public function removeRendererFromDisplay( renderer:IScrollListItemRenderer ):void
		{
			// Create the list holder if it doesn't exist. the layout can start populating its display list prior to being add to the stage.
			createListHolderIfNotExist();
			
			if( _listHolder.contains( renderer as DisplayObject ) )
				( renderer as DisplayObject ).visible = false;
		}
		
		/**
		 * copy @IScrollListLayoutTarget#commitContentChange()
		 */
		public function commitContentChange():void
		{
			// Set bounds of content holder.
			if( _listHolder )
			{
				_listHolder.height = getContentHeight();
				_listHolder.width = getContentWidth();	
			}
			// Update the visual display.
			updateDisplay();
			// Run refresh on viewport.
			if( _viewport ) _viewport.refresh();
			// Show the cells based on display properties.
			if( _layout ) showCells();
		}
		
		/**
		 * Returns the list of IScrollListItemRenderer instances. 
		 * @return Vector.<IScrollListItemRenderer>
		 */
		public function get renderers():Vector.<IScrollListItemRenderer>
		{
			return _cells;
		}
		
		/**
		 * Returns the length of the list of IScrollListItemRenderer instances. 
		 * @return int
		 */
		public function get rendererAmount():int
		{
			return _cells.length;
		}
		
		/**
		 * Returns the current scroll position of the display list. 
		 * @return Point
		 */
		public function get scrollPosition():Point
		{
			return _currentScrollPosition;
		}
		
		/**
		 * IScrollViewportDelegate implementation for start of scroll animation. 
		 * @param position Number
		 */
		public function scrollViewDidStart( position:Point ):void
		{
			_currentScrollPosition = position;
			if( _delegate ) _delegate.listDidStartScroll( this, position );
		}
		
		/**
		 * IScrollViewportDelegate implementation for animation of scroll. 
		 * @param position Number
		 */
		public function scrollViewDidAnimate( position:Point ):void
		{
			_isScrolling = true;
			_currentScrollPosition = position;
			if( _delegate ) _delegate.listDidScroll( this, position );
			showCells();
		}
		
		/**
		 * IScrollViewportDelegate implementation for end of scroll animation. 
		 * @param position Number
		 */
		public function scrollViewDidEnd( position:Point ):void
		{
			_currentScrollPosition = position;
			_isScrolling = false;
			if( _delegate ) _delegate.listDidEndScroll( this, position );
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			// Empty list.
			_cells = new Vector.<IScrollListItemRenderer>();
			
			// Empty display list.
			while( _listHolder.numChildren > 0 )
				_listHolder.removeChildAt( 0 );
			
			// Unmediate on tap gesture.
			if( _tapMediator.isMediating( _listHolder ) )
				_tapMediator.unmediateTapGesture( _listHolder );
			
			// Dispose of layout manager.
			_layout.dispose();
			_layout = null;
			
			// Dispose of viewport display.
			_viewport.dispose();
			_viewport = null;
			
			// Null reference to any selected item.
			_selectedRenderer = null;
			
			// Null reference to delegate.
			_delegate = null;
		}
		
		/**
		 * @inherit
		 * 
		 * Override to set the display area for the list. 
		 * @param value Rectangle
		 */
		public function get scrollBounds():Rectangle
		{
			return _bounds;
		}
		
		/**
		 * Accessor for the background display that can be used in the skinning process. 
		 * @return Shape
		 */
		public function get backgroundDisplay():Graphics
		{
			return graphics;
		}
		
		/**
		 * Accessor/Modifier for the seperator size between list items. 
		 * @return int
		 */
		public function get seperatorLength():int
		{
			return _seperatorLength;
		}
		public function set seperatorLength(value:int):void
		{
			if( _seperatorLength == value ) return;
			
			_seperatorLength = ( value < 0 ) ? 0 : value;
			invalidateDisplay();
		}
		
		/**
		 * Accessor/Modifier for the action delegate notified of change in properties. 
		 * @return IScrollListDelegate
		 */
		public function get delegate():IScrollListDelegate
		{
			return _delegate;
		}
		public function set delegate( value:IScrollListDelegate ):void
		{
			_delegate = value;
		}
		
		/**
		 * Accessor/Modifier for the layout manager for the item renderers in the list. 
		 * @return IScrollListLayout
		 */
		public function get layout():IScrollListLayout
		{
			return _layout;
		}
		public function set layout( value:IScrollListLayout ):void
		{
			if( _layout == value ) return;
			// Clear old layout.
			if( _layout != null ) _layout.dispose();
			
			_layout = value;
			invalidateLayout();
		}
		
		/**
		 * Accessor/Modifier for the viewport context that manages user gestures and animation of display. 
		 * @return IScrollViewportContext
		 */
		public function get scrollContext():IScrollViewportContext
		{
			return _scrollContext;
		}
		public function set scrollContext( value:IScrollViewportContext ):void
		{
			if( _scrollContext == value ) return;
			
			_scrollContext = value;
			invalidateScrollContext();
		}
		
		/**
		 * Accessor/Modifier for the item renderer instance to represent the data. 
		 * @return String The fully qualified class name of the item renderer.
		 */
		public function get itemRenderer():String
		{
			return _itemRenderer;
		}
		public function set itemRenderer( value:String ):void
		{
			if( _itemRenderer == value ) return;
			
			_itemRenderer = value;
			invalidateItemRenderer();
		}
		
		/**
		 * @copy IScrollListContainer#selectionEnabled
		 */
		public function get selectionEnabled():Boolean
		{
			return _selectionEnabled;
		}
		public function set selectionEnabled( value:Boolean ):void
		{
			if( _selectionEnabled == value ) return;
			
			_selectionEnabled = value;
			invalidateSelectionEnablement();
		}
		
		/**
		 * Accessor/Modifier of the selected item within the list from the data provided. This is not the selected item renderer instance. 
		 * @return Object
		 */
		public function get selectedItem():Object
		{
			// Based on the selected index.
			return ( _selectedIndex >= 0 && _selectedIndex < _dataProvider.length ) ? _dataProvider[_selectedIndex] : null;
		}
		public function set selectedItem( value:Object ):void
		{
			// Set selected index based on the value.
			var index:int = _dataProvider.indexOf( value );
			if( _selectedIndex == index ) return;
			
			if( index > -1 ) selectedIndex = index;
		}
		
		/**
		 * Accessor/Modifier for the selected index within the list. 
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
			invalidateSelection(); 
			if( _delegate ) _delegate.listSelectionChange( this, _selectedIndex );
		}
		
		/**
		 * Accessor/Modifier for the array of data represented. 
		 * @return Array An Array of Object-based objects.
		 */
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		public function set dataProvider( value:Array ):void
		{
			if( _dataProvider == value ) return;
			
			var oldValue:Array = _dataProvider;
			_dataProvider = value;
			invalidateDataProvider( oldValue, _dataProvider );
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * @private
 * 
 * ScrollListHolder is an extension of Sprite that holds dimension values representing width and height. This is so not to scale the Sprite,
 * and is used as the basis for scroling in the viewport based on content dimensions. 
 * @author toddanderson
 */
class ScrollListHolder extends Sprite
{
	protected var _width:Number = 0;
	protected var _height:Number = 0;
	
	protected var _visibleWidth:Number = 0;
	protected var _visibleHeight:Number = 0;
	
	protected var _rectCache:Rectangle;
	private static const ORIGIN:Point = new Point( 0, 0 );
	
	/**
	 * Constructor.
	 */
	public function ScrollListHolder() 
	{
		_rectCache = new Rectangle();
	}
	
	/**
	 * @inherit
	 * 
	 * Override to prvide proper bounds based on visible height rather than child display height. 
	 * @param targetCoordinateSpace DisplayObject
	 * @return Rectangle
	 */
	override public function getBounds( targetCoordinateSpace:DisplayObject ):Rectangle
	{
		// Use parent positioning, as this content is scrolled within, and the point should reside at the origina of parenting container.
		var pt:Point = ( parent ) ? parent.localToGlobal( ScrollListHolder.ORIGIN ) : localToGlobal( ScrollListHolder.ORIGIN );
		var w:int = _visibleWidth * targetCoordinateSpace.scaleX;
		var h:int = _visibleHeight * targetCoordinateSpace.scaleY;
		
		_rectCache.x = pt.x;
		_rectCache.y = pt.y;
		_rectCache.width = w;
		_rectCache.height = h;
		
		return _rectCache;
	}
	
	/**
	 * Accessor/Modifier for the visible width dimension of this display within the list. 
	 * @return Number
	 */
	public function get visibleWidth():Number
	{
		return _visibleWidth;
	}
	public function set visibleWidth( value:Number ):void
	{
		if( _visibleWidth == value ) return;
		
		_visibleWidth = value;
	}
	
	/**
	 * Accessor/Modifier for the visible height dimension of this display within the list. 
	 * @return Number
	 */
	public function get visibleHeight():Number
	{
		return _visibleHeight;
	}
	public function set visibleHeight( value:Number ):void
	{
		if( _visibleHeight == value ) return;
		
		_visibleHeight = value;
	}
	
	/**
	 * Accessor/Modifier for the preferred width of the display. 
	 * @return Number
	 */
	override public function get width():Number
	{
		return _width;
	}
	override public function set width( value:Number ):void
	{
		if( _width == value ) return;
		
		_width = value;
	}
	
	/**
	 * Accessor/Modifier for the preferred height of the display. 
	 * @return Number
	 */
	override public function get height():Number
	{
		return _height;
	}
	override public function set height( value:Number ):void
	{
		if( _height == value ) return;
		
		_height = value;
	}
}