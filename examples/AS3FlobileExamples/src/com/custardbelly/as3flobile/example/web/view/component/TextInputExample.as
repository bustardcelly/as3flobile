package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.textinput.TextInput;
	
	import flash.display.Sprite;
	
	public class TextInputExample extends Sprite
	{
		public function TextInputExample()
		{
			var label:Label = new Label();
			label.text = "TextInput Example:";
			label.autosize = true;
			addChild( label );
			
			var singleInput:TextInput = new TextInput();
			singleInput.y = 30;
			singleInput.width = 200;
			singleInput.defaultText = "Enter some text...";
			addChild( singleInput );
			
			
			label = new Label();
			label.text = "multiline:";
			label.y = 80;
			label.autosize = true;
			addChild( label );
			
			var multiInput:TextInput = new TextInput();
			multiInput.y = 110;
			multiInput.multiline = true;
			multiInput.width = 300;
			multiInput.height = 240;
			addChild( multiInput );
		}
	}
}