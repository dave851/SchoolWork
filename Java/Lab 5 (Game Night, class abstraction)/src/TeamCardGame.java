/**
 * Filename: TeamCardGame.java
 *
 * File:
 *	$Id: TeamCardGame.java,v 1.4 2013/09/28 20:20:45 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: TeamCardGame.java,v $
 *	Revision 1.4  2013/09/28 20:20:45  drd3073
 *	Added Missing print statements, Fixed null pointer error, Fixed out of bounds error when picking players. Now increments players game number when he is picked
 *
 *	Revision 1.3  2013/09/28 03:22:11  drd3073
 *	Documentation added. Null pointer Runtime error
 *
 *	Revision 1.2  2013/09/28 02:23:24  drd3073
 *	TeamCardGame Writen
 *
 *	Revision 1.1  2013/09/28 01:44:56  drd3073
 *	Game and ConsoleGame class writen, GameNight started
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;

public class TeamCardGame extends Game {

	private ArrayList<Player> Team1 = new ArrayList<Player>(2);
	private ArrayList<Player> Team2 = new ArrayList<Player>(2);
	
	/**
	 * Constructor. Assumes all such games are played by four players.
	 * Parameters:
	 * n - Name of game
	 * 
	 */
	public TeamCardGame(String n){
		super(n, 4);
	}
	
	/**
	 * Plays the game, selecting a winning team according to total 
	 * team intelligence. This is computed for each team as the team's 
	 * higher intelligence value plus twice the team's lower intelligence value.
	 */
	public void play(){
		System.out.println("Playing " + Name + "...");
		Team1.add(Players.get(0));
		Team1.add(Players.get(1));
		Team2.add(Players.get(2));
		Team2.add(Players.get(3));
		int Team1int = 0;
		int Team2int = 0;
		if(Team1.get(0).getIntelligence() > Team1.get(1).getIntelligence()){
			Team1int+= Team1.get(0).getIntelligence() + 2*Team1.get(1).getIntelligence();
		}
		else if(Team1.get(0).getIntelligence() < Team1.get(1).getIntelligence()){
			Team1int+= Team1.get(1).getIntelligence() + 2*Team1.get(0).getIntelligence();
		}
		if(Team2.get(0).getIntelligence() > Team2.get(1).getIntelligence()){
			Team2int+= Team2.get(0).getIntelligence() + 2*Team2.get(1).getIntelligence();
		}
		else if(Team2.get(0).getIntelligence() < Team2.get(1).getIntelligence()){
			Team2int+= Team2.get(1).getIntelligence() + 2*Team2.get(0).getIntelligence();
		}
		if(Team1int > Team2int){
			Team1.get(0).youWin();
			Team1.get(1).youWin();
			System.out.println("Winner is " + Team1.get(0).getName() + " and "+Team1.get(1).getName());
		}
		else if(Team1int < Team2int){
			Team2.get(0).youWin();
			Team2.get(1).youWin();
			System.out.println("Winner is " + Team2.get(0).getName() + " and "+Team2.get(1).getName());
		}
	}
}
