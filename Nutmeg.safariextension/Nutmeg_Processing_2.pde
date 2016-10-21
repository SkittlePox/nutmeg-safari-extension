void setup() {
  size(600, 549);
  background(0,0,0,0);
  fill(115);
  PFont font = loadFont("HelveticaNeue.ttf");
  textFont(font, 12);
  textAlign(CENTER);
  rectMode(CENTER);
  noLoop();
}

Tree pTree;

void display() {
  if(tree == null) return;
  var nodes = [];
  for(int i = 0; i < tree.nodes.length; i++) {
    nodes.push(new Node(tree.nodes[i]));
  }
  pTree = new Tree(tree.root, nodes);
  console.log("Getting past initialization");
  pTree.setup();
  console.log("Getting past setup");
  background(0,0,0,0);
  
  pTree.display();
}

void draw() {
  if(pTree != null) pTree.listen();
}

void mouseClicked() {
  if(pTree.hoverNode != null) {
    pTree.hoverNode.navigate(true);
  }
}

void mouseOver() {
  loop();
}

void mouseOut() {
  noLoop();
}

// TODO Maybe use processing loop() functionality to active hovering
import java.util.Date;

class Node {
  public Object jsNode;
  public ArrayList<Node> allChildren, allParents, displayedChildren;
  public int row, x = 0, y = 0;
  public boolean titleShow = false, root = false;
  public long displayUntil = new Date().getTime();
  public Node displayedParent;
  public Tree parentTree;
  
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
    if(root) displayTitle();
    if(titleShow) displayTitle();
  }
  
  public void displayTitleRequest(boolean request) {
    if(request == titleShow && !request) return;
    if(request) {
      parentTree.displayBuffer[row] = this;
      titleShow = true;
      displayUntil = new Date().getTime();
      displayUntil += 1200;
    } else if(new Date().getTime() < displayUntil && (parentTree.displayBuffer[row] == null || parentTree.displayBuffer[row] == this)) {
      titleShow = true;
      parentTree.displayBuffer[row] = this;
    } else titleShow = false;
    
    if(titleShow) displayTitle();
    else {
      if(parentTree.displayBuffer[row] == this) parentTree.displayBuffer[row] = null;
      background(0,0,0,0);
      parentTree.display();
    }
  }
  
  public void displayTitle() {
    fill(239);
    noStroke();
    rect(x, y-25, textWidth(jsNode.title != null ? jsNode.title : jsNode.url)+10, 18, 10);
    fill(115);
    text(jsNode.title != null ? jsNode.title : jsNode.url, x, y-20);
  }
  
  public void listen() {
    if(mouseX > x - 12 && mouseX < x + 12 && mouseY > y - 12 && mouseY < y + 12) {
      parentTree.hoverNode = this;
      if(!root) displayTitleRequest(true);
    }
    else {
      if(parentTree.hoverNode == this) parentTree.hoverNode = null;
      if(!root) displayTitleRequest(false);
    }
  }
  
  public void navigate(boolean newTab) {
    navigateToPage(jsNode.url, newTab);
  }
}
import java.util.HashMap;

class Tree {
  public HashMap<String, Node> allNodes = new HashMap<String, Node>();
  public ArrayList<Node> checked;
  public ArrayList<Node>[] buffer;
  public Node[] displayBuffer;
  public Node rootNode;
  public Node hoverNode;
  public int depth = 1, spacingY = 56, spacingX = 50;
  
  public Tree(String rootURL, Node[] comprisingNodes) {
    for(int i = 0; i < comprisingNodes.length; i++) {
      allNodes.put(comprisingNodes[i].jsNode.url, comprisingNodes[i]);
      comprisingNodes[i].parentTree = this;
    }
    rootNode = allNodes.get(rootURL);
    rootNode.root = true;
    checked = new ArrayList<Node>();
  }
  
  public void setup() {
    checked.clear();
    checked.add(rootNode);
    generateHierarchy(rootNode, 0);
    console.log("Hierarchy generated");
    depth = calculateDepth();
    buffer = (ArrayList<Node>[])new ArrayList[depth];
    displayBuffer = new Node[depth];
    console.log("Depth calculated and buffer created");
    int rootHeight = 250 - (depth * spacingY / 2);
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
    rootNode.displayTitleRequest(true);
    recursivelyDisplay(rootNode);
  }
  
  public void listen() {
    for(Node n : displayBuffer) {
      if(n != null) {
        n.listen();
      }
    }
    recursivelyListen(rootNode);
  }
  
  public void recursivelyListen(Node n) {
    n.listen();
    for(Node c : n.displayedChildren) {
      recursivelyListen(c);
    }
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
        populateBuffer_GenerateCoordinates(n.displayedChildren.get(i), (int) (x - (size-1)/2.0 * spacingX + spacingX * i), y + spacingY);
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
    if(children.size() < 3) return;
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
    for(int i = buffer.length - 2; i > 0; i--) {
      beautifyRow(i);
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
  
  public void beautifyRow(int row) {
    for(Node n : buffer[row]) {
      if(n.displayedChildren.size() > 0) {
        int sum = 0;
        for(Node c : n.displayedChildren) {
          sum += c.x;
        }
        n.x = (int) (sum / n.displayedChildren.size());
      }
    }
  }
  
  public void recursivelyDisplay(Node n) {
    if(n.displayedParent != null) {
      noFill();
      stroke(115);
      strokeWeight(5);
      bezier(n.displayedParent.x, n.displayedParent.y + 15, n.displayedParent.x, n.y - 15, n.x, n.displayedParent.y + 15, n.x, n.y - 15);
    }
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
