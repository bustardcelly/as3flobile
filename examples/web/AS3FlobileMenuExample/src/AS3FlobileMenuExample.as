package
{
	import com.custardbelly.as3flobile.android.control.menu.AndroidMenu;
	import com.custardbelly.as3flobile.android.control.menu.panel.IMenuPanelDisplay;
	import com.custardbelly.as3flobile.android.model.menu.MenuItem;
	import com.custardbelly.as3flobile.controls.button.Button;
	import com.custardbelly.as3flobile.controls.button.ToggleButton;
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.signal.CancelableSignal;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormatAlign;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	import org.osflash.signals.events.GenericEvent;
	
	public class AS3FlobileMenuExample extends Sprite
	{
		protected var view:Sprite;
		protected var menu:AndroidMenu;
		
		protected var _pageIndex:int;
		
		protected var _nextPageButton:Button;
		protected var _prevPageButton:Button;
		
		protected var _menuButton:ToggleButton;
		protected var _backButton:Button;
		
		protected var _currentPage:Page;
		protected var _pages:Vector.<Page>;
		
		public function AS3FlobileMenuExample()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT; 
			
			_pages = new Vector.<Page>();
			
			createChildren();
			this.stage.addEventListener( Event.RESIZE, handleResize );
			handleResize( null );
			
			setPage( _pageIndex );
		}
		
		protected function createChildren():void
		{
			view = new Sprite();
			addChild( view );
			
			var label:Label = new Label();
			label.format = new ElementFormat( new FontDescription( "DroidSans" ), 36 );
			label.width = 470;
			label.y = 5;
			label.textAlign = TextFormatAlign.RIGHT;
			label.text = "AS3Flobile: Menu";
			view.addChild( label );
			
			var linkFormat:ElementFormat = new ElementFormat( new FontDescription( "DroidSans" ), 14, 0x0000FF );
			var linkHandler:EventDispatcher = new EventDispatcher();
			linkHandler.addEventListener( MouseEvent.CLICK, handleLink );
			var link:TextElement = new TextElement( "http://github.com/bustardcelly/as3flobile", linkFormat, linkHandler );
			var block:TextBlock = new TextBlock();
			block.content = link;
			var line:TextLine = block.createTextLine();
			line.y = 60;
			line.x = 182;
			view.addChild( line );
			
			menu = new AndroidMenu();
			menu.openSignal.add( menuDidOpen );
			menu.closeSignal.add( menuDidClose );
			menu.selectionChange.add( menuSelectionChange );
			
			label = new Label();
			label.x = 354;
			label.y = 715;
			label.text = "page actions";
			view.addChild( label );
			
			_prevPageButton = new Button();
			_prevPageButton.tap.add( buttonTapped );
			_prevPageButton.label = "<<";
			_prevPageButton.y = 740;
			_prevPageButton.x = 330;
			_prevPageButton.width = 60;
			view.addChild( _prevPageButton );
			
			_nextPageButton = new Button();
			_nextPageButton.tap.add( buttonTapped );
			_nextPageButton.label = ">>";
			_nextPageButton.x = 400;
			_nextPageButton.y = 740;
			_nextPageButton.width = 60;
			view.addChild( _nextPageButton );
			
			label = new Label();
			label.x = 85;
			label.y = 715;
			label.text = "menu actions";
			view.addChild( label );
			
			_menuButton = new ToggleButton();
			_menuButton.toggle.add( toggleButtonSelectionChange );
			_menuButton.label = "show menu";
			_menuButton.y =  740;
			_menuButton.x = 20;
			view.addChild( _menuButton );
			
			_backButton = new Button();
			_backButton.tap.add( buttonTapped );
			_backButton.label = "back";
			_backButton.y = 740;
			_backButton.x = 130;
			_backButton.enabled = false;
			view.addChild( _backButton );
			
			createPages( 8 );
		}
		
		protected function createPages( amount:int ):void
		{
			var i:int;
			var page:Page;
			for( i = 0; i < amount; i++ )
			{
				page = new Page();
				page.x = 10;
				page.y = 70;
				page.width = 460;
				page.height = 630;
				page.title = "Page " + ( i + 1 );
				page.body = "The as3flobile Menu component is a composite control of menu panels; considering the first panel as the Main Menu, and any subsequent panels create (as a result of overflow) as SubMenu. A single Menu control is used throughout all the pages and grabs resources from a re-use pool of elements and models as needed.\n\nUse the Page Action buttons below to navigate to pages that have specific content related to their menu options.\n\nUse the Menu Action buttons below to show, hide or move the menu within its history.\n\nLorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat"
				page.color = ( i == 0 ) ? 0xDDDDDD : Math.random() * 0xFFFFFF;
				page.menuData = getMenuData( randomRange( 1, 10 ), "pg" + ( i + 1 ) );
				_pages.push( page );
			}
			
			var border:Shape = new Shape();
			border.graphics.lineStyle( 4, 0x666666, 1, true, "normal", "square", "miter" );
			border.graphics.drawRect( 8, 68, 464, 634 );
			view.addChild( border );
		}
		
		protected function getMenuData( amount:int, prefix:String ):Vector.<MenuItem>
		{
			var i:int;
			var item:MenuItem;
			var items:Vector.<MenuItem> = new Vector.<MenuItem>();
			for( i = 0; i < amount; i++ )
			{
				item = new MenuItem( prefix + " op." + ( i + 1 ) );
				items.push( item );
			}
			return items;
		}
		
		protected function randomRange( min:int, max:int ):int
		{
			return Math.random() * (max - min + 1) + min;
		}
		
		protected function setPage( index:int ):void
		{
			if( _currentPage != null )
			{
				view.removeChild( _currentPage );
			}
			menu.close();
			_currentPage = _pages[index];
			_pageIndex = index;
			view.addChild( _currentPage );
		}
		
		protected function handleResize( evt:Event ):void
		{
			var scale:Number = 1;
			if( stage.stageWidth != 480 || stage.stageHeight != 800 )
			{
				scale = Math.min( stage.stageWidth / 480, stage.stageHeight / 800 );
			}
			view.scaleX = ( scale > 1 ) ? 1 : scale;
			view.scaleY = ( scale > 1 ) ? 1 : scale;
		}
		
		protected function handleLink( evt:MouseEvent ):void
		{
			navigateToURL( new URLRequest( "http://github.com/bustardcelly/as3flobile" ) );
		}
		
		public function buttonTapped( evt:GenericEvent ):void
		{
			var button:Button = evt.target as Button;
			if( button == _prevPageButton )
			{
				if( --_pageIndex < 0 )
				{
					++_pageIndex;
				}
				else
				{
					setPage( _pageIndex );
				}
			}
			else if( button == _nextPageButton )
			{
				if( ++_pageIndex > _pages.length - 1 )
				{
					--_pageIndex;
				}
				else
				{
					setPage( _pageIndex );
				}	
			}
			else if( button == _backButton )
			{
				menu.back();		
			}
		}
		
		public function toggleButtonSelectionChange( evt:GenericEvent ):void
		{
			var toggleButton:ToggleButton = evt.target as ToggleButton;
			var selected:Boolean = toggleButton.selected;
			if( selected )
			{
				_currentPage.showMenu( menu );
				toggleButton.label = "hide menu";
			}
			else
			{
				menu.close();
				toggleButton.label = "show menu";
			}
		}
		
		public function menuSelectionChange( menu:AndroidMenu, item:MenuItem, signal:CancelableSignal ):void
		{
			// set evt.false to stop close of menu.
			signal.preventDefault();
		}
		public function menuDidOpen( menu:AndroidMenu, menuPanel:IMenuPanelDisplay ):void
		{
			var isShown:Boolean = menu.isActive();
			_backButton.enabled = isShown;
			_prevPageButton.enabled = !isShown;
			_nextPageButton.enabled = !isShown;
		}
		public function menuDidClose( menu:AndroidMenu, menuPanel:IMenuPanelDisplay ):void
		{
			var isShown:Boolean = menu.isActive();
			_backButton.enabled = isShown;
			_prevPageButton.enabled = !isShown;
			_nextPageButton.enabled = !isShown;
			if( !isShown )
			{
				_menuButton.selected = false;
				_currentPage.onMenuClose();
			}
		}
	}
}