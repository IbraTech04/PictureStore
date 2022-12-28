//PictureStorePro 2022 //<>// //<>//
// IbraTech04
//Please don't sue me, Adobe :)

import uibooster.*;
import uibooster.components.*;
import uibooster.model.*;
import uibooster.model.formelements.*;
import uibooster.model.options.*;
import uibooster.utils.*;

import controlP5.*;

ControlP5 cp5;

DropdownList d1, d2, d3;

import java.util.ArrayList;
//Variables for context menu bar
final String[] menuBarEntries = {"File", "Import", "Help"}; //Strings for menubar
final String[][] subMenuBarEntries = {{"New", "Open", "Save", "Export to Image", "sep", "Exit"}, {"Image (.png, .jpg)"}, {"About PictureStorePro 2022"}}; //Sub menubar entries
final ActionListener[][] actionsFromContext = { //Action listeneres - used to give the context menu abilities
  {new ActionListener() {
      //New Project
      public void actionPerformed(ActionEvent arg0) {
        Form form = new UiBooster()
        .createForm("New Project:")
        .addText("Project Name")
        .addText("Width:")
        .addText("Height:")
        .show();

currentProject = new Project(int(form.getByIndex(1).asString()), int(form.getByIndex(2).asString()), form.getByIndex(0).asString());

}
}, new ActionListener() {
  public void actionPerformed(ActionEvent arg0) {
    //Open Project
    File file = null;

    while (file == null) { //While a file isn't selected
      file = booster.showFileSelection();//Prompt the user to select a file
      if (file.getName().endsWith(".pso")) { //Making sure the selected file is a PictureStorePro file
        break;
      } else {
        booster.showErrorDialog("Invalid File Selected, Please Try Again", "Error");
        file = null;
      }
    }
    //Load the file
    currentProject = loadProject(file.getParent() + "\\" + file.getName());
    currentProject.canvas.beginDraw();
    currentProject.canvas.pushMatrix();
    currentProject.canvas.translate(currentProject.canvas.width/2, currentProject.canvas.height/2);
    surface.setTitle("PictureStore 2022 - " + currentProject.name); //Set window name accordingly
  }
}
, new ActionListener() {
  //Save Prokect
  public void actionPerformed(ActionEvent arg0) {
    if (currentProject.name.equals("Untitled Project")) { //If the project is unsaved, ask the user for a name
      String fileName = booster.showTextInputDialog("What would you like to call this project?");
      currentProject.name = fileName; //Set name accordingly
      saveProject(currentProject.name + ".pso"); // Save file to disk
      surface.setTitle("PictureStore 2022 - " + currentProject.name); //Update window name
    } else {
      saveProject(currentProject.name + ".pso"); //Save file
    }
  }
}
, new ActionListener() {
  //Export to image
  public void actionPerformed(ActionEvent arg0) {
    File directory = booster.showDirectorySelection(); //Ask user where they want to export the image
    currentProject.canvas.save(directory.getAbsolutePath() + "\\" + currentProject.name + ".png");
    new UiBooster().showInfoDialog("Exporeted Successfully");
  }
}
, null, new ActionListener() {
  //Exit
  public void actionPerformed(ActionEvent arg0) {
    exit();
  }
}
}, {

  new ActionListener() {
    //Import image
    public void actionPerformed(ActionEvent arg0) {
      File file = null;

      while (file == null) { //While an invalid file is selected keep asking hte user for a file
        file = booster.showFileSelection();
        if (file.getName().endsWith(".png") || file.getName().endsWith(".jpg")|| file.getName().endsWith(".jpeg")) { //Making sure the selected file is a PictureStorePro file
          break;
        } else {
          booster.showErrorDialog("Invalid File Selected, Please Try Again", "Error");
          file = null;
        }
      }
      PImage img = loadImage(file.getAbsolutePath());
      currentProject.layers.get(selectedLayer).layer.add(new ImageElement(0, 0, currentProject.canvas, img, file.getAbsolutePath()));
    }
  }
}
, {
  new ActionListener() {
    //About PictureStorePro
    public void actionPerformed(ActionEvent arg0) {
      new UiBooster().showInfoDialog("RabYSoft PictureStorePro 2022 \nCopyright 2022 \nAll rights reserved");
    }
  }
}
};


