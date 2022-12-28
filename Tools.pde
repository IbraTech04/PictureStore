abstract class Tool { //Main Class for tools
  PImage icon;
  abstract void useTool(); //Function which gets called whenever a mouse is pressed/moved/released and a tool is selected
  public Tool(PImage icon) {
    this.icon = icon;
  }
}

class Brush extends Tool {
  void useTool() {
    if (isOnCanvas()) {
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));

      float distX = ((mouseX - centerX)/scaleAmount) - transAmountX;
      float distY = ((mouseY - centerY)/scaleAmount) - transAmountY;

      currentProject.layers.get(selectedLayer).layer.add(new CircleElement(int(distX), int(distY), currentBrushThickness, currentBrushThickness, currentProject.canvas, currentFill, currentFill));
    }
  }
  public Brush(PImage tool) {
    super(tool);
  }
}

class Eraser extends Tool {
  void useTool() {
    if (isOnCanvas()) {
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));

      float distX = ((mouseX - centerX)/scaleAmount) - transAmountX;
      float distY = ((mouseY - centerY)/scaleAmount) - transAmountY;

      currentProject.layers.get(selectedLayer).layer.add(new CircleElement(int(distX), int(distY), currentBrushThickness, currentBrushThickness, currentProject.canvas, color(#ffffff), color(#ffffff)));
    }
  }
  public Eraser(PImage tool) {
    super(tool);
  }
}

class Line extends Tool {

  int x1;
  int x2;
  int y1;
  int y2;
  boolean lineInProgress = false;
  public Line(PImage tool) {
    super(tool);
  }

  void useTool() {
    if (mousePressed && !lineInProgress) {
      lineInProgress = true;
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));

      x1 = int(((mouseX - centerX)/scaleAmount) - transAmountX);
      y1 = int(((mouseY - centerY)/scaleAmount) - transAmountY);
    } else if (!mousePressed && lineInProgress) {
      lineInProgress = false;
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));

      x2 = int(((mouseX - centerX)/scaleAmount) - transAmountX);
      y2 = int(((mouseY - centerY)/scaleAmount) - transAmountY);

      currentProject.layers.get(selectedLayer).layer.add(new LineElement(x1, y1, x2, y2, currentProject.canvas, currentStroke, currentBrushThickness));
    }
  }
}

class Circle extends Tool {

  int x;
  int y;
  int xSize;
  int ySize;

  boolean circleInProgress = false;
  public Circle(PImage tool) {
    super(tool);
  }
  void useTool() {
    if (mousePressed && !circleInProgress) {
      circleInProgress = true;
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));

      x = int(((mouseX - centerX)/scaleAmount) - transAmountX);
      y = int(((mouseY - centerY)/scaleAmount) - transAmountY);
    } else if (!mousePressed && circleInProgress) {
      circleInProgress = false;
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));
      int x2 = int(((mouseX - centerX)/scaleAmount) - transAmountX);
      int y2 = int(((mouseY - centerY)/scaleAmount) - transAmountY);
      if (keyPressed && keyCode == 18) {
        xSize = int(dist(x, y, x2, y2));
        xSize = ySize;
      } else {
        xSize = x2 - x;
        ySize = y2 - y;
      }
      currentProject.layers.get(selectedLayer).layer.add(new CircleElement(x, y, xSize, ySize, currentProject.canvas, currentFill, currentStroke));
    }
  }
}

class Rect extends Tool {

  int x;
  int y;
  int xSize;
  int ySize;

  boolean rectInProgress = false;
  public Rect(PImage tool) {
    super(tool);
  }
  void useTool() {
    if (mousePressed && !rectInProgress) {
      rectInProgress = true;
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));

      x = int(((mouseX - centerX)/scaleAmount) - transAmountX);
      y = int(((mouseY - centerY)/scaleAmount) - transAmountY);
    } else if (!mousePressed && rectInProgress) {
      rectInProgress = false;
      float centerX = ((width/2 - 100));
      float centerY = ((height/2 + 25));
      int x2 = int(((mouseX - centerX)/scaleAmount) - transAmountX);
      int y2 = int(((mouseY - centerY)/scaleAmount) - transAmountY);
      if (keyPressed && keyCode == 18) {
        xSize = int(dist(x, y, x2, y2));
        xSize = ySize;
      } else {
        xSize = x2 - x;
        ySize = y2 - y;
      }
      currentProject.layers.get(selectedLayer).layer.add(new RectElement(x, y, xSize, ySize, currentProject.canvas, currentFill, currentStroke));
    }
  }
}

class Text extends Tool {
  Text(PImage tool) {
    super(tool);
  }

  void useTool() {
    float centerX = ((width/2 - 100));
    float centerY = ((height/2 + 25));

    int x = int(((mouseX - centerX)/scaleAmount) - transAmountX);
    int y = int(((mouseY - centerY)/scaleAmount) - transAmountY);

    String text = booster.showTextInputDialog("What text would you like in this text box?");
    if (text == null) {
      return;
    }

    currentProject.layers.get(selectedLayer).layer.add(new TextElement(currentProject.canvas, x, y, test[int(d2.getValue())], currentFill, text, createFont(PFont.list()[int(d1.getValue())], int(d3.getValue())*5+1), int(d3.getValue())));
  }
}

class TCketManage extends Tool {
  TCketManage(PImage tool) {
    super(tool);
  }

  void useTool() {
    float centerX = ((width/2 - 100));
    float centerY = ((height/2 + 25));

    int x = int(((mouseX - centerX)/scaleAmount) - transAmountX);
    int y = int(((mouseY - centerY)/scaleAmount) - transAmountY);
    if (currentProject.layers.get(0).LayerName.equals("tCketLayer")) {
      currentProject.layers.get(0).layer.set(0, new TCketField(currentProject.canvas, x, y, currentFill, createFont(PFont.list()[int(d1.getValue())], int(d3.getValue())*5+1), int(d3.getValue()), test[int(d2.getValue())]));
    } else {
      currentProject.layers.add(0, new Layer("tCketLayer", currentProject.canvas));
      currentProject.layers.get(0).layer.add(0, new TCketField(currentProject.canvas, x, y, currentFill, createFont(PFont.list()[int(d1.getValue())], int(d3.getValue())*5+1), int(d3.getValue()), test[int(d2.getValue())]));
      selectedLayer = 1;
    }
  }
}
