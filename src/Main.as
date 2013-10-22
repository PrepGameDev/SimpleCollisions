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
		
		public var physObjs:Vector.<PhysObj> = new Vector.<PhysObj>
		
		public var score:Number = 0
		
		
		public function Main():void {
			//Draw a red circle with radius 20 into our player Sprite
			//var s:Sprite = new Sprite
			
			//Add the sprite to the stage
			//player.g = s
			player = new PhysObj()
			player.graphics.beginFill(0xFF0000)
			player.graphics.drawCircle(0, 0, 20)
			player.recalcBounds()
			physObjs.push(player)
			stage.addChild(player)
			//place the player at coordinates (200,200)
			player.x = 200
			player.y = 200
			
			//var s2:Sprite = new Sprite
			
			//obstacle = new PhysObj()			
			//obstacle.graphics.beginFill(0x00FF00)
			//obstacle.graphics.drawRect( -20, -20, 40, 40)
			//obstacle.recalcBounds()
			
			level = new Level1
			level.x = 300
			level.y = 300
			stage.addChild(level)
			
			var children:Vector.<DisplayObject> = new Vector.<DisplayObject>
			for (var i:int = 0; i < level.numChildren; i++) {
				var s:DisplayObject = level.getChildAt(i);
				children[i] = s
			}
			
			for (var i:int = 0; i < children.length; i++) {
				var s:DisplayObject = children[i]
				if (s is PhysObj) {
					var obj:PhysObj = PhysObj(s)
					physObjs.push(obj)
					obj.x += level.x
					obj.y += level.y
				}
				stage.addChild(s)
			}
			
			
			//physObjs.push(obstacle)
			//stage.addChild(obstacle)
			//obstacle.x = 300
			//obstacle.y = 300
			
			//add a listener for the frame loop
			stage.addEventListener(Event.ENTER_FRAME, enterFrame)
			
			//add a listener for the key down and up events			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
		
		}
		
		public function enterFrame(e:Event = null):void {
			//Check which WSAD keys are being pressed and then apply the appropriate acceleration
			if(wIsDown){
				//player.vy = -25
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
			
			player.ay = 2
			player.colliding = false
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
				
				if (obj != player) {
					if(obj is Collectable){
						if (obj.handleCollisonsWith(player)) {
							score += 10
							stage.removeChild(obj)
							physObjs.splice(physObjs.indexOf(obj), 1)
							trace("SCORE:	", score)
						}
					}else {
						obj.handleCollisonsWith(player)
					}
				}
				//obj.updateGraphics()
			}
			//player.updateGraphics()
			
			//trace(player.colliding)
			
		}
		
		public function keyDown(e:KeyboardEvent):void {
			//Check which key was pressed
			if (e.keyCode == 87) {
				wIsDown = true
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