package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.dropdown.DropDown;
	import com.custardbelly.as3flobile.controls.label.Label;
	
	import flash.display.Sprite;
	
	public class DropDownExample extends Sprite
	{
		public function DropDownExample()
		{
			var label:Label = new Label();
			label.text = "DropDown Example:";
			label.autosize = true;
			addChild( label );
			
			var dropDown:DropDown = new DropDown();
			dropDown.y = 30;
			dropDown.width = 300;
			dropDown.dataProvider = [{label:"item 1"}, {label:"item 2 with really long textual content to display."}, {label:"item 3"}, {label:"item 4"}, {label:"item 5"}, {label:"item 6"}, {label:"item 7"},
										{label:"item 8"}, {label:"item 9"}, {label:"item 10"}, {label:"item 11"}, {label:"item 12"}, {label:"item 13"}, {label:"item 14"},
										{label:"item 15"}, {label:"item 16"}, {label:"item 17"}, {label:"item 18"}, {label:"item 19"}, {label:"item 20"}, {label:"item 21"}]
			addChild( dropDown );
		}
	}
}