package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Main extends Sprite {
		//The graphical object containing our player (red circle)
		public var player:PhysObj 
		public var level:Sprite
		//A set of boolean properties (true or false) representing whether or not the W,S,A,D
		//	keys are being held down
		public var wIsDown:Boolean = false
		public var sIsDown:Boolean = false
		public var aIsDown:Boolean = false
		public var dIsDown:Boolean = false
		//The player's velocity in the X and Y direction
		//	velocity takes the unit pixels/frame
		//	-VX means we're moving left +VX means we're moving right
		//	-VY means we're moving up +VY means we're moving down (remember 0,0 is in the top left)
		public var playerVX:Number = 0
		public var playerVY:Number = 0
		//The player's acceleration in the X and Y direction
		//	acceleration takes the unit (pixels/frame)/frame -> (its the rate of the change in velocity per frame)
		public var playerAX:Number = 0
		public var playerAY:Number = 0
		//Note: if we set the FPS (frames per second) to 30, then each frame is equal to (1/30)seconds
		
		//A list of every Physics Object in the simulation
		public var physObjs:Vector.<PhysObj> = new Vector.<PhysObj>
		
		//the score
		public var score:Number = 0
		//A display object inside of the stage that we can use to scroll the objects on the screen
		//	By adding everything to the canvas instead of the stage we can move them in unison
		public var canvas:Sprite = new Sprite
		
		//The initial position of the player
		public var initialPlayerX:Number = 200
		public var initialPlayerY:Number = 200
		
		public function Main():void {		
			
			//Add the canvas to the stage
			stage.addChild(canvas)
			
			//instantiate the player
			player = new PhysObj()
			//draw it as a red circle with radius 20
			player.graphics.beginFill(0xFF0000)
			player.graphics.drawCircle(0, 0, 20)
			//recalculate the player's bounds, so that they match the width/height of the circle
			player.recalcBounds()
			//add the player to the list of physics objects
			physObjs.push(player)
			//add the player to the canvas
			canvas.addChild(player)
			//place the player at coordinates (200,200)
			player.x = initialPlayerX
			player.y = initialPlayerY
			
			//make a new level
			level = new Level1
			level.x = 300
			level.y = 300
			
			//create a list to hold a reference to each child in the level's display list
			var children:Vector.<DisplayObject> = new Vector.<DisplayObject>
			//parse the level's display list			
			for (var i:int = 0; i < level.numChildren; i++) {
				var s:DisplayObject = level.getChildAt(i);
				children[i] = s
			}
			//the previous step is necessary because when objects are added to a new display list, they are removed from any previous list
			//now that we have references to each display object in the level
			//	look for objects of the type PhysObj and add them to the canvas and the physics object list
			for (var i:int = 0; i < children.length; i++) {
				var s:DisplayObject = children[i]
				if (s is PhysObj) {
					var obj:PhysObj = PhysObj(s)
					physObjs.push(obj)
					obj.x += level.x
					obj.y += level.y
				}
				canvas.addChild(s)
			}
			
			//add a listener for the frame loop
			stage.addEventListener(Event.ENTER_FRAME, enterFrame)
			
			//add a listener for the key down and up events			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
		
		}
		
		public function enterFrame(e:Event = null):void {
			//Check which WSAD keys are being pressed and then apply the appropriate acceleration
			if(wIsDown){
				
			}else if(sIsDown){
				player.ay = 1
			}else {
				player.ay = 0
			}
			
			if(aIsDown){
				player.ax = -1
			}else if(dIsDown){
				player.ax = 1
			}else{
				player.ax = 0
			}
			//Always make the player's downward acceloration 2 (gravity)
			player.ay = 2
			//Set the colliding flag on the player to false
			//	If it is still colliding with something it will be set to true in the following loop
			player.colliding = false
			//Go through every physics object, integrate its velocity and acceloration, and test for collisions against the player
			for (var i:int = 0; i < physObjs.length; i++) {				
				var obj:PhysObj = physObjs[i];
				//Integrate acceleration
				obj.vx += obj.ax
				obj.vy += obj.ay
				//Apply damping to velocity
				obj.vx *= obj.damping
				obj.vy *= obj.damping
				//Integrate velocity
				obj.x += obj.vx
				obj.y += obj.vy
				//Note: the integrals above are approximations... we are not using calculus
				
				//if the object is not the player 
				if (obj != player) {
					//And a collectable
					if (obj is Collectable) {
						//test for collisions
						if (obj.handleCollisonsWith(player)) {
							//add 10 to the score
							score += 10
							//remove the collectable from the stage
							canvas.removeChild(obj)
							//remove the collectable from the list of physics objects
							physObjs.splice(physObjs.indexOf(obj), 1)
							//trace the score so we know what it is (NOTE: this only works in debug mode)
							trace("SCORE:	", score)
						}
					//if the object is not a collectable, then it is a block
					}else {
						//test for and resolve collisions between the player and the block
						obj.handleCollisonsWith(player)
					}
				}
				
			}
			//Move the Canvas according the the player's motion so that the player is always in
			//	the same place with reference to the stage.
			canvas.x = -player.x+initialPlayerX
			canvas.y = -player.y+initialPlayerY
			
			
		}
		
		public function keyDown(e:KeyboardEvent):void {
			//Check which key was pressed
			if (e.keyCode == 87) {
				wIsDown = true
				//if the player is colliding with a block allow it to jump when we press "W"
				if(player.colliding)player.vy = -25
			}
			if (e.keyCode == 83) {
				sIsDown = true				
			}
			if (e.keyCode == 65) {
				aIsDown = true				
			}
			if (e.keyCode == 68) {
				dIsDown = true				
			}		
		}
		public function keyUp(e:KeyboardEvent):void {
			//Check which key was released
			if(e.keyCode == 87){
				wIsDown = false
			}
			if(e.keyCode == 83){
				sIsDown = false
			}
			if(e.keyCode == 65){
				aIsDown = false
			}
			if(e.keyCode == 68){
				dIsDown = false
			}
		}
		
	}
	
}