//Variables for scaling and moving around the canvas
float scaleAmount = 0.25;
float transAmountX = 0;
float transAmountY = 0;
int currentBrushThickness = 25;

color currentFill; //Current Fill Color
color currentStroke; //Current Stroke Color
int selectedLayer = 0; //Current selected layer
Menu_bar mp; //Menubar object
Project currentProject; //Current project

Tool[] tools = new Tool[7]; //Tools
Tool currentTool; //Selected tool
UiBooster booster; //UiBooster instance

void settings() {
  size(1000, 750, JAVA2D);
}

void setup() {
  surface.setVisible(false); //Hiding the window until we're done loading
  surface.setIcon(loadImage("Adobe_Photoshop_CC_icon.svg.png")); //Loading image to be used in taskbar

  booster = new UiBooster();
  cp5 = new ControlP5(this);
  d1 = cp5.addDropdownList("fontlist")
    .setPosition(55, 15)
    .setSize(200, 200)
    ;
  d1.setBackgroundColor(color(190));
  d1.setItemHeight(20);
  d1.setBarHeight(15);
  d1.getCaptionLabel().set("Font Select");
  d1.close();
  d2 = cp5.addDropdownList("alignment")
    .setPosition(width-55, 15)
    .setSize(100, 200)
    ;
  d2.setBackgroundColor(color(190));
  d2.setItemHeight(20);
  d2.setBarHeight(15);
  d2.getCaptionLabel().set("Text Align");
  d2.close();
  d3 = cp5.addDropdownList("size")
    .setPosition(width-210, 15)
    .setSize(50, 200)
    ;
  d3.setBackgroundColor(color(190));
  d3.setItemHeight(20);
  d3.setBarHeight(15);
  d3.getCaptionLabel().set("Text Size");
  d3.close();

  String[] fontList = PFont.list();
  for (int i = 0; i < fontList.length; i++) {
    d1.addItem(fontList[i], i);
  }

  d2.addItem("LEFT", 0);
  d2.addItem("CENTER", 1);
  d2.addItem("RIGHT", 2);

  d1.setColorBackground(color(60));
  d1.setColorActive(color(255, 128));
  d2.setColorBackground(color(60));
  d2.setColorActive(color(255, 128));
  d3.setColorBackground(color(60));
  d3.setColorActive(color(255, 128));
  String splashImage = dataPath("Adobe_Photoshop_CC_icon.svg.png"); //Display splash screen until we're done loading
  Splashscreen splash = booster.showSplashscreen(splashImage);
  surface.setResizable(true); //Allowing hte user to resize the window
  mp = new Menu_bar(this, menuBarEntries, subMenuBarEntries, actionsFromContext); //Initializing menubar
  currentFill = #000000; //Setting stroke and fill colors
  currentStroke = #FFFFFF;

  //Initializing Tools
  tools[0] = new Brush(loadImage("brush.png"));
  tools[1] = new Eraser(loadImage("eraser.png"));
  tools[2] = new Line(loadImage("line.png"));
  tools[3] = new Circle(loadImage("circle.png"));
  tools[4] = new Rect(loadImage("rect.png"));
  tools[5] = new Text(loadImage("type.png"));
  tools[6] = new TCketManage(loadImage("tCketManage.png"));


  currentTool = tools[0]; //Setting current tool
  splash.hide(); //once everything is loaded, hide the splash screen
  currentProject = new Project(1125, 2436, "Untitled Project");
  for (int i = 0; i < currentProject.wid/4; i++) {
    d3.addItem(str(i*5 + 1), i);
  }

  surface.setVisible(true);
}


