/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IMenuItemRenderer.as</p>
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
package com.custardbelly.as3flobile.controls.menu.renderer
{
	import com.custardbelly.as3flobile.controls.core.ISimpleDisplayObject;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.menu.MenuItem;
	import com.custardbelly.as3flobile.helper.ITapMediator;
	import com.custardbelly.as3flobile.model.IDisposable;
	import com.custardbelly.as3flobile.skin.ISkinnable;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;

	/**
	 * IMenuItemRenderer is a view display representing a MenuItem. 
	 * @author toddanderson
	 */
	public interface IMenuItemRenderer extends ISimpleDisplayObject, IDisposable, ISkinnable, IEventDispatcher
	{
		/**
		 * Returns the reference to the background display. 
		 * @return Graphics
		 */
		function get backgroundDisplay():Graphics;
		/**
		 * Returns the reference to the title label display. 
		 * @return Label
		 */
		function get titleDisplay():Label;
		/**
		 * Returns the reference to the icon display. 
		 * @return DisplayObject
		 */
		function get iconDisplay():DisplayObject;
		
		/**
		 * Accessor/Modifier for the client requesting notification of selection. 
		 * @return IMenuItemSelectionDelegate
		 */
		function get delegate():IMenuItemSelectionDelegate;
		function set delegate( value:IMenuItemSelectionDelegate ):void;
		
		/**
		 * Accessor/Modifier for the mediating tap manager. 
		 * @return ITapMediator
		 */
		function get tapMediator():ITapMediator;
		function set tapMediator( value:ITapMediator ):void;
		
		/**
		 * Accessor/Modifier for the model to represent. 
		 * @return MenuItem
		 */
		function get data():MenuItem;
		function set data( value:MenuItem ):void;
	}
}