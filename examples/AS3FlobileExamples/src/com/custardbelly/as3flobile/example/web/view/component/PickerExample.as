package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.picker.IPickerSelectionDelegate;
	import com.custardbelly.as3flobile.controls.picker.Picker;
	import com.custardbelly.as3flobile.controls.picker.PickerColumn;
	
	import flash.display.Sprite;
	
	public class PickerExample extends Sprite implements IPickerSelectionDelegate
	{
		public function PickerExample()
		{
			var label:Label = new Label();
			label.text = "DropDown Example:";
			label.autosize = true;
			addChild( label );
			
			var dataProvider:Vector.<PickerColumn> = new Vector.<PickerColumn>();
			dataProvider.push( getPickerColumnMonths() );
			dataProvider.push( getPickerColumnDays( 50 ) );
			dataProvider.push( getPickerColumnYears( 80 ) );
			
			var picker:Picker = Picker.initWithDelegate( this );
			picker.y = 30;
			picker.dataProvider = dataProvider;
			picker.itemHeight = 50;
			addChild( picker );
		}
		
		protected function getPickerColumnDays( width:Number = Number.NaN ):PickerColumn
		{
			var column:PickerColumn = new PickerColumn();
			for( var i:int = 0; i < 31; i++ )
			{
				column.data.push( {label:( i + 1 ).toString()} );
			}
			column.width = width;
			return column;
		}
		
		protected function getPickerColumnMonths( width:Number = Number.NaN ):PickerColumn
		{
			var column:PickerColumn = new PickerColumn();
			column.data = [{label:"January"}, {label:"February"}, {label:"March"}, {label:"April"}, {label:"May"}, {label:"June"}, {label:"July"},
							{label:"August"}, {label:"September"}, {label:"October"}, {label:"November"}, {label:"December"}];
			column.width = width;
			return column;
		}
		
		protected function getPickerColumnYears( width:Number = Number.NaN ):PickerColumn
		{
			var column:PickerColumn = new PickerColumn( [] );
			var i:int = 50;
			while( --i > -1 )
			{
				column.data.push( {label: (1973 + i).toString()} );
			}
			column.width = width;
			return column;
		}
		
		public function pickerSelectionDidChange( picker:Picker, column:PickerColumn, index:int ):void
		{
			trace( "picker selection change: " + column.data[index].label );
		}
	}
}