void draw() {
  background(color(#212121)); //set background color
  drawCanvas();
  pushStyle(); //Using pushstyle to containerize the UI's style from the rest
  noStroke();
  //Drawing UI
  drawTopBar();
  drawLayersBar();
  drawSideBar();
  popStyle();

  textAlign(RIGHT, BOTTOM);
  textSize(50);
  fill(255);
  text("+", width-10, height-10); //New Layer Button

  if (isOnCanvas()) { //setting cursor based on where mousepointer is
    noFill();
    strokeWeight(2);
    stroke(0);
    ellipseMode(CENTER);
    ellipse(mouseX, mouseY, currentBrushThickness*scaleAmount, currentBrushThickness*scaleAmount);
    noCursor();
  } else {
    cursor(HAND);
  }
}

void drawCanvas() { //Method which draws canvas
  currentProject.canvas.beginDraw(); //Tell canvas we're drawing to it
  currentProject.canvas.background(255);
  currentProject.canvas.pushMatrix();
  currentProject.canvas.translate(currentProject.canvas.width/2, currentProject.canvas.height/2); //Translate centerpoint to center of canvas

  imageMode(CENTER);
  for (int i = int(currentProject.layers.size()-1); i >= 0; i--) {
    currentProject.layers.get(i).render(); //Iterate through all the layers backwards and render them out
  }
  currentProject.canvas.popMatrix();
  currentProject.canvas.endDraw(); //We're done drawing to the canvas!
  pushMatrix(); //We're going to translate the coordinate system now. To avoid this affecting other elements we use Push and Pop Matrix
  translate(width/2 - 100, height/2 + 25); //Translate to relative center position
  scale(scaleAmount); //Scale to user-set scale
  translate(transAmountX, transAmountY); //Translate to user-set position
  imageMode(CENTER); //Set imageMode to center so the canvas get's drawn relative to the center
  image(currentProject.canvas, 0, 0);
  popMatrix();
}

void drawSideBar() { //Method which draws sidebar and all tools availible to user
  //Drawing current stroke and fill colors
  fill(color(#413F42));
  rect(0, 0, 50, height);
  pushStyle();
  rectMode(CENTER);
  fill(currentFill);
  rect(25, 500, 25, 25);

  noFill();
  strokeWeight(7);
  stroke(currentStroke);
  rect(25, 532, 20, 20);

  popStyle();

  pushMatrix(); //To avoid affecting other UI elements
  for (Tool t : tools) {
    //drawing all the tools
    imageMode(CENTER);
    image(t.icon, 25, 75, 30, 30);
    translate(0, 35);
  }
  popMatrix();
}

void drawTopBar() { //Top bar which contains project name and info
  fill(color(#413F42));
  rect(0, 0, width, 50);
  textAlign(CENTER, BOTTOM);
  fill(255);
  textSize(40);
  text(currentProject.name, width/2 - 100, 45); //Project Name
}

void drawLayersBar() { //Draws the layer bar for the user to visualize their layers
  pushStyle();
  pushMatrix(); //Since we're translating coordinate system we need to use pushmatrix to avoid affecting other things
  fill(color(#413F42));
  rect(width - 250, 0, height, height);
  translate(width - 250, 50);
  for (int i = 0; i < currentProject.layers.size(); i++) { //Iterates through all the layers and renders them all one by one
    fill(color(#171010));
    if (i == selectedLayer) {
      stroke(255, 0, 0);
    } else {
      noStroke();
    }
    rect(10, 10, 230, 60);
    fill(255);
    textSize(25);
    textAlign(CENTER, CENTER); //Names the layer relative to center
    text(currentProject.layers.get(i).LayerName, 115, 30);
    translate(0, 80);
  }
  popMatrix();
  popStyle();
}

void mousePressed() { //When the mouse is pressed, use the current tool
  if (isOnCanvas()) {
    //Use current Selected tool
    currentTool.useTool();
  } else {
    //Fill Color
    if (mouseX <= 50 && mouseX >= 0 && mouseY >=475 && mouseY <= 525) {
      currentFill = booster.showColorPickerAndGetRGB("Choose a fill-color to be used", "Color picking");
    } else  if (mouseX <= 50 && mouseX >= 0 && mouseY >=507 && mouseY <= 557) {
      //Stroke Color
      currentStroke = booster.showColorPickerAndGetRGB("Choose a stroke-color to be used", "Color picking");
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 105 && mouseY >= 25) {
      //Brush tool
      currentTool = tools[0];
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 135 && mouseY >= 105) {
      //Eraser tool
      currentTool = tools[1];
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 165 && mouseY >= 135) {
      //Line tool
      currentTool = tools[2];
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 195 && mouseY >= 165) {
      //Ellipse tool
      currentTool = tools[3];
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 225 && mouseY >= 195) {
      //rect tool
      currentTool = tools[4];
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 255 && mouseY >= 225) {
      //tcketmanage tool
      currentTool = tools[5];
    } else if (mouseX <= 50 && mouseX >= 0 && mouseY <= 285 && mouseY >= 255) {
      //tcketmanage tool
      currentTool = tools[6];
    } else if (mouseX >= width - 65 && mouseY >= height - 85) {
      //Add new layer
      currentProject.layers.add(new Layer("Layer " + int(currentProject.layers.size() + 1), currentProject.canvas));
    }
  }
}

void mouseDragged() { //Same as above function, execept for dragging mouse
  if (isOnCanvas()) {
    currentTool.useTool();
  }
}

void mouseReleased() { //Same as above, except for releasing mouse
  if (isOnCanvas()) {
    currentTool.useTool();
  }
}
boolean isOnCanvas() { //Checks if hte mouse pointer is on the canvas
  float actualWidth = currentProject.wid * scaleAmount; //Get's scaled width and height of canvas
  float actualHeight = currentProject.hei * scaleAmount;
  float centerX = (width/2 - 100) + transAmountX; //Finds center coordinates of canvas relative to translations
  float centerY = (height/2 + 25) + transAmountY;

  //Doing math to figure out if the cursor is on the canvas
  return (centerX + actualWidth/2 >= mouseX && centerX - actualWidth/2 <= mouseX && centerY - actualHeight/2 <= mouseY && centerY + actualHeight/2 >= mouseY);
}

void keyPressed() {
  if (keyCode == 96) { //If the user pressed Ctrl + 0, align the canvas to center
    if (currentProject.wid > currentProject.hei) {
      scaleAmount =  (width-350f)/currentProject.wid;
    } else {
      scaleAmount =  (height-125f)/currentProject.hei;
    }
    transAmountX = 0;//Resetting translations, like real photoshop
    transAmountY = 0;
  }
  if (keyCode == 91) { //If the { key is pressed decrease brush size
    currentBrushThickness -= 5;
  } else if (keyCode == 93) { //If } is pressed increase brush size
    currentBrushThickness +=5;
  }
  if (keyCode == UP) { //Move through layers with arrow keys
    if (selectedLayer == 0) {
      selectedLayer = currentProject.layers.size() - 1;
    } else {
      selectedLayer--;
    }
  } else if (keyCode == DOWN) {
    if (selectedLayer == currentProject.layers.size() - 1) {
      selectedLayer = 0;
    } else {
      selectedLayer++;
    }
  }

  if (key == 'd') {
    File file = null;

    while (file == null) { //While an invalid file is selected keep asking hte user for a file
      file = booster.showFileSelection();
      if (file.getName().endsWith(".png") || file.getName().endsWith(".jpg")|| file.getName().endsWith(".jpeg")) { //Making sure the selected file is a PictureStorePro file
        break;
      } else {
        booster.showErrorDialog("Invalid File Selected, Please Try Again", "Error");
        file = null;
      }
    }
    PImage img = loadImage(file.getAbsolutePath());
    currentProject.layers.get(selectedLayer).layer.add(new ImageElement(0, 0, currentProject.canvas, img, file.getAbsolutePath()));
  }
}


void mouseWheel(MouseEvent event) { //Used for zooming
  if (d1.isOpen() || d2.isOpen() || d3.isOpen()) {
    return;
  }
  float e = event.getCount();
  if (keyPressed && keyCode == 17 && scaleAmount >= 0) { //If the user is holding CTRL, we know to zoom
    scaleAmount -= e/18;
    if (scaleAmount < 0) {
      scaleAmount = 0;
    }
  } else if (keyPressed && keyCode == 18) { //If the user is holding alt, we know to move horizontally
    transAmountX -= e*12;
  } else { //Otherwise scroll up and down
    transAmountY -= e*12;
  }
}
