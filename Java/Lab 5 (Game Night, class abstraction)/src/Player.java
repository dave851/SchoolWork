/**
 * Filename: Player.java
 *
 * File:
 *	$Id: Player.java,v 1.1 2013/09/28 01:44:57 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Player.java,v $
 *	Revision 1.1  2013/09/28 01:44:57  drd3073
 *	Game and ConsoleGame class writen, GameNight started
 * 
 *
 * @author Dave
 */

/**
 * Represents a person playing a game.  The person has several attributes,
 * namely age, intelligence, dexterity, and luck.  This class also keeps
 * track of the number of games played and the number of games won by 
 * the player.
 *
 * @author zjb
 */
public class Player {

    /**
     * The number of wins this player has
     */
    private int numwins;

    /**
     * The age of the player
     */
    private int age;

    /**
     * The intelligence of the player
     */
    private int intelligence;

    /**
     * The dexterity of the player
     */
    private int dexterity;

    /**
     * The player's luck
     */
    private int luck;

    /**
     * The number of games the player has played
     */
    private int numplayed;

    /**
     * The name of the player
     */
    private String name;
 
    /**
     * Constructor takes in all relevant information to create the Player.
     * Should also set the number of games played and won to zero.
     * @param name Name
     * @param i Intelligence
     * @param d Dexterity
     * @param l Luck
     * @param a Age
     */
    public Player(String name, int i, int d, int l, int a) {
	intelligence = i;
	dexterity = d;
	luck = l;
	age = a;
	this.name = name;
	numwins = 0;
	numplayed = 0;
    }

    /**
     * Returns a string including the name, number of games played and 
     * number won, such as "Zack has played 3 games and has 2 wins."
     * @return Player description
     */
    public String toString() {
	return name + " played " + numplayed + " games and has " + numwins + " wins.";
    }

    /**
     * Increments the number of games played.
     */
    public void play() {
	numplayed++;
    }

    /**
     * Increments the number of games won.
     */
    public void youWin() {
	numwins++;
    }

    /**
     * Accessor for the age
     * @return age
     */
    public int getAge() {
	return age;
    }

    /**
     * Accessor for the intelligence
     * @return intelligence
     */
    public int getIntelligence() {
	return intelligence;
    }

    /**
     * Accessor for luck
     * @return luck
     */
    public int getLuck() {
	return luck;
    }

    /**
     * Accessor for the dexterity
     * @return dexterity
     */
    public int getDexterity() {
	return dexterity;
    }

    /**
     * Accessor for the number of wins
     * @return wins
     */
    public int getWins() {
	return numwins;
    }

    /**
     * Accessor for the name
     * @return name
     */
    public String getName() {
	return name;
    }
}