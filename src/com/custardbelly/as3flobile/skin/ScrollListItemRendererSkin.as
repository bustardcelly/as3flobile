/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollListItemRendererSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.list.renderer.DefaultScrollListItemRenderer;
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.model.BoxPadding;
	
	import flash.display.Graphics;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;

	/**
	 * ScrollListItemRendererSkin is the base class for skinning a DefaultScrollListItemRenderer control. 
	 * @author toddanderson
	 */
	public class ScrollListItemRendererSkin extends Skin
	{
		protected var _defaultLabelFormat:ElementFormat;
		
		/**
		 * Constructor.
		 */
		public function ScrollListItemRendererSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Returns default ElementFormat instance to apply the label display of the target item renderer. 
		 * @return ElementFormat
		 */
		protected function getDefaultFormat():ElementFormat
		{
			if( _defaultLabelFormat == null )
			{
				_defaultLabelFormat = new ElementFormat( new FontDescription( "DroidSans" ) );
				_defaultLabelFormat.fontSize = 14;
			}
			return _defaultLabelFormat;
		}
		
		/**
		 * @private
		 * 
		 * Updates the graphical display of the background of the item renderer. 
		 * @param display Graphics
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			var isSelected:Boolean = ( _target.skinState == BasicStateEnum.SELECTED );
			display.clear();
			display.beginFill( ( isSelected ) ? 0xDDDDDD : 0xFFFFFF );
			display.drawRect( 0, 0, width, height );
			display.endFill();
		}
		
		/**
		 * @private
		 * 
		 * Updates the label display of the item renderer. 
		 * @param display Label
		 * @param width int
		 * @param height int
		 */
		protected function updateLabel( display:Label, width:int, height:int ):void
		{
			var format:ElementFormat = getDefaultFormat();
			display.format = format;
		}
		
		protected function updatePosition( width:int, height:int ):void
		{
			var itemTarget:IScrollListItemRenderer = ( _target as IScrollListItemRenderer );
			var padding:BoxPadding = _target.padding;
			(itemTarget as DefaultScrollListItemRenderer).labelDisplay.x = padding.left;
			(itemTarget as DefaultScrollListItemRenderer).labelDisplay.y = padding.top;
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var itemTarget:IScrollListItemRenderer = ( _target as IScrollListItemRenderer );
			updateBackground( itemTarget.backgroundDisplay, width, height );
			updateLabel( (itemTarget as DefaultScrollListItemRenderer).labelDisplay, width, height );
			updatePosition( width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var itemTarget:IScrollListItemRenderer = ( _target as IScrollListItemRenderer );
			updateBackground( itemTarget.backgroundDisplay, width, height );
			updateLabel( (itemTarget as DefaultScrollListItemRenderer).labelDisplay, width, height );
			updatePosition( width, height );
		}
	}
}