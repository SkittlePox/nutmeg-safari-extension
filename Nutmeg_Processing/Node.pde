class Node {
  public Object treeNode;
  public Node(Object treeNode) {
    this.treeNode = treeNode;
  }
  
  public void display(int x, int y) {
    noFill();
    stroke(115);
    strokeWeight(4);
    ellipse(x,y,12,12);
    fill(115);
    text(treeNode.title, x+10, y-10);
  }
}