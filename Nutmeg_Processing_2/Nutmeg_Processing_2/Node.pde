class Node {
  public Object jsNode;
  public ArrayList<Node> allChildren, allParents, displayedChildren;
  public int row;
  public Node displayedParent;
  
  public Node(Object jsNode) {
    this.jsNode = jsNode;
    allChildren = new ArrayList<Node>();
    allParents = new ArrayList<Node>();
    displayedChildren = new ArrayList<Node>();
  }
}