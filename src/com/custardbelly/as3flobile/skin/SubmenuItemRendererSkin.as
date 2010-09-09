/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: SubmenuItemRendererSkin.as</p>
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
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;

	/**
	 * SubmenuItemRendererSkin is an extension of MenuItemRendererSkin to customize the layout of display elements in an IMenuItemRenderer 
	 * @author toddanderson
	 */
	public class SubmenuItemRendererSkin extends MenuItemRendererSkin
	{
		/**
		 * Constructor.
		 */
		public function SubmenuItemRendererSkin() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function updateBackground( display:Graphics, width:Number, height:int ):void
		{	
			display.clear();
			display.beginFill( 0xFFFFFF );
			display.drawRoundRect( 0, 0, width, height, 10, 10 );
			display.endFill();
		}
		
		/**
		 * @inherit
		 */
		override protected function updatePosition( width:Number, height:int ):void
		{
			const labelOffset:int = 10;
			var itemTarget:IMenuItemRenderer = ( _target as IMenuItemRenderer );
			var title:Label = itemTarget.titleDisplay;
			var icon:DisplayObject = itemTarget.iconDisplay;
			
			var xposition:int = itemTarget.padding.left;
			if( icon != null )
			{
				icon.x = itemTarget.padding.left;
				icon.y = ( height - icon.height ) * 0.5;
				xposition = icon.x + icon.width + labelOffset;
			}
			
			title.x = xposition;
			title.y = ( height - title.height ) * 0.5;
		}
	}
}