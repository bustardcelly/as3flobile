package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.checkbox.CheckBox;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.enum.BoxPositionEnum;
	
	import flash.display.Sprite;
	
	public class MiscExample extends Sprite
	{
		public function MiscExample()
		{
			var label:Label = new Label();
			label.text = "Miscellany:";
			label.autosize = true;
			addChild( label );
			
			label = new Label();
			label.multiline = true;
			label.autosize = true;
			label.width = 300;
			label.y = 30;
			label.text = "The following are miscellanious controls that are not worthy of their own section. For instance, this text is actually in a Label control!";
			addChild( label );
			
			var toggleButton:ToggleButton = new ToggleButton();
			toggleButton.y = 120;
			toggleButton.width = 180;
			toggleButton.label = "i am a toggle button!";
			addChild( toggleButton );
			
			var checkBox:CheckBox = new CheckBox();
			checkBox.label = "i am a check box!";
			checkBox.y = 190;
			addChild( checkBox );
			
		}
	}
}