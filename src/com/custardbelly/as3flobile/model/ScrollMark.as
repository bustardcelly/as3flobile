/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollMark.as</p>
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
package com.custardbelly.as3flobile.model
{
	/**
	 * ScrollMark is a model class representing a point in time at which a scroll action has occured.  
	 * @author toddanderson
	 */
	public class ScrollMark
	{
		public var x:Number;
		public var y:Number;
		public var time:Number;
		
		/**
		 * @private
		 * 
		 * Internally managed pool of ScrollMark instances. 
		 */
		private static var _pool:Vector.<ScrollMark>;
		
		/**
		 * Constructor 
		 * @param x Number The position along the x axis that the scroll action occured.
		 * @param y Number The position along the y axis that the scroll action occured.
		 * @param time Number The time at which the scroll action occured.
		 */
		public function ScrollMark( x:Number = 0, y:Number = 0, time:Number = 0 )
		{
			this.x = x;
			this.y = y;
			this.time = time;
		}
		
		/**
		 * Utility factory method to access a ScrollMark instance. Checks if ScrollMark is available in pool of instances. If not creates a new one. 
		 * @param x Number The position along the x axis that the scroll action occured.
		 * @param y Number The position along the y axis that the scroll action occured.
		 * @param time Number The time at which the scroll action occured.
		 * @return ScrollMark
		 */
		static public function getScrollMark( x:Number, y:Number, time:Number ):ScrollMark
		{
			if( _pool == null )
				_pool = new Vector.<ScrollMark>();
			
			if( _pool.length == 0 )
				_pool[0] = new ScrollMark();
			
			var mark:ScrollMark = _pool.shift();
			mark.x = x;
			mark.y = y;
			mark.time = time;
			return mark;
		}
		
		/**
		 * Utility method to return a ScrollMark instance to the internally managed pool of ScrollMarks. 
		 * @param mark ScrollMark
		 */
		static public function returnScrollMark( mark:ScrollMark ):void
		{
			mark.x = mark.y = mark.time = 0;
			_pool[_pool.length] = mark;
		}
		
		/**
		 * Utility method to flush the internally managed pool of ScrollMark references.
		 */
		static public function flush():void
		{
			_pool = new Vector.<ScrollMark>();
		}
	}
}