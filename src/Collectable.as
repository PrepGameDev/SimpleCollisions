package  
{
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	
	 
	 /* TODO: 8A) Make a new class just like this one called BadThing in a new file called BadThing.as
	  * 			Hint: right click src and click new class. Then name it BadThing. Capitalization is important.
	  * 			Hint: Then copy all the code in this file to the new one.
	  * 			Hint: In the new file (BadThing.as) replace the word Colectable with BadThing everywhere you see it.
	  * 					The easy way to do this is to press CTRL+H and follow the menu instructions.*/
	  /* TODO: 8B)  1. Go into Flash Pro and draw a red circle just like the green collectables in the file Assets.fla.
	   * 			2. Then select all of it.
	   * 			3. Right click it and press Convert to Symbol.
	   * 			4. Name it BadThing1.
	   * 			5. Then check export for actionscript and change the base class of it to BadThing. Now you can close the window.
	   * 			6. Place a few instances of this symbol inside the level object.
	   * 				You can enter the level object by double clicking it. You can exit it by double clicking the grey/white space.
	   * 				Move red circles inside with cut/copy and paste (CTRL+X,CTRL+C,CTRL+V ... or right click and use the menus).
	   * 			7. Press CTRL + Enter inside Flash Pro to export the swc
	   * 			8. Press CTRL + Enter inside Flash Develop. 
	   * 			Check: If you've done everything right so far your red circles should be inside the level, but when you 
	   * 					touch them they should do nothing 			
	   */
	public class Collectable extends PhysObj
	{
		//A collectable object that increases your score when touched
		public function Collectable() 
		{
			//call on the constructor of the collectable's parent data type (PhysObj)
			//	Explicitly make the collectable a detector instead of a rigid object
			super(-1,-1,true,true)
			
		}
		
	}

}