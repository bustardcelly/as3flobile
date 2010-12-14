/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: PickerColumn.as</p>
 * <p>Version: 0.3</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */
package com.custardbelly.as3flobile.controls.picker
{
	import com.custardbelly.as3flobile.controls.list.layout.IScrollListVerticalLayout;
	import com.custardbelly.as3flobile.controls.list.renderer.DefaultScrollListItemRenderer;
	import com.custardbelly.as3flobile.controls.picker.layout.PickerColumnVerticalLayout;
	import com.custardbelly.as3flobile.controls.picker.renderer.PickerColumnItemRenderer;
	
	import flash.utils.getQualifiedClassName;

	/**
	 * PickerColumn is a model representing the data used in a single scroll list for a Picker control. 
	 * @author toddanderson
	 */
	public class PickerColumn
	{
		protected var _width:Number;
		protected var _itemRenderer:String;
		protected var _layout:IScrollListVerticalLayout;
		protected var _data:Array;
		
		protected var _defaultLayout:IScrollListVerticalLayout;
		protected var _defaultItemRenderer:String;
		
		/**
		 * Constructor. 
		 * @param data Array A generic array of objects. The defined itemRenderer should know how to handle the items in this array.
		 * @param itemRenderer String The fully-qualified classname of the itemRenderer.
		 * @param width Number The optional defined width of the column
		 */
		public function PickerColumn( data:Array = null, itemRenderer:String = null, layout:IScrollListVerticalLayout = null, width:Number = Number.NaN )
		{
			_width = width;
			_itemRenderer = ( itemRenderer ) ? itemRenderer : getDefaultItemRenderer();
			_layout = ( layout ) ? layout : getDefaultLayout();
			_data = ( data ) ? data : [];
		}
		
		/**
		 * Returns the default item renderer to render eahc item of data found on this model. 
		 * @return String
		 */
		public function getDefaultItemRenderer():String
		{
			if( _defaultItemRenderer == null ) 
			{
				_defaultItemRenderer = getQualifiedClassName( PickerColumnItemRenderer );
			}
			return _defaultItemRenderer;
		}
		
		/**
		 * Returns the default layout to display items in a column list. 
		 * @return IScrollListVerticalLayout
		 */
		public function getDefaultLayout():IScrollListVerticalLayout
		{
			if( _defaultLayout == null )
			{
				_defaultLayout = new PickerColumnVerticalLayout();
			}
			return _defaultLayout;
		}

		/**
		 * Accessor/Modifier for the target width of this column. Default is Number.NAN which will be handled as a percentage within the Picker control. 
		 * @return Number
		 */
		public function get width():Number
		{
			return _width;
		}
		public function set width( value:Number ):void
		{
			_width = value;
		}
		
		/**
		 * Accessor/Modifier of the item renderer class name to render each item within the data found on this model. 
		 * @return String The fully-qualified class name of the item renderer.
		 */
		public function get itemRenderer():String
		{
			return _itemRenderer;
		}
		public function set itemRenderer( value:String ):void
		{
			_itemRenderer = value;
		}
		
		/**
		 * Accessor/Modifier of the layout instance to used when displaying items within a column list. Default is null. 
		 * @return IScrollListVerticalLayout
		 */
		public function get layout():IScrollListVerticalLayout
		{
			return _layout;
		}
		public function set layout(value:IScrollListVerticalLayout):void
		{
			_layout = value;
		}

		/**
		 * Accessor/Modifier for the payload of data to be rendered by the item renderer. 
		 * @return Array
		 */
		public function get data():Array
		{
			return _data;
		}
		public function set data( value:Array ):void
		{
			_data = value;
		}
	}
}