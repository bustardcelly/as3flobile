/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: Button.as</p>
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
package com.custardbelly.as3flobile.controls.button
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.skin.ButtonSkin;
	import com.custardbelly.as3flobile.skin.ISkin;
	import com.custardbelly.as3flobile.skin.Skin;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	/**
	 * Button is a component that renders a graphic and textual display to represent an interactable object. 
	 * @author toddanderson
	 */
	public class Button extends AS3FlobileComponent
	{
		protected var _labelDisplay:Label;
		
		protected var _label:String;
		protected var _labelPadding:int;
		
		/**
		 * Constructor.
		 */
		public function Button()
		{
			super();
			mouseChildren = false;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_width = 100;
			_height = 48;
			
			_labelPadding = 5;
			
			_skin = new ButtonSkin();
			_skin.target = this;
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			_labelDisplay = new Label();
			_labelDisplay.autosize = true;
			_labelDisplay.multiline = true;
			addChild( _labelDisplay );
		}
		
		/**
		 * @private 
		 * 
		 * Invalidates the label text for the label display.
		 */
		protected function invalidateLabel():void
		{
			_labelDisplay.text = _label;
			updateDisplay();
		}
		
		override protected function addDisplayHandlers():void
		{
			addEventListener( MouseEvent.MOUSE_DOWN, handleDown, false, 0, true );
			addEventListener( MouseEvent.MOUSE_OUT, handleOut, false, 0, true );
			addEventListener( MouseEvent.MOUSE_UP, handleOut, false, 0, true );
		}
		
		override protected function removeDisplayHandlers():void
		{
			removeEventListener( MouseEvent.MOUSE_DOWN, handleDown, false );
			removeEventListener( MouseEvent.MOUSE_OUT, handleOut, false );
			removeEventListener( MouseEvent.MOUSE_UP, handleOut, false );
		}
		
		protected function handleDown( evt:MouseEvent ):void
		{
			_skinState = BasicStateEnum.DOWN;
			updateDisplay();
		}
		
		protected function handleOut( evt:MouseEvent ):void
		{
			_skinState = BasicStateEnum.NORMAL;
			updateDisplay();
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			while( numChildren > 0 )
				removeChildAt( 0 );
		}
		
		/**
		 * Accessor/Modifier for the textual display of the label. 
		 * @return String
		 */
		public function get label():String
		{
			return _label;
		}
		public function set label( value:String ):void
		{
			if( _label == value ) return;
			
			_label = value;
			invalidateLabel();
		}
		
		/**
		 * Accessor/Modifier for the padding offset for the label display. 
		 * @return int
		 */
		public function get labelPadding():int
		{
			return _labelPadding;
		}
		public function set labelPadding( value:int ):void
		{
			if( _labelPadding == value ) return;
			
			_labelPadding = value;
			updateDisplay();
		}
		
		/**
		 * Accessor for the label display that can be used in skinning process. 
		 * @return Label
		 */
		public function get labelDisplay():Label
		{
			return _labelDisplay;
		}
		
		/**
		 * Accessor for the buttonDisplay that can be used in the skinning process. 
		 * @return Sprite
		 */
		public function get backgroundDisplay():Graphics
		{
			return graphics;
		}
	}
}