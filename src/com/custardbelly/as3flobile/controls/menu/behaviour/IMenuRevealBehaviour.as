/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IMenuRevealBehaviour.as</p>
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
package com.custardbelly.as3flobile.controls.menu.behaviour
{
	import com.custardbelly.as3flobile.controls.menu.panel.IMenuPanelDisplay;
	import com.custardbelly.as3flobile.model.IDisposable;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	/**
	 * IMenuRevealBehaviour is a managing object for translations on properties to transition a target display in and out of view on a traget container. 
	 * @author toddanderson
	 */
	public interface IMenuRevealBehaviour extends IDisposable
	{
		/**
		 * Invokes transition in of target display on a specified container at a specified position. 
		 * @param target DisplayObjectContainer The target container to add the target display to that is being transitioned.
		 * @param origin Point The top-left point at which to being any coordinate translations.
		 */
		function reveal( target:DisplayObjectContainer, origin:Point ):void;
		/**
		 * Invokes transition out of target display on a specified container.
		 */
		function conceal():void;
		
		/**
		 * Returns the current state of the behaviour. Valid values are enumerated on MEnuRevealBehaviourStateEnum. 
		 * @return int
		 */
		function getState():int;
		
		/**
		 * Accessor/Modifier for the client that requires notification of transitioning state. 
		 * @return IMenuBehaviourDelegate
		 */
		function get delegate():IMenuBehaviourDelegate;
		function set delegate( value:IMenuBehaviourDelegate ):void;
		
		/**
		 * Accessor/Modifier for the target menu panel display to perform translations on. 
		 * @return IMenuPanelDisplay
		 */
		function get targetDisplay():IMenuPanelDisplay;
		function set targetDisplay( value:IMenuPanelDisplay ):void;
	}
}