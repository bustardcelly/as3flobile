package com.custardbelly.as3flobile.example.web.view
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.label.Label;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	import org.osflash.signals.events.GenericEvent;
	
	public class ControlPanel extends Sprite
	{
		protected var _delegate:IControlPanelDelegate;
		private var _gitRepo:String = "http://github.com/bustardcelly/as3flobile";
		
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
			createButton( "picker", 5, 171 );
			createButton( "drop down", 5, 229 );
			createButton( "text input", 5, 287 );
			createButton( "text area", 5, 345 );
			createButton( "sliders", 5, 403 );
			createButton( "toggle switch", 5, 461 );
			createButton( "miscellany", 5, 519 );
			
			var linkFormat:ElementFormat = new ElementFormat( new FontDescription( "DroidSans" ), 14, 0x0000FF );
			var linkHandler:EventDispatcher = new EventDispatcher();
			linkHandler.addEventListener( MouseEvent.CLICK, handleLink );
			var link:TextElement = new TextElement( "http://github.com/bustardcelly/as3flobile", linkFormat, linkHandler );
			var block:TextBlock = new TextBlock();
			block.content = link;
			var line:TextLine = block.createTextLine();
			line.y = 55;
			line.x = 163;
			addChild( line );
		}
		
		protected function createButton( label:String, xpos:int, ypos:int ):void
		{
			var button:Button = new Button();
			button.tap.add( buttonTapped );
			button.label = label;
			button.x = xpos;
			button.y = ypos;
			addChild( button );
		}
		
		protected function drawBackground():void
		{
			var height:int = 587;
			graphics.clear();
			graphics.beginFill( 0xE8C782 );
			graphics.drawRoundRect( 0, 45, 110, height, 5, 5 );
			graphics.endFill();
		}
		
		public function buttonTapped( evt:GenericEvent ):void
		{
			var button:Button = evt.target as Button;
			var index:int = getChildIndex( button );
			_delegate.controlPanelSelectionChange( this, index - 1 );
		}
		
		protected function handleLink( evt:MouseEvent ):void
		{
			navigateToURL( new URLRequest( _gitRepo ) );
		}
	}
}