void setup() {
  size(600, 549);
  background(0,0,0,0);
  fill(115);
  PFont font = loadFont("HelveticaNeue.ttf");
  textFont(font, 12);
  textAlign(CENTER);
}

void display() {
  if(tree == null) return;
  var nodes = [];
  for(int i = 0; i < tree.nodes.length; i++) {
    nodes.push(new Node(tree.nodes[i]));
  }
  Tree pTree = new Tree(tree.root, nodes);
  console.log("Getting past initialization");
  pTree.setup();
  console.log("Getting past setup");
  background(0,0,0,0);
  
  pTree.display();
}
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
import java.util.HashMap;

class Tree {
  public HashMap<String, Node> allNodes = new HashMap<String, Node>();
  public ArrayList<Node> checked;
  public ArrayList<Node>[] buffer;
  public Node rootNode;
  public int depth = 1, spacingY = 50, spacingX = 50;
  
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
    console.log("Hierarchy generated");
    depth = calculateDepth();
    buffer = (ArrayList<Node>[])new ArrayList[depth];
    console.log("Depth calculated and buffer created");
    int rootHeight = 300 - (depth * spacingY / 2);
    progenySort(rootNode.displayedChildren);
    console.log("Progeny sorted");
    progenyJumble(rootNode.displayedChildren);
    console.log("Progeny Jumbled");
    populateBuffer_GenerateCoordinates(rootNode, 300, rootHeight);
    console.log("Buffer populated and coordinates generated");
    bufferTouchUp();
    console.log("Touched up buffer");
  }
  
  public void display() {
    recursivelyDisplay(rootNode);
  }
  
  public void printBuffer() {
    for(ArrayList<Node> r : buffer) {
      var c = "";
      for(Node n : r) {
        c += n.jsNode.title + ", ";
      }
      console.log(c);
    }
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
  
  public void populateBuffer_GenerateCoordinates(Node n, int x, int y) {
    n.x = x;
    n.y = y;
    
    if (buffer[n.row] == null) buffer[n.row] = new ArrayList<Node>();
    buffer[n.row].add(n);
    
    int size = n.displayedChildren.size();
    if(size == 1) {
      console.log(n.displayedChildren.size());
      populateBuffer_GenerateCoordinates(n.displayedChildren.get(0), x, y + spacingY);
    }
    else {
      for(int i = 0; i < size; i++) {
        populateBuffer_GenerateCoordinates(n.displayedChildren.get(i), (int) (x - (size-1)/2.0 * spacingX + spacingX * i), y + spacingY); //FINISH THIS LINE AND REST OF METHOD
      }
    }
  }
  
  public void progenySort(ArrayList<Node> children) {
    for(int i = 0; i < children.size()-1; i++) {
      Node leastChildren = children.get(i);
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
  
  public void progenyJumble(ArrayList<Node> children) {
    Node[] newChildren = new Node[children.size()];
    int smallIterator = 0, bigIterator = children.size()-1;
    
    for(int i = 0; i < children.size()/2; i++) {
      if(i % 2 == 0) {
        newChildren[i] = children.get(bigIterator);
        bigIterator--;
        newChildren[children.size()-1-i] = children.get(bigIterator);
        bigIterator--;
      }
      else {
        newChildren[i] = children.get(smallIterator);
        smallIterator++;
        if(newChildren[children.size()-1-i] == null) {
          newChildren[children.size()-1-i] = children.get(smallIterator);
          smallIterator++;
        }
      }
    }
    
    for(int i = 0; i < children.size(); i++) {
      children.set(i, newChildren[i]);
    }
  }
  
  public void bufferTouchUp() {
    for(int i = 2; i < buffer.length; i++) {
      spaceRow(i);
    }
  }
  
  public void spaceRow(int row) {
    if(buffer[row].size() < 2) return;
    int center = (int) (buffer[row].size()/2);
    console.log(center);
    int leftBranchX = buffer[row].get(center).x, rightBranchX = leftBranchX;
    console.log("getting here");
    for(int i = 1; i < (buffer[row].size()+1)/2+2; i++) {
      if(center - i >= 0) {
        Node left = buffer[row].get(center - i);
        if(leftBranchX - left.x < spacingX) {
          shift(left, -1 * (spacingX - (leftBranchX - left.x)), 0);
        }
        
        leftBranchX = left.x;
      }
      
      if(center + i < buffer[row].size()) {
        Node right = buffer[row].get(center + i);
        if(right.x - rightBranchX < spacingX) {
          shift(right, spacingX - (right.x - rightBranchX), 0);
        }
        
        rightBranchX = right.x;
      }
    }
  }
  
  public void recursivelyDisplay(Node n) {
    n.displayBubble();
    for(Node c : n.displayedChildren) recursivelyDisplay(c);
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
