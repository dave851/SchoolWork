/**
 * Filename: ChainedMap.java
 *
 * File:
 *	$Id: ChainedMap.java,v 1.5 2013/10/14 20:35:21 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: ChainedMap.java,v $
 *	Revision 1.5  2013/10/14 20:35:21  drd3073
 *	Fixed rehash, working though tests.
 *
 *	Revision 1.4  2013/10/14 03:42:06  drd3073
 *	Added docs, still need fixes to rehash
 *
 *	Revision 1.3  2013/10/14 02:26:25  drd3073
 *	Everything working expect error related to rehashing.
 *
 *	Revision 1.2  2013/10/14 00:39:05  drd3073
 *	Fixed hash problem, fixed if statements to .equals
 *
 *	Revision 1.1  2013/10/13 23:18:12  drd3073
 *	Put, get written, error getting table index, returning negative numbers
 * 
 *
 * @author Dave
 */
import java.util.ArrayList;

public class ChainedMap<K, V> {
	
	private static int INTIAL_CAPACITY = 10;
	private static double MAX_LOAD = 0.7;
	private double Elements;
	private ArrayList<ChainedKey<K, V>> Map;
	
	/**
	 * Constructor. Creates the table and fills it with null values.
	 */
	public ChainedMap(){
		Elements = 0;
		Map = new ArrayList<ChainedKey<K, V>>(INTIAL_CAPACITY);
		for(int i=0; i < INTIAL_CAPACITY;i++){
			Map.add(null);
		}
	}
	
	/**
	 * Add a (key, value) pair to the map. If the key is already present, 
	 *replaces the existing key with the new one. Invokes rehashing if necessary.
	 *
	 * @param key - Key to add
	 * @param value - Value to add
	 */
	public void put(K key, V value){
		int position = Math.abs(key.hashCode() % Map.size());
		if(Map.get(position) == null){
			Map.set(position, new ChainedKey<K, V>(key, value));
		}
		else{
			Map.get(position).add(key, value);
		}
		Elements++;
		if((Elements / Map.size()) > MAX_LOAD){
			rehash();
		}
	}
	
	/**
	 * Looks up a key in the table.
	 * 
	 * @param key - Key of requested entry
	 * @return value of given key, null if not present
	 */
	public V get(K key){
		int position = Math.abs(key.hashCode() % Map.size());
		if(Map.get(position) == null){
			return null;
		}
		else{
			ArrayList<K> search = Map.get(position).Keys;
			ArrayList<V> result = Map.get(position).Vals;
			int i = 0;
			while(i < search.size()){
				if(search.get(i).equals(key)){
					return result.get(i);
				}
				i+=1;
			}
		}
		return null;
	}
	
	/**
	 * Removes a (key,value) pair from the table.
	 * 
	 * @param key - Key to be removed
	 * @return Value of removed entry, or null if not present
	 */
	public V remove(K key){
		V value = get(key);
		if(value == null){
			return null;
		}
		else{
			Elements--;
			int position = Math.abs(key.hashCode() % Map.size());
			int resp = Map.get(position).Keys.indexOf(key);
			Map.get(position).Keys.remove(key);
			Map.get(position).Vals.remove(resp);
			return value;
		}
	}
	
	/**
	 * Invoked to reduce the load factor on map
	 */
	private void rehash(){
		ArrayList<ChainedKey<K, V>> old = (ArrayList<ChainedKey<K, V>>) Map.clone();
		INTIAL_CAPACITY*=2;
		Elements = 0;
		Map = new ArrayList<ChainedKey<K, V>>(INTIAL_CAPACITY);
		for(int i=0; i < INTIAL_CAPACITY;i++){
			Map.add(null);
		}
		for(ChainedKey<K, V> key : old){
			int i = 0;
			if(!(key == null)){
				for(K item : key.Keys){
				V res = key.Vals.get(i);
				put(item, res);
				i++;
				}
			}
		}
	}
}
