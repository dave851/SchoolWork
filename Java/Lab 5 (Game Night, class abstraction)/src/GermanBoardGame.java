/**
 * Filename: GermanBoardGame.java
 *
 * File:
 *	$Id: GermanBoardGame.java,v 1.5 2013/09/28 20:29:33 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: GermanBoardGame.java,v $
 *	Revision 1.5  2013/09/28 20:29:33  drd3073
 *	Corrected GermanBoardGame pickplayers function.
 *
 *	Revision 1.4  2013/09/28 20:20:46  drd3073
 *	Added Missing print statements, Fixed null pointer error, Fixed out of bounds error when picking players. Now increments players game number when he is picked
 *
 *	Revision 1.3  2013/09/28 03:22:11  drd3073
 *	Documentation added. Null pointer Runtime error
 *
 *	Revision 1.2  2013/09/28 02:34:29  drd3073
 *	GermanBoardGame writen
 *
 *	Revision 1.1  2013/09/28 01:44:57  drd3073
 *	Game and ConsoleGame class writen, GameNight started
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;
import java.util.Random;

public class GermanBoardGame extends BoardGame {

	/**
	 * Constructor, takes a name and number of players
	 * Parameters:
	 * n - Name of the game
	 * np - Number of players of the game
	 */
	public GermanBoardGame(String n, int np){
		super(n, np, 0);
	}
	
	/**
	 * Chooses players to play the game at random, but will not choose 
	 * any player age 10 or under.
	 * 
	 * Overrides:
	 * pickPlayers in class Game
	 * 
	 * Parameters:
	 * players - List of players to choose from
	 * num - The number of players to pick
	 */
	@Override
	public void pickPlayers(ArrayList<Player> players, int num){
		System.out.println("Picking player for " + Name + "...");
		Random Rnum = new Random();
		if(num > numPlayers){
			num = numPlayers;
		}
		int count = 0;
		for(int i = 0; i < num && count < 10*players.size();){
			// count < 10*players.size() to protect if every 
			//player in list is playing
			Player cur = players.get(Rnum.nextInt(players.size()));
			if(!isPlaying(cur) && (cur.getAge() > 10)){
				Players.add(cur);
				cur.play();
				System.out.println(cur.getName());
				i++;
			}
			count++;
		}
	}
}
