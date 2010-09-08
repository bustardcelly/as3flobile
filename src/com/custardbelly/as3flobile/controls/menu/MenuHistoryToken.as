/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MenuHistoryToken.as</p>
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
package com.custardbelly.as3flobile.controls.menu
{
	import com.custardbelly.as3flobile.controls.menu.behaviour.IMenuRevealBehaviour;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * MenuHistoryToken is a model class for a leaf in the history of panel displays within a Menu control. 
	 * @author toddanderson
	 */
	public class MenuHistoryToken
	{
		/**
		 * The held behaviour for a menu panel display. Based on direction, the display will transition in or out of view. 
		 */
		public var behaviour:IMenuRevealBehaviour;
		/**
		 * The target display container on which to attach the menu panel display for transition. 
		 */
		public var targetContainer:DisplayObjectContainer;
		/**
		 * The origin point for the menu panel from which to based the start and end position of the translation. 
		 */
		public var origin:Point;
		
		/**
		 * Constructor.
		 */
		public function MenuHistoryToken() {}
		
		/**
		 * Invokes the behaviour manager for a menu display to animate in a specified direction. 
		 * @param direction int The direction to move animate the token in history. Valid values can be found on MenuHistoryTokenDirectionEnum
		 */
		public function execute( direction:int ):void
		{
			if( direction == MenuHistoryTokenDirectionEnum.FORWARD )
			{
				behaviour.reveal( targetContainer, origin );
			}
			else if( direction == MenuHistoryTokenDirectionEnum.BACKWARD )
			{
				behaviour.conceal();
			}
		}
	}
}