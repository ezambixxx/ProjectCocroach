class Cokroach {
  PVector pos;
  PVector vel;
  PImage img;
  float heading;
  boolean alive;

  Cokroach(PImage _img, float _x, float _y) {
    pos = new PVector(_x, _y);
    vel = PVector.random2D();
    heading = 0;
    img = _img;
    alive = true;
  }

  void live() {
    if (alive) {
      pos.add(vel);

      if (pos.x <= 0 || pos.x >= width) vel.x *= -1;
      if (pos.y <= 0 || pos.y >= height) vel.y *= -1;

      heading = atan2(vel.y, vel.x);
      pushMatrix();
      imageMode(CENTER);
      translate(pos.x, pos.y);
      rotate(heading + 0.5 * PI);
      image(img, 0, 0);
      popMatrix();
    }
  }

  void die() {
    alive = false; 
  }

  boolean isAlive() {
    return alive;
  }

  boolean hit(float mx, float my) {
  float d = dist(mx, my, pos.x, pos.y);
  return d < max(paluWidth, paluHeight) / 2; 
}
}
