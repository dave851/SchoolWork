/**
 * Filename: Game.java
 *
 * File:
 *	$Id: Game.java,v 1.4 2013/09/28 20:20:45 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Game.java,v $
 *	Revision 1.4  2013/09/28 20:20:45  drd3073
 *	Added Missing print statements, Fixed null pointer error, Fixed out of bounds error when picking players. Now increments players game number when he is picked
 *
 *	Revision 1.3  2013/09/28 03:22:11  drd3073
 *	Documentation added. Null pointer Runtime error
 *
 *	Revision 1.2  2013/09/28 03:00:16  drd3073
 *	Finished writing classes, not tested.
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;
import java.util.Random;

public abstract class Game {

	protected String Name;
	protected int numPlayers;
	protected ArrayList<Player> Players;
	
	/**
	 * Constructor, takes two args to set the instance variables
	 * 
	 * Parameters:
	 * n - Name of the game
	 * np - Number of players that can play the game at once
	 */
	public Game(String N, int np){
		Name = N;
		numPlayers = np;
		Players = new ArrayList<Player>(np);
	}
	
	/**
	 * Chooses players at random from the array passed in to play the game.
	 *  Will pick as many players as can play the game at once. 
	 *  
	 *  Parameters:
	 *  players - List of Players that might play the game
	 */
	public void pickPlayers(ArrayList<Player> players){
		pickPlayers(players, numPlayers);
	}
	
	/**
	 * Chooses players at random from the list passed in to play the game. 
	 * Will pick the number of players given as the second parameter 
	 * (unless the parameter is larger than the number that can play). 
	 *  
	 * Parameters:
	 * players - List of Players that might play the game
	 * num - Number of players to pick
	 */
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
			if(!isPlaying(cur)){
				Players.add(cur);
				cur.play();
				System.out.println(cur.getName());
				i++;
			}
			count++;
		}
	}
	
	/**
	 * Checks the list of current players to see if a particular player is
	 * playing the game
	 * 
	 * Parameters:
	 * p - A player to check
	 * 
	 * Returns:
	 * Whether the player passed in is playing this game
	 */
	public boolean isPlaying(Player p){
		return Players.contains(p);
	}
	
	/**
	 * Play the game! 
	 */
	public abstract void play();
	
	/**
	 * Returns a String representation of the game, in this case simply 
	 * the name of the game.
	 * 
	 * Overrides:
	 * toString in class Object
	 * 
	 * Returns:
	 * Name of the game
	 */
	@Override
	public String toString(){
		return Name;
	}
	
}
