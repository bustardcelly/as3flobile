/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ObjectPool.as</p>
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
package com.custardbelly.as3flobile.util
{
	import flash.utils.getDefinitionByName;

	/**
	 * ObjectPool is a generic, dynamic-sized IObjectPool implementation that creates instances based on classname.  
	 * @author toddanderson
	 */
	public class ObjectPool implements IObjectPool
	{
		protected var _type:String;
		protected var _pool:Array;
		
		/**
		 * Constructor. 
		 * @param type String The fully-qualified classname of the instance type to be created, retrieved and stored.
		 */
		public function ObjectPool( type:String, size:Number = Number.NaN )
		{
			_type = type;
			if( isNaN( size ) ) 
			{
				_pool = [];
			}
			else
			{
				_pool = new Array( int(size) );
			}
		}
		
		/**
		 * @copy IObjectPool#getInstance()
		 */
		public function getInstance( initProperties:Object = null ):Object
		{
			// If nothings in the pool, add one to pop.
			if( _pool.length == 0 )
			{
				var objectClass:Class = getDefinitionByName( _type ) as Class;
				var obj:Object = new objectClass();
				_pool[_pool.length] = obj;
			}
			// Remove and get reference to the last in the pool.
			var typeObject:Object = _pool.pop();
			// Try assign properties to instance based on argument.
			try
			{
				var property:String;
				for(property in initProperties)
				{
					typeObject[property] = initProperties[property];
				}
			}
			catch( e:Error ) 
			{
				// fail gracefully.
			}
			return typeObject;
		}
		
		/**
		 * @copy IObjectPool#returnInstance()
		 */
		public function returnInstance( value:Object ):void
		{
			_pool[_pool.length] = value;
		}
		
		/**
		 * @copy IObjectPool#length()
		 */
		public function length():int
		{
			return _pool.length;
		}
		
		/**
		 * @copy IObjectPool#flush()
		 */
		public function flush():void
		{
			_pool = [];
		}
		
		/**
		 * @copy IObjectPool#dispose()
		 */
		public function dispose():void
		{
			flush();
			_pool = null;
		}
	}
}