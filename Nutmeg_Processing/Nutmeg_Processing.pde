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