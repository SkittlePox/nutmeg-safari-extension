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
}