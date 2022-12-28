//Example from processing forum - Modified to use arrays
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

public class Menu_bar {
  JFrame frame;

  public Menu_bar(PApplet app, String[] entries, String[][] subentries, ActionListener[][] actions) {
    System.setProperty("apple.laf.useScreenMenuBar", "true");
    frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();

    // Creates a menubar for a JFrame
    JMenuBar menu_bar = new JMenuBar();
    // Add the menubar to the frame
    frame.setJMenuBar(menu_bar);
    // Define and add two drop down menu to the menubar

    for (int i = 0; i < entries.length; i++) {
      JMenu temp = new JMenu(entries[i]);
      menu_bar.add(temp);
      for (int j = 0; j < subentries[i].length; j++) {
        String t = subentries[i][j];
        if (t.equals("sep")) {
          temp.addSeparator();
        } else {
          try {
            JMenuItem tempEntry = new JMenuItem(t);
            temp.add(tempEntry);
            tempEntry.addActionListener(actions[i][j]);
          }

          catch(Exception e) {
          }
        }
      }
      frame.setVisible(true);
    }
  }
}
