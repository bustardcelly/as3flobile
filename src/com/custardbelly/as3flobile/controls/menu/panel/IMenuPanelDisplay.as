/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IMenuPanelDisplay.as</p>
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
	import com.custardbelly.as3flobile.controls.core.ISimpleDisplayObject;
	import com.custardbelly.as3flobile.controls.menu.MenuItem;
	import com.custardbelly.as3flobile.controls.menu.layout.IMenuLayout;
	import com.custardbelly.as3flobile.controls.menu.layout.IMenuLayoutTarget;
	import com.custardbelly.as3flobile.model.IDisposable;
	import com.custardbelly.as3flobile.skin.ISkinnable;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.IEventDispatcher;

	/**
	 * IMenuPanelDisplay is a panel display for menus and submenus in the composite Menu control. 
	 * @author toddanderson
	 */
	public interface IMenuPanelDisplay extends ISimpleDisplayObject, ISkinnable, IMenuLayoutTarget, IDisposable, IEventDispatcher
	{	
		/**
		 * Returns the background display for skinning purposes. 
		 * @return Graphics
		 */
		function get backgroundDisplay():Graphics;
			
		/**
		 * Accessor/Modifier for the fully-qualified class name of the item renderer of the display. 
		 * @return String The fully-qualified class name.
		 */
		function get itemRenderer():String;
		function set itemRenderer( value:String ):void;
		
		/**
		 * Accessor/Modifier for the full-qualified class name of the item renderer skin for each item renderer. 
		 * @return String
		 */
		function get itemRendererSkin():String;
		function set itemRendererSkin( value:String ):void;
		
		/**
		 * Accessor/Modifier for the default height of each child item for layout. 
		 * @return int
		 */
		function get itemHeight():int;
		function set itemHeight(value:int):void;
		
		/**
		 * Accessor/Modifier for the default width of each child item for layout. 
		 * @return int
		 */
		function get itemWidth():int;
		function set itemWidth(value:int):void;
		
		/**
		 * Accessor/Modifier for the layout type for the menu panel display. 
		 * @return IMenuLayout
		 */
		function get layout():IMenuLayout;
		function set layout( value:IMenuLayout ):void;
		
		/**
		 * Accessor/Modifier for the client requesting notification on change to selection within this panel. 
		 * @return IMenuPanelSelectionDelegate
		 */
		function get selectionDelegate():IMenuPanelSelectionDelegate;
		function set selectionDelegate(value:IMenuPanelSelectionDelegate):void;
		
		/**
		 * Accessor/Modifier for the list model of items to be renderered using the item renderer. 
		 * @return Vector.<MenuItem>
		 */
		function get dataProvider():Vector.<MenuItem>;
		function set dataProvider( value:Vector.<MenuItem> ):void;
	}
}