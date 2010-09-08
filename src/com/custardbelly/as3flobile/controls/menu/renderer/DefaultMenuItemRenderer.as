/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: DefaultMenuItemRenderer.as</p>
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
package com.custardbelly.as3flobile.controls.menu.renderer
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.menu.MenuItem;
	import com.custardbelly.as3flobile.helper.ITapMediator;
	import com.custardbelly.as3flobile.helper.MouseTapMediator;
	import com.custardbelly.as3flobile.skin.MenuItemRendererSkin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * DefaultMenuItemRenderer is the base menu item renderer display for a MenuItem from the model of a Menu control. 
	 * @author toddanderson
	 */
	public class DefaultMenuItemRenderer extends AS3FlobileComponent implements IMenuItemRenderer
	{
		protected var _title:Label;
		protected var _iconDisplay:Bitmap;
		
		protected var _iconLoader:Loader;
		
		protected var _tapMediator:ITapMediator;
		protected var _delegate:IMenuItemSelectionDelegate;
		protected var _data:MenuItem;
		
		/**
		 * Constructor.
		 */
		public function DefaultMenuItemRenderer() 
		{ 
			super();
			mouseChildren = false;
			_tapMediator = new MouseTapMediator();
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			// Update padding.
			updatePadding( 3, 3, 3, 3 );
			
			// Default skin.
			_skin = new MenuItemRendererSkin();
			_skin.target = this;
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// Default displays a single label.
			_title = new Label();
			_title.autosize = true;
			_title.multiline = false;
			addChild( _title );
		}
		
		/**
		 * @private
		 * 
		 * Validates the ITapMediator instance used in deiscovering a tap gestue on this control. 
		 * @param newValue ITapMediator
		 */
		protected function invalidateTapMediator( newValue:ITapMediator ):void
		{
			// Clear out mediation on old ITapMediator instance if currently mediating.
			if( _tapMediator && _tapMediator.isMediating( this ) )
				_tapMediator.unmediateTapGesture( this );
			
			// Set new ITapMediator instance reference.
			_tapMediator = newValue;
			// Start mediating if we are on the display list.
			if( isActiveOnDisplayList() )
				_tapMediator.mediateTapGesture( this, handleTap );
		}
		
		/**
		 * @private 
		 * 
		 * Validates the model for this display.
		 */
		protected function invalidateData():void
		{
			// Update label from model.
			_title.text = _data.title;
			
			// Update icon from model.
			if( _iconDisplay && contains( _iconDisplay ) )
				removeChild( _iconDisplay );
			
			// Determine if an update to the display is based on an async operation, such as in the case of loading an image.
			var asyncDisplay:Boolean = !addIconDisplay( _data.icon );
			if( !asyncDisplay ) updateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Adds an icon display to this item renderer. Determines if the operation is an async operation. 
		 * @param icon Object The icon to display. Can be a DisplayObject or a String. If String type, defaulted as a url for the icon.
		 * @return Boolean Flag determining if the icon should be added through an async operation, such as loading an icon from a url.
		 */
		protected function addIconDisplay( icon:Object ):Boolean
		{
			var isAsyncDisplay:Boolean;
			// Stop previous load.
			stopIconLoad();
			
			// If a DisplayObject type, just add to display.
			if( icon is DisplayObject )
			{
				// If no icon loader, create a new bitmap.
				if( _iconDisplay == null )
					_iconDisplay = new Bitmap();
				// If bitmap data is associated with icon loader, dispose of it.
				if( _iconDisplay.bitmapData != null ) 
					_iconDisplay.bitmapData.dispose();
				// Make copy of icon.
				_iconDisplay.bitmapData = new BitmapData( ( icon as DisplayObject ).width, ( icon as DisplayObject ).height, true, 0xFF );
				_iconDisplay.bitmapData.draw( icon as DisplayObject );
				addChild( _iconDisplay );
			}
			// If String type, load the icon.
			else if( icon is String )
			{
				startIconLoad( icon as String );
				isAsyncDisplay = true;
			}
			// Return flag.
			return isAsyncDisplay;
		}
		
		/**
		 * @private
		 * 
		 * Starts the loading of an icon through an async operation from a url. 
		 * @param url String
		 */
		protected function startIconLoad( url:String ):void
		{
			if( _iconLoader == null )
			{
				_iconLoader = new Loader();
				_iconLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleIconLoadComplete, false, 0, true );
				_iconLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, handleIconLoadError, false, 0, true );
			}
			_iconLoader.unloadAndStop();
			_iconLoader.load( new URLRequest( url ) );
		}
		
		/**
		 * @private 
		 * 
		 * Stops the loading of an icon from an async operation.
		 */
		protected function stopIconLoad():void
		{
			if( _iconLoader != null )
				_iconLoader.unloadAndStop();
		}
		
		/**
		 * @inherit
		 */
		override protected function addDisplayHandlers():void
		{
			super.addDisplayHandlers();
			if( !_tapMediator.isMediating( this ) ) _tapMediator.mediateTapGesture( this, handleTap );
		}
		
		/**
		 * @inherit
		 */
		override protected function removeDisplayHandlers():void
		{
			super.removeDisplayHandlers();
			if( _tapMediator.isMediating( this ) ) _tapMediator.unmediateTapGesture( this );
		}
		
		/**
		 * @private
		 * 
		 * Event handle for click detection on label display. 
		 * @param evt Event
		 */
		protected function handleTap( evt:Event ):void
		{
			if( _delegate ) _delegate.menuItemSelected( _data, this );
		}
		
		protected function handleIconLoadComplete( evt:Event ):void
		{
			var bitmap:Bitmap = ( evt.target as LoaderInfo ).content as Bitmap;
			_iconDisplay = bitmap;
			addChild( _iconDisplay );
			
			updateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Event handler for error in loading icon from async operation. 
		 * @param evt IOErrorEvent
		 */
		protected function handleIconLoadError( evt:IOErrorEvent ):void
		{
			// Gracefully fail, but notify developer through trace.
			trace( "[" + getQualifiedClassName( this ) + "] :: Error loading icon for menu item...\n" + evt.text );
			updateDisplay();
		}
		
		/**
		 * Returns the reference to the background display. 
		 * @return Graphics
		 */
		public function get backgroundDisplay():Graphics
		{
			return graphics;
		}
		
		/**
		 * Returns the reference to the Label display. 
		 * @return Label
		 */
		public function get titleDisplay():Label
		{
			return _title;
		}
		
		/**
		 * Returns the reference to the icon display. 
		 * @return DisplayObject
		 */
		public function get iconDisplay():DisplayObject
		{
			return _iconDisplay;
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			// Remove all children.
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			// Close down icon loader.
			if( _iconLoader )
			{
				stopIconLoad();
				_iconLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, handleIconLoadComplete, false );
				_iconLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, handleIconLoadError, false );
				_iconLoader = null;
			}
			
			// Dispose of title label.
			_title.dispose();
			_title = null;
			
			// Dispose of icon display if AS3FlobileComponent.
			if( _iconDisplay is AS3FlobileComponent )
			{
				( _iconDisplay as AS3FlobileComponent ).dispose();
			}
			
			// Kill tap mediator.
			if( _tapMediator && _tapMediator.isMediating( this ) )
				_tapMediator.unmediateTapGesture( this );
			
			// Null references.
			_delegate = null;
			_tapMediator = null;
		}
		
		/**
		 * Accessor/Modifier for the mediating tap manager. 
		 * @return ITapMediator
		 */
		public function get tapMediator():ITapMediator
		{
			return _tapMediator;
		}
		public function set tapMediator(value:ITapMediator):void
		{
			if( _tapMediator == value ) return;
			
			invalidateTapMediator( value );
		}
		
		/**
		 * Accessor/Modifier for the client request notification on selection of this instance. 
		 * @return IMenuItemSelectionDelegate
		 */
		public function get delegate():IMenuItemSelectionDelegate
		{
			return _delegate;
		}
		public function set delegate(value:IMenuItemSelectionDelegate):void
		{
			_delegate = value;
		}
		
		/**
		 * Accessor/Modifier for the model to be represented. 
		 * @return MenuItem
		 */
		public function get data():MenuItem
		{
			return _data;
		}
		public function set data( value:MenuItem ):void
		{
			if( _data == value ) return;
			
			_data = value;
			invalidateData();
		}
	}
}