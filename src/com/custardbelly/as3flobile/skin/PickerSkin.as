/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: PickerSkin.as</p>
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
package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
	import com.custardbelly.as3flobile.controls.picker.Picker;
	import com.custardbelly.as3flobile.controls.picker.PickerColumn;
	import com.custardbelly.as3flobile.model.BoxPadding;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * PickerSkin is a base skin for a Picker control. 
	 * @author toddanderson
	 */
	public class PickerSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function PickerSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Performs initialization on the background display of target. 
		 * @param display Graphics
		 * @param width int
		 * @param height int
		 */
		protected function initializeBackground( display:Graphics, width:int, height:int ):void
		{
			updateBackground( display, width, height );	
		}
		
		/**
		 * @private
		 * 
		 * Performs initialization on the selection bar display of target. 
		 * @param display Shape
		 * @param barHeight int
		 * @param width int
		 * @param height int
		 */
		protected function initializeSelectionBar( display:Shape, barHeight:int, width:int, height:int ):void
		{
			updateSelectionBar( display, barHeight, width, height );
		}
		
		/**
		 * @private
		 * 
		 * Updates the background display for the target. 
		 * @param display Graphics
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			display.clear();
			display.beginFill( 0x999999 );
			display.lineStyle( 2, 0x666666, 1, true, "normal", "square", "miter" );
			display.drawRect( 0, 0, width, height );
			display.endFill();
		}
		
		/**
		 * @private
		 * 
		 * Updates the selection bar dipslay of the target. 
		 * @param display Shape
		 * @param barHeight int
		 * @param width int
		 * @param height int
		 */
		protected function updateSelectionBar( display:Shape, barHeight:int, width:int, height:int ):void
		{
			display.graphics.clear();
			display.graphics.beginFill( 0xFF7F00, 0.3 );
			display.graphics.drawRect( 0, 0, width, barHeight );
			display.graphics.endFill();
			display.graphics.lineStyle( 1, 0xFF7F00, 1, true, "normal", "square", "miter" );
			display.graphics.moveTo( width - 1, 1 );
			display.graphics.lineTo( width - 1, barHeight - 1 );
			display.graphics.lineTo( 1, barHeight - 1 );
			display.graphics.lineStyle( 2, 0xFF7F00, 0.5, true, "normal", "square", "miter" );
			display.graphics.moveTo( 1, barHeight - 1 );
			display.graphics.lineTo( 1, 1 );
			display.graphics.lineTo( width - 1, 1 );
		}
		
		/**
		 * @private
		 * 
		 * Positions the skinnable displays within the target control. 
		 * @param width int
		 * @param height int
		 */
		protected function updatePosition( width:int, height:int ):void
		{
			var padding:BoxPadding = _target.padding;
			var horizPadding:int = padding.left + padding.right;
			var vertPadding:int = padding.top + padding.bottom;
			
			var pickerTarget:Picker = ( _target as Picker );
			var selectionBar:DisplayObject = pickerTarget.selectionBarDisplay;
			var columnSeperator:int = pickerTarget.columnSeperatorLength;
			var columnPickerWidths:Vector.<Number> = pickerTarget.columnWidths;
			var columnLists:Vector.<IScrollListContainer> = pickerTarget.columnLists;
			var itemHeight:int = pickerTarget.itemHeight;
			
			// Position selection bar in the middle of the target.
			selectionBar.y = ( height - selectionBar.height ) * 0.5;
			
			// Find the available percentage dimensions for column lists based on theri specified width and the alloted width fo the target.
			var i:int;
			var length:int = columnPickerWidths.length;
			var availableWidth:Number = ( width - horizPadding ) - ( ( length - 1 ) * columnSeperator );
			var columnAmountForPercentage:int = columnLists.length;
			var columnWidth:Number;
			// Remove available width from defined column widths.
			for( i = 0; i < length; i++ )
			{
				columnWidth = columnPickerWidths[i];
				if( !isNaN( columnWidth ) ) 
				{
					availableWidth -= columnWidth;
					columnAmountForPercentage--;
				}
			}
			// Update the column widths with the available and defined widths.
			var percentageWidth:int = ( availableWidth > 0 ) ? ( availableWidth / columnAmountForPercentage ) : 0;
			var columnList:DisplayObject;
			var xpos:int = padding.left;
			length = columnLists.length;
			for( i = 0; i < length; i++ )
			{
				columnList = columnLists[i] as DisplayObject;
				columnWidth = columnPickerWidths[i];
				columnList.width = ( isNaN( columnWidth ) ) ? percentageWidth : columnWidth;
				columnList.height = height - vertPadding;
				columnList.x = xpos;
				columnList.y = padding.top;
				xpos += columnList.width + columnSeperator;
			}
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var pickerTarget:Picker = ( _target as Picker );
			initializeBackground( pickerTarget.backgroundDisplay, width, height );
			initializeSelectionBar( pickerTarget.selectionBarDisplay, pickerTarget.itemHeight, width, height );
			updatePosition( width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var pickerTarget:Picker = ( _target as Picker );
			updateBackground( pickerTarget.backgroundDisplay, width, height );
			updateSelectionBar( pickerTarget.selectionBarDisplay, pickerTarget.itemHeight, width, height );
			updatePosition( width, height );
		}
	}
}