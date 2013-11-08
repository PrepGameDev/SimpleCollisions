package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class PhysObj extends Sprite
	{
		//x, and y are inherited by Sprite
		//This gives us the advantage of not needing a seperate graphical object
		//The physics object is the graphical object
		
		//The velocity of the object
		public var vx:Number = 0
		public var vy:Number = 0
		//The acceloration of the object
		public var ax:Number = 0
		public var ay:Number = 0
		//The damping (air resistance) of the object
		public var damping:Number = .9
		
		public var g:MovieClip
		
		//Flags determining whether or not the object is a detector (an object that listens for collisions but does not resolve them)
		//	or collidable (an object that will factor into collision detection and resolution)
		public var detector:Boolean 
		public var collidable:Boolean
		
		//The min/max, X/Y, values of the collision bounderies
		//	This is defined by a box aligned to the X and Y axis
		public var minX:Number = 0
		public var maxX:Number = 0
		public var minY:Number = 0
		public var maxY:Number = 0
		
		//A flag who's value is changed depending on whether or not the object is colliding with something
		//	At this point only the player's colliding flag changes
		public var colliding:Boolean = false
		
		
		
		public function PhysObj(width:Number=-1, height:Number=-1, detector:Boolean = false, collidable:Boolean = true):void {
			//recalculate the bounds from the get go
			recalcBounds(width, height)			
			//Define public flags by parameter input
			this.detector = detector
			this.collidable = collidable			
		}
		//Recalculate the bounds of the object by the width and height of its graphical components
		//	Alternately a custom width and height can be set with the corresponding parameters.
		public function recalcBounds(width:Number=-1, height:Number=-1):void {
			if (width < 0) width = this.width			
			if (height < 0) height = this.height
			minX = -width * .5
			maxX = width * .5
			minY = -height * .5
			maxY = height * .5
		}
		
		//Detect collisions with obj
		//	In this case obj is always the player
		// NOTE: this code only works if the obj is the player. It does not work in the general case
		public function handleCollisonsWith(obj:PhysObj):Boolean {
			//if either object being sampled is flagged as not collidable just return false
			if (!obj.collidable || !this.collidable) return false
			
			//instantiate distX,distY
			var distX:Number = 0
			var distY:Number = 0
			
			//Find axis where the shapes overlap
			//	By the Seperating Axis Theorem if the shapes do not overlap along any axis, they are not touching
			// 	in which case we can end the function early. During the collsion detection step the distances along 
			//	each axis are stored.			
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
			
			//If we get to this point obj is for sure colliding with this 
			obj.colliding = true
			//If this is not a detector resolve the collisions
			if (!this.detector) {
				//Find the shortest distance between each shape and determine the axis of resolution.
				//	Then translate obj (always the player) outside of "this" along that axis.
				if (Math.abs(distX) < Math.abs(distY)) {
					obj.x += distX
					obj.vx = 0
				}else {
					obj.y += distY
					obj.vy = 0
				}
			}
			
			//There was a collision: return true
			return true
		}
		
	}

}