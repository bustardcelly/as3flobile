package com.custardbelly.as3flobile.controls.list
{
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;

	public interface IScrollListLayoutTarget
	{
		/**
		 * Adds an IScrollListItemRenderer instance to the display of the layout target. 
		 * @param renderer IScrollListItemRenderer
		 */
		function addRendererToDisplay( renderer:IScrollListItemRenderer ):void;
		/**
		 * Removes the IScrollListItemRenderer instance from the display of the layout target. 
		 * @param renderer IScrollListItemRenderer
		 */
		function removeRendererFromDisplay( renderer:IScrollListItemRenderer ):void;
		/**
		 * Runs a refesh on the display due to a change in content from the layout.
		 */
		function commitContentChange():void;
	}
}