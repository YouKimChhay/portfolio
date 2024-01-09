/* Student Name: You Kim Chhay
   Student ID: 44424590 */

final int NCOLOR = 6;
final int NPART = 420;
final int LEFT = 0;
final int TOP = 1;
final int BOTTOM = 2;

color[] typeColors = new color[NCOLOR];
int[] colorIndex = new int[NPART];
float[] x = new float[NPART];
float[] y = new float[NPART];
float[] diameter = new float[NPART];
float[] drawingRect = new float[3];
boolean[] alive = new boolean[NPART];

void setup ()
{
  size(700, 500);
  
  defineColors();
  initialize();
}

void draw ()
{
  background(0);

  checkAttractionForce();
  checkInteraction();
  runSimulation();
  viewStatistics();
}

// This function initialize the color (type of particles)
void defineColors ()
{
  // Set the types of color randomly
  for (int i = 0; i < NCOLOR; i++)
  {
    typeColors[i] = color(random(256), random(256), random(256));
  }
  
  // Each particles' initial color is picked from the available colors, and it won't change during a simulation run.
  int j = 0;
  while(j < NPART)
  {
    for (int k = 0; k < NCOLOR; k++)
    {
      colorIndex[j] = typeColors[k];
      j++;
    }
  }
}

// This function initialize the value of drawingRect, x, y and diameter
void initialize ()
{
  drawingRect[LEFT] = width * 0.3;  // 30% of the width
  drawingRect[TOP] = height * 0.1;  // 10% of the height (top margin)
  drawingRect[BOTTOM] = height - drawingRect[TOP];  // 10% of the height (bottom magin)
  
  /* Each particle's initial position is randomized horizontally within the particle view and vertically between -height * 2 and -height / 3.
     Each particle has different size which is a random number between 3 and 30. */
     
  for (int i = 0; i < NPART; i++)
  {
    x[i] = random(drawingRect[LEFT], width);
    y[i] = random(-height, 0);  // When you run the program, you have to wait a little while before the particles show up.
    diameter[i] = random(3, 30);
    alive[i] = true;
  }
}

// This function runs the simulation (draw and move particles and draw particle view)
void runSimulation ()
{
  for (int i = 0; i < NPART; i++)
  {
    drawParticle(i);
    moveParticle(i);
  }
  
  fill(40, 50, 80);
  rect(0, 0, drawingRect[LEFT], height);  // Statistics view
  fill(255);
  rect(0, 0, width, drawingRect[TOP]);  // top margin
  rect(0, drawingRect[BOTTOM], width, drawingRect[TOP]);  // bottom margin
}

// This function is used to check if the position of a particle is in the area of the particle view or not.
boolean visible(int idx)
{
  return y[idx] >= drawingRect[TOP];
}

// This function draws one particle if it is in the particle view
void drawParticle (int idx)
{
  if (visible(idx) && alive[idx])
  {
    stroke(0);
    fill(colorIndex[idx]);
    ellipse(x[idx], y[idx], diameter[idx], diameter[idx]);
  }
}

// This function moves one particle
void moveParticle (int idx)
{
  // Each particle moves randomly between -3 and 3 horizontally.
  x[idx] += random(-3, 3);
  
  // Each particle moves randomly between -2 and 3 vertically.
  y[idx] += random(-2, 3);
  
  checkParticle(idx);
}

// This function checks if one particle move out of the particle view, then: 
void checkParticle (int idx)
{
  /* If a particle horizontal position is less than the left side of the particle view,
     the horizontal position of the particle should be set to the right side of the particle view, and vice-versa */
     
  if (x[idx] < drawingRect[LEFT] + diameter[idx] / 2)
    x[idx] = width - diameter[idx] / 2;

  else if (x[idx] > width - diameter[idx] / 2)
    x[idx] = drawingRect[LEFT] + diameter[idx] / 2;
  
  /* If a particle vertical position is bigger than the bottom vertical position of the particle view,
     then its vertical position is reset randomly between -height * 2 and -height / 3. */
     
  if (y[idx] > drawingRect[BOTTOM] + diameter[idx] / 2)
    y[idx] = random(-height * 2, -height / 3);
}

