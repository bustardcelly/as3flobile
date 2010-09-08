/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MenuItemRendererSkin.as</p>
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
package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.menu.renderer.IMenuItemRenderer;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;

	/**
	 * MenuItemRendererSkin is a default skin for menu item display of a Menu control. 
	 * @author toddanderson
	 */
	public class MenuItemRendererSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function MenuItemRendererSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Updates the background display of the skin target. 
		 * @param display Graphics
		 * @param width Number
		 * @param height int
		 */
		protected function updateBackground( display:Graphics, width:Number, height:int ):void
		{	
			const offset:int = 1;
			const padding:int = 2;
			display.clear();
			display.beginFill( 0xAAAAAA );
			display.drawRect( -offset, -offset, width + offset, height + offset );
			display.beginFill( 0xEEEEEE );
			display.drawRect( offset, offset, width - padding - offset, height - padding - offset );
			display.endFill();
		}
		
		/**
		 * @private
		 * 
		 * Updates the label display of the skin target. 
		 * @param display Label
		 * @param width Number
		 * @param height int
		 */
		protected function updateLabel( display:Label, width:Number, height:int ):void
		{
			// using default ElementFormat on Label instance.
		}
		
		/**
		 * @private
		 * 
		 * Updates the position of graphic displays within the skin target. 
		 * @param width Number
		 * @param height int
		 */
		protected function updatePosition( width:Number, height:int ):void
		{
			var itemTarget:IMenuItemRenderer = ( _target as IMenuItemRenderer );
			var title:Label = itemTarget.titleDisplay;
			var icon:DisplayObject = itemTarget.iconDisplay;
			
			title.x = ( width - title.width ) * 0.5;
			title.y = ( icon ) ? ( height - title.height - itemTarget.padding.bottom ) : ( height - title.height ) * 0.5;
			
			if( icon != null )
			{
				icon.x = ( width - icon.width ) * 0.5;
				icon.y = ( ( title.y + itemTarget.padding.top ) - icon.height ) * 0.5;
			}
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var itemTarget:IMenuItemRenderer = ( _target as IMenuItemRenderer );
			var w:Number = itemTarget.width;
			// Passing in raw width to get accurate sizing of menu item.
			updateBackground( itemTarget.backgroundDisplay, w, height );
			updateLabel( itemTarget.titleDisplay, w, height );
			updatePosition( w, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var itemTarget:IMenuItemRenderer = ( _target as IMenuItemRenderer );
			// Passing in raw width to get accurate sizing of menu item.
			var w:Number = itemTarget.width;
			updateBackground( itemTarget.backgroundDisplay, w, height );
			updateLabel( itemTarget.titleDisplay, w, height );
			updatePosition( w, height );
		}
	}
}