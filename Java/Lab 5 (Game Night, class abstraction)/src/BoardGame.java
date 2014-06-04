/**
 * Filename: BoardGame.java
 *
 * File:
 *	$Id: BoardGame.java,v 1.2 2013/09/28 03:00:16 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: BoardGame.java,v $
 *	Revision 1.2  2013/09/28 03:00:16  drd3073
 *	Finished writing classes, not tested.
 *
 *	Revision 1.1  2013/09/28 01:44:56  drd3073
 *	Game and ConsoleGame class writen, GameNight started
 * 
 *
 * @author Dave
 */

/**
 * Class that represent a board game.  In addition to the features
 * of a regular game, it includes a variable for the luck factor,
 * which is a real value between 0 and 1.
 * @author zjb
 */
public class BoardGame extends Game {

    /**
     * Luck factor of the game
     */
    private double luckFactor;

    /**
     * Constructor, takes three args to set the instance variables
     * @param n Name of the game
     * @param np Number of players that can play the game at once
     * @param l Luck factor
     */
    public BoardGame(String n, int np, double l) {
        super(n,np);
        luckFactor = l;
    }

    /**
     * Plays the game and chooses a winner.  Winner is chosen to be
     * the person with the largest value of 
     * intelligence + (luck * luckFactor), where luck refer's to the
     * Player's luckiness and luckFactor refers to the Game's instance
     * variable.  This method returns nothing but does call youWin()
     * on the Player that won the game.
     */
    public void play() {
        System.out.println("Playing " + Name + "...");
        double bestval = 0;
        Player winner = null;
        // find player with max intelligence + luck*luckFactor
        for (Player player : Players) {
            double thisval = player.getIntelligence() + 
                player.getLuck() * luckFactor;
            if (thisval > bestval) {
                bestval = thisval;
                winner = player;
            }
        }
        System.out.println("Winner is " + winner.getName());
        winner.youWin();
    }
}