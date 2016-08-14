size(400, 400);

noFill();
stroke(115);
strokeWeight(5);
bezier(85, 20, 10, 10, 90, 90, 15, 80);
bezier(200, 200, 200, 250, 230, 200, 230, 250);

fill(246);
ellipse(200,200,15,15);
ellipse(230,250,15,15);

fill(115);
PFont font = loadFont("HelveticaNeue.ttf");
textFont(font, 12);
text("Parent", 210, 190);
text("Child", 240, 240);