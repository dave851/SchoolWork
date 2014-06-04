/**
 * Filename: DoMagic.java
 *
 * File:
 *	$Id: DoMagic.java,v 1.1 2013/11/01 01:56:08 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: DoMagic.java,v $
 *	Revision 1.1  2013/11/01 01:56:08  drd3073
 *	Flawless victory
 * 
 *
 * @author Dave
 */
import java.util.*;

public class DoMagic {

	/**
	 * Test code
	 */
	public static void main(String[] args) {
		ArrayList<String> items = new ArrayList<String>();
		
		items.add("TURTLE");
		items.add("RABBIT");
		items.add("THE KRAKEN");
		items.add("MAGIC");
		items.add("HAT");
		items.add("MAGIC");
		items.add("BILL GATES");
		items.add("THIS LAB");
		items.add("TURTLE");
		items.add("TARDIS");
		
		MagicBag<String> bag = new MagicBag<String>();
		
		for(String item : items){
			System.out.println("Putting " + item + " in the bag.");
			bag.add(item);
			System.out.println("Bag has " + bag.size() + " items in it.");
			System.out.println("");
		}
		
		System.out.println("Testing pull();");
		while(!bag.isEmpty()){
			String item = bag.pull();
			System.out.println("I got " + item + ", bag now has " + bag.size()
															+ " items in it.");			
		}
		
		bag.addAll(items);
		
		Scanner sn = new Scanner(System.in);
		
		System.out.println("");
		System.out.println("Testing iteration:");
		System.out.println("What would you like from the bag? ");
		String search = sn.nextLine();
		Iterator<String> magic = bag.iterator();
		while(magic.hasNext()){
			String cur = magic.next();
			System.out.println("Got " + cur);
			if(cur.equals(search)){
				magic.remove();
				System.out.println("Here you are!");
				System.out.println("Bag has " + bag.size() + " items in it.");
				break;
				
			}
			System.out.println("I'll keep looking...");
		}
		sn.close();

	}

}
