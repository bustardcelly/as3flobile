/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BoxPadding.as</p>
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
	 * BoxPadding represents the positional offset of padding for a control. 
	 * @author toddanderson
	 */
	public class BoxPadding
	{
		public var left:int;
		public var top:int;
		public var right:int;
		public var bottom:int;
		
		/**
		 * Constructor. 
		 * @param left int Default 0.
		 * @param top int Default 0.
		 * @param right int Default 0.
		 * @param bottom int Default 0.
		 */
		public function BoxPadding( left:int = 0, top:int = 0, right:int = 0, bottom:int = 0 )
		{
			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
		}
		
		/**
		 * Compares values of two BoxPadding models to determine if they are equivalient. 
		 * @param padding BoxPadding
		 * @param matchPadding BoxPadding
		 * @return Boolean
		 */
		public static function equals( padding:BoxPadding, matchPadding:BoxPadding ):Boolean
		{
			if( padding == null || matchPadding == null ) return false;
			
			return 	matchPadding.left == padding.left && 
					matchPadding.top == padding.top && 
					matchPadding.right == padding.right && 
					matchPadding.bottom == padding.bottom;
		}
	}
}