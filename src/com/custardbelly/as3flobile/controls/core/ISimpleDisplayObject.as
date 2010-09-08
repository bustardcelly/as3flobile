/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ISimpleDisplayObject.as</p>
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
package com.custardbelly.as3flobile.controls.core
{
	/**
	 * SimpleDisplayObject exposes common properties available on DisplayObject that can be referenced with working with interface implementations that extend DisplayObject. 
	 * @author toddanderson
	 */
	public interface ISimpleDisplayObject
	{
		/**
		 * Accessor/Modifier for the position along the x axis. 
		 * @return Number
		 */
		function get x():Number;
		function set x( value:Number ):void;
		/**
		 * Accessor/Modifier for the position along the y axis. 
		 * @return Number
		 */
		function get y():Number;
		function set y( value:Number ):void;
		/**
		 * Accessor/Modifier for the width dimension of this instance. 
		 * @return Number
		 */
		function get width():Number;
		function set width( value:Number ):void;
		/**
		 * Accessor/Modifier for the height dimension of this instance. 
		 * @return Number
		 */
		function get height():Number;
		function set height( value:Number ):void;
		/**
		 * Accessor/Modifier for enablement of a control. 
		 * @return Boolean
		 */
		function get enabled():Boolean;
		function set enabled( value:Boolean ):void;
	}
}