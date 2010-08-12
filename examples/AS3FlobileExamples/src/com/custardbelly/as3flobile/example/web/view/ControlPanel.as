package com.custardbelly.as3flobile.example.web.view
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.debug.PrintLine;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.utils.getTimer;
	
	public class ControlPanel extends Sprite
	{
		protected var _delegate:IControlPanelDelegate;
		public function ControlPanel( delegate:IControlPanelDelegate )
		{
			_delegate = delegate;
			createChildren();
			drawBackground();
		}
		
		protected function createChildren():void
		{
			var label:Label = new Label();
			label.x = 84;
			label.text = "AS3Flobile Components";
			label.autosize = true;
			label.format = new ElementFormat( new FontDescription( "DroidSans" ), 32 );
			addChild( label );
			
			createButton( "scroll viewport", 5, 55 );
			createButton( "scroll list", 5, 113 );
			createButton( "text area", 5, 171 );
			createButton( "toggle switch", 5, 229 );
		}
		
		protected function createButton( label:String, xpos:int, ypos:int ):void
		{
			var button:Button = new Button();
			button.label = label;
			button.x = xpos;
			button.y = ypos;
			button.addEventListener( MouseEvent.CLICK, handleSelection );
			addChild( button );
		}
		
		protected function drawBackground():void
		{
			var height:int = 244;
			graphics.clear();
			graphics.beginFill( 0xCCCCCC );
			graphics.drawRoundRect( 0, 45, 110, height, 5, 5 );
			graphics.endFill();
		}
		
		protected function handleSelection( evt:Event ):void
		{
			var target:DisplayObject = evt.target as DisplayObject;
			var index:int = getChildIndex( target );
			_delegate.controlPanelSelectionChange( this, index - 1 );
		}
	}
}