class Node {
  public Object jsNode;
  public ArrayList<Node> allChildren, allParents, displayedChildren;
  public int row, x = 0, y = 0;
  public Node displayedParent;
  
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
}