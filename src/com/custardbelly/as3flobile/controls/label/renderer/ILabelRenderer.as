/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ILabelRenderer.as</p>
 * <p>Version: 0.2</p>
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
package com.custardbelly.as3flobile.controls.label.renderer
{
	import flash.text.engine.TextElement;

	/**
	 * ILabelRenderer is responsible for the rendering and layout of a Label component. 
	 * @author toddanderson
	 */
	public interface ILabelRenderer
	{
		/**
		 * Invokes the rendering process for text lines based on element and dimensions. 
		 * @param element TextElement
		 * @param width int
		 * @param height int
		 */
		function render( element:TextElement, width:int, height:int ):void;
		/**
		 * Performs any cleanup.
		 */
		function dispose():void;
		
		/**
		 * Accessor/Modifier for the textual content to be used on truncation. 
		 * @return Boolean
		 */
		function get truncationText():String;
		function set truncationText( value:String ):void;
		
		/**
		 * Accessor/Modifier for the alignment of each text line. Valid values ae those from flash.text.TextFormatAlign.
		 * @return String
		 */
		function get textAlign():String;
		function set textAlign( value:String ):void;
	}
}