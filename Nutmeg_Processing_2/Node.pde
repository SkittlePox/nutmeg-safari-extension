class Node {
  public Object jsNode;
  public ArrayList<Node> allChildren, allParents, displayedChildren;
  public int row, x = 0, y = 0;
  public boolean titleShow = false, root = false;
  public Node displayedParent;
  public Tree parentTree;
  
  public Node(Object jsNode) {
    this.jsNode = jsNode;
    allChildren = new ArrayList<Node>();
    allParents = new ArrayList<Node>();
    displayedChildren = new ArrayList<Node>();
  }
  
  public void displayBubble() {
    noFill();
    stroke(115);
    strokeWeight(4);
    ellipse(x,y,12,12);
    fill(115);
  }
  
  public void displayTitle(boolean disp) {
    if(disp == titleShow && !root) return;
    if(disp || root) {
      titleShow = true;
      
      fill(239);
      noStroke();
      rect(x, y-25, textWidth(jsNode.title)+10, 18, 5);
      fill(115);
      text(jsNode.title, x, y-20);
    }
    else {
      titleShow = false;
      background(0,0,0,0);
      parentTree.display();
    }
  }
  
  public void listen() {
    if(root) return;
    if(mouseX > x - 12 && mouseX < x + 12 && mouseY > y - 12 && mouseY < y + 12) {
      displayTitle(true);
    }
    else displayTitle(false);
  }
}