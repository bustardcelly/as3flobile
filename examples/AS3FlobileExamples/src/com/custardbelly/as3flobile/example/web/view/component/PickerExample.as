package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.picker.Picker;
	import com.custardbelly.as3flobile.controls.picker.PickerColumn;
	
	import flash.display.Sprite;
	
	public class PickerExample extends Sprite
	{
		protected var labels:Array;
		protected var picker:Picker;
		public function PickerExample()
		{
			var label:Label = new Label();
			label.text = "Picker Example:";
			label.autosize = true;
			addChild( label );
			
			label = new Label();
			label.multiline = true;
			label.autosize = true;
			label.width = 300;
			label.y = 30;
			label.text = "A Picker control is a collection of scroll lists allowing you do select multiple items. The following is an example of a Date Chooser using the Picker control.";
			addChild( label );
			
			labels = [];
			
			label = new Label();
			label.autosize = true;
			label.x = 4;
			label.y = 120;
			addChild( label );
			labels.push( label );
			
			label = new Label();
			label.autosize = true;
			label.y = 120;
			label.x = 165;
			addChild( label );
			labels.push( label );
			
			label = new Label();
			label.autosize = true;
			label.y = 120;
			label.x = 220;
			addChild( label );
			labels.push( label );
			
			var dataProvider:Vector.<PickerColumn> = new Vector.<PickerColumn>();
			dataProvider.push( getPickerColumnMonths() );
			dataProvider.push( getPickerColumnDays( 50 ) );
			dataProvider.push( getPickerColumnYears( 80 ) );
			
			picker = new Picker();
			picker.selectionChange.add( pickerSelectionDidChange );
			picker.y = 150;
			picker.dataProvider = dataProvider;
			picker.itemHeight = 50;
			addChild( picker );
			
			var date:Date = new Date();
			picker.setSelectedIndex( date.getMonth(), 0 );
			picker.setSelectedIndex( date.getDate() - 1, 1 );
			picker.setSelectedIndex( getIndexFromYear( date.getFullYear(), dataProvider[2].data ), 2 );
		}
		
		protected function getIndexFromYear( year:Number, data:Array ):int
		{
			var i:int = data.length;
			while( --i > -1 )
			{
				if( data[i].label == year.toString() ) return i;
			}
			return 0;
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
				column.data.push( {label:(1973 + i).toString()} );
			}
			column.width = width;
			return column;
		}
		
		public function pickerSelectionDidChange( column:PickerColumn, index:int ):void
		{
			var columnIndex:int = picker.dataProvider.indexOf( column );
			labels[columnIndex].text = column.data[index].label;
		}
	}
}