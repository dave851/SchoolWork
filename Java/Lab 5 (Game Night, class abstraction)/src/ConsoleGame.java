/**
 * Filename: ConsoleGame.java
 *
 * File:
 *	$Id: ConsoleGame.java,v 1.4 2013/09/28 20:29:33 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: ConsoleGame.java,v $
 *	Revision 1.4  2013/09/28 20:29:33  drd3073
 *	Corrected GermanBoardGame pickplayers function.
 *
 *	Revision 1.3  2013/09/28 20:20:45  drd3073
 *	Added Missing print statements, Fixed null pointer error, Fixed out of bounds error when picking players. Now increments players game number when he is picked
 *
 *	Revision 1.2  2013/09/28 03:22:11  drd3073
 *	Documentation added. Null pointer Runtime error
 *
 *	Revision 1.1  2013/09/28 01:44:56  drd3073
 *	Game and ConsoleGame class writen, GameNight started
 * 
 *
 * @author Dave
 */

public class ConsoleGame extends Game {
	
	private boolean brains;

	/**
	 * Constructor, takes three args to set the instance variables
	 * 
	 * Parameters:
	 * name - Name of the game
	 * np - Number of players that can play the game at once
	 * usesBrains - Whether or not the game uses intelligence
	 */
	public ConsoleGame(String name, int np, boolean usesBrains){
		super(name, np);
		brains = usesBrains;
	}
	
	/**
	 * Plays the game and chooses a winner. Winner is chosen either as 
	 * the player with highest dexterity (if the game does not use intelligence)
	 * or highest (dexterity + intelligence) otherwise.
	 */
	public void play(){
		System.out.println("Playing " + Name + "...");
		if(Players.size() == 0){
			System.out.println("Must pick Players first");
		}
		else if(brains){
			Player winner = new Player("Derp",0,0,0,0);
			for(Player p : Players){
				if((p.getDexterity() + p.getIntelligence()) > 
						(winner.getDexterity() + winner.getIntelligence())){
					winner = p;
				}
			}
			winner.youWin();
			System.out.println("Winner is " + winner.getName());
		}
		else if(!brains){
			Player winner = new Player("Derp",0,0,0,0);
			for(Player p : Players){
				if(p.getDexterity() > winner.getDexterity()){
					winner = p;
				}
			}
			winner.youWin();
			System.out.println("Winner is " + winner.getName());
		}
	}

}
