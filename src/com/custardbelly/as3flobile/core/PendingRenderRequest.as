/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: PendingRenderRequest.as</p>
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
	public class PendingRenderRequest implements IPendingRenderRequest
	{
		protected var _method:Function;
		protected var _arguments:Array;
		
		/**
		 * Constructor. 
		 * @param method Function The method to invoke on execute()
		 * @param args The optional arguments to pass along in the method invocation.
		 */
		public function PendingRenderRequest( invokeMethod:Function = null, args:Array = null )
		{
			_method = invokeMethod;
			_arguments = args;
		}
		
		/**
		 * @private 
		 * 
		 * Removes references for elligiblity for GC.
		 */
		protected function dispose():void
		{
			_method = null;
			_arguments = null;
		}
		
		/**
		 * @copy IPendingInitRequest#execute()
		 */
		public function execute():void
		{
			_method.apply( null, _arguments );
			dispose();
		}
		
		/**
		 * @copy IPendingInitRequest#method
		 */
		public function get method():Function
		{
			return _method;
		}
		public function set method( value:Function ):void
		{
			_method = value;
		}
		
		/**
		 * @copy IPendingInitRequest#arguments
		 */
		public function get arguments():Array
		{
			return _arguments;
		}
		public function set arguments( value:Array ):void
		{
			_arguments = value;
		}
	}
}