/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollViewport.as</p>
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
package com.custardbelly.as3flobile.controls.viewport
{
	import com.custardbelly.as3flobile.controls.core.ISimpleDisplayObject;
	import com.custardbelly.as3flobile.controls.viewport.context.IScrollViewportContext;
	import com.custardbelly.as3flobile.model.IDisposable;
	
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;

	/**
	 * IScrollViewport is a display container that provides a viewport area for scrolling of content. 
	 * @author toddanderson
	 */
	public interface IScrollViewport extends ISimpleDisplayObject, IDisposable, IEventDispatcher
	{
		/**
		 * Runs a reset on context and context.
		 */
		function reset():void;
		
		/**
		 * Runs a refresh on content and context.
		 */
		function refresh():void;
		
		/**
		 * Returns flag of this viewport being considered active and live on the stage. 
		 * @return Boolean
		 */
		function isActiveOnDisplayList():Boolean;
		
		/**
		 * Updates the display base on scroll position along the x and y axis. 
		 * @param position Point
		 */
		function scrollToPosition( position:Point ):void;
		
		/**
		 * Returns signal reference for start of scroll. 
		 * @return Signal Signal( Point );
		 */
		function get scrollStart():Signal;
		/**
		 * Returns signal reference for end of scroll. 
		 * @return Signal Signal( Point );
		 */
		function get scrollEnd():Signal;
		/**
		 * Returns signal reference for change in scroll. 
		 * @return Signal Signal( Point );
		 */
		function get scrollChange():Signal;
		
		/**
		 * Returns the bounding area for which the content is presented in a scrollable viewport.
		 * The properties of this bounding area is updated on change to width and height.
		 * @return Rectangle
		 */
		function get scrollBounds():Rectangle;
		
		/**
		 * Accessor/Modifier for the content that is being scrolled within the viewport. 
		 * @return InteractiveObject
		 */
		function get content():InteractiveObject;
		function set content( value:InteractiveObject ):void;
		
		/**
		 * Accessor/Modifier for the viewport context that manages user gestures and animation of display. 
		 * @return IScrollViewportContext
		 */
		function get context():IScrollViewportContext;
		function set context( value:IScrollViewportContext ):void;
	}
}