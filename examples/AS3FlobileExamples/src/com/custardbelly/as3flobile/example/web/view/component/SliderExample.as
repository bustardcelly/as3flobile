package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.slider.Slider;
	import com.custardbelly.as3flobile.enum.OrientationEnum;
	
	import flash.display.Sprite;
	
	public class SliderExample extends Sprite
	{
		protected var _vertSlider:Slider;
		protected var _vertValueLabel:Label;
		protected var _horizSlider:Slider;
		protected var _horizValueLabel:Label;
		
		public function SliderExample()
		{
			var label:Label = new Label();
			label.text = "Slider Example:";
			label.autosize = true;
			addChild( label );
			
			label = new Label();
			label.multiline = true;
			label.autosize = true;
			label.width = 300;
			label.y = 30;
			label.text = "A Slider control provides a way to select a value position within a range on a model.";
			addChild( label );
			
			label = new Label();
			label.autosize = true;
			label.y = 420;
			label.text = "min: 0";
			addChild( label );
			
			label = new Label();
			label.autosize = true;
			label.y = 420;
			label.x = 230;
			label.text = "max: 100";
			addChild( label );
			
			_horizValueLabel = new Label();
			_horizValueLabel.autosize = true;
			_horizValueLabel.y = 380;
			_horizValueLabel.x = 150;
			_horizValueLabel.text = "value: 0";
			addChild( _horizValueLabel );
			
			_horizSlider = Slider.initWithOrientation( OrientationEnum.HORIZONTAL );
			_horizSlider.valueChange.add( horizSliderValueDidChange );
			_horizSlider.y = 400;
			_horizSlider.width = 170;
			_horizSlider.x = 50;
			_horizSlider.minimumValue = 0;
			_horizSlider.maximumValue = 100;
			addChild( _horizSlider );
			
			label = new Label();
			label.autosize = true;
			label.y = 90;
			label.text = "min: -100";
			addChild( label );
			
			label = new Label();
			label.autosize = true;
			label.y = 335;
			label.text = "max: 100";
			addChild( label );
			
			_vertValueLabel = new Label();
			_vertValueLabel.autosize = true;
			_vertValueLabel.y = 310;
			_vertValueLabel.x = 60;
			_vertValueLabel.text = "value: -100";
			addChild( _vertValueLabel );
			
			_vertSlider = Slider.initWithOrientation( OrientationEnum.VERTICAL );
			_vertSlider.valueChange.add( vertSliderValueDidChange );
			_vertSlider.y = 110;
			_vertSlider.height = 220;
			_vertSlider.minimumValue = -100;
			_vertSlider.maximumValue = 100;
			_vertSlider.orientation = OrientationEnum.VERTICAL;
			addChild( _vertSlider );
		}
		
		public function horizSliderValueDidChange( value:Number ):void
		{
			_horizValueLabel.text = "value: " + ( int( value ) ).toString();
		}
		public function vertSliderValueDidChange( value:Number ):void
		{
			_vertValueLabel.text = "value: " + ( int( value ) ).toString();
		}
	}
}