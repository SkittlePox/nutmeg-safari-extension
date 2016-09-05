void setup() {
  size(600, 549);
  background(0, 0, 0, 0);
  
  //noFill();
  //stroke(115);
  //strokeWeight(5);
  //bezier(200, 215, 200, 235, 230, 215, 230, 235);
  
  //ellipse(200,200,15,15);
  //ellipse(230,250,15,15);
  
  fill(115);
  PFont font = loadFont("HelveticaNeue.ttf");
  textFont(font, 12);
  textAlign(CENTER);
  //text("Parent", 210, 190);
  //text("Child", 240, 240);
}

void display() {
  if(tree != null) {
    var nodes = [];
    for(int i = 0; i < tree.nodes.length; i++) {
      nodes.push(new Node(tree.nodes[i]));
    }
    Tree processingTree = new Tree(tree.root, nodes);
    background(0,0,0,0);
    processingTree.display();
  }
}
class Node {
  public Object treeNode;
  public int storeX = -1, storeY = -1;
  public Node parent;
  public Node(Object treeNode) {
    this.treeNode = treeNode;
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
import java.util.HashMap;

class Tree {
  HashMap<String, Node> nodeStore = new HashMap<String, Node>();
  ArrayList<Node> drawn = new ArrayList<Node>();
  ArrayList<Node>[] buffer;
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
    drawn.clear();
    buffer = (ArrayList<Node>[])new ArrayList[depth];
    
    int layer = 0;
    int drawHeight = (availableHeight / 2) - (depth * yDistance / 2);
    displayNodeBasic(nodeStore.get(root), availableWidth/2, drawHeight, 0);
    revise();
  }
  
  public void displayNodeBasic(Node n, int coordX, int coordY, int d) {
    n.displayNode(coordX, coordY);  // This will do a simple display of nodes
    //n.storeX = coordX;
    //n.storeY = coordY;
    
    if (buffer[d] == null) buffer[d] = new ArrayList<Node>();
    buffer[d].add(n);
    drawn.add(n);
    if(d == 0) n.displayTitle(coordX, coordY);
    d++;
    int size = n.treeNode.childrenURLs.length;
    if (n.treeNode.childrenURLs.length == 1) displayNodeBasic(nodeStore.get(n.treeNode.childrenURLs[0]), coordX, coordY + yDistance, d);
    else {
      for(int i = 0; i < n.treeNode.childrenURLs.length; i++) {
        if (!drawn.contains(n.treeNode.childrenURLs[i])) {
          nodeStore.get(n.treeNode.childrenURLs[i]).parent = n;
          displayNodeBasic(nodeStore.get(n.treeNode.childrenURLs[i]), coordX - (size-1)/2.0 * xDistanceMin + xDistanceMin * i, coordY + yDistance, d);
        } 
      }
    }
  }
  
  public void revise() {
    //int fattestRow = 0;
    //for(int i = 1; i < buffer.length; i--) {
    //  if(buffer[i].size() > buffer[fattestRow].size()) fattestRow = i;
    //}
    
    //for(int i = 0; i < buffer.length; i++) {
    //  for(int j = 0; j < buffer[i].size(); j++) {
    //    buffer[i].get(j).displayNode();
    //  }
    //}
  }
  
  public void shift(Node n, int coordXTransform, int coordYTransform) {
    int indexY = -1, indexX = -1;
    for(int i = 0; i < buffer.length; i++) {
      for(int j = 0; j < buffer[i].size(); j++) {
        if(buffer[i].get(j) == n) {
          indexY = i;
          indexX = j;
          break;
        }
      }
      if(indexY != -1) break;
    }
    if(indexY == -1) return;
    
    // TODO: Apply transform
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
