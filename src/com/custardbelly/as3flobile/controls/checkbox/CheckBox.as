/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: CheckBox.as</p>
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
package com.custardbelly.as3flobile.controls.checkbox
{
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.enum.BoxPositionEnum;
	import com.custardbelly.as3flobile.helper.ITapMediator;
	import com.custardbelly.as3flobile.helper.MouseTapMediator;
	import com.custardbelly.as3flobile.skin.CheckBoxSkin;
	import com.custardbelly.as3flobile.skin.CheckBoxToggleSkin;
	
	import flash.events.Event;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	/**
	 * CheckBox is a control display for a user to change selection on a model. 
	 * @author toddanderson
	 */
	public class CheckBox extends AS3FlobileComponent
	{
		protected var _boxDisplay:ToggleButton;
		protected var _labelDisplay:Label;
		
		protected var _currentState:int;
		
		protected var _label:String;
		protected var _multiline:Boolean;
		protected var _autosize:Boolean;
		protected var _labelPlacement:int;
		protected var _tapMediator:ITapMediator;
		
		protected var _check:DeluxeSignal;
		protected var _checkEvent:GenericEvent;
		
		/**
		 * Constructor.
		 */
		public function CheckBox() 
		{ 
			super();
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			mouseChildren = false;
			mouseEnabled = true;
			
			// *Note: 	The height property is regardless in this context.
			//			The height will be updated once the group is filled with content.
			_width = 180;
			_height = 34;
			
			_multiline = false;
			_autosize = false;
			
			_skin = new CheckBoxSkin();
			_skin.target = this;
			
			_labelPlacement = BoxPositionEnum.RIGHT;
			
			_tapMediator = new MouseTapMediator();
			
			_check = new DeluxeSignal( this );
			_checkEvent = new GenericEvent();
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_boxDisplay = new ToggleButton();
			_boxDisplay.skin = new CheckBoxToggleSkin();
			addChild( _boxDisplay );
			
			_labelDisplay = new Label();
			_labelDisplay.multiline = _multiline;
			_labelDisplay.autosize = _autosize;
			_labelDisplay.mouseChildren = false;
			_labelDisplay.mouseEnabled = false;
			addChild( _labelDisplay );
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
		 * Validates the textual content of the label.
		 */
		protected function invalidateLabel():void
		{
			_labelDisplay.text = _label;
			invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the multiline flag for the label display.
		 */
		protected function invalidateMultiline():void
		{
			_labelDisplay.multiline = _multiline;
			invalidateSize();
		}
		
		/**
		 * @private
		 * 
		 * Validates the autosize flag for the label display.
		 */
		protected function invalidateAutosize():void
		{
			_labelDisplay.autosize = _autosize;
			invalidateSize();
		}
		
		/**
		 * @inherit
		 */
		override protected function invalidateSize():void
		{
			// The true size of this control is actually based on the size of the label if it.
			_labelDisplay.width = _width;
			_labelDisplay.height = _height;
			if( _height < _labelDisplay.height ) _height = _labelDisplay.height;
			super.invalidateSize();
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
		 * Toggles the current state based on flag. 
		 * @param value Boolean
		 */
		protected function toggleState( value:Boolean ):void
		{
			_currentState = value ? BasicStateEnum.SELECTED : BasicStateEnum.NORMAL;
			_skinState = _currentState;
			_boxDisplay.selected = value;
			updateDisplay();
			
			_check.dispatch( _checkEvent );
		}
		
		/**
		 * @private
		 * 
		 * Determines if current state is associated with flag. 
		 * @param value Boolean
		 * @return Boolean
		 */
		protected function isStateEqual( value:Boolean ):Boolean
		{
			if( value ) return _currentState == BasicStateEnum.SELECTED;
			else 		return _currentState == BasicStateEnum.NORMAL;
		}
		
		/**
		 * @private
		 * 
		 * Event handle for click detection on label display. 
		 * @param evt Event
		 */
		protected function handleTap( evt:Event ):void
		{
			this.selected = !this.selected;
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			if( _tapMediator && _tapMediator.isMediating( this ) )
				_tapMediator.unmediateTapGesture( this );
			
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			_boxDisplay = null;
			_labelDisplay = null;
			_tapMediator = null;
			
			_check.removeAll();
			_check = null;
			_checkEvent = null;
		}
		
		/**
		 * Returns signal of change to toggle check. 
		 * @return DeluxeSignal
		 */
		public function get check():DeluxeSignal
		{
			return _check;
		}
		
		/**
		 * Returns the toggle box display instance for skinning. 
		 * @return ToggleButton
		 */
		public function get boxDisplay():ToggleButton
		{
			return _boxDisplay;
		}
		
		/**
		 * Returns the label display instance for skinning. 
		 * @return Label
		 */
		public function get labelDisplay():Label
		{
			return _labelDisplay;
		}
		
		/**
		 * Accessor/Modifier for the label diplay to render text acorss multiple lines. 
		 * @return Boolean
		 */
		public function get multiline():Boolean
		{
			return _multiline;
		}
		public function set multiline( value:Boolean ):void
		{
			if( _multiline == value ) return;
			
			_multiline = value;
			invalidateMultiline();
		}
		
		/**
		 * Accessor/Modifier for the label display to auto size based on supplied dimensions. 
		 * @return Boolean
		 */
		public function get autosize():Boolean
		{
			return _autosize;
		}
		public function set autosize( value:Boolean ):void
		{
			if( _autosize == value ) return;
			
			_autosize = value;
			invalidateAutosize();
		}
		
		/**
		 * Accessor/Modifier for the placement of the label within this control. Valid values are on BoxPositionEnum. 
		 * @return int
		 * @see BoxPositionEnum
		 */
		public function get labelPlacement():int
		{
			return _labelPlacement;
		}
		public function set labelPlacement( value:int ):void
		{
			if( _labelPlacement == value ) return;
			
			_labelPlacement = value;
			invalidateSize();
		}

		/**
		 * Accessor/Modifier for the textusl content to display. 
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
		 * Accessor/Modifier for the ITapMediator implementation that recognizes a tap gesture. 
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
		 * Accessor/Modifier for selection flag associate with current state. 
		 * @return Boolean
		 */
		public function get selected():Boolean
		{
			return ( _currentState == BasicStateEnum.SELECTED );
		}
		public function set selected( value:Boolean ):void
		{
			if( isStateEqual( value ) ) return;
			
			toggleState( value );
		}
	}
}