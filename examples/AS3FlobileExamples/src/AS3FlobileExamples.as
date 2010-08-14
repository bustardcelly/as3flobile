package
{
	import com.bit101.components.FPSMeter;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.custardbelly.as3flobile.controls.list.ScrollList;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListHorizontalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListHorizontalLayout;
	import com.custardbelly.as3flobile.controls.list.layout.ScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.text.TextArea;
	import com.custardbelly.as3flobile.controls.toggle.ToggleSwitch;
	import com.custardbelly.as3flobile.controls.viewport.ScrollViewport;
	import com.custardbelly.as3flobile.debug.PrintLine;
	import com.custardbelly.as3flobile.example.web.view.ComponentsPanel;
	import com.custardbelly.as3flobile.example.web.view.ControlPanel;
	import com.custardbelly.as3flobile.example.web.view.IControlPanelDelegate;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	public class AS3FlobileExamples extends Sprite implements IControlPanelDelegate
	{
		protected var view:Sprite;
		protected var _controlPanel:Sprite;
		protected var _componentPanel:ComponentsPanel;
		protected var _selectedViewIndex:int;
		
//		[SWF(width="480", height="800")]
		public function AS3FlobileExamples()
		{
//			this.stage.scaleMode = StageScaleMode.SHOW_ALL;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT; 
			
			createChildren();
			this.stage.addEventListener( Event.RESIZE, handleResize );
			handleResize( null );
		}
		
		protected function createChildren():void
		{
			view = new Sprite();
			addChild( view );
			
			_controlPanel = new ControlPanel( this );
			_controlPanel.x = 10;
			_controlPanel.y = 10;
			view.addChild( _controlPanel );
			
			_componentPanel = new ComponentsPanel();
			_componentPanel.x = 140;
			_componentPanel.y = 55;
			view.addChild( _componentPanel );
			
			new FPSMeter( view, 15, 30 );
			
			var printField:TextArea = new TextArea();
			var format:ElementFormat = new ElementFormat( new FontDescription( "Arial" ), 20 );
			printField.format = format;
//			view.addChild( printField );
			
			printField.x = 10;
			printField.y = 320;
			printField.width = 160;
			printField.height = 470;
			PrintLine.instance().field = printField;
		}
		
		public function controlPanelSelectionChange( controlPanel:ControlPanel, index:int ):void
		{
			index = ( index < 0 ) ? 0 : index;
			_componentPanel.selectedIndex = index;
		}
		
		protected function handleResize( evt:Event ):void
		{
			var scale:Number = 1;
			var h:int = _componentPanel.y + _componentPanel.height + 10;
			if( stage.stageWidth != 480 || stage.stageHeight != h )
			{
				scale = Math.min( stage.stageWidth / 480, stage.stageHeight / h );
			}
			view.scaleX = scale;
			view.scaleY = scale;
			PrintLine.instance().print( "scale: " + scale );
			PrintLine.instance().print( "stage: " + stage.stageWidth + ", " + stage.stageHeight, true );
		}
	}
}