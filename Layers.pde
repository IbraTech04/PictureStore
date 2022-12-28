//None of these are done yet //<>//

int[] test = {LEFT, CENTER, RIGHT};

class Layer { //Main layer class
  ArrayList<LayerElement> layer; //Elements on layer
  String LayerName; //Layer's Name
  PGraphics canvas; //Reference to Canvas object, so it can draw to it

  public Layer(String LayerName, PGraphics canvas) {
    layer = new ArrayList<LayerElement>();
    this.LayerName = LayerName;
    this.canvas = canvas;
  }

  void render() {
    for (LayerElement l : layer) { //Iterates through all layer elements and renders them
      l.render();
    }
  }
}



abstract class LayerElement { //Abstract layerelement class. This is what will contain all the elements in the layer
  public LayerElement() {
  }
  abstract void render(); //Only necissary function - Rendering
}

class LineElement extends LayerElement { //Class for lines
  int[] x; //X1 and X2
  int[] y; //Y1 and Y2
  color stroke; //Stroke Color
  PGraphics canvas; //Reference to canvas
  int weight; //How thick
  public LineElement(int x1, int y1, int x2, int y2, PGraphics canvas, color stroke, int weight) {
    x = new int[]{x1, x2};
    y = new int[]{y1, y2};
    this.canvas = canvas;
    this.stroke = stroke;
    this.weight = weight;
  }
  void render() {
    canvas.pushStyle(); //Avoid messing up other layer elements' styles
    canvas.stroke(stroke); //Set Stroke
    canvas.strokeWeight(weight); //Set Thickness
    canvas.line(x[0], y[0], x[1], y[1]); //Draw like
    canvas.popStyle();
  }
}

class CircleElement extends LayerElement { //Class for circles
  int x; //Center point
  int y;
  int wid; //Width and height
  int hei;
  PGraphics canvas; //Canvas Reference
  color fill; //Fill and Stroke colors
  color stroke;
  public CircleElement(int x, int y, int wid, int hei, PGraphics canvas, color fill, color stroke) {
    this.x = x;
    this.y = y;
    this.wid = wid;
    this.hei = hei;
    this.canvas = canvas;
    this.fill = fill;
    this.stroke = stroke;
  }

  void render() {

    canvas.pushStyle(); //Avoid messing up other layers' styles
    canvas.ellipseMode(CENTER); //Draw circle relative to center
    canvas.fill(fill);
    canvas.stroke(stroke);
    canvas.ellipse(x, y, wid, hei);

    canvas.popStyle();
  }
}

class RectElement extends LayerElement { //Class for circles
  int x; //Corner coordinates
  int y;
  int wid; //Size
  int hei;
  PGraphics canvas;
  color fill;
  color stroke;
  public RectElement(int x, int y, int wid, int hei, PGraphics canvas, color fill, color stroke) {
    this.x = x;
    this.y = y;
    this.wid = wid;
    this.hei = hei;
    this.canvas = canvas;
    this.fill = fill;
    this.stroke = stroke;
  }

  void render() {

    canvas.pushStyle();
    canvas.rectMode(CORNER);
    canvas.fill(fill);
    canvas.stroke(stroke);
    canvas.rect(x, y, wid, hei);

    canvas.popStyle();
  }
}

class ImageElement extends LayerElement { //Class for circles
  int x;
  int y;
  PGraphics canvas;
  PImage img;
  String path;
  public ImageElement(int x, int y, PGraphics canvas, PImage img, String path) {
    this.x = x;
    this.y = y;
    this.canvas = canvas;
    this.img = img;
    this.path = path;
  }

  void render() {
    canvas.pushStyle();
    canvas.imageMode(CENTER);
    canvas.image(img, x, y, currentProject.wid, currentProject.hei);
    canvas.popStyle();
  }
}

class TextElement extends LayerElement {
  PGraphics canvas;
  int x, y, alignment;
  color col;
  String text;
  PFont font;
  int fontSize;
  public TextElement(PGraphics canvas, int x, int y, int alignment, color col, String text, PFont font, int fontSize) {
    this.canvas = canvas;
    this.x = x;
    this.y = y;
    this.alignment = alignment;
    this.col = col;
    this.text = text;
    this.font = font;
    this.fontSize = fontSize;
  }

  void render() {
    canvas.pushStyle();
    canvas.fill(col);
    canvas.textAlign(alignment, CENTER);
    canvas.textFont(font);
    canvas.fill(col);
    canvas.text(text, x, y);
    canvas.popStyle();
  }
}

class TCketField extends LayerElement {
  PGraphics canvas;
  int x, y, size, alignment;
  color col;
  PFont font;
  String firstName, lastName, eMail;
  PImage QR;

  public TCketField(PGraphics canvas, int x, int y, color col, PFont font, int size, int alignment) {
    super();
    this.canvas = canvas;
    this.x = x;
    this.y = y;
    this.col = col;
    this.font = font;
    this.size = size;
    this.firstName = "<<firstName>>";
    this.lastName = "<<lastName>>";
    this.eMail = "<<email>>";
    this.alignment = alignment;
  }

  void render() {
    canvas.pushStyle();

    if (QR == null) {
      canvas.rectMode(CORNER);
      canvas.fill(0);
      canvas.rect(-562.5, 691.5/4, 562.5*2, 562.5*2);
      canvas.fill(255);
      canvas.textSize(45);
      canvas.textAlign(CENTER, CENTER);
      canvas.text("QR Goes Here\nAny element overlapping\nthis area will not\nbe rendered", 0, 691.5/2);
    } else {
      canvas.imageMode(CORNER);
      canvas.image(QR, -562.5, 691.5/4);
    }
    canvas.textFont(font);
    canvas.textAlign(alignment, CENTER);


    canvas.fill(col);
    String s = String.format("%s %s\n%s", firstName, lastName, eMail);
    canvas.text(s, x, y);

    canvas.popStyle();
  }

  void setMergeFields(String firstName, String lastName, String eMail) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.eMail = eMail;
  }

  void updateSize(int newSize) {
    this.size = newSize;
  }

  void setQR(PImage QR) {
    this.QR = QR;
  }
}
