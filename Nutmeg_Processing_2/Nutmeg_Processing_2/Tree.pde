import java.util.HashMap;

class Tree {
  public HashMap<String, Node> allNodes = new HashMap<String, Node>();
  public ArrayList<Node> checked;
  public Node rootNode;
  
  public Tree(String rootURL, Node[] comprisingNodes) {
    for(int i = 0; i < comprisingNodes.length; i++) {
      allNodes.put(comprisingNodes[i].jsNode.url, comprisingNodes[i]);
    }
    rootNode = allNodes.get(rootURL);
    checked = new ArrayList<Node>();
  }
  
  public void setup() {
    checked.clear();
    generateHierarchy(rootNode, 0);
  }
  
  public void generateHierarchy(Node parent, int row) {
    checked.add(parent);
    parent.row = row;
    for(int i = 0; i < parent.jsNode.childrenURLs.length; i++) {
      if(!checked.contains(allNodes.get(parent.jsNode.childrenURLs[i]))) {
        checked.add(allNodes.get(parent.jsNode.childrenURLs[i]));
        allNodes.get(parent.jsNode.childrenURLs[i]).displayedParent = parent;
        parent.displayedChildren.add(allNodes.get(parent.jsNode.childrenURLs[i]));
        generateHierarchy(allNodes.get(parent.jsNode.childrenURLs[i]), row+1);
      }
      parent.allChildren.add(allNodes.get(parent.jsNode.childrenURLs[i]));
      allNodes.get(parent.jsNode.childrenURLs[i]).allParents.add(parent);
    }
  }
}