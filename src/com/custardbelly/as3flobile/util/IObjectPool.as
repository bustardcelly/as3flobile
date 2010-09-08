/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IObjectPool.as</p>
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
package com.custardbelly.as3flobile.util
{
	import com.custardbelly.as3flobile.model.IDisposable;

	/**
	 * IObjectPool manages the creation, retrieval and storage of objects for recycling purposes.
	 * Once objects are retrieved using getInstance(), their memory does not remain in the pool.
	 * @author toddanderson
	 */
	public interface IObjectPool extends IDisposable
	{
		/**
		 * Returns a new instance of a specified type filled with optional properties. 
		 * @param initProperties Object Generic key/value pairs of properties related to specified object type.
		 * @return Object
		 */
		function getInstance( initProperties:Object = null ):Object;
		/**
		 * Returns an instance to the pool for later reuse. 
		 * @param value Object
		 */
		function returnInstance( value:Object ):void;
		/**
		 * Returns the length of the list of objects available in the pool. 
		 * @return int
		 */
		function length():int;
		/**
		 * Empties out the pool of objects.
		 */
		function flush():void;
	}
}