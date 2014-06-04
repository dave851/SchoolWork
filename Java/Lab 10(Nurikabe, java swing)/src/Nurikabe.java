/**
 * Filename: Nurikabe.java
 *
 * File:
 *	$Id: Nurikabe.java,v 1.2 2013/11/08 05:56:07 drd3073 Exp $ 
 *
 * Revisions:
 *	$Log: Nurikabe.java,v $
 *	Revision 1.2  2013/11/08 05:56:07  drd3073
 *	Reset, Load, and grid events handled
 *
 *	Revision 1.1  2013/11/08 04:53:56  drd3073
 *	Set up gui look, event handles started
 * 
 *
 * @author Dave
 */
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import java.util.Arrays;

public class Nurikabe extends JFrame {

	private static final long serialVersionUID = 1L;

	/**
	 * Puzzles and there solutions in array form, left to right top to bottom
	 */
	private final int[] puz1 = { 0, 2, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 5, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 5, 0, 0 };

	private final int[] puz1S = { 0, 2, -1, -1, -1, -1, -1, -1, 3, 0, 0,
		-1, 5, -1, -1, -1, -1, -1, 0, 0, 0, 0, -1, 0, -1, -1, -1, -1, -1,
		0, 0, 2, -1, 5, 0, 0 };

	private final int[] puz2 = { 1, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0,
		3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0 };

	private final int[] puz2S = { 1, -1, 0, 0, -1, 3, -1, -1, -1, 3, -1,
		0, -1, 0, 3, -1, -1, 0, -1, 0, -1, 3, -1, -1, -1, -1, -1, 0, 0,
		-1, 0, 2, -1, -1, -1, -1 };

	private final int[] puz3 = { 0, 0, 9, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0 };

	private final int[] puz3S = { 0, 0, 9, -1, 7, 0, 0, -1, -1, -1, 0, 0,
		0, -1, 2, -1, 0, 0, 0, -1, 0, -1, -1, 0, 0, -1, -1, 0, 2, -1, 0,
		0, -1, -1, -1, -1 };

	/**
	 * Current board in use and dimensions
	 */
	private final JFrame game;
	public final int rows = 6;
	public final int cols = 6;
	private final int[] board = new int[rows * cols];
	private int[] curPuzSol;

	/**
	 * The constructor, builds ui and contains all event handlers
	 */
	public Nurikabe() {

		// JFrame layout
		game = new JFrame("Nurikabe");
		Container content = game.getContentPane();
		content.setLayout(new BorderLayout());
		game.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// Playing Grid layout
		JPanel tiles = new JPanel();
		tiles.setLayout(new GridLayout(rows, cols));

		// Commands layout
		JPanel commands = new JPanel();
		commands.setLayout(new FlowLayout());

		// ActionListener for grid
		class cellAction implements ActionListener {

			public void actionPerformed(ActionEvent e) {
				int i = Integer.parseInt(e.getActionCommand());
				JButton cell = (JButton) e.getSource();
				if (cell.getText() != "") {
					// Do nothing
				}
				else if (board[i] == 0) {
					board[i] = -1;
					cell.setBackground(Color.black);
				}
				else if (board[i] == -1) {
					board[i] = 0;
					cell.setBackground(Color.lightGray);
				}
			}
		}// end ActionListener

		// Playing Grid creation
		cellAction buttonGrid = new cellAction();
		JButton[] buttons = new JButton[rows * cols];
		JButton cell;

		for (int i = 0; i < rows * cols; i++) {
			cell = new JButton();
			cell.setPreferredSize(new Dimension(80, 80));
			cell.setActionCommand(Integer.toString(i));
			cell.setBackground(Color.lightGray);
			tiles.add(cell);
			buttons[i] = cell;
			cell.addActionListener(buttonGrid);
		}

		// Puzzle loader event handler
		class PLoad implements ActionListener {

			private final JButton[] buttons;
			private final int[] puzz;

			public PLoad(JButton[] buttonList, int[] puzzle) {
				buttons = buttonList;
				puzz = puzzle;
			}

			public void actionPerformed(ActionEvent e) {
				int puz = Integer.parseInt(e.getActionCommand());
				if (puz == 1) {
					System.arraycopy(puz1, 0, board, 0, puz1.length);
					curPuzSol = puz1S;
				}
				if (puz == 2) {
					System.arraycopy(puz2, 0, board, 0, puz2.length);
					curPuzSol = puz2S;
				}
				if (puz == 3) {
					System.arraycopy(puz3, 0, board, 0, puz3.length);
					curPuzSol = puz3S;
				}
				for (int i = 0; i < puzz.length; i++) {
					buttons[i].setBackground(Color.lightGray);
					if (puzz[i] != 0) {
						buttons[i].setText(Integer.toString(puzz[i]));
					}
					if (puzz[i] == 0) {
						buttons[i].setText("");
					}
				}
			}
		}// end loader

		// Puzzle Loader Command buttons
		JButton p1 = new JButton("P1");
		p1.setPreferredSize(new Dimension(80, 50));
		p1.addActionListener(new PLoad(buttons, puz1));
		p1.setActionCommand("1");
		commands.add(p1);
		JButton p2 = new JButton("P2");
		p2.setPreferredSize(new Dimension(80, 50));
		p2.addActionListener(new PLoad(buttons, puz2));
		p2.setActionCommand("2");
		commands.add(p2);
		JButton p3 = new JButton("P3");
		p3.setPreferredSize(new Dimension(80, 50));
		p3.addActionListener(new PLoad(buttons, puz3));
		p3.setActionCommand("3");
		commands.add(p3);

		// Check Command button
		JButton check = new JButton("Check");
		check.setPreferredSize(new Dimension(80, 50));
		check.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				if (Arrays.equals(board, curPuzSol)) {
					JOptionPane.showMessageDialog(game, "YOU WIN!!!!",
						"Solution Check", JOptionPane.INFORMATION_MESSAGE);
				}
				else {
					JOptionPane.showMessageDialog(game,
						"Not a valid Solution", "Solution Check",
						JOptionPane.ERROR_MESSAGE);
				}
			}

		});
		commands.add(check);

		// Reset Command button
		JButton reset = new JButton("Reset");
		reset.setPreferredSize(new Dimension(80, 50));

		// Reset listener
		class reset implements ActionListener {

			private final JButton[] buttons;

			public reset(JButton[] but) {
				buttons = but;
			}

			public void actionPerformed(ActionEvent e) {
				for (int i = 0; i < board.length; i++) {
					if (board[i] == -1) {
						buttons[i].setBackground(Color.lightGray);
						board[i] = 0;
					}
				}
			}
		}// End reset
		
		reset.addActionListener(new reset(buttons));
		commands.add(reset);

		// Putting all components in jframe
		content.add("Center", tiles);
		content.add("South", commands);
		game.pack();
		game.setVisible(true);
	}

	/**
	 * Starts game
	 */
	public static void main(String[] args) {
		new Nurikabe();
	}

}
