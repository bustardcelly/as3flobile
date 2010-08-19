package com.custardbelly.as3flobile.skin
{
	import com.custardbelly.as3flobile.enum.BasicStateEnum;
	
	import flash.display.Graphics;

	public class CheckBoxToggleSkin extends com.custardbelly.as3flobile.skin.ToggleButtonSkin
	{
		public function CheckBoxToggleSkin() { super(); }
		
		/**
		 * @inherit
		 */
		override protected function updateBackground( display:Graphics, width:int, height:int ):void
		{
			if( display == null ) return;
			
			super.updateBackground( display, width, height );
			
			if( _target.skinState == BasicStateEnum.SELECTED )
			{	
				var position:Number = height * 0.25;
				display.lineStyle( 4, 0xFF7F00 );
				display.moveTo( position, position );
				display.lineTo( width * 0.5, height - position );
				display.lineTo( width + position, -position );
			}
		}
	}
}