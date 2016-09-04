import java.util.HashMap;

class Tree {
  HashMap<String, Node> nodeStore = new HashMap<String, Node>();
  int depth = 0, availableWidth = 600, availableHeight = 550;
  int yDistance = 50, xDistanceMin = 50;
  String root;
  public Tree(String root, Node[] nodes) {
    this.root = root;
    for(int i = 0; i < nodes.length; i++) {
      nodeStore.put(nodes[i].treeNode.url, nodes[i]);
    }
  }
  
  public void display() {
    depth = findDepth(nodeStore.get(root));
    
    int layer = 0;
    int drawHeight = (availableHeight / 2) - (depth * yDistance / 2);
    nodeStore.get(root).display(availableWidth/2, drawHeight);
  }
  
  public int findDepth(Node n) {
    if(n.treeNode.childrenURLs.length > 0) {
      int[] subDepths = new int[n.treeNode.childrenURLs.length];
      for(int i = 0; i < n.treeNode.childrenURLs.length; i++) {
        subDepths[i] = findDepth(nodeStore.get(n.treeNode.childrenURLs[i]));
      }
      int max = 0;
      for(int i = 0; i < subDepths.length; i++) {
        if(subDepths[i] > max) max = subDepths[i];
      }
      return max + 1;
    } else {
      return 1;
    }
  }
}