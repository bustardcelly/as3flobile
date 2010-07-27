/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ToggleSwitch.as</p>
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
package com.custardbelly.as3flobile.controls.toggle
{
	import com.custardbelly.as3flobile.controls.core.AS3FlobileComponent;
	import com.custardbelly.as3flobile.controls.toggle.context.BaseToggleSwitchStrategy;
	import com.custardbelly.as3flobile.controls.toggle.context.IToggleSwitchContext;
	import com.custardbelly.as3flobile.controls.toggle.context.ToggleSwitchMouseContext;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	/**
	 * ToggleSwitch is an IToggleSwitch implementation that provides a control to select an between 2 values, usually representing opposites such as OFF an ON (default). 
	 * @author toddanderson
	 */
	public class ToggleSwitch extends AS3FlobileComponent implements IToggleSwitch
	{
		protected var _block:TextBlock;
		
		protected var _background:Sprite;
		protected var _labelHolder:Sprite;
		protected var _labelMask:Sprite; // Label mask is only set to mask label holder when formatting is out of bounds of height specified.
		protected var _thumb:Sprite;
		
		protected var _format:ElementFormat;
		protected var _labels:Vector.<String>;
		protected var _labelPadding:int = 5;
		protected var _selectedIndex:uint;
		
		protected var _bounds:Rectangle;
		protected var _toggleContext:IToggleSwitchContext;
		
		protected var _delegate:IToggleSwitchDelegate;
		
		/**
		 * Constructor.
		 */
		public function ToggleSwitch()
		{
			initialize();
			createChildren();
			invalidateLabels();
			toggleContext = getDefaultContext();
		}
		
		/**
		 * @private 
		 * 
		 * Initializes any necessary values/properties.
		 */
		protected function initialize():void
		{
			_width = 100;
			_height = 40;
			
			_bounds = new Rectangle( 0, 0, _width, _height );
			
			_block = new TextBlock();
			
			_format = new ElementFormat( new FontDescription( "DroidSans" ) );
			_format.color = 0xEEEEEE;
			_format.fontSize = 12;
			
			_labels = getDefaultLabels();
			
			addHandlers();
		}
		
		/**
		 * @private 
		 * 
		 * Creates any necessary display children.
		 */
		protected function createChildren():void
		{
			_background = new Sprite();
			addChild( _background );
			
			_labelHolder = new Sprite();
			_labelHolder.mouseChildren = false;
			_labelHolder.mouseEnabled = false;
			addChild( _labelHolder );
			
			_thumb = new Sprite();
			addChild( _thumb );
		}
		
		/**
		 * @private 
		 * 
		 * Adds event handlers for addition and removal from parent display list.
		 */
		protected function addHandlers():void
		{
			addEventListener( Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event handlers.
		 */
		protected function removeHandlers():void
		{
			removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage, false );
			removeEventListener( Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false );
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
			return new ToggleSwitchMouseContext( new BaseToggleSwitchStrategy() );
		}
		
		/**
		 * @private
		 * 
		 * Returns flag of this instance residing on a display list. Add and Remove events are tracked by this control in order to activate/deactivate the IToggleContext.
		 * @return Boolean
		 */
		protected function isOnDisplayList():Boolean
		{
			return this.stage != null;
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
			updateDisplay();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the formatting used in the textual display.
		 */
		protected function invalidateFormat():void
		{
			invalidateLabels();
		}
		
		/**
		 * @private 
		 * 
		 * Validates the textual content labels.
		 */
		protected function invalidateLabels():void
		{
			// Remove previous labels from display.
			while( _labelHolder.numChildren > 0 )
			{
				_labelHolder.removeChildAt( 0 );
			}
			
			// Use TextBlock factory to create TextLines.
			var label:String;
			var i:int;
			for each( label in _labels )
			{
				_block.content = new TextElement( label, _format );
				var line:TextLine = _block.createTextLine( null );
				line.y = line.height;
				_labelHolder.addChild( line );
			}
			// Refresh.
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
			
			if( _delegate ) _delegate.toggleSwitchSelectionChange( this, _selectedIndex );
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
		 * @private
		 * 
		 * Refreshes the display.
		 */
		protected function updateDisplay():void
		{
			redraw();
			positionLabels();
			positionThumb();
		}
		
		/**
		 * @private 
		 * 
		 * Redraws any graphical display elements.
		 */
		protected function redraw():void
		{
			_background.graphics.clear();
			_background.graphics.beginFill( 0x333333 );
			_background.graphics.drawRect( 0, 0, _width, _height );
			_background.graphics.endFill();
			
			var thumbWidth:int = _width * 0.5;
			_thumb.graphics.clear();
			_thumb.graphics.beginFill( 0xAAAAAA );
			_thumb.graphics.drawRect( 0, 0, thumbWidth, _height );
			_thumb.graphics.endFill();
		}
		
		/**
		 * @private 
		 * 
		 * Positions the labels within the control.
		 */
		protected function positionLabels():void
		{
			if( _labelHolder.numChildren == 0 ) return;
			
			var firstLabel:DisplayObject = _labelHolder.getChildAt( 0 );
			var lastLabel:DisplayObject = _labelHolder.getChildAt( 1 );
			
			if( firstLabel ) 	firstLabel.x = _labelPadding;
			if( lastLabel ) 	lastLabel.x = int(_width - lastLabel.width - _labelPadding);
			
			if( _labelHolder.height > _height )
			{
				_labelHolder.y = 0;
				addLabelHolderMask();
			}
			else
			{
				_labelHolder.y = int(( _height - _labelHolder.height ) * 0.5);
				removeLabelHolderMask();
			}
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
		 * @private 
		 * 
		 * Adds a mask to the label display if formatting has increased the height of the labels greater than that of the specified height.
		 */
		protected function addLabelHolderMask():void
		{
			if( _labelHolder.mask == null )
			{
				_labelMask = new Sprite();
				_labelMask.graphics.beginFill( 0, 0 );
				_labelMask.graphics.drawRect( 0, 0, _width, _height );
				_labelMask.graphics.endFill();
				addChild( _labelMask );
				
				_labelHolder.mask = _labelMask;
			}
		}
		
		/**
		 * @private 
		 * 
		 * Removes the possible mask set to the label display.
		 */
		protected function removeLabelHolderMask():void
		{
			if( _labelMask && _labelHolder.mask == _labelMask )
			{
				removeChild( _labelMask );
				_labelHolder.mask = null;
				_labelMask = null;
			}
		}
		
		/**
		 * @private
		 * 
		 * Event handler for being added to the display list of parent. 
		 * @param evt Event
		 */
		protected function handleAddedToStage( evt:Event ):void
		{
			if( _toggleContext )
				_toggleContext.activate();
		}
		
		/**
		 * @private
		 * 
		 * Event handler for being removed from the display list of the parent. 
		 * @param evt Event
		 */
		protected function handleRemovedFromStage( evt:Event ):void
		{
			if( _toggleContext )
				_toggleContext.deactivate();
		}
		
		/**
		 * Performs any cleanup.
		 */
		public function dispose():void
		{
			// Remove label displays.
			while( _labelHolder.numChildren > 0 )
			{
				_labelHolder.removeChildAt( 0 );
			}
			// Remove mask.
			removeLabelHolderMask();
			
			// Clean up context.
			_toggleContext.dispose();
			_toggleContext = null;
			
			// Remove handlers.
			removeHandlers();
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
		 * @copy IToggleSwitch#toggleBounds
		 */
		public function get toggleBounds():Rectangle
		{
			return _bounds;
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
			
			_labels = value.slice( 0, 1 );
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
		
		/**
		 * @copy IToggleSwitch#delegate
		 */
		public function get delegate():IToggleSwitchDelegate
		{
			return _delegate;
		}
		public function set delegate( value:IToggleSwitchDelegate ):void
		{
			_delegate = value;
		}
	}
}