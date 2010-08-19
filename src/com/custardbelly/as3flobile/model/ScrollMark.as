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
	import flash.utils.Dictionary;

	/**
	 * ScrollMark is a model class representing a point in time at which a scroll action has occured.  
	 * @author toddanderson
	 */
	public class ScrollMark
	{
		public var x:Number;
		public var y:Number;
		public var time:Number;
		
		private static var KEY_INCREMENT:uint = 0;
		
		/**
		 * @private
		 * 
		 * Internally managed pool of ScrollMark instances. 
		 */
		private static var _pool:Dictionary;
		
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
		 * @private
		 * 
		 * Fail safe method to retrieve the mark list related to the unique key in the pool. 
		 * @param key uint
		 * @return Vector.<ScrollMark>
		 */
		static private function getMarksFromKey( key:uint ):Vector.<ScrollMark>
		{
			// If pool not created, create it.
			if( _pool == null )
				_pool = new Dictionary( true );
			// If associated list of marks not available, create it.
			if( _pool[key] == null )
				_pool[key] = new Vector.<ScrollMark>();
			// Return list based on key.
			return _pool[key];
		}
		
		/**
		 * Generates and returns a unique key to use when working with mark pools. 
		 * @return uint
		 */
		static public function generateKey():uint
		{
			// Simple, simple increment. We're not doing web security here, people. We just playing.
			return ScrollMark.KEY_INCREMENT++;
		}
		
		/**
		 * Utility factory method to access a ScrollMark instance. Checks if ScrollMark is available in pool of instances. If not creates a new one. 
		 * @param key uint The unique key associated with the pool request. Keys can first be obtained using ScrollMark#generateKey().
		 * @param x Number The position along the x axis that the scroll action occured.
		 * @param y Number The position along the y axis that the scroll action occured.
		 * @param time Number The time at which the scroll action occured.
		 * @return ScrollMark
		 */
		static public function getScrollMark( key:uint, x:Number, y:Number, time:Number ):ScrollMark
		{
			var marks:Vector.<ScrollMark> = ScrollMark.getMarksFromKey( key );
			if( marks.length == 0 )
				marks[0] = new ScrollMark();
			
			var mark:ScrollMark = marks.shift();
			mark.x = x;
			mark.y = y;
			mark.time = time;
			return mark;
		}
		
		/**
		 * Utility method to return a ScrollMark instance to the internally managed pool of ScrollMarks. 
		 * @param key uint
		 * @param mark ScrollMark
		 */
		static public function returnScrollMark( key:uint, mark:ScrollMark ):void
		{
			var marks:Vector.<ScrollMark> = ScrollMark.getMarksFromKey( key );
			mark.x = mark.y = mark.time = 0;
			marks[marks.length] = mark;
		}
		
		/**
		 * Utility method to flush the internally managed pool of ScrollMark references.
		 * @param key uint The unique key to the mark pool.
		 */
		static public function flush( key:uint ):void
		{
			if( _pool == null ) return;
			
			var marks:Vector.<ScrollMark> = ScrollMark.getMarksFromKey( key );
			while( marks.length > 0 )
				marks.shift();
		}
		
		/**
		 * Utility method to flush all internally managed pools of ScrollMark references. 
		 */
		static public function flushAll():void
		{
			if( _pool == null ) return;
			
			var key:uint;
			for each( key in _pool )
			{
				ScrollMark.flush( key );
			}
		}
	}
}