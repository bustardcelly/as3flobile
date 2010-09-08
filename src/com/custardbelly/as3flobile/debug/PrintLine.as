/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: PrintLine.as</p>
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
package com.custardbelly.as3flobile.debug
{
	import com.custardbelly.as3flobile.controls.text.TextArea;

	/**
	 * PrintLine is a simple global reference to post messages to to facilitate debugging. 
	 * @author toddanderson
	 */
	public class PrintLine
	{
		private var _field:TextArea;
		private static var _instance:PrintLine = new PrintLine();
		
		/**
		 * Returns the instance of PrintLine singleton. 
		 * @return PrintLine
		 */
		public static function instance():PrintLine
		{
			return _instance;
		}
		
		/**
		 * Constructor.
		 */
		public function PrintLine() {}
		
		public function print( message:String, append:Boolean = false ):void
		{
			if( append && _field.text.length > 0 )
			{
				_field.text += "\n" + message;
			}
			else
			{
				_field.text = message;
			}
		}
		
		/**
		 * Accessor/Modifier for the output field to which messages are printed. 
		 * @return TextArea
		 */
		public function get field():TextArea
		{
			return _field;
		}
		public function set field( value:TextArea ):void
		{
			_field = value;
		}
	}
}