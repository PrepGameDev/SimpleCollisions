package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	/*TODO: Animate 1) Make your player more interesting.
						1. In Player.fla double click the player object
						2. Look at it's timeline. There is a layer called yourStuff and one called Template
						3. Draw your player's animation inside the yourStuff layer
						4. Start by following the template. Make a stop frame, 4 walking frames, and 1 jumping frame.
						5. If you want to get rid of the template just click the dot on the timeline underneathe the eye.
							This will make it invisible.
						6. If you've already begun this step in another file, you can open both and copy the contents of each frame
							to the new one. */
	/*TODO: Animate 2) Make your level more interesting.
	  					1. In Assets.fla double click the level object on one of the blocks
						2. Now that your inside the level object copy and paste the objects inside it to
							make your level bigger and more interesting
						3. If you would like you can change the graphics for the blue blocks and the green circles.
							Just double click one of them and change the graphics to something more interesting.
							(any change you make to one should apply to all of them)*/
							
	/*TODO: Animate 3) Make a background
	  					1. In Assets.fla draw a background anywhere. Try to use low saturation colors so you can tell
							the level from the background. If you don't know what that means ask me.
						2. Make the background a symbol, name it Background and check export for actionscript.
							The default base class of MovieClip will be fine. No need to change it.
						3. Press CTRL+ENTER to export
						4. In Flash Develop add the line stage.addChildAt(new Background, 0).
						Check: Press CTRL+Enter and see the magic. (if its too small scale it up in Flash Pro and repeat step 3)
						*/
	
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
		
		/*TODO: 7A) Make a new variable called scoreText of the type TextField
					Hint: canvas is a variable called canvas of the type Sprite*/
		
		//the center of the screen
		public var screenCenterX:Number 
		public var screenCenterY:Number 
		
		//The frame our player animation is in
		public var playerFrame:int = 0
		//Points on the timeline for our player animation
		public var stopFrame:int = 1
		public var minWalkFrame:int = 2
		public var maxWalkFrame:int = 5
		public var jumpFrame:int = 6
		
		
		
		
		public function Main():void {
			
			screenCenterX = stage.stageWidth/2
			screenCenterY = stage.stageHeight / 2
			//TODO: 2) change the way the screen is centered	
			
			//Add the canvas to the stage
			stage.addChild(canvas)
			
			/*TODO: 7B) add scoreText to the stage
						Hint: canvas was added to the stage in the last line*/
			
			//instantiate the player
			player = new PhysObj()
			
			player = new Player()
			//player.addChild(player.g)
			player.recalcBounds()
			
			//draw it as a red circle with radius 20
			//player.graphics.beginFill(0xFF0000)
			//player.graphics.drawCircle(0, 0, 20)
			//recalculate the player's bounds, so that they match the width/height of the circle
			player.recalcBounds()
			//add the player to the list of physics objects
			physObjs.push(player)
			//add the player to the canvas
			canvas.addChild(player)
			
			
			//place the player at coordinates (200,200)
			player.x = 200
			player.y = 200
			//TODO: 1) change player's coordinates
			
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
			
			/*TODO: 7D) It looks pretty small. Lets make it bigger.
						Change scoreText.scaleX and scoreText.scaleY to 2*/
			
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
			/*TODO: 6C) Make player.touchingGround false at the beginning of every frame so
			  			that if it isn't made true in the collision detection stage it is false*/
			
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
							//TODO: 4) increase the amount of points the player gets per pickup
							
							//remove the collectable from the stage
							canvas.removeChild(obj)
							//remove the collectable from the list of physics objects
							physObjs.splice(physObjs.indexOf(obj), 1)
							//trace the score so we know what it is (NOTE: this only works in debug mode)
							trace("SCORE:	", score)
							
						
							/*TODO: 7C) make scoreText.text equal to the score
										Hint: when you compile you will get an error message
										try doing ""+score or "Score: "+score
										-When you get it working collect a green thing and check the top left corner*/
							
						}				
						
					/*TODO: 8C) type: }else if(obj is BadThing){
								Then below that you can figure out the rest.
								The bad thing should lower your score. So you can pretty much copy the lines above
								but do score -= somenumber instead of += 
								Check: Compile it with CTRL+Enter. If you've done everything right your score should be lowered
										when you touch the red circles. And they should disapear when touched. 
								!!!HOOORAY You've finished the hardest challege!!! Now your a true game developer!!!*/
					
					
					//if the object is not a collectable, then it is a block
					}else {
						//test for and resolve collisions between the player and the block
						obj.handleCollisonsWith(player)
					}
				}
				
			}
			//Move the Canvas according the the player's motion so that the player is always in
			//	the same place with reference to the stage.
			canvas.x = -player.x + screenCenterX			
			canvas.y = -player.y + screenCenterY
			
			//handle player run animation
			if (player.colliding) {
				//if were going slow enough use stop animation
				if (Math.abs(player.vx) < .075) {
					playerFrame = stopFrame
				}else {
				//otherwise iterate the frame 
					playerFrame++
					//make sure were inside the frame range for walking
					if (playerFrame < minWalkFrame || playerFrame > maxWalkFrame) {
						playerFrame = minWalkFrame
					}
				}	
			//if we're not colliding go to the jump frame
			}else {
				playerFrame = jumpFrame
			}
			player.gotoAndStop(playerFrame)
		}
		
		public function keyDown(e:KeyboardEvent):void {
			/*TODO: 5) Change the controls to the arrow keys or just add the functionality on top of WSAD
						(Hint: check which keys are being pressed with trace(e.keycode)) */
			//Check which key was pressed
			if (e.keyCode == 87) {
				wIsDown = true
				
				//if the player is colliding with a block allow it to jump when we press "W"
				if (player.colliding) player.vy = -25
				//TODO: 3) change the height of the player's jump
				
				/*TODO: 6D) Change player.colliding to player.touchingGround
							If you've done everything right the player should only be able to jump when it is on the ground*/
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