package com.custardbelly.as3flobile.example.web.view.component
{
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.button.IButtonDelegate;
	import com.custardbelly.as3flobile.controls.button.IToggleButtonDelegate;
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.menu.IMenuDisplayDelegate;
	import com.custardbelly.as3flobile.controls.menu.IMenuSelectionDelegate;
	import com.custardbelly.as3flobile.controls.menu.Menu;
	import com.custardbelly.as3flobile.controls.menu.MenuItem;
	import com.custardbelly.as3flobile.controls.menu.panel.IMenuPanelDisplay;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	public class MenusExample extends Sprite implements IButtonDelegate, IToggleButtonDelegate, IMenuDisplayDelegate, IMenuSelectionDelegate
	{
		[Embed(source="/assets/more_icon.png")]
		public var moreIconClass:Class;
		
		[Embed(source="/assets/info_icon.png")]
		public var infoIconClass:Class;
		
		protected var sprite:Sprite;
		protected var toggle:ToggleButton;
		protected var backButton:Button;
		protected var menu:Menu;
		protected var isShown:Boolean;
		
		private static const MENU_ORIGIN:Point = new Point( 0, 330 );
		
		public function MenusExample()
		{
			var label:Label = new Label();
			label.text = "Menus Example:";
			label.autosize = true;
			addChild( label );
			
			label = new Label();
			label.multiline = true;
			label.autosize = true;
			label.width = 300;
			label.y = 30;
			label.text = "A Menu is a composite control of submenu displays that shows a maximum amount of items in each panel.";
			addChild( label );
			
			sprite = new Sprite();
			sprite.y = 90;
			sprite.graphics.beginFill( 0x333333 );
			sprite.graphics.drawRect( 0, 0, 240, 330 );
			addChild( sprite );
			
			var text:Label = new Label();
			text.autosize = true;
			text.multiline = true;
			text.text = "This is a display that has an associated menu.";
			text.format = new ElementFormat( new FontDescription( "DroidSans" ), 12, 0xFFFFFF );
			text.y = 10;
			text.x = 10;
			text.width = 220;
			sprite.addChild( text );
			
			var shape:Shape = new Shape();
			shape.y = 90;
			shape.graphics.beginFill( 0, 0 );
			shape.graphics.drawRect( 0, 0, 240, 330 );
			addChild( shape );
			sprite.mask = shape;
			
			menu = Menu.initWithDelegates( this, this );
			menu.width = 240;
			menu.moreMenuItem = new MenuItem( "More", new moreIconClass() as Bitmap );
			menu.dataProvider = getMenuItems( 40 );
//			var subConfigMenuPanelDisplayContextxt = neMenuPanelDisplayContextext( getQualifiedClassName( MenuPanel ) );
//			subConfig.layoutType = getQualifiedClassName( GridMenuLayout );
//			menu.submenuPanelConfiguration = subConfig;
			
			toggle = ToggleButton.initWithDelegate( this );
			toggle.y = 430;
			toggle.label = "show";
			addChild( toggle );
			
			backButton = Button.initWithDelegate( this );
			backButton.x = 110;
			backButton.y = 430;
			backButton.label = "back";
			backButton.enabled = false;
			addChild( backButton );
			
//			var btn:Button = new Button();
//			btn.addEventListener( MouseEvent.CLICK, handleInflate );
//			btn.y = 430;
//			btn.x = 220;
//			btn.label = "change";
//			addChild( btn );
		}
		
		protected function randomRange( min:int, max:int ):int
		{
			return Math.random() * (max - min + 1) + min;
		}
		
		protected function getMenuItems( amount:int ):Vector.<MenuItem>
		{
			var menuItems:Vector.<MenuItem> = new Vector.<MenuItem>();
			var i:int;
			var icon:Bitmap;
			for( i = 0; i < amount; i++ )
			{
				icon = new infoIconClass() as Bitmap;
				menuItems.push( new MenuItem( "item " + i, icon ) );
			}
			return menuItems;
		}
		
		protected function handleInflate( evt:Event ):void
		{
			menu.dataProvider = getMenuItems( randomRange( 3, 36 ) );
		}
		
		public function buttonTapped( button:Button ):void
		{
			if( button.label == "back" ) menu.back();
		}
		
		public function toggleButtonSelectionChange( button:ToggleButton, selected:Boolean ):void
		{
			isShown = selected;
			if( isShown )
			{
				button.label = "hide";
				menu.open( sprite, MENU_ORIGIN );
			}
			else
			{
				button.label = "show";
				menu.close();
			}
		}			
		public function menuDidOpen( menu:Menu, menuPanel:IMenuPanelDisplay ):void
		{
			isShown = menu.isActive();
			backButton.enabled = isShown;
		}
		public function menuDidClose( menu:Menu, menuPanel:IMenuPanelDisplay ):void
		{
			isShown = menu.isActive();
			backButton.enabled = isShown;
			if( !isShown ) toggle.selected = false;
		}
		public function menuSelectionChange( menu:Menu, selectedItem:MenuItem ):Boolean
		{
			return true;
		}
	}
}