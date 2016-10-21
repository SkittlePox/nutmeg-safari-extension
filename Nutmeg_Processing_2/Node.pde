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