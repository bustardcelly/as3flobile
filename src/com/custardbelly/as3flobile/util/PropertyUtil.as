/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: PropertyUtil.as</p>
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
	import flash.utils.describeType;

	/**
	 * PropertyUtil provides convenience methods for working with properties of an object. 
	 * @author toddanderson
	 */
	public class PropertyUtil
	{
		private static const READ_WRITE:String = "readwrite";
		
		/**
		 * Returns a list of read-write properties available on the Object. 
		 * @param object Object
		 * @return Vector.<String>
		 */
		static public function getReadWriteDescription( object:Object ):Vector.<String>
		{
			var description:Vector.<String> = new Vector.<String>();
			var xml:XML = describeType( object );
			var variables:XMLList = xml..variable;
			var variable:XML;
			// Run through public variable declarations.
			for each( variable in variables )
			{
				description[description.length] = variable.@name;
			}
			// Run through accessors.
			var accessors:XMLList = xml..accessor;
			for each( variable in accessors )
			{
				// Only include if readwrite.
				if( variable.@access == PropertyUtil.READ_WRITE )
					description[description.length] = variable.@name;
			}
			return description;
		}
	}
}