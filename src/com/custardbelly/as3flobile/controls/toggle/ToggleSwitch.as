/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleSwitch.as</p>
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
package com.custardbelly.as3flobile.controls.toggle
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.toggle.context.HorizontalToggleSwitchStrategy;
	import com.custardbelly.as3flobile.controls.toggle.context.IToggleSwitchContext;
	import com.custardbelly.as3flobile.controls.toggle.context.ToggleSwitchMouseContext;
	import com.custardbelly.as3flobile.skin.ToggleSwitchSkin;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	
	import org.osflash.signals.Signal;
	
	/**
	 * ToggleSwitch is an IToggleSwitch implementation that provides a control to select an between 2 values, usually representing opposites such as OFF an ON (default). 
	 * @author toddanderson
	 */
	public class ToggleSwitch extends AS3FlobileComponent implements IToggleSwitch
	{
		protected var _background:Sprite;
		protected var _leftLabel:Label;
		protected var _rightLabel:Label;
		protected var _thumb:Sprite;
		
		protected var _format:ElementFormat;
		protected var _labels:Vector.<String>;
		protected var _labelPadding:int = 5;
		protected var _selectedIndex:uint;
		
		protected var _bounds:Rectangle;
		protected var _toggleContext:IToggleSwitchContext;
		
		protected var _selectionChange:Signal;
		
		/**
		 * Constructor.
		 */
		public function ToggleSwitch()
		{
			super();
			invalidateLabels();
			toggleContext = getDefaultContext();
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_width = 100;
			_height = 40;
			
			_bounds = new Rectangle( 0, 0, _width, _height );
			
			_labels = getDefaultLabels();
			
			_skin = new ToggleSwitchSkin();
			_skin.target = this;
			
			_selectionChange = new Signal( int );
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_background = new Sprite();
			addChild( _background );
			
			_leftLabel = new Label();
			_leftLabel.autosize = true;
			_leftLabel.mouseEnabled = false;
			_leftLabel.mouseChildren = false;
			addChild( _leftLabel );
			
			_rightLabel = new Label();
			_rightLabel.autosize = true;
			_rightLabel.mouseEnabled = false;
			_rightLabel.mouseChildren = false;
			addChild( _rightLabel );
			
			_thumb = new Sprite();
			addChild( _thumb );
		}
		
		/**
		 * @private
		 * 
		 * Returns the default labels displayed. Default is ["OFF", "ON"]. 
		 * @return Vector.<String>
		 */
		protected function getDefaultLabels():Vector.<String>
		{
			return Vector.<String>(["OFF", "ON"]);	
		}
		
		/**
		 * @private
		 * 
		 * Returns the default IToggleContext instance used to position thumb display. 
		 * @return IToggleContext
		 */
		protected function getDefaultContext():IToggleSwitchContext
		{
			return new ToggleSwitchMouseContext( new HorizontalToggleSwitchStrategy() );
		}
		
		/**
		 * @private 
		 * 
		 * Validates the new dimensions given to this instance.
		 */
		override protected function invalidateSize():void
		{
			_bounds.width = _width;
			_bounds.height = _height;
			super.invalidateSize();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the formatting used in the textual display.
		 */
		protected function invalidateFormat():void
		{
			updateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the textual content labels.
		 */
		protected function invalidateLabels():void
		{
			_leftLabel.text = ( _labels && _labels.length > 0 ) ? _labels[0] : "";
			_rightLabel.text = ( _labels && _labels.length > 0 ) ? _labels[1] : "";
			
			updateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the specified padding between a label and its border in the control.
		 */
		protected function invalidateLabelPadding():void
		{
			positionLabels();
		}
		
		/**
		 * @private
		 *  
		 * Validates the selected index within the control.
		 */
		protected function invalidateSelectedIndex():void
		{
			// Notify toggle context, if present.
			if( _toggleContext )
			{
				_toggleContext.updateSelectedIndex( _selectedIndex );
			}
			// Else just position the thumb.
			else
			{
				positionThumb();
			}
			
			_selectionChange.dispatch( _selectedIndex );
		}
		
		/**
		 * @private
		 * 
		 * Validates the new IToggleContext instance to be used. 
		 * @param oldContext IToggleContext
		 * @param newContext IToggleContext
		 */
		protected function invalidateToggleContext( oldContext:IToggleSwitchContext, newContext:IToggleSwitchContext ):void
		{
			if( oldContext ) oldContext.dispose();
			
			_toggleContext = newContext;
			_toggleContext.initialize( this );
			
			if( isOnDisplayList() )
				_toggleContext.activate();
		}
		
		/**
		 * @inherit
		 */
		override protected function updateDisplay():void
		{
			super.updateDisplay();
			positionLabels();
			positionThumb();
		}
		
		/**
		 * @private 
		 * 
		 * Positions the labels within the control.
		 */
		protected function positionLabels():void
		{
			_leftLabel.x = _labelPadding;
			_rightLabel.x = _width - _rightLabel.width - _labelPadding;
		}
		
		/**
		 * @private 
		 * 
		 * Positions thumb display based on selected index.
		 */
		protected function positionThumb():void
		{	
			_thumb.x = ( _selectedIndex == 0 ) ? 0 : _width - _thumb.width;
		}
		
		/**
		 * @inherit
		 */
		override protected function handleAddedToStage( evt:Event ):void
		{
			super.handleAddedToStage( evt );
			if( _toggleContext )
				_toggleContext.activate();
		}
		
		/**
		 * @inherit
		 */
		override protected function handleRemovedFromStage( evt:Event ):void
		{
			super.handleRemovedFromStage( evt );
			if( _toggleContext )
				_toggleContext.deactivate();
		}
		
		/**
		 * @copy ISlider#commitOnPositionChange
		 */
		public function commitOnPositionChange( position:Point ):void
		{
			selectedIndex = ( position.x == ( _width - _thumb.width ) ) ? 1 : 0;
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			while( numChildren )
				removeChildAt( 0 );
			
			_leftLabel.dispose();
			_leftLabel = null;
			
			_rightLabel.dispose();
			_rightLabel = null;
			
			// Clean up context.
			_toggleContext.dispose();
			_toggleContext = null;
			
			_selectionChange.removeAll();
			_selectionChange = null;
		}
		
		/**
		 * Returns signal reference for change in selection on switch instanc. 
		 * @return Signal Signal( int )
		 */
		public function get selectionChange():Signal
		{
			return _selectionChange;
		}
		
		/**
		 * @copy IToggleSwitch#backgroundTarget
		 */
		public function get backgroundTarget():InteractiveObject
		{
			return _background;
		}
		
		/**
		 * @copy IToggelSwitch# thumbTarget
		 */
		public function get thumbTarget():InteractiveObject
		{
			return _thumb;
		}
		
		/**
		 * @copy ISlider#sliderBounds
		 */
		public function get sliderBounds():Rectangle
		{
			return _bounds;
		}
		
		/**
		 * Returns reference to background display.
		 * @return Sprite
		 */
		public function get backgroundDisplay():Sprite
		{
			return _background;
		}
		/**
		 * Returns reference to thunm display. 
		 * @return Sprite
		 */
		public function get thumbDisplay():Sprite
		{
			return _thumb;
		}
		/**
		 * Returns reference to the left ("off") label display. 
		 * @return Label
		 */
		public function get leftLabelDisplay():Label
		{
			return _leftLabel;
		}
		/**
		 * Returns reference to the right ("on") label display. 
		 * @return Label
		 */
		public function get rightLabelDisplay():Label
		{
			return _rightLabel;
		}

		/**
		 * Accessor/Modifier for the format used to create text lines. 
		 * @return ElementFormat
		 */
		public function get format():ElementFormat
		{
			return _format;
		}
		public function set format(value:ElementFormat):void
		{
			if( _format == value ) return;
			
			_format = value;
			invalidateFormat();
		}

		/**
		 * Accessor/Modifier for the labels to display within the control. 
		 * @return Vector.<String>
		 */
		public function get labels():Vector.<String>
		{
			return _labels;
		}
		public function set labels(value:Vector.<String>):void
		{
			if( _labels == value ) return;
			
			_labels = value.slice( 0, 2 );
			invalidateLabels();
		}
		
		/**
		 * Accessor/Modifier for the padding given to the labels within the control display. 
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
			invalidateLabelPadding();
		}

		/**
		 * @copy IToggleSwitch#selectedIndex
		 */
		public function get selectedIndex():uint
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:uint):void
		{
			if( _selectedIndex == value ) return;
			
			_selectedIndex = ( value > 1 ) ? 1 : value;
			invalidateSelectedIndex();
		}
		
		/**
		 * @copy IToggleSwitch#toggleContext
		 */
		public function get toggleContext():IToggleSwitchContext
		{
			return _toggleContext;
		}
		public function set toggleContext( value:IToggleSwitchContext ):void
		{
			if( _toggleContext == value ) return;
			
			invalidateToggleContext( _toggleContext, value );
		}
	}
}