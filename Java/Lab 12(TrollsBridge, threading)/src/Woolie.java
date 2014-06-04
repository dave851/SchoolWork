/**
 * Filename: Woolie.java
 * 
 * File: $Id: Woolie.java,v 1.2 2013/11/25 14:39:43 drd3073 Exp $
 * 
 * Revisions: $Log: Woolie.java,v $
 * Revisions: Revision 1.2  2013/11/25 14:39:43  drd3073
 * Revisions: Changed to sync on this object, enforced ordering of crossing. Wrote last test codes
 * Revisions: Revision 1.1 2013/11/23 19:47:04 drd3073
 * Classes written, Need to write two test cases and test.
 * 
 * 
 * @author Dave
 */

public class Woolie extends Thread {

	/**
	 * name - name of woolie
	 * time - time it takes to cross the bridge
	 * dest - where woolie is going
	 * troll - monitor for crossing bridge
	 */
	private final String name;
	private final int time;
	private final int weight;
	private final String dest;
	private final TrollsBridge troll;

	/**
	 * Builds a woolie
	 * @param name - his/her name
	 * @param crossTime - time it takes for them to cross the bridge
	 * @param weight - their weight
	 * @param destination - where they are going
	 * @param bridgeGuard - troll monitoring them
	 */
	public Woolie(String name, int crossTime, int weight,
		String destination, TrollsBridge bridgeGuard) {
		this.name = name;
		this.weight = weight;
		time = crossTime;
		dest = destination;
		troll = bridgeGuard;
	}

	/**
	 * getter for weight
	 * @return int, the woolies weight
	 */
	public int getWeight() {
		return weight;
	}
	
	/**
	 * Get name of woolie
	 * @returns - name of woolie, String
	 */
	public String myName(){
		return name;
	}

	/**
	 * woolie trys to cross the bridge
	 */
	@Override
	public void run() {
		int crossing = 0;
		troll.enterBridgePlease(this);
		System.out.println(name+ " is starting to cross.");
		while (time > crossing) {
			try {
				sleep(1000);
			}
			catch (InterruptedException e) {
				System.err.println( "Abort. Unexpected thread interruption.(woolie)" );
			}
			crossing += 1;
			System.out.println("        " + name + " " + crossing
				+ " seconds.");
		}
		troll.leave(this);
		System.out.println(name + " leaves at " + dest);
	}

}
