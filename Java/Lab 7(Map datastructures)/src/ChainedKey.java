/**
 * Filename: ChainedKey.java
 *
 * File:
 *	$Id: ChainedKey.java,v 1.2 2013/10/14 03:42:06 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: ChainedKey.java,v $
 *	Revision 1.2  2013/10/14 03:42:06  drd3073
 *	Added docs, still need fixes to rehash
 *
 *	Revision 1.1  2013/10/13 23:18:12  drd3073
 *	Put, get written, error getting table index, returning negative numbers
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;

public class ChainedKey<K, V> {
	
	public ArrayList<K> Keys = new ArrayList(1);
	public ArrayList<V> Vals = new ArrayList(1);
	
	/**
	 * Contructor for new key set in chainedmap
	 * @param name - Name/Key of entry
	 * @param Value - Value of entry
	 */
	public ChainedKey(K name, V Value){
		Keys.add(name);
		Vals.add(Value);
	}

	/**
	 * Adds data to key
	 * @param key - Name/Key of entry 
	 * @param val - Value of entry
	 */
	public void add(K key, V val){
		Keys.add(key);
		Vals.add(val);
	}
}
