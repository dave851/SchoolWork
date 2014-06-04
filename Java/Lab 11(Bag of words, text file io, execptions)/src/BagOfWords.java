/**
 * Filename: BagOfWords.java
 *
 * File:
 *	$Id$ 
 *
 * Revisions:
 *	$Log$ 
 *
 * @author Dave
 */
import java.io.*;
import java.util.*;
import java.util.Map.Entry;

public class BagOfWords {

	/**
	 * Punctuation - List of Punctuation to be ignored
	 * stopWords - TreeSet of words to be ignored
	 * words - TreeMap of words in file, key is the word and its value is the number of times it is in the file
	 */
	private List<String> punctuation  = new ArrayList<String>(Arrays.asList(".",",","?","!",":",";")); 
	private Set<String> stopWords = new TreeSet<String>();
	private Map<String, Integer> words = new TreeMap<String, Integer>();
	
	/**
	 * Constructs the object and loads the words to be ignored
	 * 
	 * @param stopfile - File of words to be ignored
	 * @throws IOException - thrown in case of general IO failure
	 * @throws BagException - thrown if file is formated improperly
	 */
	public BagOfWords(String stopfile)
		throws IOException, BagException{
		
		try{
			Scanner stop = new Scanner(new File(stopfile));
			while(stop.hasNext()){
				String word = stop.next().toLowerCase();
				for(String i : punctuation){
					if(word.contains(i)){
						throw new BagException("Bad Stop word: "+word);
					}
				}
				stopWords.add(word);
			}
			stop.close();
		}
		finally{}
	}
	
	/**
	 * Adds all non-stop words into the treemap, keeps track of number of times seen
	 * @param fileName - File to be read
	 * @throws IOException - thrown in general io errors
	 * @throws BagException - thrown if all words in file are stops words
	 */
	public void makeBag(String fileName)
		throws IOException, BagException{
		try{
			Scanner text = new Scanner(new File(fileName));
			while(text.hasNext()){
				String word = text.next().toLowerCase();
				for(String i : punctuation){
					if(word.contains(i)){
						word = word.substring(0,word.length()-1);
					}
				}
				if(words.containsKey(word)){
					Integer num = words.get(word);
					num+=1;
					words.put(word , num);
				}
				else if(!stopWords.contains(word)){
					words.put(word,1);
				}
			}
			text.close();
			if(words.size() == 0){
				throw new BagException("No non-stop Words in given file");
			}
		}
		finally{}
	}
	
	/**
	 * Takes an output stream and writes the word and the number of times it appeared
	 * Based on the TreeMap generated from calling makeBag
	 * @param out - output stream to write to
	 * @throws IOException - thrown in general IO problems 
	 */
	public void outputBag(OutputStream out)
		throws IOException{
		try{
			PrintWriter stream = new PrintWriter(new BufferedOutputStream(out));
			Set<Entry<String, Integer>> entry = words.entrySet();
			for(Entry<String, Integer> i  : entry){
				String line = i.getKey().toString() + ": " + i.getValue();
				stream.println(line);
			}
			stream.close();
		}
		finally{}
	}
	
	/**
	 * Takes in a Stop file name, a file to read, and optional a file to write output to.
	 * @param args - <STOP_WORD_FILE> <INPUT_TEXT> [OUTPUT_FILE]
	 */
	public static void main(String[] args){
		if(args.length != 2 && args.length != 3){
			System.out.println("Usage: java BagOfWords STOP_WORD_FILE INPUT_TEXT [OUTPUT_FILE]");
			System.exit(-1);
		}
		try {
			BagOfWords words = new BagOfWords(args[0]);
			words.makeBag(args[1]);
			if(args.length == 2){
				words.outputBag(System.out);
			}
			else if(args.length == 3){
				File file = new File(args[2]);
				if(file.exists()){
					System.out.println("File alreadly exists!");
					System.exit(-1);
				}
				OutputStream out = new FileOutputStream(file);
				words.outputBag(out);
				out.close();
			}
		}
		catch (IOException e) {
			System.err.println("Bad File");
			System.exit(-1);
		}
		catch (BagException e) {
			System.err.println(e.getMessage());
			System.exit(-1);
		}
	}
}