/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: DropDownSkin.as</p>
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
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.dropdown.DropDown;
	import com.custardbelly.as3flobile.controls.list.ScrollList;

	/**
	 * DropDownSkin is a base class for skinning a DropDown control. 
	 * @author toddanderson
	 */
	public class DropDownSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function DropDownSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * Invalidates the label button display of the target DropDown control. 
		 * @param display Button
		 * @param width int
		 * @param height int
		 */
		protected function initializeLabelButton( display:Button, width:int, height:int ):void
		{
			display.skin = new LabelButtonSkin();
			updateLabelButton( display, width, height );
		}
		/**
		 * @private
		 * 
		 * Invalidates the arrow button display of the target DropDown control 
		 * @param display Button
		 * @param width int
		 * @param height int
		 */
		protected function initializeArrowButton( display:Button, width:int, height:int ):void
		{
			display.skin = new ArrowButtonSkin();
			display.label = "";
			updateArrowButton( display, width, height );	
		}
		/**
		 * @private
		 * 
		 * Invalidates the list display of the target DropDown control. 
		 * @param display ScrollList
		 * @param width int
		 * @param height int
		 */
		protected function initializeDropDownList( display:ScrollList, width:int, height:int ):void
		{
			// allow scroll list display default skin.
			updateDropDownList( display, width, height );
		}
		
		/**
		 * @private
		 * 
		 * Updates the label button display of the target DropDown control. 
		 * @param display Button
		 * @param width int
		 * @param height int
		 */
		protected function updateLabelButton( display:Button, width:int, height:int ):void
		{
			var dropDownTarget:DropDown = ( _target as DropDown );
			display.width = width - dropDownTarget.arrowButtonDisplay.width;
			display.height = height;
		}
		/**
		 * @private
		 * 
		 * Updates the arrow button display of the target DropDown control. 
		 * @param display Button
		 * @param width int
		 * @param height int
		 */
		protected function updateArrowButton( display:Button, width:int, height:int ):void
		{
			display.x = width - display.width;
			display.height = height;
		}
		/**
		 * @private
		 * 
		 * Updates the list display of the target DropDown control. 
		 * @param display ScrollList
		 * @param width int
		 * @param height int
		 */
		protected function updateDropDownList( display:ScrollList, width:int, height:int ):void
		{
			var dropDownTarget:DropDown = ( _target as DropDown );
			display.width = ( dropDownTarget.dropDownWidth > 0 ) ? dropDownTarget.dropDownWidth : width;
			display.height = ( dropDownTarget.dropDownHeight > 0 ) ? dropDownTarget.dropDownHeight : 160;
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var dropDownTarget:DropDown = ( _target as DropDown );
			initializeLabelButton( dropDownTarget.labelButtonDisplay, width, height );
			initializeArrowButton( dropDownTarget.arrowButtonDisplay, width, height );
			initializeDropDownList( dropDownTarget.dropDownListDisplay, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var dropDownTarget:DropDown = ( _target as DropDown );
			updateLabelButton( dropDownTarget.labelButtonDisplay, width, height );
			updateArrowButton( dropDownTarget.arrowButtonDisplay, width, height );
			updateDropDownList( dropDownTarget.dropDownListDisplay, width, height );
		}
	}
}

import com.custardbelly.as3flobile.controls.label.Label;
import com.custardbelly.as3flobile.skin.ButtonSkin;

import flash.display.Graphics;

import flashx.textLayout.formats.TextAlign;

/**
 * LabelButtonSkin is a skin class for the label button of a DropDown control. 
 * @author toddanderson
 */
class LabelButtonSkin extends ButtonSkin
{
	/**
	 * Constructor.
	 */
	public function LabelButtonSkin() { super(); }
	
	/**
	 * @inherit
	 */
	override protected function initializeLabel( label:Label, width:int, height:int, padding:int = 0 ):void
	{
		super.initializeLabel( label, width, height, padding );
		// Left align and truncate.
		label.truncationText = "...";
		label.multiline = false;
		label.autosize = false;
		label.textAlign = TextAlign.LEFT;
	}
	/**
	 * @inherit
	 */
	override protected function updateLabel( label:Label, width:int, height:int, padding:int = 0 ):void
	{
		super.updateLabel( label, width, height, padding );
		label.x = padding;
	}
}

/**
 * ArrowButtonSkin is a skin class for the arrow button of a DropDown control. 
 * @author toddanderson
 */
class ArrowButtonSkin extends ButtonSkin
{
	/**
	 * Constructor.
	 */
	public function ArrowButtonSkin() { super(); }
	
	/**
	 * @inherit
	 */
	override protected function updateBackground( display:Graphics, width:int, height:int ):void
	{
		super.updateBackground( display, width, height );
		
		var length:Number = width * 0.5;
		var depth:Number = height * 0.14;
		display.lineStyle( 2, 0xCCCCCC, 1, true, "normal", "square", "miter" );
		display.beginFill( 0x999999 );
		display.moveTo( length * 0.5, ( height * 0.5 ) - depth  );
		display.lineTo( ( width - ( length * 0.5 ) ), ( height * 0.5 ) - depth );
		display.lineStyle( 2, 0x666666, 1, true, "normal", "square", "miter" );
		display.lineTo( width * 0.5, ( height * 0.5 ) + depth );
		display.lineStyle( 2, 0xCCCCCC, 1, true, "normal", "square", "miter" );
		display.moveTo( length * 0.5, ( height * 0.5 ) - depth  );
		display.endFill();
	}
}