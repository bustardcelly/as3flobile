package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	
	import flash.display.Graphics;

	public class ScrollListItemRendererSkin extends Skin
	{
		public function ScrollListItemRendererSkin() { super(); }
		
		protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			var isSelected:Boolean = ( _target.skinState == BasicStateEnum.SELECTED );
			display.clear();
			display.beginFill( ( isSelected ) ? 0xDDDDDD : 0xFFFFFF );
			display.drawRect( 0, 0, width, height );
			display.endFill();
		}
		
		/**
		 * @inherit
		 */
		override public function initializeDisplay( width:int, height:int ):void
		{
			super.initializeDisplay( width, height );
			
			var itemTarget:IScrollListItemRenderer = ( _target as IScrollListItemRenderer );
			updateBackground( itemTarget.backgroundDisplay, width, height );
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			super.updateDisplay( width, height );
			
			var itemTarget:IScrollListItemRenderer = ( _target as IScrollListItemRenderer );
			updateBackground( itemTarget.backgroundDisplay, width, height );
		}
	}
}