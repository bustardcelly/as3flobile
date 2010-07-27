/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollViewport.as</p>
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
package com.custardbelly.as3flobile.controls.viewport
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.viewport.context.BaseScrollViewportStrategy;
	import com.custardbelly.as3flobile.controls.viewport.context.IScrollViewportContext;
	import com.custardbelly.as3flobile.controls.viewport.context.ScrollViewportMouseContext;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ScrollViewport is an IScrollViewport implementation that acts as a scrollable display container.
	 * @author toddanderson
	 */
	public class ScrollViewport extends AS3FlobileComponent implements IScrollViewport
	{
		protected var _bounds:Rectangle;
		protected var _content:InteractiveObject;
		protected var _context:IScrollViewportContext;
		protected var _delegate:IScrollViewportDelegate;
		
		/**
		 * Constructor.
		 */
		public function ScrollViewport()
		{	
			_width = 100;
			_height = 100;
			context = getDefaultViewportContext();
			scrollRect = new Rectangle( 0, 0, _width, _height );
			initialize();
		}
		
		/**
		 * Utility factory method for ease of creation with initialization properties. 
		 * @param bounds Rectangle The rectangular viewport area.
		 * @param delegate IScrollViewportDelegate The delegate to notify on changein action.
		 * @return ScrollViewport
		 */
		public static function initWithScrollRectAndDelegate( bounds:Rectangle, delegate:IScrollViewportDelegate = null ):ScrollViewport
		{
			var viewport:ScrollViewport = new ScrollViewport();
			viewport.scrollRect = bounds;
			viewport.delegate = delegate;
			return viewport;
		}
		
		/**
		 * @private 
		 * 
		 * Performs initialization operations.
		 */
		protected function initialize():void
		{
			_bounds = new Rectangle( 0, 0, _width, _height );
			addHandlers();
		}
		
		/**
		 * @private
		 * 
		 * Factory method to return the default IScrollViewportContext. 
		 * @return IScrollViewportContext
		 */
		protected function getDefaultViewportContext():IScrollViewportContext
		{
			return new ScrollViewportMouseContext( new BaseScrollViewportStrategy() );
		}
		
		/**
		 * @private 
		 * 
		 * Adds event handlers for addition and removal from parent display list.
		 */
		protected function addHandlers():void
		{
			addEventListener( Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event handlers.
		 */
		protected function removeHandlers():void
		{
			removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage, false );
			removeEventListener( Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false );
		}
		
		/**
		 * @private 
		 * 
		 * Validate the size of the scrollable viewport area.
		 */
		override protected function invalidateSize():void
		{
			_bounds.width = _width;
			_bounds.height = _height;
			this.scrollRect = _bounds;
			invalidateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the display.
		 */
		protected function invalidateDisplay():void
		{
			_context.update();
		}
		
		/**
		 * @private
		 * 
		 * Validates the IScrollViewportContext used in managing user action and strategy operations. 
		 * @param oldContext IScrollViewportContext
		 * @param newContext IScrollViewportContext
		 */
		protected function invalidateContext( oldContext:IScrollViewportContext, newContext:IScrollViewportContext ):void
		{
			if( oldContext ) oldContext.dispose();
			
			_context = newContext;
			_context.initialize( this );
			
			if( isOnDisplayList() )
				_context.activate();
		}
		
		/**
		 * @private
		 * 
		 * Event handler for being added to the display list of parent. 
		 * @param evt Event
		 */
		protected function handleAddedToStage( evt:Event ):void
		{
			if( _context )
				_context.activate();
		}
		
		/**
		 * @private
		 * 
		 * Event handler for being removed from the display list of the parent. 
		 * @param evt Event
		 */
		protected function handleRemovedFromStage( evt:Event ):void
		{
			if( _context )
				_context.deactivate();
		}
		
		/**
		 * @private
		 * 
		 * Adds the content to the scrollable viewport. 
		 * @param display DisplayObject
		 */
		protected function addContent( display:DisplayObject ):void
		{
			if( !contains( display ) )
				addChild( display );
		}
		
		/**
		 * @private
		 * 
		 * Removes the content from the scrollable viewport. 
		 * @param display DisplayObject
		 */
		protected function removeContent( display:DisplayObject ):void
		{
			if( contains( display ) )
				removeChild( display );
		}
		
		/**
		 * @private
		 * 
		 * Returns flag of this instance being on a display list. 
		 * @return Boolean
		 */
		protected function isOnDisplayList():Boolean
		{
			return stage != null;
		}
		
		/**
		 * @copy IScrollViewport#refresh()
		 */
		public function refresh():void
		{
			if( _content )
			{
				_content.x = _content.y = 0;
			}
			_context.update();
		}
		
		/**
		 * @copy IScrollViewport#dispose()
		 */
		public function dispose():void
		{
			removeHandlers();
			
			_context.dispose();
			_context = null;
			
			_delegate = null;
		}
		
		/**
		 * @copy IScrollViewport#scrollBounds
		 */
		public function get scrollBounds():Rectangle
		{
			return _bounds;
		}
		
		/**
		 * @copy IScrollViewport#content
		 */
		public function get content():InteractiveObject
		{
			return _content;
		}
		public function set content( value:InteractiveObject ):void
		{
			if( _content != null ) removeContent( _content );
			
			_content = value;
			addContent( value );
			invalidateDisplay();
		}
		
		/**
		 * @copy IScrollViewport#context
		 */
		public function get context():IScrollViewportContext
		{
			return _context;
		}
		public function set context( value:IScrollViewportContext ):void
		{
			if( _context == value ) return;
			
			invalidateContext( _context, value );
		}
		
		/**
		 * @copy IScrollViewport#delegate
		 */
		public function get delegate():IScrollViewportDelegate
		{
			return _delegate;
		}
		public function set delegate( value:IScrollViewportDelegate ):void
		{
			if( _delegate == value ) return;
			
			_delegate = value;
			invalidateDisplay();
		}
	}
}