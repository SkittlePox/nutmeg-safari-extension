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
    createBuffer(nodeStore.get(root), 0);
    autoSwap(nodeStore.get(root));
    generateCoords(nodeStore.get(root), availableWidth/2, drawHeight);
    //revise();
    finalDisplay();
  }
  
  public void firstPass(Node n, int coordX, int coordY, int d) {
    //n.displayNode(coordX, coordY);  // This will do a simple display of nodes
    n.storeX = coordX;
    n.storeY = coordY;
    
    if (buffer[d] == null) buffer[d] = new ArrayList<Node>();
    buffer[d].add(n);
    drawn.add(n);
    if(d == 0) n.displayTitle(coordX, coordY);
    d++;
    int size = n.treeNode.childrenURLs.length;
    if (n.treeNode.childrenURLs.length == 1) firstPass(nodeStore.get(n.treeNode.childrenURLs[0]), coordX, coordY + yDistance, d);
    else {
      for(int i = 0; i < n.treeNode.childrenURLs.length; i++) {
        if (!drawn.contains(n.treeNode.childrenURLs[i])) {
          nodeStore.get(n.treeNode.childrenURLs[i]).parent = n;
          n.childrenDisplayed++;
          firstPass(nodeStore.get(n.treeNode.childrenURLs[i]), coordX - (size-1)/2.0 * xDistanceMin + xDistanceMin * i, coordY + yDistance, d);
        } 
      }
    }
  }
  
  public void createBuffer(Node n, int row) {
    if (buffer[row] == null) buffer[row] = new ArrayList<Node>();
    buffer[row].add(n);
    drawn.add(n);
    row++;
    
    ArrayList<Node> children = new ArrayList<Node>();
    
    for(int i = 0; i < n.treeNode.childrenURLs.length; i++) {
      if (!drawn.contains(n.treeNode.childrenURLs[i])) {
        nodeStore.get(n.treeNode.childrenURLs[i]).parent = n;
        children.add(nodeStore.get(n.treeNode.childrenURLs[i]));
        n.childrenDisplayed++;
      }
    }
    
    for(Node c : children) {
      createBuffer(c, row); 
    }
  }
  
  public void generateCoords(Node n, int coordX, int coordY) {
    n.storeX = coordX;
    n.storeY = coordY;
    if(n.childrenDisplayed == 0) return;
    int childIndex = 0;
    
    for(int i = 0; i < buffer.length; i++) {
      for(int j = 0; j < buffer[i].size(); j++) {
        if(buffer[i].get(j).parent == n) {
          generateCoords(buffer[i].get(j), (int)(coordX - (n.childrenDisplayed-1)/2.0 * xDistanceMin + xDistanceMin * childIndex), coordY + yDistance);
          childIndex++;
        }
      }
    }
  }
  
  public void revise() {
    
  }
  
  public void shift(Node n, int coordXTransform, int coordYTransform) {
    ArrayList<Node> parents = new ArrayList<Node>();
    parents.add(n);
    n.storeX += coordXTransform;
    n.storeY += coordYTransform;
    int indexY = -1, indexX = -1;
    for(int i = 0; i < buffer.length; i++) {
      for(int j = 0; j < buffer[i].size(); j++) {
        int s = parents.size();
        for(int r = 0; r < s; r++) {
          if(buffer[i].get(j).parent == parents.get(r)) {
            parents.add(buffer[i].get(j));
            buffer[i].get(j).storeX += coordXTransform;
            buffer[i].get(j).storeY += coordYTransform;
          }
        }
      }
    }
  }
  
  public void autoSwap(Node parent) {
    if(parent.childrenDisplayed == 0) return;
    
    int start = 99999, end = -1, row = -1;
    ArrayList<Node> children = new ArrayList<Node>();
    for(int i = 1; i < buffer.length; i++) {
      for(int j = 0; j < buffer[i].size(); j++) {
        if(buffer[i].get(j).parent == parent) {
          if(j < start) start = j;
          if(j > end) end = j;
          if(row == -1) row = i;
          children.add(buffer[i].get(j));
        }
      }
      if(end != -1) break;
    }
       
    if(children.size() == 1) {
      autoSwap(children.get(0));
      return;
    }
    
    childSort(children);
    // TODO FIX THIS
    
    Node[] distChildren = new Node[children.size()];  // Distributed Children
    int lowIndex = 0, highIndex = children.size()-1;
    for(int i = 0; i < distChildren.length/2 + 1; i++) {
      if(i % 2 == 0) {
        distChildren[i] = children.get(highIndex);
        highIndex--;
        if(i != distChildren.length-1-i) {
          distChildren[distChildren.length-1-i] = children.get(highIndex);
          highIndex--;
        }
      }
      else {
        distChildren[i] = children.get(lowIndex);
        lowIndex++;
        if(i != distChildren.length-1-i) {
          distChildren[distChildren.length-1-i] = children.get(lowIndex);
          lowIndex++;
        }
      }
    }
    text("Getting here", 210, 190 + 10 * row);
    
    int tempIndex = 0;
    for(int i = start; i <= end; i++) {
      buffer[row].set(i, distChildren[tempIndex]);
      tempIndex++;
    }
    
    for(int i = 0; i < distChildren.length; i++) {
      autoSwap(distChildren[i]);
    }
  }
  
  public void swap(Node a, Node b) {
    int dist = b.storeX - a.storeX;
    shift(a, dist, 0);
    shift(b, -dist, 0);
  }
  
  public void childSort(ArrayList<Node> children) {  // Sorts by smallest to largest amount of children
  text(children.size(), 50, 190);
    for(int i = 0; i < children.size()-1; i++) {
      int smallIndex = i;
      for(int j = i+1; j < children.size(); j++) {
        if(children.get(j).childrenDisplayed < children.get(smallIndex).childrenDisplayed) smallIndex = j;
      }
      if(smallIndex != i) {
        Node small = children.get(smallIndex);
        children.set(smallIndex, children.set(i, children.get(smallIndex)));
      }
    }
  }
  
  public void finalDisplay() {
    for(int i = 0; i < buffer.length; i++) {
      for(int j = 0; j < buffer[i].size(); j++) {
        buffer[i].get(j).displayNode();
      }
    }
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
