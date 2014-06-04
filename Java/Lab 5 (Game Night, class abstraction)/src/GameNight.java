/**
 * Filename: GameNight.java
 *
 * File:
 *	$Id: GameNight.java,v 1.5 2013/09/28 20:29:33 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: GameNight.java,v $
 *	Revision 1.5  2013/09/28 20:29:33  drd3073
 *	Corrected GermanBoardGame pickplayers function.
 *
 *	Revision 1.4  2013/09/28 20:20:45  drd3073
 *	Added Missing print statements, Fixed null pointer error, Fixed out of bounds error when picking players. Now increments players game number when he is picked
 *
 *	Revision 1.3  2013/09/28 03:22:11  drd3073
 *	Documentation added. Null pointer Runtime error
 *
 *	Revision 1.2  2013/09/28 03:00:16  drd3073
 *	Finished writing classes, not tested.
 *
 *	Revision 1.1  2013/09/28 01:44:56  drd3073
 *	Game and ConsoleGame class writen, GameNight started
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;
import java.util.Random;

public class GameNight {
	
	/**
	 * Constructs a 'empty' GameNight object
	 */
	public GameNight(){
	}
	
	/**
	 * Creates and populates a list of 5 players.
	 * Creates and populates a list of 5 games, using 
	 * each subclass of Game at least once, and picks players for each game.
	 * Uses a loop to play each game exactly once.
	 * Uses a loop to print out each Player's ending stats and determine the 
	 * big winner of the night (Player with the most wins.
	 */
	public static void main(String[] args) {
		Random R = new Random();
		ArrayList<Player> Players = new ArrayList<Player>();
		ArrayList<Game> Games = new ArrayList<Game>();
		Player Player1 = new Player("Jack", 5,5,5,50);
		Player Player2 = new Player("Jill", 1,13,1,25);
		Player Player3 = new Player("Bill", 5,8,10,6);
		Player Player4 = new Player("Dave", 10,8,2,19);
		Player Player5 = new Player("Kate", 8,10,5,18);
		Players.add(Player1);
		Players.add(Player2);
		Players.add(Player3);
		Players.add(Player4);
		Players.add(Player5);
		Game Con = new ConsoleGame("Killing Floor", 4, true);
		Con.pickPlayers(Players);
		Game TeamCard = new TeamCardGame("Spades");
		TeamCard.pickPlayers(Players);
		Game BoardGame = new BoardGame("Monopoly", 5, R.nextInt(1));
		BoardGame.pickPlayers(Players);
		Game GermanBoard = new GermanBoardGame("UBER^&*(%", 4);
		GermanBoard.pickPlayers(Players);
		Game Con2 = new ConsoleGame("COD", 4, false);
		Con2.pickPlayers(Players);
		Games.add(Con);
		Games.add(TeamCard);
		Games.add(BoardGame);
		Games.add(GermanBoard);
		Games.add(Con2);
		for(Game g : Games){
			g.play();
		}
		for(Player p : Players){
			System.out.println(p.toString());
		}
		Player Winner = new Player("derp",0,0,0,0);
		for(Player p : Players){
			p.toString();
			if(p.getWins() > Winner.getWins()){
				Winner = p;
			}
		}
		System.out.println("Winner is " + Winner.getName());

	}

}
