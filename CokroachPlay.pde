import java.util.ArrayList;
import processing.sound.*;

ArrayList<Cokroach> coks;
PImage img, imgPalu, ground; 
PImage gameTitle;              
SoundFile soundFX, backSound;
int lastSpawnTime;
float paluWidth = 50;   
float paluHeight = 100;  
float paluTipSize = 10; 
boolean gameStarted = false; 
boolean gamePaused = false; 
int score = 0; 
int highScore = 0; 
int nextSpawnThreshold = 10; 

void setup() {
  size(800, 800);                    
  coks = new ArrayList<Cokroach>();
  img = loadImage("kecoa.png");         
  imgPalu = loadImage("palu.png");     
  ground = loadImage("ground.png");     
  gameTitle = loadImage("gameTitle.png"); 
  soundFX = new SoundFile(this, "soundFX.mp3");  
  backSound = new SoundFile(this, "back.mp3");    
  backSound.loop();                         
  lastSpawnTime = millis();
  
  loadHighScore();  
  cursor(); 
}

void draw() {
  if (!gameStarted) {
    showStartScreen(); 
  } else if (gamePaused) {
    showPauseOverlay();  
  } else {
    noCursor(); 
    imageMode(CORNER);                    
    image(ground, 0, 0, width, height);    

    if (millis() - lastSpawnTime > 5000) {
      float x = random(width);
      float y = random(height);
      coks.add(new Cokroach(img, x, y));
      lastSpawnTime = millis();
    }

    if (score >= nextSpawnThreshold) {
        for (int i = 0; i < 10; i++) { 
            float x = random(width);
            float y = random(height);
            coks.add(new Cokroach(img, x, y));
        }
        nextSpawnThreshold += 10;
    }

    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      c.live();

      if (!c.isAlive()) {
        coks.remove(i);
      }
    }

    fill(51);
    textSize(16);
    text("Jumlah Kecoak : " + coks.size(), 110, 750); 
    text("Skor : " + score, 75, 770); 

    imageMode(CENTER);
    image(imgPalu, mouseX, mouseY, paluWidth, paluHeight);

    float paluTipX = mouseX;         
    float paluTipY = mouseY + paluHeight / 2 - 75; 
    fill(255, 0, 0);
    ellipse(paluTipX, paluTipY, paluTipSize, paluTipSize); 
  }
}

void mouseClicked() {
  if (!gameStarted) {
    float playX = width / 2;
    float playY = height / 2 + 80;
    float exitX = width / 2;
    float exitY = height / 2 + 130;

    if (dist(mouseX, mouseY, playX, playY) < 50) {
      gameStarted = true;
    } else if (dist(mouseX, mouseY, exitX, exitY) < 50) {
      if (score > highScore) {
          highScore = score;
      }
      exit();
    }
  } else if (gamePaused) {
    float menuX = width / 2;
    float menuY = height / 2 + 50;
    if (dist(mouseX, mouseY, menuX, menuY) < 50) {
      resetGame();
    }
  } else {
    boolean hit = false;
    float paluTipX = mouseX;                 
    float paluTipY = mouseY + paluHeight / 2 - 75;  

    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      if (c.hit(paluTipX, paluTipY)) {         
        c.die();
        hit = true;
        score++; 
      }
    }

    if (hit) {
      soundFX.play();
    }
  }
}

void keyPressed() {
  if (key == ' ') {  
    gamePaused = !gamePaused;
    if (gamePaused) {
      cursor();  
    } else {
      noCursor();  
    }
  }
}

void showStartScreen() {
  imageMode(CORNER);
  image(ground, 0, 0, width, height);

  imageMode(CENTER);
  image(gameTitle, width / 2, height / 2 - 50); 

  fill(0);
  textSize(32);
  textAlign(CENTER);
  textFont(createFont("Arial-Bold", 32));
  text("Play", width / 2, height / 2 + 110); 
  text("Exit", width / 2, height / 2 + 160); 
  text("High Score: " + highScore, width / 2, height / 2 + 135); 
}

void showPauseOverlay() {
  fill(255, 255, 255, 200);  // Overlay transparan
  rect(width / 2 - 150, height / 2 - 75, 300, 150, 20);  

  fill(0);
  textSize(32);
  textAlign(CENTER);
  text("Game Paused", width / 2, height / 2 - 20);
  text("Menu", width / 2, height / 2 + 30);
}

void resetGame() {
  if (score > highScore) {
  highScore = score; 
  saveHighScore();  
  }
  gameStarted = false;
  gamePaused = false;
  score = 0;
  nextSpawnThreshold = 10;
  coks.clear(); // Hapus semua kecoa
}

void loadHighScore() {
  String[] data = loadStrings("highscore.txt");
  if (data != null && data.length > 0) {
    highScore = int(data[0]); 
  }
}

void saveHighScore() {
  String[] data = { str(highScore) }; 
  saveStrings("highscore.txt", data); 
}
