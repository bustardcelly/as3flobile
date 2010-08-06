package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.text.TextArea;
	
	import flash.display.Shape;

	/**
	 * TextAreaSkin is the base class for skinning a TextArea control. 
	 * @author toddanderson
	 */
	public class TextAreaSkin extends Skin
	{
		/**
		 * Constructor.
		 */
		public function TextAreaSkin() { super(); }
		
		/**
		 * @private
		 * 
		 * updates the look and feel of the background display of the target TextArea. 
		 * @param display Shape
		 * @param width int
		 * @param height int
		 */
		protected function updateBackground( display:Shape, width:int, height:int ):void
		{
			display.graphics.clear();
			display.graphics.lineStyle( 2, 0x999999, 1, true, "normal", "square", "miter" );
			display.graphics.drawRect( 0, 0, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var textAreaTarget:TextArea = ( _target as TextArea );
			updateBackground( textAreaTarget.backgroundDisplay, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var textAreaTarget:TextArea = ( _target as TextArea );
			updateBackground( textAreaTarget.backgroundDisplay, width, height );
		}
	}
}