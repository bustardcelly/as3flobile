package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.checkbox.CheckBox;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.radiobutton.RadioButton;
	import com.custardbelly.as3flobile.controls.radiobutton.RadioGroup;
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
			checkBox.width = 240;
			checkBox.multiline = true;
			checkBox.y = 190;
			addChild( checkBox );
			
			var radioDataProvider:Vector.<RadioButton> = getRadioDataProvider();
			var radioGroup:RadioGroup = new RadioGroup();
			radioGroup.width = 280;
			radioGroup.y = 240;
			radioGroup.dataProvider = radioDataProvider;
			addChild( radioGroup );
		}
		
		protected function getRadioDataProvider():Vector.<RadioButton>
		{
			var data:Vector.<RadioButton> = new Vector.<RadioButton>();
			data.push( getRadioButton( "1. Pack my box with five dozen liquor jugs." ) );
			data.push( getRadioButton( "2. The jay, pig, fox, zebra, and my wolves! Jaded zombies acted quietly but kept driving their oxen forward." ) );
			data.push( getRadioButton( "3. My girl wove six dozen plaid jackets before she quit." ) );
			return data;
		}
		
		protected function getRadioButton( label:String ):RadioButton
		{
			var button:RadioButton = new RadioButton();
			button.label = label;
			button.multiline = true;
			return button;
		}
	}
}