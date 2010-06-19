/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollViewport.as</p>
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
package com.custardbelly.as3flobile.controls.viewport
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * IScrollViewport is a display container that provides a viewport area for scrolling of content. 
	 * @author toddanderson
	 */
	public interface IScrollViewport extends IEventDispatcher
	{
		/**
		 * Runs a refresh on content and context.
		 */
		function refresh():void;
		/**
		 * Performs any clenaup.
		 */
		function dispose():void;
		
		/**
		 * Accessor/Modifier for the rectangular area of the viewport. 
		 * @return Rectangle
		 */
		function get scrollRect():Rectangle;
		function set scrollRect( value:Rectangle ):void;
		
		/**
		 * Accessor/Modifier for the display width of the viewport. 
		 * @return Number
		 */
		function get width():Number;
		function set width( value:Number ):void;
		
		/**
		 * Accessor/Modifier for the display height of the viewport. 
		 * @return Number
		 */
		function get height():Number;
		function set height( value:Number ):void;
		
		/**
		 * Accessor/Modifier for the IScrollViewportDelegate that recieves notifications on action. 
		 * @return IScrollViewportDelegate
		 */
		function get delegate():IScrollViewportDelegate;
		function set delegate( value:IScrollViewportDelegate ):void;
		
		/**
		 * Accessor/Modifier for the content that is being scrolled within the viewport. 
		 * @return InteractiveObject
		 */
		function get content():InteractiveObject;
		function set content( value:InteractiveObject ):void;
	}
}