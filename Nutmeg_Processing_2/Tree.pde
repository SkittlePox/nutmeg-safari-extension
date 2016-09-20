import java.util.HashMap;

class Tree {
  public HashMap<String, Node> allNodes = new HashMap<String, Node>();
  public ArrayList<Node> checked;
  public Node rootNode;
  public int depth = 1;
  
  public Tree(String rootURL, Node[] comprisingNodes) {
    for(int i = 0; i < comprisingNodes.length; i++) {
      allNodes.put(comprisingNodes[i].jsNode.url, comprisingNodes[i]);
    }
    rootNode = allNodes.get(rootURL);
    checked = new ArrayList<Node>();
  }
  
  public void setup() {
    checked.clear();
    checked.add(rootNode);
    generateHierarchy(rootNode, 0);
    depth = calculateDepth();
  }
  
  public void generateHierarchy(Node parent, int row) {
    parent.row = row;  // Sets row of parent
    for(int i = 0; i < parent.jsNode.childrenURLs.length; i++) {
      String childURL = parent.jsNode.childrenURLs[i];
      Node childNode = allNodes.get(childURL);
      if(!checked.contains(childNode)) {        // If not already processed
        checked.add(childNode);                 // Mark it as processed
        childNode.displayedParent = parent;     // Assigning single parent
        parent.displayedChildren.add(childNode);// Add childNode to ArrayList of parent's displayed children
        generateHierarchy(childNode, row+1);    // Recurs
      }
      parent.allChildren.add(childNode);    // Add childNode to ArrayList of all of parent's children
      childNode.allParents.add(parent);     // Add parent to ArrayList of all ofchild's parents
    }
  }
  
  public void progenySort(ArrayList<Node> children) {
    for(int i = 0; i < children.size()-1; i++) {
      Node leastChildren = children.get(0);
      int lowIndex = i;
      for(int j = i+1; j < children.size(); j++) {
        if(children.get(j).displayedChildren.size() < leastChildren.displayedChildren.size()) {
          leastChildren = children.get(j);
          lowIndex = j;
        }
      }
      Node replaced = children.get(i);
      children.set(i, leastChildren);
      children.set(lowIndex, replaced);
      
      if(children.get(i).displayedChildren.size() > 1) progenySort(children.get(i).displayedChildren);
    }
  }
  
  public void graphicalSwap(Node a, Node b) {
    int distance = b.x - a.x;
    shift(a, distance, 0);
    shift(b, -distance, 0);
  }
  
  public void shift(Node n, int pushX, int pushY) {
    n.x += pushX;
    n.y += pushY;
    
    for(Node c : n.displayedChildren) {
      shift(c, pushX, pushY);
    }
  }
  
  public int calculateDepth() {
    int deepest = 0;
    for(Node n : allNodes.values()) {
      if(n.row > deepest) deepest = n.row;
    }
    return deepest;
  }
}