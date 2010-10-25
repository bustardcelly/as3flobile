package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.toggle.ToggleSwitch;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.events.GenericEvent;
	
	public class ToggleSwitchExample extends Sprite
	{
		protected var _selectionField:Label;
		protected var _toggleSwitch:ToggleSwitch;
		
		public function ToggleSwitchExample()
		{
			var label:Label = new Label();
			label.text = "ToggleSwitch Example:";
			label.autosize = true;
			addChild( label );
			
			label = new Label();
			label.multiline = true;
			label.autosize = true;
			label.width = 300;
			label.y = 30;
			label.text = "A ToggleSwitch control responds to mouse/touch gestures to change the flag value of a model.";
			addChild( label );
			
			_toggleSwitch = new ToggleSwitch();
			_toggleSwitch.selectionChange.add( toggleSwitchSelectionChange );
			_toggleSwitch.y = 90;
			_toggleSwitch.width = 180;
			_toggleSwitch.height = 80;
			addChild( _toggleSwitch );
			
			_selectionField = new Label();
			_selectionField.x = 40;
			_selectionField.y = 180;
			_selectionField.autosize = true;
			_selectionField.text = "Selected Position: 0";
//			addChild( _selectionField );
			
			label = new Label();
			label.y = 180;
			label.autosize = true;
			label.text = "Manual override.";
			addChild( label );
			
			var button:Button = new Button();
			button.tap.add( buttonTapped );
			button.label = "set off";
			button.y = 200;
			addChild( button );
			
			button = new Button();
			button.tap.add( buttonTapped );
			button.label = "set on";
			button.y = 200;
			button.x = 110;
			addChild( button );
		}
		
		public function buttonTapped( evt:GenericEvent ):void
		{
			var button:Button = evt.target as Button;
			_toggleSwitch.selectedIndex = ( button.label == "set off" ) ? 0 : 1; 
		}
		
		public function toggleSwitchSelectionChange( selectedIndex:uint ):void
		{
			_selectionField.text = "Selected Position: " + selectedIndex.toString();
		}
	}
}