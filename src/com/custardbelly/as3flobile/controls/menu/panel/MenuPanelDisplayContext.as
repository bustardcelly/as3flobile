/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MenuPanelDisplayContext.as</p>
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
package com.custardbelly.as3flobile.controls.menu.panel
{
	import com.custardbelly.as3flobile.controls.menu.layout.IMenuLayout;
	import com.custardbelly.as3flobile.controls.menu.renderer.IMenuItemRenderer;
	import com.custardbelly.as3flobile.skin.ISkin;
	import com.custardbelly.as3flobile.util.IObjectPool;
	import com.custardbelly.as3flobile.util.ObjectPool;

	/**
	 * MenuPanelDisplayContext represents a model for configuration of an IMenuPanelDisplay instance. 
	 * By extending IObjectPool, this model also acts as a factory for creating new instances based on configuration properties. 
	 * @author toddanderson
	 */
	public class MenuPanelDisplayContext implements IObjectPool
	{
		protected var _menuPanelType:String;
		protected var _layoutType:String;
		protected var _skinType:String;
		protected var _itemRendererType:String;
		protected var _itemRendererSkinType:String;
		
		protected var _panelPool:IObjectPool;
		protected var _layoutPool:IObjectPool;
		protected var _skinPool:IObjectPool;
		
		/**
		 * Constructor. 
		 * @param menuPanelType String The fully-qualified classname of the IMenuPanelDisplay implementation.
		 */
		public function MenuPanelDisplayContext( menuPanelType:String )
		{
			this.menuPanelType = menuPanelType;
		}
		
		/**
		 * Returns a new instance of the IMenuPanelDisplay implementation with defined properties updated. 
		 * @param initProperties Object
		 * @return Object
		 */
		public function getInstance( initProperties:Object = null ):Object
		{
			var menuPanel:IMenuPanelDisplay = _panelPool.getInstance() as IMenuPanelDisplay;
			if( _skinPool ) menuPanel.skin = _skinPool.getInstance() as ISkin;
			if( _layoutPool ) menuPanel.layout = _layoutPool.getInstance() as IMenuLayout;
			if( _itemRendererType ) menuPanel.itemRenderer = _itemRendererType;
			if( _itemRendererSkinType ) menuPanel.itemRendererSkin = _itemRendererSkinType;
			return menuPanel;
		}
		
		/**
		 * Returns the specified instance back into an internal pool for re-use. 
		 * @param value Object An IMediaPanelDisplay object
		 */
		public function returnInstance( value:Object ):void
		{
			if( !(value is IMenuPanelDisplay) ) return;
			
			if( _skinPool ) _skinPool.returnInstance( value.skin );
			if( _layoutPool ) _layoutPool.returnInstance( value.layout );
			_panelPool.returnInstance( value );
		}
		
		/**
		 * @copy IObjectPool#length()
		 */
		public function length():int
		{
			return _panelPool.length();
		}
		
		/**
		 * @copy IObjectPool#flush()
		 */
		public function flush():void
		{
			_panelPool.flush();
			if( _skinPool ) _skinPool.flush();
			if( _layoutPool ) _layoutPool.flush();
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		public function dispose():void
		{
			_panelPool.dispose();
			_panelPool = null;
			if( _skinPool )
			{
				_skinPool.dispose();
				_skinPool = null;
			}
			if( _layoutPool )
			{
				_layoutPool.dispose();
				_layoutPool = null;
			}
		}
		
		/**
		 * Returns flag of speficied configuration properties equaling those held on this instance. 
		 * @param configuration MenuPanelDisplayContext
		 * @return Boolean
		 */
		public function isEqual( configuration:MenuPanelDisplayContext ):Boolean
		{
			return	( configuration.menuPanelType == _menuPanelType ) &&
					( configuration.layoutType == _layoutType ) &&
					( configuration.skinType == _skinType ) &&
					( configuration.itemRendererType == _itemRendererType ) &&
					( configuration.itemRendererSkinType == _itemRendererSkinType );
		}
		
		/**
		 * Accessor/Modifier for the fully-qualified classname of the IMediaPanelDisplay implementation. 
		 * @return String
		 */
		public function get menuPanelType():String
		{
			return _menuPanelType;
		}
		public function set menuPanelType(value:String):void
		{
			if( _menuPanelType == value ) return;
			
			_menuPanelType = value;
			
			if( _panelPool != null ) _panelPool.flush();
			_panelPool = new ObjectPool( _menuPanelType );
		}

		/**
		 * Accessor/Modifier for the full-qualified classname of the IMenuLayout implementation. 
		 * @return String
		 */
		public function get layoutType():String
		{
			return _layoutType;
		}
		public function set layoutType(value:String):void
		{
			if( _layoutType == value ) return;
			
			_layoutType = value;
			if( _layoutPool != null ) _layoutPool.flush();
			_layoutPool = new ObjectPool( _layoutType );
		}

		/**
		 * Accessor/Modifier for the fully-qualified classname of the ISkin implementation. 
		 * @return String
		 */
		public function get skinType():String
		{
			return _skinType;
		}
		public function set skinType(value:String):void
		{
			if( _skinType == value ) return;
			
			_skinType = value;
			if( _skinPool != null ) _skinPool.flush();
			_skinPool = new ObjectPool( _skinType );
		}

		/**
		 * Accessor/Modifier for the fully-qualified classname of the IMenuItemRenderer implementation. 
		 * @return String
		 */
		public function get itemRendererType():String
		{
			return _itemRendererType;
		}
		public function set itemRendererType(value:String):void
		{
			_itemRendererType = value;
		}

		/**
		 * Accessor/Modifier for the fully-qualified classname of the ISkin implementation to be applied to the item renderer. 
		 * @return String
		 */
		public function get itemRendererSkinType():String
		{
			return _itemRendererSkinType;
		}
		public function set itemRendererSkinType(value:String):void
		{
			_itemRendererSkinType = value;
		}
	}
}