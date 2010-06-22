/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollViewportMouseContext.as</p>
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
package com.custardbelly.as3flobile.controls.viewport.context
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ScrollViewportMouseContext is a context for scrolling strategy that bases its mediated user interaction for a scroll event using the mouse. 
	 * @author toddanderson
	 */
	public class ScrollViewportMouseContext extends BaseScrollViewportContext
	{
		protected var _mouseTarget:Stage;
		
		/**
		 * Constructor. 
		 * @param strategy IScrollViewportStrategy The strategy to use during mediation of a scrolling seqeunce.
		 */
		public function ScrollViewportMouseContext(strategy:IScrollViewportStrategy)
		{
			super(strategy);
		}
		
		/**
		 * @private 
		 * 
		 * Adds event handlers for targets representing a start and end to scrolling.
		 */
		protected function addTargetListeners():void
		{
			_mouseTarget.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true );
			_mouseTarget.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event handlers from targets representing a start and end to scrolling.
		 */
		protected function removeTargetListeners():void
		{
			if( !_mouseTarget ) return;
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove, false );
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for MOUSE_DOWN event which instrcuts the scrolling strategy to start. 
		 * @param evt MouseEvent
		 */
		protected function handleMouseDown( evt:MouseEvent ):void
		{
			_mouseTarget = ( evt.target as InteractiveObject ).stage;
			addTargetListeners();
			
			_strategy.start( new Point( _mouseTarget.mouseX, _mouseTarget.mouseY ) );
		}
		
		/**
		 * Event handler for MOUSE_MOVE event which instructs the scrolling strategy to move. 
		 * @param evt MouseEvent
		 * 
		 */
		protected function handleMouseMove( evt:MouseEvent ):void
		{
			_strategy.move( new Point( _mouseTarget.mouseX, _mouseTarget.mouseY ) );
		}
		
		/**
		 * Event handler for MOUSE_UP event which instructs the scrolling strategy to end. 
		 * @param evt MouseEvent
		 */
		protected function handleMouseUp( evt:MouseEvent ):void
		{
			removeTargetListeners();
			_strategy.end( new Point( _mouseTarget.mouseX, _mouseTarget.mouseY ) );
		}
		
		/**
		 * @inherit
		 */
		override public function activate():void
		{
			super.activate();
			_viewport.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true );
		}
		
		/**
		 * @inherit
		 */
		override public function deactivate():void
		{
			super.deactivate();
			_viewport.removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false );
			removeTargetListeners();
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			_mouseTarget = null;
		}
	}
}