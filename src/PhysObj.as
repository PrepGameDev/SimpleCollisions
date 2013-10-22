package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class PhysObj extends Sprite
	{
		//public var x:Number = 0
		//public var y:Number = 0
		public var vx:Number = 0
		public var vy:Number = 0
		public var ax:Number = 0
		public var ay:Number = 0
		public var damping:Number = .9
		public var g:Sprite
		
		public var detector:Boolean 
		public var collidable:Boolean
		
		public var minX:Number = 0
		public var maxX:Number = 0
		public var minY:Number = 0
		public var maxY:Number = 0
		
		public var colliding:Boolean = false
		
		
		
		public function PhysObj(width:Number=-1, height:Number=-1, detector:Boolean = false, collidable:Boolean = true) 
		{
			recalcBounds(width, height)
			
			this.g = g
			this.detector = detector
			this.collidable = collidable
			
		}
		public function recalcBounds(width:Number=-1, height:Number=-1):void {
			if (width < 0) width = this.width			
			if (height < 0) height = this.height
			minX = -width * .5
			maxX = width * .5
			minY = -height * .5
			maxY = height * .5
		}
		
		public function handleCollisonsWith(obj:PhysObj):Boolean {
			if (!obj.collidable || !this.collidable) return false
			
			var distX:Number = 0
			var distY:Number = 0
			if (minX + x > obj.maxX + obj.x) {
				return false
			}else {
				distX = (minX + x)-(obj.maxX + obj.x)
			}
			if (maxX + x < obj.minX + obj.x) {
				return false
			}else {
				var tempX:Number = (maxX + x) - (obj.minX + obj.x)
				if(tempX < -distX) distX = tempX
			}
			if (minY + y > obj.maxY + obj.y) {
				return false
			}else {
				distY = (minY + y)-(obj.maxY + obj.y)
			}
			if (maxY + y < obj.minY + obj.y) {
				return false
			}else {
				var tempY:Number = (maxY + y) - (obj.minY + obj.y)
				if(tempY < -distY) distY = tempY
			}
			//if (obj.vx * distX > 0) return
			//if (obj.vy * distY > 0) return
				
			obj.colliding = true
			if (!this.detector){
				if (Math.abs(distX) < Math.abs(distY)) {
					obj.x += distX
					obj.vx = 0
				}else {
					obj.y += distY
					obj.vy = 0
				}
			}
			
			return true
			trace("Contact", distX, distY)
		}
		
	}

}