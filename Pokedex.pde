import controlP5.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

ControlP5 cp5;
Textfield inputField;
ScrollableList searchList;
PFont font;

ArrayList<Pokemon> pokeList;
Pokemon current;

void setup() {
  size(800, 400);
 
  cp5 = new ControlP5(this);
  font = loadFont("input.vlw");
  textFont(font, 11);
  
  inputField = new Textfield(cp5, "input");
  inputField.getCaptionLabel().setVisible(false);
  inputField.setSize(200, 30);
  inputField.setPosition(width - 200, 0);
  inputField.setFocus(true);
  inputField.setFont(font);
  inputField.setColorBackground(color(89));
  inputField.setColor(color(244));
  inputField.setColorActive(color(0));
  inputField.setColorForeground(color(0));
  
  searchList = new ScrollableList(cp5, "search");
  searchList.setSize(200, 390);
  searchList.setPosition(width - 200, 30);
  searchList.setFont(font);
  searchList.setBarVisible(false);
  searchList.setBarHeight(0);
  searchList.setItemHeight(30);
  searchList.setColorBackground(color(58));
  searchList.setColorForeground(color(75));
  searchList.setColorValue(color(230));
  searchList.setColorActive(color(75));

  
  //loading pokedex
  pokeList = new ArrayList<Pokemon>();
  XML xml = loadXML("dex.xml");
  XML[] children = xml.getChildren("record");
  for (int i = 0; i < children.length; i++) {
    
    if (children[i].getChild("Pokemon") != null) {
      Pokemon poke = new Pokemon();
      poke.name = children[i].getChild("Pokemon").getContent();
      poke.type1 = children[i].getChild("TypeI").getContent();
      poke.type2 = children[i].getChild("TypeII").getContent();
      poke.size = children[i].getChild("Size").getContent();
      poke.h = Float.parseFloat(children[i].getChild("Height").getContent());
      poke.mass = Float.parseFloat(children[i].getChild("Mass").getContent());
      poke.hp = Integer.parseInt(children[i].getChild("HP").getContent());
      poke.atk = Integer.parseInt(children[i].getChild("Atk").getContent());
      poke.def = Integer.parseInt(children[i].getChild("Def").getContent());
      poke.spa = Integer.parseInt(children[i].getChild("SpA").getContent());
      poke.spd = Integer.parseInt(children[i].getChild("SpD").getContent());
      poke.spe = Integer.parseInt(children[i].getChild("Spe").getContent());
      poke.total = Integer.parseInt(children[i].getChild("Total").getContent());
      
      pokeList.add(poke);
    }
  }
  
  current = pokeList.get(0);
}

void draw() {
  
  background(color(33));
  stroke(color(0));
  
  //dividing lines
  line(width - 201, 0, width - 201, height);
  line(300, 0, 300, height);
  line(0, height / 2, 300, height / 2);
  
  ////////////////////SPRITE BOX////////////////////
  fill(244);
  text(current.name, 10, 20);
  
  if (!current.type2.equals("-")) {
    text(current.type1 + " / "+  current.type2, 300 - (current.type1.length() + current.type2.length()) * 10, 20);
  } else {
    text(current.type1, 300 - current.type1.length() * 10, 20);
  }
  
  text(current.size, 10, 195);
  
  String heightString = "Height: " + current.h + "m";
  text(heightString, 90, 195);
  
  String massString = "Mass: " + current.mass + "kg";
  text(massString, 300 - massString.length() * 9, 195);
  ////////////////////END SPRITE BOX////////////////////
  
  
  ////////////////////GRAPH////////////////////
  int hOffset = height - 20;
  int hp = (int) ((float) current.hp / 255 * 180);
  int atk = (int) ((float) current.atk / 255 * 180);
  int def = (int) ((float) current.def / 255 * 180);
  int spa = (int) ((float) current.spa / 255 * 180);
  int spd = (int) ((float) current.spd / 255 * 180);
  int spe = (int) ((float) current.spe / 255 * 180);
  
  color red = color(255, 84, 84);
  color yellow = color(247, 249, 119);
  color green = color(160, 249, 142);
  color blue = color(142, 197, 249);
  color purple = color(215, 142, 249);
  color pink = color(252, 212, 245);
  
  //graph bottom bar
  fill(200);
  rect(-10, height - 20, 311, 20);
  
  fill(color(244));
  text("TOTAL: " + current.total, 100, 220);
  
  fill(red);
  stroke(red);
  rect(0, hOffset - hp,  50, hp);
  fill(color(0));
  text("HP", 15, hOffset + 15);
  fill(color(0, 0, 0, 0.5));
  text(current.hp, 15, hOffset - 2);
  
  fill(yellow);
  stroke(yellow);
  rect(50, hOffset - atk, 50, atk);
  fill(color(0));
  text("ATK", 60, hOffset + 15);
  fill(color(0, 0, 0, 0.5));
  text(current.atk, 60, hOffset - 3);
  
  fill(green);
  stroke(green);
  rect(100, hOffset - def, 50, def);
  fill(color(0));
  text("DEF", 110, hOffset + 15);
  fill(color(0, 0, 0, 0.5));
  text(current.def, 110, hOffset - 3);
  
  fill(blue);
  stroke(blue);
  rect(150, hOffset - spa, 50, spa);
  fill(color(0));
  text("SPA", 160, hOffset + 15);
  fill(color(0, 0, 0, 0.5));
  text(current.spa, 160, hOffset - 3);
  
  fill(purple);
  stroke(purple);
  rect(200, hOffset - spd, 50, spd);
  fill(color(0));
  text("SPD", 210, hOffset + 15);
  fill(color(0, 0, 0, 0.5));
  text(current.spd, 210, hOffset - 3);
  
  fill(pink);
  stroke(pink);
  rect(250, hOffset - spe, 50, spe);
  fill(color(0));
  text("SPE", 260, hOffset + 15);
  fill(color(0, 0, 0, 0.5));
  text(current.spe, 260, hOffset - 3);
  ////////////////////END GRAPH////////////////////
  
  
  searchList.setOpen(true);
}

public void keyTyped() {
  searchList.clear();
  
  if (!inputField.getText().equals("")) {
    System.out.println(inputField.getText());
    Pattern pattern = Pattern.compile(inputField.getText().toUpperCase());
    
    for (Pokemon poke : pokeList) {
      Matcher matcher = pattern.matcher(poke.name.toUpperCase());
      if (matcher.find() && matcher.start() == 0) {
        searchList.addItem(poke.name, poke);
      }
    }
  }
}

public void input(String theText) {
  for (Pokemon poke : pokeList) {
    if (poke.name.equals(theText)) {
      current = poke;
    }
  }
}

public void search(int n) {
  current = (Pokemon) searchList.getItem(n).get("value");
  inputField.clear();
  searchList.clear();
}