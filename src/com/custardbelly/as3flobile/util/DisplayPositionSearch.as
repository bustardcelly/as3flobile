/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: DisplayPositionSearch.as</p>
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
	import flash.display.DisplayObject;

	/**
	 * DisplayPositionSearch is a utility class to find the index of an object within a list given the target position. Uses a Binary Search algorithm.  
	 * @author toddanderson
	 */
	public class DisplayPositionSearch
	{
		/**
		 * Utility method to find a cell item that resides within the current position. 
		 * @param vector Object Must be an Array or Vector.
		 * @param position Number The position along the x or y axis. This position is compared with the following function arguments.
		 * @param compareFunction Function A Delegate function to compare if the object resides above or below the position.
		 * @param rangeFunction Function A Delegate function to detemrine if the object's dimensions reside within the position.
		 * @return int The elemental index of the cell display object that resides within the list at the position.
		 */
		public static function findCellIndexInPosition( vector:Object, position:Number, compareFunction:Function = null, rangeFunction:Function = null ):int
		{
			var length:int = vector.length;
			if( length == 0 ) return -1;
			
			var low:int = 0;
			var high:int = length;
			var mid:int;
			var item:DisplayObject;
			while( low < high )
			{
				mid = ( low + high ) * 0.5;
				item = vector[mid] as DisplayObject;
				if( compareFunction.apply( null, [item, position] ) )
				{
					low = mid + 1;
				}
				else
				{
					high = mid;
				}
			}
			
			if ( (low < length) )
			{
				item = vector[low] as DisplayObject;
				if( rangeFunction.apply( null, [item, position] ) )
				{
					return low;
				}
			}
			
			return -1;
		}
	}
}