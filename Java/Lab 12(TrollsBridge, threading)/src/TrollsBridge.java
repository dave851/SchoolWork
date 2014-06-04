/**
 * Filename: TrollsBridge.java
 *
 * File:
 *	$Id: TrollsBridge.java,v 1.2 2013/11/25 14:39:43 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: TrollsBridge.java,v $
 *	Revision 1.2  2013/11/25 14:39:43  drd3073
 *	Changed to sync on this object, enforced ordering of crossing. Wrote last test codes
 *
 *	Revision 1.1  2013/11/23 19:47:05  drd3073
 *	Classes written, Need to write two test cases and test.
 * 
 *
 * @author Dave
 */
import java.util.LinkedList;

public class TrollsBridge {

	/**
	 * weightOnBridge - Current weight on the Bridge woolieList - Queue of
	 * woolies currently on the bridge
	 */
	private int weightOnBridge;
	private final int weightMax = 100;
	private LinkedList<Woolie> woolieWait;
	private LinkedList<Woolie> woolieOn;
	private final int max;

	/**
	 * Makes a new troll monitor
	 * 
	 * @param max
	 *            - max numbber of woolies on the bridge at once
	 */
	public TrollsBridge(int max) {
		weightOnBridge = 0;
		woolieWait = new LinkedList<Woolie>();
		woolieOn = new LinkedList<Woolie>();
		this.max = max;
	}

	/**
	 * Controls the woolies getting on the bridge
	 * 
	 * @param thisWoolie
	 *            - woolie to attempt to cross bridge
	 */
	public void enterBridgePlease(Woolie thisWoolie) {
		System.out.println("The troll scowls \"Get in Line!\" when "
			+ thisWoolie.myName() + " shows up at the bridge.");
		synchronized (this) {
			while (((woolieOn.size() >= max) || (thisWoolie.getWeight()
				+ weightOnBridge > weightMax))
				|| !(thisWoolie.equals(woolieWait.peek()) || 
					woolieWait.isEmpty())) {
				if(!woolieWait.contains(thisWoolie)){woolieWait.add(thisWoolie);}
				try {
					wait();
				}
				catch (InterruptedException e) {
					System.err.println("Abort. Unexpected thread "
						+ "interruption.(enterBridge)");
				}
			}
			if(woolieWait.contains(thisWoolie)){woolieWait.remove(thisWoolie);}
			woolieOn.add(thisWoolie);
			weightOnBridge += thisWoolie.getWeight();
		}
	}

	/**
	 * For when a woolie leaves the bridge
	 * 
	 * @param thisWoolie
	 *            - woolie leaving
	 */
	public void leave(Woolie thisWoolie) {
		synchronized (this) {
			woolieOn.remove(thisWoolie);
			weightOnBridge -= thisWoolie.getWeight();
			notifyAll();
		}
	}

}