// This function provides a visual statistics information
void viewStatistics ()
{
  float[] barX = new float[NPART];
  color[] barColors = typeColors;
  int[] count = new int[NCOLOR]; 
  float barY = drawingRect[TOP];
  float barSize = (drawingRect[BOTTOM] - drawingRect[TOP]) / NCOLOR;
  
  /* The maximum of BarX is 30% of width (drawingRect[LEFT]), and it has 70 particles (NPART / NCOLOR = 420 / 6); however,
     all 70 particles per typeColor never show up all in once (in the particle view area), so I assume that the maximum of each typeColor shown up is 20. */
     
  float increaseBarX = (drawingRect[LEFT] / 20);

  // Initialize the array count and barX to 0
  for (int i = 0; i < NCOLOR; i++)
  {
    count[i] = 0;
    barX[i] = 0;
  }
  
  // Count visible and alive particles according to barColors[]
  for (int i = 0; i < NPART; i++)
  {
    if (visible(i) && alive[i])
    {
      if (barColors[0] == colorIndex[i])
      {
        count[0]++;
        barX[0] += increaseBarX;
      }
      
      if (barColors[1] == colorIndex[i])
      {
        count[1]++;
        barX[1] += increaseBarX;
      }
 
      if (barColors[2] == colorIndex[i])
      {
        count[2]++;
        barX[2] += increaseBarX;
      }
  
      if (barColors[3] == colorIndex[i])
      {
        count[3]++;
        barX[3] += increaseBarX;
      }
  
      if (barColors[4] == colorIndex[i])
      {
        count[4]++;
        barX[4] += increaseBarX;
      }
      
      if (barColors[5] == colorIndex[i])
      {
        count[5]++;
        barX[5] += increaseBarX;
      }
    }
  }
  
  // Draw a bar chart that represent the number of particles (shown by text) per color in the left 30% of the display window 
  for (int i = 0; i < NCOLOR; i++)
  {
    stroke(0);
    fill(barColors[i]);
    rect(0, barY, barX[i], barSize);
    barY += barSize;
  }
  
  // Each text displays the number of particles of each type of colors  
  float textY = drawingRect[TOP] + barSize / 2;
  textAlign(CENTER, CENTER);
  textSize(width / 29); // size 24 in this case width = 700
  fill(0);
  text("(" + count[0] + ")", barX[0] / 2, textY);
  text("(" + count[1] + ")", barX[1] / 2, textY + barSize);
  text("(" + count[2] + ")", barX[2] / 2, textY + 2 * barSize);
  text("(" + count[3] + ")", barX[3] / 2, textY + 3 * barSize);
  text("(" + count[4] + ")", barX[4] / 2, textY + 4 * barSize);
  text("(" + count[5] + ")", barX[5] / 2, textY + 5 * barSize);
}

/* This function checks if any two particles within the particle view are attracted to each other within the range of cohesionForce (random(20, 50)):
   and if they have the same color, draw green line from centre to centre. 
   and if they have different color, draw red line from centre to centre. */
   
void checkAttractionForce ()
{ 
  for (int i = 0; i < NPART; i++)
  {
    for (int k = i + 1; k < NPART - 1; k++)
    {
      if (visible(i) && visible(k) && alive[i] && alive[k])
      {
        float distanceCentres = dist(x[i], y[i], x[k], y[k]);
        float cohesionForce = random(20, 50);
        
        if (distanceCentres <= cohesionForce)
        {
          if (colorIndex[i] == colorIndex[k])
            stroke(0, 255, 0);
          else
            stroke(255, 0, 0);
            
          line(x[i], y[i], x[k], y[k]);
        }
      }
    }
  }
}

/* This function uses to check if any two particles collide and both of them are in the particle view area:
   and if they have the same color, they combine into a bigger particle.
   and if they have different color, they annihilate. The small one disappear, the bigger one has its radius reduced by the smaller's. */
   
void checkInteraction ()
{
  for (int i = 0; i < NPART; i++)
  {
    for (int k = i + 1; k < NPART - 1; k++)
    {
      if (visible(i) && visible(k) && alive[i] && alive[k])
      {
        float distanceCentres = dist(x[i], y[i], x[k], y[k]);
        float collide = (diameter[i] + diameter[k]) / 2;
        
        if (distanceCentres <= collide)
        {
          if (colorIndex[i] == colorIndex[k])
          {
            diameter[i] += diameter[k];
            alive[k] = false;
          }
          else if (diameter[i] < diameter[k])
          {
            diameter[k] -= diameter[i]; 
            alive[i] = false;
              
            if (diameter[k] <= 0)
              alive[k] = false;
          } 
          else if (diameter[i] > diameter[k])
          {
            diameter[i] -= diameter[k];
            alive[k] = false;
              
            if (diameter[i] <= 0)
              alive[i] = false;
          }
        }
      }
    }
  }
}
