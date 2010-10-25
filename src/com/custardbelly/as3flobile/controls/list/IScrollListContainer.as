/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollListContainer.as</p>
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
package com.custardbelly.as3flobile.controls.list
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListLayout;
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	import com.custardbelly.as3flobile.controls.viewport.context.IScrollViewportContext;
	import com.custardbelly.as3flobile.model.IDisposable;
	import com.custardbelly.as3flobile.skin.ISkinnable;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;

	
	/**
	 * IScrollListContainer is a list of data pbjects represented as IScrollListItemRenderer instances. 
	 * @author toddanderson
	 */
	public interface IScrollListContainer extends ISkinnable, IDisposable
	{
		/**
		 * Returns the IScrollListItemRenderer instance that resides at the elemental index within the list.
		 * @param index uint
		 * @return IScrollListItemRenderer
		 */
		function getRendererAt( index:uint ):IScrollListItemRenderer;
		
		/**
		 * Scrolls the list to the specified index. 
		 * @param index uint
		 */
		function scrollPositionToIndex( index:uint ):void;
		
		/**
		 * Returns the signal reference for the start of scroll.
		 * Clients can listen for start of scroll by using the DeluxeSignal::add() method. 
		 * @return DeluxeSignal
		 */
		function get scrollStart():DeluxeSignal
		/**
		 * Returns the signal reference for the end of scroll.
		 * Clients can listen for the end of scroll by using the DeluxeSignal::add() method. 
		 * @return DeluxeSignal
		 */
		function get scrollEnd():DeluxeSignal;
		/**
		 * Returns the signal reference for the scroll.
		 * Clients can list for the scroll of a container by using the DeluxeSignal::add() method. 
		 * @return DeluxeSignal
		 */
		function get scrollChange():DeluxeSignal;
		
		/**
		 * Returns the signal reference for select change. 
		 * @return DeluxeSignal
		 */
		function get selectionChange():DeluxeSignal;
		
		/**
		 * Returns the list of IScrollListItemRenderers. 
		 * @return Vector.<IScrollListItemRenderer>
		 */
		function get renderers():Vector.<IScrollListItemRenderer>;
		/**
		 * Returns the amount of IScrollListItemRenderers in the list. 
		 * @return int
		 */
		function get rendererAmount():int;
		
		/**
		 * Returns the current scroll position of the list container. 
		 * @return Point
		 */
		function get scrollPosition():Point;
		
		/**
		 * Accessor/Modifier for the rectangular scroll area of the container. 
		 * @return Rectangle
		 */
		function get scrollBounds():Rectangle;
		
		/**
		 * Accessor/Modifier for the layout manager for the item renderers in the list. 
		 * @return IScrollListLayout
		 */
		function get layout():IScrollListLayout;
		function set layout( value:IScrollListLayout ):void;
		
		/**
		 * Accessor/Modifier for the viewport context that manages user gestures and animation of display. 
		 * @return IScrollViewportContext
		 */
		function get scrollContext():IScrollViewportContext;
		function set scrollContext( value:IScrollViewportContext ):void;
		
		/**
		 * Accessor/Modifier for the seperator size between list items. 
		 * @return int
		 */
		function get seperatorLength():int;
		function set seperatorLength(value:int):void; 
		
		/**
		 * Accessor/Modifier for the item renderer instance to represent the data. 
		 * @return String The fully qualified class name of the item renderer.
		 */
		function get itemRenderer():String;
		function set itemRenderer( value:String ):void;
		
		/**
		 * Accessor/Modfier for flag of being able to make a selection within the list. 
		 * @return Boolean
		 */
		function get selectionEnabled():Boolean;
		function set selectionEnabled( value:Boolean ):void;
		
		/**
		 * Accessor/Modifier of the selected item within the list from the data provided. This is not the selected item renderer instance. 
		 * @return Object
		 */
		function get selectedItem():Object;
		function set selectedItem( value:Object ):void;
		
		/**
		 * Accessor/Modifier for the selected index within the list. 
		 * @return int
		 */
		function get selectedIndex():int;
		function set selectedIndex( value:int ):void;
		
		/**
		 * Accessor/Modifier for the property field of a data item to use as the textual context for the label of the item renderer. 
		 * @return String
		 */
		function get labelField():String;
		function set labelField( value:String ):void;
		
		/**
		 * Accessor/Modifier for an Array of object data that is interpreted visually as IScrollListItemRenderer instances. 
		 * @return Array
		 */
		function get dataProvider():Array;
		function set dataProvider( value:Array ):void;
	}
}