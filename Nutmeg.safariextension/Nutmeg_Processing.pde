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
    clear();
    processingTree.display();
  }
}

void clear() {
  var ctx = sketch.getContext("2d");
  ctx.clearRect(0,0,sketch.width, sketch.height);
}
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
