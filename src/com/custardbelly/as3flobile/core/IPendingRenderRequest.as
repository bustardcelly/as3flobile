/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IPendingRenderRequest.as</p>
 * <p>Version: 0.4</p>
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
package com.custardbelly.as3flobile.core
{
	/**
	 * PendingRenderRequest represents an operation pending invocation upon refresh to render of a control within its life-cycle. 
	 * @author toddanderson
	 */
	public interface IPendingRenderRequest
	{
		/**
		 * Performs the operation pending render.
		 */
		function execute():void;
		
		/**
		 * Accessor/Modifier for the method to invoke upon execute. 
		 * @return Function
		 */
		function get method():Function;
		function set method( value:Function ):void;
		/**
		 * Accessor/Modifier for the arguments to pass in the method upon execute. 
		 * @return Array
		 */
		function get arguments():Array;
		function set arguments( value:Array ):void;
	}
}