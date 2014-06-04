/**
 * Filename: HotelApp.java
 *
 * File:
 *	$Id$ 
 *
 * Revisions:
 *	$Log$ 
 *
 * @author Dave
 */
import com.cdyne.ws.WeatherWS.WeatherSoapProxy;

import java.rmi.RemoteException;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class HotelApp {

	/**
	 * Addresses the Rest services to issues commands to
	 */
	private final static String hotelServiceURL = 
				"http://api.ean.com/ean-services/rs/hotel/v3/list?_type=xml";
	private final static String directionsURL = 
				"http://maps.googleapis.com/maps/api/directions/xml?origin=";

	/**
	 * Prints out hotel info in given location
	 * 
	 * @param city
	 *            - City to stay at
	 * @param state
	 *            - state to stay at
	 * @param country
	 *            - country to stay in
	 * @return A string of the name and location of the hotel
	 * @throws IOException
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 */
	public static String getHotel(String city, String state, String country)
		throws IOException, ParserConfigurationException, SAXException {

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory
			.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(hotelServiceURL + "&city=" + city
			+ "&stateProvinceCode=" + state + "&countryCode=" + country
			+ "&apiKey=utf2pd8jsm9mr6mmfxyjqeq9");
		doc.getDocumentElement().normalize();

		NodeList list = doc.getElementsByTagName("HotelSummary");

		Node hotel = list.item(0);

		NodeList hotelInfo = hotel.getChildNodes();

		String hotelName = hotelInfo.item(1).getTextContent();
		String hotelAd = hotelInfo.item(2).getTextContent() + ","
			+ hotelInfo.item(3).getTextContent() + ","
			+ hotelInfo.item(4).getTextContent();

		return "We found the following hotel: " + hotelName + "\n"
			+ "At this address: " + hotelAd;
	}

	/**
	 * Returns directions from the origin to dest
	 * 
	 * @param origin
	 *            - Starting location
	 * @param dest
	 *            - ending location
	 * @return Readable list of directions
	 * @throws IOException
	 * @throws SAXException
	 * @throws ParserConfigurationException
	 */
	public static String getDirections(String origin, String[] dest)
		throws IOException, SAXException, ParserConfigurationException {

		String start = origin.replace("\\s", "%20");
		String end = dest[0] + "," + dest[1] + "," + dest[2];

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory
			.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(directionsURL + start
			+ "&destination=" + end + "&sensor=false");
		doc.getDocumentElement().normalize();

		NodeList steps = doc.getElementsByTagName("step");

		String out = "The routing directions: \n";

		for (int i = 0; i < steps.getLength(); i++) {
			Node currStep = steps.item(i);
			NodeList stepInfo = currStep.getChildNodes();
			String line = stepInfo.item(11).getTextContent();
			StringBuilder temp = new StringBuilder();
			Boolean del = false;
			Boolean needSpace = false;
			for (int j = 0; j < line.length(); j++) {
				if (line.charAt(j) == '<') {
					del = true;
					if (needSpace) {
						temp.append(" ");
						needSpace = false;
					}
				}
				else if (line.charAt(j) == '>') {
					del = false;
					needSpace = true;
				}
				else if (del) {
					// Do nothing
				}
				else {
					temp.append(line.charAt(j));
					needSpace = false;
				}
			}

			if (temp.indexOf("Destination") != -1) {
				int index = temp.indexOf("Destination");
				temp.insert(index, "\n");
			}

			out += temp + "\n";

		}
		return out;
	}

	/**
	 * Gets the Zip code of a city
	 * 
	 * @param city
	 *            - City to get zip code
	 * @param state
	 *            - State of city
	 * @param country
	 *            - Country of state
	 * @return The zip code of the first hotel found in city
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public static String getHotelZip(String city, String state,
		String country) throws ParserConfigurationException, SAXException,
		IOException {
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory
			.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(hotelServiceURL + "&city=" + city
			+ "&stateProvinceCode=" + state + "&countryCode=" + country
			+ "&apiKey=utf2pd8jsm9mr6mmfxyjqeq9");
		doc.getDocumentElement().normalize();

		NodeList list = doc.getElementsByTagName("HotelSummary");

		Node hotel = list.item(0);

		NodeList hotelInfo = hotel.getChildNodes();

		return hotelInfo.item(5).getTextContent();
	}

	/**
	 * Returns the address of the hotel found in city given
	 * 
	 * @param city
	 *            - City to search
	 * @param state
	 *            - state to search
	 * @param country
	 *            - country to search
	 * @return A list of strings, containing all info of the hotels location
	 * @throws SAXException
	 * @throws IOException
	 * @throws ParserConfigurationException
	 */
	private static String[] getHotelAdress(String city, String state,
		String country) throws SAXException, IOException,
		ParserConfigurationException {
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory
			.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(hotelServiceURL + "&city=" + city
			+ "&stateProvinceCode=" + state + "&countryCode=" + country
			+ "&apiKey=utf2pd8jsm9mr6mmfxyjqeq9");
		doc.getDocumentElement().normalize();

		NodeList list = doc.getElementsByTagName("HotelSummary");

		Node hotel = list.item(0);

		NodeList hotelInfo = hotel.getChildNodes();

		String[] out = { hotelInfo.item(2).getTextContent(),
			hotelInfo.item(3).getTextContent(),
			hotelInfo.item(4).getTextContent() };

		return out;
	}

	/**
	 * Gets tempature of city with the given zip
	 * 
	 * @param zip
	 *            - Area to get temp from
	 * @return A string readout of the tempature
	 * @throws RemoteException
	 */
	public static String getCityTemp(String zip) throws RemoteException {
		WeatherSoapProxy wc = new WeatherSoapProxy();
		return "The current temperature of the hotel area is "
			+ wc.getCityWeatherByZIP(zip).getTemperature() + "F";
	}

	/**
	 * Gives the directions, and local weather of your destination
	 * 
	 * @throws IOException
	 * @throws SAXException
	 * @throws ParserConfigurationException
	 */
	public static void main(String[] args) throws IOException,
		SAXException, ParserConfigurationException {
		String start = "1 Lomb Memorail Drive, Rochester, NY";
		String[] end = { "Hartford", "CT", "US" };
		System.out
			.println("Traveling from Rochester, NY to Hartford, CT \n");
		System.out.println(getHotel(end[0], end[1], end[2]));
		System.out.println(getDirections(start,
			getHotelAdress(end[0], end[1], end[2])));
		System.out
			.println(getCityTemp(getHotelZip(end[0], end[1], end[2])));
	}

}