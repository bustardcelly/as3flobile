/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleSwitchMouseContext.as</p>
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
package com.custardbelly.as3flobile.controls.toggle.context
{
	import com.custardbelly.as3flobile.controls.slider.ISlider;
	import com.custardbelly.as3flobile.controls.toggle.IToggleSwitch;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * ToggleSwitchMouseContext is an extension of BaseToggleSwitchContext to provide stategy context based on mouse gestures. 
	 * @author toddanderson
	 */
	public class ToggleSwitchMouseContext extends BaseToggleSwitchContext
	{
		protected var _point:Point;
		protected var _mouseTarget:InteractiveObject;
		protected var _backgroundTarget:InteractiveObject;
		protected var _thumbTarget:InteractiveObject;
		
		/**
		 * Constructor. 
		 * @param strategy IToggleSwitchStrategy
		 */
		public function ToggleSwitchMouseContext(strategy:IToggleSwitchStrategy)
		{
			super( strategy );
			_point = new Point();
		}
		
		/**
		 * @private 
		 * 
		 * Adds events listeners to target interactive objects.
		 */
		protected function addTargetListeners():void
		{
			_thumbTarget.stage.addEventListener( MouseEvent.MOUSE_MOVE, handleThumbMove, false, 0, true );
			_thumbTarget.stage.addEventListener( MouseEvent.MOUSE_UP, handleThumbUp, false, 0 , true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event listeners form target interactive objects.
		 */
		protected function removeTargetListeners():void
		{
			if( !_thumbTarget ) return;
			_thumbTarget.stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleThumbMove, false );
			_thumbTarget.stage.removeEventListener( MouseEvent.MOUSE_UP, handleThumbUp, false );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for click gesture on background target.
		 * @param evt MouseEvent
		 */
		protected function handleBackgroundClick( evt:MouseEvent ):void
		{
			_point.x = _mouseTarget.mouseX;
			_point.y = _mouseTarget.mouseY;
			_strategy.click( _point );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for down gesture on thumb target 
		 * @param evt MouseEvent
		 */
		protected function handleThumbDown( evt:MouseEvent ):void
		{
			addTargetListeners();
			
			_point.x = _mouseTarget.mouseX;
			_point.y = _mouseTarget.mouseY;
			_strategy.start( _point );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for move gesture of thumb target. 
		 * @param evt MouseEvent
		 */
		protected function handleThumbMove( evt:MouseEvent ):void
		{
			_point.x = _mouseTarget.mouseX;
			_point.y = _mouseTarget.mouseY;
			_strategy.move( _point );	
		}
		
		/**
		 * @private
		 * 
		 * Event handler for up gesture on thumb target. 
		 * @param evt MouseEvent
		 */
		protected function handleThumbUp( evt:MouseEvent ):void
		{
			removeTargetListeners();
			_point.x = _mouseTarget.mouseX;
			_point.y = _mouseTarget.mouseY;
			_strategy.end( _point );
		}
		
		/**
		 * @inherit
		 */
		override public function initialize( target:ISlider ):void
		{
			super.initialize( target );
			_mouseTarget = ( target as InteractiveObject );
			_backgroundTarget = target.backgroundTarget;
			_thumbTarget = target.thumbTarget;
		}
		
		/**
		 * @inherit
		 */
		override public function activate():void
		{
			super.activate();
			_backgroundTarget.addEventListener( MouseEvent.CLICK, handleBackgroundClick, false, 0, true );
			_thumbTarget.addEventListener( MouseEvent.MOUSE_DOWN, handleThumbDown, false, 0, true );
		}
		
		/**
		 * @inherit
		 */
		override public function deactivate():void
		{
			if( _isActive ) removeTargetListeners();
			
			super.deactivate();
			_backgroundTarget.removeEventListener( MouseEvent.CLICK, handleBackgroundClick, false );
			_thumbTarget.removeEventListener( MouseEvent.MOUSE_DOWN, handleThumbDown, false );
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			_mouseTarget = null;
			_backgroundTarget = null;
			_thumbTarget = null;
		}
	}
}