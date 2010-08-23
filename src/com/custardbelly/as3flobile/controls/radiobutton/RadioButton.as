/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: RadioButton.as</p>
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
package com.custardbelly.as3flobile.controls.radiobutton
{
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	import com.custardbelly.as3flobile.enum.BoxPositionEnum;
	import com.custardbelly.as3flobile.helper.ITapMediator;
	import com.custardbelly.as3flobile.helper.MouseTapMediator;
	import com.custardbelly.as3flobile.skin.RadioButtonSkin;
	import com.custardbelly.as3flobile.skin.RadioButtonToggleSkin;
	
	import flash.events.Event;
	
	/**
	 * RadioButton is a control that toggles the selection of a model.
	 * Though it is possible to create and add a RadioButton to a display directly, it is more common to use a RadioGroup to manage the selection of a model across multiple RadioButtons.
	 * @see RadioGroup
	 * @author toddanderson
	 */
	public class RadioButton extends AS3FlobileComponent
	{
		protected var _radioDisplay:ToggleButton;
		protected var _labelDisplay:Label;
		
		protected var _currentState:int;
		
		protected var _label:String;
		protected var _multiline:Boolean;
		protected var _autosize:Boolean;
		protected var _labelPlacement:int;
		protected var _tapMediator:ITapMediator;
		protected var _delegate:IRadioButtonDelegate;
		
		/**
		 * Constructor.
		 */
		public function RadioButton() 
		{ 
			super();
			mouseChildren = false;
			mouseEnabled = true;
			_tapMediator = new MouseTapMediator();
		}
		
		/**
		 * Static util function to create a new RadioButton instance with an IRadioButtonDelegate reference.
		 * @param delegate IRadioButtonDelegate
		 * @return RadioButton
		 */
		static public function initWithDelegate( delegate:IRadioButtonDelegate ):RadioButton
		{
			var radio:RadioButton = new RadioButton();
			radio.delegate = delegate;
			return radio;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_width = 180;
			_height = 34;
			
			_multiline = false;
			_autosize = false;
			
			_skin = new RadioButtonSkin();
			_skin.target = this;
			
			_labelPlacement = BoxPositionEnum.RIGHT;
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_radioDisplay = new ToggleButton();
			_radioDisplay.skin = new RadioButtonToggleSkin();
			addChild( _radioDisplay );
			
			_labelDisplay = new Label();
			_labelDisplay.multiline = _multiline;
			_labelDisplay.autosize = _autosize;
			_labelDisplay.mouseEnabled = false;
			_labelDisplay.mouseChildren = false;
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
		 * Validate the textual content to display.
		 */
		protected function invalidateLabel():void
		{
			_labelDisplay.text = _label;
			invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the flag toshow mutliline text in the display.
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
			if( !_tapMediator.isMediating( this ) ) _tapMediator.mediateTapGesture( this, handleTap );
		}
		
		/**
		 * @inherit
		 */
		override protected function removeDisplayHandlers():void
		{
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
			_radioDisplay.selected = value;
			updateDisplay();
			
			if( _delegate )
				_delegate.radioButtonSelectionChange( this, value );
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
		 * Event handler for click on the labell display. 
		 * @param evt MouseEvent
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
			
			while( numChildren > 0 )
				removeChildAt( 0 );
			
			_radioDisplay = null;
			_labelDisplay = null;
		}

		/**
		 * Returns the toggle button radio display for skinning. 
		 * @return ToggleButton
		 */
		public function get radioDisplay():ToggleButton
		{
			return _radioDisplay;
		}
		
		/**
		 * Returns the label display for skinnning. 
		 * @return Label
		 */
		public function get labelDisplay():Label
		{
			return _labelDisplay;
		}
		
		/**
		 * Accessor/Modifier for the textual content of the display. 
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
		 * Accessor/Modifier for flag to show multiline text. 
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
		 * Accessor/Modifier for positon of label within this control display. 
		 * @return int
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
		 * Accessor/Modifier for the client that requires notification of changes to this control. 
		 * @return IRadioButtonDelegate
		 */
		public function get delegate():IRadioButtonDelegate
		{
			return _delegate;
		}
		public function set delegate( value:IRadioButtonDelegate ):void
		{
			_delegate = value;
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
			// Toggle.
			toggleState( value );
		}
	}
}