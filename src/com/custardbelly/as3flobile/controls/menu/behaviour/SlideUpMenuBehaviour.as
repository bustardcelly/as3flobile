/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: SlideUpMenuBehaviour.as</p>
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
	import com.custardbelly.as3flobile.controls.core.ISimpleDisplayObject;
	import com.custardbelly.as3flobile.controls.menu.panel.IMenuPanelDisplay;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * SlideUpMenuBehaviour is a basic behaviour manager for an IMenuPanelDisplay to apply translations along the y-axis. 
	 * @author toddanderson
	 */
	public class SlideUpMenuBehaviour implements IMenuRevealBehaviour
	{
		protected var _targetDisplay:DisplayObject;
		protected var _delegate:IMenuBehaviourDelegate;
		
		protected var _targetPosition:int;
		protected var _velocityY:Number;
		
		protected var _state:int;
		protected var _originPosition:Number;
		protected var _originAlpha:Number;
		protected var _alphaMultiplier:int;
		
		private static const DAMP:Number = 0.38;
		private static const ALPHA_DAMP:Number = 0.18;
		private static const MIN_VECTOR:Number = 0.75;
		
		/**
		 * Constructor.
		 */
		public function SlideUpMenuBehaviour() 
		{
			_state = MenuRevealBehaviourStateEnum.IDLE;
		}
		
		/**
		 * @private
		 * 
		 * Adds an frame handler to the target menu panel for animation.
		 */
		protected function addFrameHandler():void
		{
			removeFrameHandler();
			_targetDisplay.addEventListener( Event.ENTER_FRAME, animate, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes the frame event handler for the target menu panel.
		 */
		protected function removeFrameHandler():void
		{
			_targetDisplay.removeEventListener( Event.ENTER_FRAME, animate, false );
		}
		
		/**
		 * @private
		 * 
		 * Starts the translation of the target menu display along the y-axis. 
		 * @param state int The current state of the translation.
		 */
		protected function startAnimate( state:int ):void
		{
			addFrameHandler();
			setState( state );
			// Notfy delegate of begin transition.
			if( _delegate )
			{
				_delegate.menuBehaviourDidBegin( this );
			}
		}
		
		/**
		 * @private
		 * 
		 * Frame event handler for transitioning target menu panel. 
		 * @param evt Event
		 */
		protected function animate( evt:Event = null ):void
		{
			// Update velocity.
			_velocityY = ( _targetPosition - _targetDisplay.y ) * SlideUpMenuBehaviour.DAMP;
			
			// Check if velocity is under threshold.
			var absVelY:Number = ( _velocityY > 0 ) ? _velocityY : -_velocityY;
			if( absVelY < SlideUpMenuBehaviour.MIN_VECTOR )
			{
				_targetDisplay.y = _targetPosition;
				_velocityY = 0;
			}
			// Update current positon with velocity.
			_targetDisplay.y += _velocityY;
			_targetDisplay.alpha += ( SlideUpMenuBehaviour.ALPHA_DAMP * _alphaMultiplier );
			// If we ain't moving, we ain't moving.
			if( _velocityY == 0 )
			{	
				endAnimate();
			}
		}
		
		/**
		 * @private 
		 * 
		 * Ends the transition session.
		 */
		protected function endAnimate():void
		{
			// Update the current state to hold.
			var endState:int = MenuRevealBehaviourStateEnum.IDLE;
			if( _state == MenuRevealBehaviourStateEnum.REVEALING )
			{
				endState = MenuRevealBehaviourStateEnum.REVEALED;
			}
			else if( _state == MenuRevealBehaviourStateEnum.CONCEALING )
			{
				var container:DisplayObjectContainer = _targetDisplay.parent;
				if( container && container.contains( _targetDisplay ) )
				{
					container.removeChild( _targetDisplay );
				}
				endState = MenuRevealBehaviourStateEnum.CONCEALED;
			} 
			
			// Remove handler and set state.
			_targetDisplay.alpha = 1;
			removeFrameHandler();
			setState( endState );
			// Notify delegate of end of transition.
			if( _delegate )
			{
				_delegate.menuBehaviourDidEnd( this );
			}
		}
		
		/**
		 * @private
		 * 
		 * Internal set of transitioning state. 
		 * @param newValue
		 * 
		 */
		protected function setState( newValue:int ):void
		{
			_state = newValue;
			// Update alpha multiplier based on state.
			_alphaMultiplier = ( newValue == MenuRevealBehaviourStateEnum.CONCEALING ) ? -1 : 1;
			// Base enablement of the penl on being in view and available to receiev touch events.
			( _targetDisplay as ISimpleDisplayObject ).enabled = ( _state == MenuRevealBehaviourStateEnum.REVEALED );
		}
		
		/**
		 * @copy IMenuRevealBehaviour#reveal()
		 */
		public function reveal( target:DisplayObjectContainer, origin:Point ):void
		{
			_originPosition = origin.y;
			_originAlpha = 0;
			
			_targetDisplay.y = _originPosition;
			_targetDisplay.alpha = _originAlpha;
			_targetPosition = _originPosition - _targetDisplay.height;
			
			target.addChild( _targetDisplay );
			startAnimate( MenuRevealBehaviourStateEnum.REVEALING );
		}
		
		/**
		 * @copy IMenuRevealBehaviour#conceal()
		 */
		public function conceal():void
		{
			_targetPosition = _originPosition;
			startAnimate( MenuRevealBehaviourStateEnum.CONCEALING );
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		public function dispose():void
		{	
			removeFrameHandler();
			if( _targetDisplay )
			{
				var container:DisplayObjectContainer = _targetDisplay.parent;
				if( container && container.contains( _targetDisplay ) )
				{
					container.removeChild( _targetDisplay );
				}
				_targetDisplay = null;
			}
			_delegate = null;
		}
		
		/**
		 * @copy IMenuRevealBehaviour#getState()
		 */
		public function getState():int
		{
			return _state;
		}
		
		/**
		 * @copy IMenuRevealBehaviour#targetDisplay
		 */
		public function get targetDisplay():IMenuPanelDisplay
		{
			return _targetDisplay as IMenuPanelDisplay;
		}
		public function set targetDisplay( value:IMenuPanelDisplay ):void
		{
			_targetDisplay = value as DisplayObject;
		}

		/**
		 * @copy IMenuRevealBehaviour#delegate
		 */
		public function get delegate():IMenuBehaviourDelegate
		{
			return _delegate;
		}
		public function set delegate(value:IMenuBehaviourDelegate):void
		{
			_delegate = value;
		}
	}
}