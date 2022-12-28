class Project { //Project class which has all the info about hte project //<>// //<>// //<>// //<>//
  PGraphics canvas; //Main drawing canvas
  ArrayList<Layer> layers; //All the layers the project has
  String name; //Project Name
  int wid; //Width and height
  int hei;
  public Project(int wid, int hei, String name) {
    layers = new ArrayList<Layer>();
    canvas = createGraphics(wid, hei, JAVA2D);
    layers.add(new Layer("Layer 1", canvas));
    this.wid = wid;
    this.hei = hei;
    this.name = name;
    canvas.smooth(); //Enable smooth motion on canvas
    surface.setTitle("PictureStore 2022 - " + this.name); //set window name accordingly
  }
}

//Method which loads a project from a filepath, obtained using UiBooster
Project loadProject(String FilePath) {

  String[] fileData = loadStrings(FilePath); //Load data from filepath
  String[] metadata = fileData[0].split(":"); //Parse project data (name, dimentions)
  Project project = new Project(int(metadata[1]), int(metadata[2]), metadata[0]); //Create new project using that metadata
  project.layers.clear(); //Remove all layers - we're going to add our own
  int numLayers = 1;
  Layer currentLayer = null;
  for (int i = 1; i < fileData.length; i++) { //Iterate through the entire file
    if (fileData[i].equals("START LAYER")) { //If we're starting a new layer, create a new one in the project
      project.layers.add(new Layer("Layer " + numLayers, project.canvas));
      currentLayer = project.layers.get(numLayers-1);
    } else if (fileData[i].equals("END LAYER")) { //Otherwise if one is done being loaded, add one to the amount of layers
      numLayers++;
    } else { //Otherwise, add the data
      String[] elementData = fileData[i].split(":");
      if (elementData[0].equals("Circle")) { //If this line is a circle
        currentLayer.layer.add(new CircleElement(int(elementData[1]), int(elementData[2]), int(elementData[3]), int(elementData[4]), project.canvas, color(unhex(elementData[5])), color(unhex(elementData[6]))));
      } else if (elementData[0].equals("Line")) { //If this line is a line
        currentLayer.layer.add(new LineElement(int(elementData[1]), int(elementData[2]), int(elementData[3]), int(elementData[4]), project.canvas, color(unhex(elementData[5])), int(elementData[6])));
      } else if (elementData[0].equals("Rect")) { //If this line is a rect
        currentLayer.layer.add(new RectElement(int(elementData[1]), int(elementData[2]), int(elementData[3]), int(elementData[4]), project.canvas, color(unhex(elementData[5])), color(unhex(elementData[6]))));
      } else if (elementData[0].equals("Img")) { //If this line is a rect
        currentLayer.layer.add(new ImageElement(int(elementData[1]), int(elementData[2]), project.canvas, loadImage(elementData[3] + ":" + elementData[4]), elementData[3] + ":" + elementData[4]));
      } else if (elementData[0].equals("tCket")) { //If this line is a rect
        currentLayer.layer.add(new TCketField(project.canvas, int(elementData[1]), int(elementData[2]), color(unhex(elementData[3])), createFont(elementData[4], int(elementData[5])*5+1), int(elementData[5]), int(elementData[6])));
      } else if (elementData[0].equals("Text")) { //If this line is a rect
        currentLayer.layer.add(new TextElement(project.canvas, int(elementData[1]), int(elementData[2]), int(elementData[3]), color(unhex(elementData[4])), elementData[5],  createFont(elementData[4], int(elementData[5])*5+1), int(elementData[5])));
      }
    }
  }

  return project; //Return the completed project
}
//Method which saves a file to a textfile
void saveProject(String FilePath) {
  PrintWriter output; //Using printerwriter to output our data
  output = createWriter(FilePath); //Make a new textfile to write to
  output.println(currentProject.name + ":" + currentProject.wid + ":" + currentProject.hei); //Write project data

  for (int i = 0; i < currentProject.layers.size(); i++) { //Iterate through all the layers
    output.println("START LAYER"); //Start the layer
    for (int j = 0; j < currentProject.layers.get(i).layer.size(); j++) { //Write all the data in that layer
      String layerName = currentProject.layers.get(i).layer.get(j).getClass().getSimpleName();
      if (layerName.equals("CircleElement")) {
        CircleElement currentObject = (CircleElement) currentProject.layers.get(i).layer.get(j);
        output.println("Circle:" + str(currentObject.x) + ":" + str(currentObject.y) + ":" + str(currentObject.wid) + ":" + str(currentObject.hei) + ":" + hex(currentObject.fill) + ":" + hex(currentObject.stroke));
      } else if (layerName.equals("LineElement")) {
        LineElement currentObject = (LineElement) currentProject.layers.get(i).layer.get(j);
        output.println("Line:" + str(currentObject.x[0]) + ":" + str(currentObject.y[0]) + ":" + str(currentObject.x[1]) + ":" + str(currentObject.y[1]) + ":" + hex(currentObject.stroke) + ":" + str(currentObject.weight));
      } else if (layerName.equals("RectElement")) {
        RectElement currentObject = (RectElement) currentProject.layers.get(i).layer.get(j);
        output.println("Rect:" + str(currentObject.x) + ":" + str(currentObject.y) + ":" + str(currentObject.wid) + ":" + str(currentObject.hei) + ":" + hex(currentObject.fill)+ ":" + hex(currentObject.stroke));
      } else if (layerName.equals("ImageElement")) { //if it's an image
        ImageElement currentObject = (ImageElement) currentProject.layers.get(i).layer.get(j);
        output.println("Img:" + str(currentObject.x) + ":" + str(currentObject.y) + ":" + currentObject.path);
      } else if (layerName.equals("TCketField")) {
        TCketField currentObject = (TCketField) currentProject.layers.get(i).layer.get(j);
        output.println("tCket:" + str(currentObject.x) + ":" + str(currentObject.y) + ":" + hex(currentObject.col) + ":" + currentObject.font.getName() + ":" + str(currentObject.size) + ":" + str(currentObject.alignment));
      } else if (layerName.equals("TextElement")) {
        TextElement currentObject = (TextElement) currentProject.layers.get(i).layer.get(j);
        output.println("Text:" + str(currentObject.x) + ":" + str(currentObject.y) + ":" + hex(currentObject.col) + ":" + currentObject.font.getName() + ":" + str(currentObject.fontSize) + ":" + str(currentObject.alignment) + ":" + currentObject.text);
      }
    }
    output.println("END LAYER"); //End the layer
  }
  output.flush();  // Write remaining data to the file
  output.close(); //Closes file
}
