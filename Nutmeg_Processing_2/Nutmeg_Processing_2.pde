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
  if(pTree.hoverNode != null && mouseButton == LEFT) {
    pTree.hoverNode.navigate(true);
  }
}

void mouseOver() {
  loop();
}

void mouseOut() {
  noLoop();
}