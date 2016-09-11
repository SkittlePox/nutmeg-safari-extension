class Node {
  public Object treeNode;
  public int storeX = -1, storeY = -1, childrenDisplayed = 0;
  public ArrayList<Node> children;
  public Node parent;
  
  public Node(Object treeNode) {
    this.treeNode = treeNode;
    children = new ArrayList<Node>();
  }
  
  public void displayNode(int x, int y) {
    noFill();
    stroke(115);
    strokeWeight(4);
    ellipse(x,y,12,12);
    fill(115);
  }
  
  public void displayNode() {
    if(storeX != -1 && storeY != -1) displayNode(storeX, storeY);
  }
  
  public void displayTitle(int x, int y) {
    text(treeNode.title, x, y-15);
  }
}