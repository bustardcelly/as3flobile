/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollListDelegate.as</p>
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
package com.custardbelly.as3flobile.controls.list
{
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	
	import flash.geom.Point;

	/**
	 * IScrollListDelegate is a delegate object that responds to operations being performed by a IScrollListContainer instance. 
	 * Meant to replace the traditional event dispatching system to allow durect access.
	 * @author toddanderson
	 */
	public interface IScrollListDelegate
	{
		/**
		 * Notifier of scroll starting from the IScrollListContainer. 
		 * @param list IScrollListContainer
		 * @param position Point
		 */
		function listDidStartScroll( list:IScrollListContainer, position:Point ):void;
		/**
		 * Notifier of scrolling from the IScrollListContainer. 
		 * @param list IScrollListContainer
		 * @param position Point
		 */
		function listDidScroll( list:IScrollListContainer, position:Point ):void;
		/**
		 * Notifier of scroll ending from the IScrollListContainer. 
		 * @param list IScrollListContainer
		 * @param position Point
		 */
		function listDidEndScroll( list:IScrollListContainer, position:Point ):void;
		
		/**
		 * Notifier of selection change from the IScrollListContainer. 
		 * @param list IScrollListContainer
		 * @param selectedIndex int
		 */
		function listSelectionChange( list:IScrollListContainer, selectedIndex:int ):void;
	}
}