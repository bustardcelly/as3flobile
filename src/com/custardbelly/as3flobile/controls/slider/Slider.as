/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: Slider.as</p>
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
package com.custardbelly.as3flobile.controls.slider
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.slider.context.BaseSliderContext;
	import com.custardbelly.as3flobile.controls.slider.context.BaseSliderStrategy;
	import com.custardbelly.as3flobile.controls.slider.context.HorizontalSliderStrategy;
	import com.custardbelly.as3flobile.controls.slider.context.ISliderContext;
	import com.custardbelly.as3flobile.controls.slider.context.SliderMouseContext;
	import com.custardbelly.as3flobile.controls.slider.context.VerticalSliderStrategy;
	import com.custardbelly.as3flobile.enum.OrientationEnum;
	import com.custardbelly.as3flobile.skin.SliderSkin;
	
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Slider is a base class to select a value from a range of linear values. The default layout and slide context is horizontal, but the orientation can be change for vertical. 
	 * @author toddanderson
	 */
	public class Slider extends AS3FlobileComponent implements ISlider
	{
		protected var _background:Sprite;
		protected var _thumb:Sprite;
		
		protected var _value:Number;
		protected var _minimumValue:Number;
		protected var _maximumValue:Number;
		protected var _thumbSize:int;
		
		protected var _bounds:Rectangle;
		
		/**
		 * @private
		 * Default horizontal slider context. The default context and created on demand. 
		 */
		protected var _horizontalContext:ISliderContext;
		/**
		 * @private
		 * Default vertical slider context. The default context and create on demand. 
		 */
		protected var _verticalContext:ISliderContext;
		
		protected var _orientation:int;
		protected var _sliderContext:ISliderContext;
		protected var _delegate:ISliderDelegate;
		
		/**
		 * Constuctor.
		 */
		public function Slider() 
		{ 
			super();
			// Set default context.
			sliderContext = getSliderContext( _orientation );
		}
		
		static public function initWithOrientationAndDelegate( orientation:int, delegate:ISliderDelegate ):Slider
		{
			var slider:Slider = new Slider();
			slider.orientation = orientation;
			slider.width = ( orientation == OrientationEnum.VERTICAL ) ? 48 : 260;
			slider.height = ( orientation == OrientationEnum.VERTICAL )  ? 260 : 48;
			slider.delegate = delegate;
			return slider;
		}
		
		/**
		 * @inherit
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			// Default orientation and sizes to horizontal.
			_orientation = OrientationEnum.HORIZONTAL;
			
			_width = 260;
			_height = 48;
			_thumbSize = 48;
			
			_bounds = new Rectangle( 0, 0, _width, _height );
			
			_skin = new SliderSkin();
			_skin.target = this;
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_background = new Sprite();
			addChild( _background );
			
			_thumb = new Sprite();
			addChild( _thumb );
		}
		
		/**
		 * @private
		 * 
		 * Returns the ISliderContext asociated with the target orientation. 
		 * @param orientation int
		 * @return ISliderContext
		 * @see OrientationEnum
		 */
		protected function getSliderContext( orientation:int ):ISliderContext
		{
			if( orientation == OrientationEnum.VERTICAL && _verticalContext == null )
			{
				_verticalContext = new SliderMouseContext( new VerticalSliderStrategy() );
			}
			else if( _horizontalContext == null )
			{
				_horizontalContext = new SliderMouseContext( new HorizontalSliderStrategy() );
			}
			return ( orientation == OrientationEnum.VERTICAL ) ? _verticalContext : _horizontalContext;
		}
		
		/**
		 * @private
		 * 
		 * Validats the current value within the specified range. 
		 * @param oldValue
		 * @param newValue
		 * 
		 */
		protected function invalidateValue( oldValue:Number, newValue:Number ):void
		{
			// If trying to set value outside of range, move along.
			if( newValue < _minimumValue || newValue > _maximumValue ) return;
			
			_value = newValue;
			// Limit value in range and update visual display.
			invalidateValueRange();
			
			// Notify delegate.
			if( _delegate )
			{
				_delegate.sliderValueDidChange( this, _value );
			}
		}
		
		/**
		 * @private
		 * 
		 * Validates the value within a specified range and updates the display.
		 */
		protected function invalidateValueRange():void
		{
			// Limit value.
			_value = ( _value > _maximumValue ) ? _maximumValue : _value;
			_value = ( _value < _minimumValue ) ? _minimumValue : _value;
			
			// Position thumb.
			if( _orientation == OrientationEnum.VERTICAL )
			{
				_thumb.x = 0;
				_thumb.y = ( _value - _minimumValue ) / ( _maximumValue - _minimumValue ) * ( _height - _thumb.height );
			}
			else
			{
				_thumb.x = ( _value - _minimumValue ) / ( _maximumValue - _minimumValue ) * ( _width - _thumb.width );
				_thumb.y = 0;
			}
		}
		
		/**
		 * @private 
		 * 
		 * Validates the orientation of the display and corrsponding slider context.
		 */
		protected function invalidateOrientation():void
		{
			sliderContext = getSliderContext( _orientation );
			invalidateValueRange();
			updateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Validates the specified thumb size.
		 */
		protected function invalidateThumbSize():void
		{
			invalidateValueRange();
			if( _sliderContext ) _sliderContext.update();
			updateDisplay();
		}
		
		/**
		 * @private
		 * 
		 * Validates the ISliderContext used to move and animate the thumb based on user gesture. 
		 * @param oldContext ISliderContext
		 * @param newContext ISliderContext
		 */
		protected function invalidateSliderContext( oldContext:ISliderContext, newContext:ISliderContext ):void
		{
			if( oldContext ) oldContext.dispose();
			
			_sliderContext = newContext;
			_sliderContext.initialize( this );
			
			if( isOnDisplayList() )
				_sliderContext.activate();
		}
		
		/**
		 * @inherit
		 */
		override protected function invalidateSize():void
		{
			// Override to udpate bounds and validate range.
			_bounds.width = _width;
			_bounds.height = _height;
			invalidateValueRange();
			super.invalidateSize();
		}
		
		/**
		 * @inherit
		 */
		override protected function handleAddedToStage( evt:Event ):void
		{
			super.handleAddedToStage( evt );
			if( _sliderContext )
				_sliderContext.activate();
		}
		
		/**
		 * @inherit
		 */
		override protected function handleRemovedFromStage( evt:Event ):void
		{
			super.handleRemovedFromStage( evt );
			if( _sliderContext )
				_sliderContext.deactivate();
		}
		
		/**
		 * @copy ISlider#commitOnPositionChange()
		 */
		public function commitOnPositionChange( position:Point ):void
		{
			if( _orientation == OrientationEnum.VERTICAL )
			{
				value = _thumb.y / ( _height - _thumb.height ) * ( _maximumValue - _minimumValue ) + _minimumValue;
			}
			else
			{
				value = _thumb.x / ( _width - _thumb.width ) * (_maximumValue - _minimumValue) + _minimumValue;	
			}
		}
		
		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			
			while( numChildren )
				removeChildAt( 0 );
			
			// Clean up context.
			_sliderContext.dispose();
			_sliderContext = null;
			
			// Null reference to delegate.
			_delegate = null;
		}
		
		/**
		 * @copy ISlider#backgroundTarget
		 */
		public function get backgroundTarget():InteractiveObject
		{
			return _background;
		}
		
		/**
		 * @copy ISlider#thumbTarget
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
		 * Returns the background display for skinning purposes. 
		 * @return Graphics
		 */
		public function get backgroundDisplay():Graphics
		{
			return _background.graphics;
		}
		
		/**
		 * REturns the thumb display for skinning purposes. 
		 * @return Sprite
		 */
		public function get thumbDisplay():Sprite
		{
			return _thumb;
		}
		
		/**
		 * Accessor/Modifier for the specified thumb size. By default, the thumb size is determined on the dimensions and orientation of this control.
		 * The range is not taken into account by default to determine the size of a thumb. You can specify a new size for the thumb using thumbSize.  
		 * @return int
		 */
		public function get thumbSize():int
		{
			return _thumbSize
		}
		public function set thumbSize( value:int ):void
		{
			if( _thumbSize == value ) return;
			
			_thumbSize = value;
			invalidateThumbSize();
		}
		
		/**
		 * Accessor/Modifier for the orientation of the slider control. Valid values are found in OrientationEnum and equate to 0 and 1. 
		 * @return int
		 */
		public function get orientation():int
		{
			return _orientation;
		}
		public function set orientation( value:int ):void
		{
			if( _orientation == value ) return;
			
			_orientation = value;
			invalidateOrientation();
		}
		
		/**
		 * Accessor/Modifier for the minimum value within the range. 
		 * @return Number
		 */
		public function get minimumValue():Number
		{
			return _minimumValue;
		}
		public function set minimumValue( value:Number ):void
		{
			if( _minimumValue == value ) return;
			
			_minimumValue = value;
			invalidateValueRange();
		}
		
		/**
		 * Accessor/Modifier for the maximum value within the range. 
		 * @return Number
		 */
		public function get maximumValue():Number
		{
			return _maximumValue;
		}
		public function set maximumValue( value:Number ):void
		{
			if( _maximumValue == value ) return;
			
			_maximumValue = value;
			invalidateValueRange();
		}
		
		/**
		 * Accessor/Modifier for the current value within the range denoted by thumb position. 
		 * @return Number
		 */
		public function get value():Number
		{
			return _value;
		}
		public function set value( theValue:Number ):void
		{
			if( _value == theValue ) return;
			
			invalidateValue( _value, theValue );
		}

		/**
		 * Accessor/Modifier for the ISliderContext used in animating and position the thumb within this conrol based on value. 
		 * @return ISliderContext
		 */
		public function get sliderContext():ISliderContext
		{
			return _sliderContext;
		}
		public function set sliderContext( value:ISliderContext ):void
		{
			if( _sliderContext == value ) return;
			
			invalidateSliderContext( _sliderContext, value );
		}
		
		/**
		 * Accessor/Modifier for optional delegate that requests notification on change to properties of this control. 
		 * @return ISliderDelegate
		 */
		public function get delegate():ISliderDelegate
		{
			return _delegate;
		}
		public function set delegate( value:ISliderDelegate ):void
		{
			_delegate = value;
		}
	}
}