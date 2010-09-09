/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: MenuPanelSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.menu.panel.IMenuPanelDisplay;
	import com.custardbelly.as3flobile.model.BoxPadding;
	
	import flash.display.Graphics;

	/**
	 * MenuPanelSkin is the base skin for the main menu submenu in a composite Menu control. 
	 * @author toddanderson
	 */
	public class MenuPanelSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function MenuPanelSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Updates the background display of the target IMenuPanelDisplay. 
		 * @param display Graphics
		 * @param width int
		 * @param height int
		 */
		protected function updateBackgroundDisplay( display:Graphics, width:int, height:int ):void
		{
			var panelTarget:IMenuPanelDisplay = ( _target as IMenuPanelDisplay );
			var padding:BoxPadding = _target.padding;
			
			const lineSize:int = 2;
			display.clear();
			display.lineStyle( lineSize, 0xAAAAAA, 1, true, "norma", "square", "miter" );
			display.beginFill( 0xFFFFFF );
			display.drawRect( padding.left, padding.top, width - ( padding.left + padding.right ), height );
			display.endFill();
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var panelTarget:IMenuPanelDisplay = ( _target as IMenuPanelDisplay );
			var background:Graphics = panelTarget.backgroundDisplay;
			updateBackgroundDisplay( background, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var panelTarget:IMenuPanelDisplay = ( _target as IMenuPanelDisplay );
			var background:Graphics = panelTarget.backgroundDisplay;
			updateBackgroundDisplay( background, width, height );
		}
	}
}