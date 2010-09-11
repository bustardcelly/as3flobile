package
{
	import com.custardbelly.as3flobile.controls.label.Label;
	import com.custardbelly.as3flobile.controls.menu.Menu;
	import com.custardbelly.as3flobile.controls.menu.MenuItem;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	public class Page extends Sprite
	{
		protected var _titleField:Label;
		protected var _bodyField:Label;
		protected var _width:int;
		protected var _height:int;
		protected var _title:String;
		protected var _body:String;
		protected var _menuData:Vector.<MenuItem>;
		protected var _color:uint;
		
		protected var _mask:Shape;
		protected var _modalSprite:Sprite;
		protected var _menu:Menu;
		
		public function Page()
		{
			super();
			_width = 300;
			_height = 600;
			createChildren();
		}

		protected function createChildren():void
		{
			_titleField = new Label();
			_titleField.autosize = true;
			_titleField.width = _width;
			_titleField.format = new ElementFormat( new FontDescription( "DroidSans" ), 20, 0xFFFFFF );
			addChild( _titleField );
			
			_bodyField = new Label();
			_bodyField.autosize = true;
			_bodyField.multiline = true;
			_bodyField.width = _width;
			_bodyField.format = new ElementFormat( new FontDescription( "DroidSans" ), 16, Math.random() * 0xFFFFFF );
			addChild( _bodyField );
			
			_mask = new Shape();
			addChild( _mask );
			
			_modalSprite = new Sprite();
			_modalSprite.addEventListener( MouseEvent.CLICK, handleClick, false, 0, true );
		}
		
		protected function position():void
		{
			_titleField.x = 10;
			_titleField.y = 10;
			
			_bodyField.x = 10;
			_bodyField.y = _titleField.y + _titleField.height + 10;
		}
		
		protected function invalidateSize():void
		{
			_titleField.width = _width - 20;
			_bodyField.width = _width - 20;
			
			position();
			updateColor();
			updateMask();
		}
		
		protected function updateTitle():void
		{
			_titleField.text = _title;
			position();
		}
		
		protected function updateBody():void
		{
			_bodyField.text = _body;
			position();
		}
		
		protected function updateColor():void
		{
			graphics.clear();
			graphics.beginFill( _color );
			graphics.drawRect( 0, 0, _width, _height );
			graphics.endFill();
		}
		
		protected function updateMask():void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill( 0 );
			_mask.graphics.drawRect( 0, 0, _width, _height );
			_mask.graphics.endFill();
			this.mask = _mask;
			
			_modalSprite.graphics.clear();
			_modalSprite.graphics.beginFill( 0, 0 );
			_modalSprite.graphics.drawRect( 0, 0, _width, _height );
			_modalSprite.graphics.endFill();
		}
		
		protected function handleClick( evt:MouseEvent ):void
		{
			if( _menu != null )
			{
				_menu.close();	
			}
		}
		
		public function showMenu( menu:Menu ):void
		{
			addChild( _modalSprite );
			
			_menu = menu;
			menu.dataProvider = _menuData;
			menu.width = _width;
			menu.open( this, new Point( 0, _height ) );
		}
		
		public function onMenuClose():void
		{
			removeChild( _modalSprite );
		}
		
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
			updateTitle();
		}

		public function get body():String
		{
			return _body;
		}
		public function set body(value:String):void
		{
			_body = value;
			updateBody();
		}
		
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			_color = value;
			updateColor();
		}

		public function get menuData():Vector.<MenuItem>
		{
			return _menuData;
		}
		public function set menuData(value:Vector.<MenuItem>):void
		{
			_menuData = value;
		}	
		
		override public function get width():Number
		{
			return _width;
		}
		override public function set width( value:Number ):void
		{
			_width = value;
			invalidateSize();
		}
		override public function get height():Number
		{
			return _height;
		}
		override public function set height( value:Number ):void
		{
			_height = value;
			invalidateSize();
		}
	}
}