/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: PickerColumnVerticalLayout.as</p>
 * <p>Version: 0.3</p>
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
package com.custardbelly.as3flobile.controls.picker.layout
{
	import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
	import com.custardbelly.as3flobile.controls.list.IScrollListLayoutTarget;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * PickerColumnVerticalLayout is a ScrollListVericalLayout extension to display empty renderers in the box padding of a scroll list target.  
	 * @author toddanderson
	 */
	public class PickerColumnVerticalLayout extends ScrollListVerticalLayout
	{
		protected var _topPaddingRenderer:IScrollListItemRenderer;
		protected var _bottomPaddingRenderer:IScrollListItemRenderer;
		
		/**
		 * Constructor.
		 */
		public function PickerColumnVerticalLayout() { super(); }
		
		/**
		 * @private
		 * 
		 * Factory method to create the IScrollListItemRenderer instance based on the item renderer class. 
		 * @return IScrollListItemRenderer
		 */
		protected function createPaddingRenderer( itemRenderer:String ):IScrollListItemRenderer
		{
			var rendererClass:Class = getDefinitionByName( itemRenderer ) as Class;
			var renderer:IScrollListItemRenderer = new rendererClass() as IScrollListItemRenderer;
			return renderer;
		}
		
		/**
		 * @private 
		 * 
		 * Updates false renderer displays in the padding space within the target scroll list.
		 */
		protected function updatePaddingRenderers():void
		{
			var rect:Rectangle = _target.scrollBounds;
			// If we don't have a top padding renderer, create one and add it to the target.
			if( _topPaddingRenderer == null )
			{
				_topPaddingRenderer = createPaddingRenderer( _target.itemRenderer );
			}
			_topPaddingRenderer.height = _padding.top;
			_topPaddingRenderer.width = rect.width;
			( _topPaddingRenderer as DisplayObject ).y = 0;
			
			// If we dont' have a bottom padding renderer, create one and add it to the target.
			if( _bottomPaddingRenderer == null )
			{
				_bottomPaddingRenderer = createPaddingRenderer( _target.itemRenderer );
				( _target as IScrollListLayoutTarget ).addRendererToDisplay( _bottomPaddingRenderer );
			}
			_bottomPaddingRenderer.height = padding.bottom;
			_bottomPaddingRenderer.width = rect.width;
			( _bottomPaddingRenderer as DisplayObject ).y = _contentHeight - _bottomPaddingRenderer.height;
			
			updatePaddingRenderersExistance();
		}
		
		/**
		 * @private 
		 * 
		 * Determines the validaity of having the paddins renderers on the dipslay list of the target scroll list.
		 */
		protected function updatePaddingRenderersExistance():void
		{
			var requiresTopPadding:Boolean = padding.top > 0;
			var requiresBottomPadding:Boolean = padding.bottom > 0;
			// Determine existance of top padding on target scroll list.
			if( requiresTopPadding )
			{
				( _target as IScrollListLayoutTarget ).addRendererToDisplay( _topPaddingRenderer );
			}
			else
			{
				( _target as IScrollListLayoutTarget ).removeRendererFromDisplay( _topPaddingRenderer );
			}
			// Determine existance of bottom padding on target scroll list.
			if( requiresBottomPadding )
			{
				( _target as IScrollListLayoutTarget ).addRendererToDisplay( _bottomPaddingRenderer );
			}
			else
			{
				( _target as IScrollListLayoutTarget ).removeRendererFromDisplay( _bottomPaddingRenderer );
			}
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay():void
		{
			super.updateDisplay();
			updatePaddingRenderers();
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			_topPaddingRenderer = null;
			_bottomPaddingRenderer = null;
		}
	}
}