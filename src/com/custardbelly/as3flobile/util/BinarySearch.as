/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BinarySearch.as</p>
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
package com.custardbelly.as3flobile.util
{
	/**
	 * BinarySearch is a basic implementation of a binary search algorithm to split the search for a sepcific value between high and low poles. 
	 * @author toddanderson
	 */
	public class BinarySearch
	{
		/**
		 * Utility method to find the exact index within an array that the value resides. 
		 * @param array Object The Array of Numbers to look through.
		 * @param value Number The Number to find in the array.
		 * @return int The elemental index at which the value resides in the Array. Returns -1 if not found.
		 */
		public static function findExact( array:Object, value:Number ):int
		{
			var length:int = array.length;
			var low:int = 0;
			var high:int = length;
			var mid:int;
			while( low < high )
			{
				mid = ( low + high ) * 0.5;
				if( array[mid] < value )
				{
					low = mid + 1;
				}
				else
				{
					high = mid;
				}
			}
			if ((low < length) && (array[low] == value))
				return low
				
			return -1;
		}
	}
}