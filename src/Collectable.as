package  
{
	/**
	 * ...
	 * @author Danny Weitekamp
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