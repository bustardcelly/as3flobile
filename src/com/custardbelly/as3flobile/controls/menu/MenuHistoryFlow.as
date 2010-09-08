/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MenuHistoryFlow.as</p>
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
	import com.custardbelly.as3flobile.controls.menu.behaviour.IMenuBehaviourDelegate;
	import com.custardbelly.as3flobile.controls.menu.behaviour.IMenuRevealBehaviour;
	import com.custardbelly.as3flobile.controls.menu.panel.IMenuPanelDisplay;
	import com.custardbelly.as3flobile.model.IDisposable;
	import com.custardbelly.as3flobile.util.IObjectPool;
	import com.custardbelly.as3flobile.util.ObjectPool;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	/**
	 * MenuHistoryFlow manages the history of panel displays within a Menu control. 
	 * A Menu control can contain multiple panels based on its maximum display amount. MenuHistoryFlow takes care of moving from one panel to another in a forward or backward fashion. 
	 * @author toddanderson
	 */
	public class MenuHistoryFlow implements IDisposable, IMenuBehaviourDelegate
	{
		/**
		 * @private
		 * The current index within the list of IMenuPanelDisplay instances. 
		 */
		protected var _cursor:int;
		/**
		 * @private
		 * The list of history tokens. 
		 */
		protected var _tokens:Vector.<MenuHistoryToken>;
		/**
		 * @private
		 * Factory pool for tokens for recycling. 
		 */
		protected var _tokenPool:IObjectPool;
		/**
		 * @private
		 * Factory pool for behaviours that manage the menu panel transitions. 
		 */
		protected var _behaviourPool:IObjectPool;
		
		/**
		 * @private
		 * The target display container to add menu panels to. 
		 */
		protected var _targetContainer:DisplayObjectContainer;
		/**
		 * @private
		 * The origin point at which to start menu panel transitioning. 
		 */
		protected var _origin:Point;
		
		/**
		 * @private
		 * The list of IMenuPanelDisplay instances to cycle through in history. 
		 */
		protected var _stack:Vector.<IMenuPanelDisplay>;
		/**
		 * @private
		 * The behaviour type to associate with the transtioning of menu panels. Full-qualified classname. 
		 */
		protected var _behaviourType:String;
		/**
		 * @private
		 * The client to notify as menu panels are transitioned in and out of view. 
		 */
		protected var _delegate:IMenuBehaviourDelegate;
		
		/**
		 * Constructor.
		 */
		public function MenuHistoryFlow() 
		{
			_tokens = new Vector.<MenuHistoryToken>();
			_tokenPool = new ObjectPool( getQualifiedClassName( MenuHistoryToken ) );
		}
		
		/**
		 * Static util method to create a new instance of MenuHIstoryFlow with a target delegate. 
		 * @param delegate IMenuBehaviourDelegate
		 * @return MenuHistoryFlow
		 */
		static public function initWithDelegate( delegate:IMenuBehaviourDelegate ):MenuHistoryFlow
		{
			var history:MenuHistoryFlow = new MenuHistoryFlow();
			history.delegate = delegate;
			return history;
		}
		
		/**
		 * @private 
		 * 
		 * Resets the object pool of behaviours that manage the transitioning of menu panels.
		 */
		protected function resetBehaviourPool():void
		{
			// If we wee currently referencing an ObjectPool for behaviours, empty and discard.
			if( _behaviourPool )
			{
				_behaviourPool.flush();
				_behaviourPool = null;
			}
			// Create our new pool.
			_behaviourPool = new ObjectPool( _behaviourType );
		}

		/**
		 * @private
		 * 
		 * Returns a history token retrieved from the pool, populated with a behaviour that manages an IMenuPanelDisplay held in the stack at the given index. 
		 * @param index int The elemental index of a IMenuPanelDisplay within the stack.
		 * @return MenuHistoryToken
		 */
		protected function getNewToken( index:int ):MenuHistoryToken
		{
			// If index out of range, return null.
			if( index < 0 || index > _stack.length ) return null;
				
			// Move cursor.
			_cursor = index;
			
			// Assign the IMenuPanelDisplay to a behaviour from the pool and retrieve an instance of a token from its pool.
			var menuPanel:IMenuPanelDisplay = _stack[_cursor];
			var behaviour:IMenuRevealBehaviour = getBehaviour();
			behaviour.targetDisplay = menuPanel;
			return _tokenPool.getInstance( {behaviour:behaviour, targetContainer:_targetContainer, origin:_origin} ) as MenuHistoryToken;
		}
		
		/**
		 * @private
		 * 
		 * Retrieves an IMenuRevealBehaviour reference from the pool. 
		 * @return IMenuRevealBehaviour
		 */
		protected function getBehaviour():IMenuRevealBehaviour
		{
			return _behaviourPool.getInstance( {delegate: this} ) as IMenuRevealBehaviour;
		}
		
		/**
		 * @private
		 * 
		 * Returns the previous token in history without moving the cursor. 
		 * @return MenuHistoryToken
		 * 
		 */
		protected function previousToken():MenuHistoryToken
		{
			return ( _tokens.length > 0 ) ? _tokens[_tokens.length-1] : null;
		}
		
		/**
		 * @private
		 * 
		 * Pops the latest token from history. 
		 * @return MenuHistoryToken
		 */
		protected function removeLastToken():MenuHistoryToken
		{
			// Pop from token list.
			var token:MenuHistoryToken = _tokens.pop();
			// If not null, return references to respective pools.
			if( token )
			{
				_behaviourPool.returnInstance( token.behaviour );
				_tokenPool.returnInstance( token );	
			}
			return token;
		}
		
		/**
		 * @copy IMenuBehaviourDelegate#menuBehaviourDidBegin()
		 */
		public function menuBehaviourDidBegin( behaviour:IMenuRevealBehaviour ):void 
		{
			if( _delegate ) _delegate.menuBehaviourDidBegin( behaviour );
		}
		/**
		 * @copy IMenuBehaviourDelegate#menuBehaviourDidEnd()
		 */
		public function menuBehaviourDidEnd( behaviour:IMenuRevealBehaviour ):void
		{
			if( _delegate ) _delegate.menuBehaviourDidEnd( behaviour );
		}
		
		/**
		 * Starts a new history session. 
		 * @param targetContainer DisplayObjectContainer The display container to attach menu panels to.
		 * @param origin Point The origin point at which to place menu panels fro transitioning.
		 */
		public function start( targetContainer:DisplayObjectContainer, origin:Point ):void
		{
			_targetContainer = targetContainer;
			_origin = origin;
			// Get the token associated with first index.
			var token:MenuHistoryToken = getNewToken( 0 );
			if( token )
			{
				// Push to history list.
				_tokens.push( token );
				// Execute to move in.
				token.execute( MenuHistoryTokenDirectionEnum.FORWARD );
			}
		}
		
		/**
		 * Moves forward in history based on cursor on menu panel stack. 
		 * @return Boolean Flag for being able to move forward.
		 */
		public function next():Boolean
		{
			var token:MenuHistoryToken = getNewToken( _cursor + 1 );
			if( token )
			{
				previousToken().execute( MenuHistoryTokenDirectionEnum.BACKWARD );
				_tokens[_tokens.length] = token;
				token.execute( MenuHistoryTokenDirectionEnum.FORWARD );
			}
			return token != null;
		}
		
		/**
		 * Moves backward in history based on cursor on menu panel stack. 
		 * @return Boolean Flag for being able to move backward.
		 */
		public function previous():Boolean
		{
			var token:MenuHistoryToken = removeLastToken();
			if( token )
			{
				// If we could remove from top of token list, move cursor back.
				--_cursor;
				// Then execute the transition in and out of last in history and second to last of history.
				token.execute( MenuHistoryTokenDirectionEnum.BACKWARD );
				var previousToken:MenuHistoryToken = previousToken();
				if( previousToken ) previousToken.execute( MenuHistoryTokenDirectionEnum.FORWARD );
			}
			return token != null;
		}
		
		/**
		 * Ends the history session.
		 */
		public function end():void
		{
			// Remove and transition the last held token in history.
			var token:MenuHistoryToken = removeLastToken();
			token.execute( MenuHistoryTokenDirectionEnum.BACKWARD );
			// Empty token history.
			while( _tokens.length > 0 )
				removeLastToken();
			// Move cursor back to front.
			_cursor = -1;
		}
		
		/**
		 * Restarts the history.
		 */
		public function restart():void
		{
			// Clear history.
			end();
			// Refresh display starting at first cursor.
			start( _targetContainer, _origin );
		}
		
		/**
		 * Returns the cursor position within the menu panel stack that is used to base history progression. 
		 * @return int
		 */
		public function get cursor():int
		{
			return _cursor;
		}
		
		/**
		 * Returns the length of history in the session. 
		 * @return int A value of 0 reveals that the history has been depleted, as is the case in moving back all the way or ending.
		 */
		public function get length():int
		{
			return _tokens.length;
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		public function dispose():void
		{
			_stack = null;
			_delegate = null;
			
			_tokenPool.dispose();
			_tokenPool = null;
			
			_behaviourPool.dispose();
			_behaviourPool = null;
		}
		
		/**
		 * Accessor/Modifier for the list of IMenuPanelDisplay instances to transition in and out of view based on history progression. 
		 * @return Vector.<IMenuPanelDisplay>
		 */
		public function get stack():Vector.<IMenuPanelDisplay>
		{
			return _stack;
		}
		public function set stack(value:Vector.<IMenuPanelDisplay>):void
		{
			_stack = value;
		}
		
		/**
		 * Accessor/Modifier for the behaviour type to manage the transitioning of menu panels in and out of display on the traget display container. 
		 * @return String Fully-qualified classname
		 */
		public function get behaviourType():String
		{
			return _behaviourType;
		}
		public function set behaviourType(value:String):void
		{
			if( _behaviourType == value ) return;
			
			_behaviourType = value;
			resetBehaviourPool();
		}

		/**
		 * Accessor/Modifier for the client to notify upon transition of menu panels in and out of the display 
		 * @return IMenuBehaviourDelegate
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