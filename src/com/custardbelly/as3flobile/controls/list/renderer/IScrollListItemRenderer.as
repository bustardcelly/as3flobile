/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollListItemRenderer.as</p>
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
package com.custardbelly.as3flobile.controls.list.renderer
{
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;

	/**
	 * IScrollListItemRenderer is an item renderer displayed in an IScrollListContainer. 
	 * @author toddanderson
	 */
	public interface IScrollListItemRenderer extends IEventDispatcher
	{
		/**
		 * Locks the renderer from performing any updates based on property changes.
		 */
		function lock():void;
		/**
		 * Frees the renderer from a locked state to perform updates based on property changes.
		 */
		function unlock():void;
		
		/**
		 * Accessor for the graphic display of the background for the item renderer.
		 */
		function get backgroundDisplay():Graphics
		
		/**
		 * Accessor/Modifier for the width dimension of this instance. 
		 * @return Number
		 */
		function get width():Number;
		function set width( value:Number ):void;
		/**
		 * Accessor/Modifier for the height dimension of this instance. 
		 * @return Number
		 */
		function get height():Number;
		function set height( value:Number ):void;
		
		/**
		 * Accessor/Modifier for flag of this instance being considered selected. 
		 * @return Boolean
		 */
		function get selected():Boolean;
		function set selected( value:Boolean ):void;
		
		/**
		 * Accessor/Modifier for flag to use variable width. Setting this flag ignores explicitly set width through IScrollListItemRenderer#width. 
		 * @return Number
		 */
		function get useVariableWidth():Boolean;
		function set useVariableWidth( value:Boolean ):void;
		/**
		 * Accessor/Modifier for flag to use variable height. Setting this flag ignores explicitly set height through IScrollListItemRenderer#height. 
		 * @return Boolean
		 */
		function get useVariableHeight():Boolean;
		function set useVariableHeight( value:Boolean ):void;
		
		/**
		 * Accessor/Modifier for the model representation to display. 
		 * @return Object
		 */
		function get data():Object;
		function set data( value:Object ):void;
	}
}