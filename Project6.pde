// VertexAnimation Project - Student Version
import java.io.*;
import java.util.*;

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator("sphere");

/*========Boxes========*/

  //Create 11 Box Interpolators-Essentially Changing position only. Thus Pos Int.
  int n; //keeps count of the interpolators/cubes
  PositionInterpolator[] PositionControllers= new PositionInterpolator[11];
/*-----Camera Setup-------*/
//Using Camera implemented from assignment 3//
CameraControl camCon;

void setup()
{
  pixelDensity(2);
  size(1200, 800, P3D);
  
  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");
  
  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterReverse.SetReverse(true);
  monsterSnap.SetAnimation(monsterAnim);
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*======(COMPLETE) Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  
  //**Setting up the 11 Boxes**//
  int offset=0;
  for (int x=-100;x<=100;)
  {
    //red ones first
     if (n<11)
       {
         //Initializing the controllers
         PositionControllers[n]= new PositionInterpolator("box");
         //creating the animation
         Animation boxAnim= new Animation();
         
         KeyFrame keyFrame= new KeyFrame();
         PVector position= new PVector(x,0,0);
         keyFrame.points.add(position);
         keyFrame.time=0;
         boxAnim.keyFrames.add(keyFrame);
         
         position= new PVector(x,0,-100);
         keyFrame=new KeyFrame();
         keyFrame.points.add(position);
         keyFrame.time=500;
         boxAnim.keyFrames.add(keyFrame);
         
         position= new PVector(x,0,0);
         keyFrame=new KeyFrame();
         keyFrame.points.add(position);
         keyFrame.time=1000;
         boxAnim.keyFrames.add(keyFrame);
         
         position= new PVector(x,0,100);
         keyFrame=new KeyFrame();
         keyFrame.points.add(position);
         keyFrame.time=1500;
         boxAnim.keyFrames.add(keyFrame);
         
         //assigning the animation
         PositionControllers[n].SetAnimation(boxAnim);
         //colors
         PositionControllers[n].SetColor(color(255,0,0)); 
         
         //Initialize Controller
         PositionControllers[n].Update(0);
         PositionControllers[n].OffSetAnimation(offset);
         
         offset+=100;
         n++;
         x+=20;
         
       }
       if (n<11)
       {
         //Initializing the controllers
         PositionControllers[n]= new PositionInterpolator("box");
        
          //creating the animation
         Animation boxAnim= new Animation();
         
         KeyFrame keyFrame= new KeyFrame();
         PVector position= new PVector(x,0,0);
         keyFrame.points.add(position);
         keyFrame.time=0;
         boxAnim.keyFrames.add(keyFrame);
         
         position= new PVector(x,0,-100);
         keyFrame=new KeyFrame();
         keyFrame.points.add(position);
         keyFrame.time=500;
         boxAnim.keyFrames.add(keyFrame);
         
         position= new PVector(x,0,0);
         keyFrame=new KeyFrame();
         keyFrame.points.add(position);
         keyFrame.time=1000;
         boxAnim.keyFrames.add(keyFrame);
         
         position= new PVector(x,0,100);
         keyFrame=new KeyFrame();
         keyFrame.points.add(position);
         keyFrame.time=1500;
         boxAnim.keyFrames.add(keyFrame);
         
         //assigning the animation
         PositionControllers[n].SetAnimation(boxAnim);
         PositionControllers[n].SetFrameSnapping(true);
         //colors
         PositionControllers[n].SetColor(color(255,255,0));
         
         //Initialize Controller
         PositionControllers[n].Update(0);
         PositionControllers[n].OffSetAnimation(offset);
         
         offset+=100;
         n++;
         x+=20;
       }
       
  }
  
  /*====== Create Animations For Spheroid ======*/
  Animation spherePos = new Animation();
  // Create and set keyframes
  KeyFrame newKey= new KeyFrame();
  newKey.time=000.0f;
  newKey.points.add(new PVector(-100,0,100));
  spherePos.keyFrames.add(newKey);
  newKey= new KeyFrame();
  newKey.time=1000.0f;
  newKey.points.add(new PVector(-100,0,-100));
  spherePos.keyFrames.add(newKey);
  newKey= new KeyFrame();
  newKey.time=2000.0f;
  newKey.points.add(new PVector(100,0,-100));
  spherePos.keyFrames.add(newKey);
   newKey= new KeyFrame();
  newKey.time=3000.0f;
  newKey.points.add(new PVector(100,0,100));
  spherePos.keyFrames.add(newKey);
  spherePosition.SetAnimation(spherePos);
  spherePosition.Update(0);
  
   //Setup for the camera
  camCon= new CameraControl();
  perspective(radians(50.0f),width/(float)height,0.1,1000);
  
}

//Helper for draw
//:timer
int prevTime=0;
void draw()
{
  lights();
  background(0);
  //Draw the grid
  DrawGrid();

  rectMode(CENTER);
  
  //**Drawing the Cubes to their locations**//
  for(int i=0; i<n;i++)
  {
    pushMatrix();
    {
      PositionControllers[i].Update(millis());
      translate(PositionControllers[i].GetX(),PositionControllers[i].GetY(),PositionControllers[i].GetZ());
      shape(PositionControllers[i].GetShape());
    }
    popMatrix();
  }
  
  //camera updtae//
  if (mousePressed && (mouseButton == RIGHT))
  SendCamPos();
  camCon.Update();

  float playbackSpeed = 0.5f;

  //// TODO: Implement your own camera

  /*====== Draw Forward Monster ======*/
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.Update(playbackSpeed);
  monsterForward.SetColor(color(128, 200, 54));
  shape(monsterForward.GetShape());
  popMatrix();
  
  /*====== Draw Reverse Monster ======*/
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.Update(-playbackSpeed);
  monsterReverse.SetColor(color(220, 80, 45));
  shape(monsterReverse.GetShape());
  popMatrix();
  
  /*====== Draw Snapped Monster ======*/
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.Update(playbackSpeed);
  monsterSnap.SetColor(color(160, 120, 85));
  shape(monsterSnap.GetShape());
  popMatrix();
  
  ///*====== Draw Spheroid ======*/
  spherePosition.Update(millis());
  sphereForward.Update(playbackSpeed);
  sphereForward.SetColor(color(39, 110, 190));
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();
  
}


// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  Animation animation = new Animation();
  // The BufferedReader class will let you read in the file data
  try
  {
    BufferedReader reader = createReader(fileName);
    int framesSize= Integer.parseInt(reader.readLine());
    int pointsSize= Integer.parseInt(reader.readLine());
    for (int i=0; i<framesSize;i++)
    {
      float frameTime=Float.parseFloat(reader.readLine());
      KeyFrame newFrame= new KeyFrame();
      newFrame.time=frameTime*1000.0f;
      for (int j=0; j<pointsSize;j++)
      {
        PVector temp= new PVector (0,0,0);
        String tempLine= reader.readLine();
        String[] words=tempLine.split(" ");
        temp.x=Float.parseFloat(words[0]);
        temp.y=Float.parseFloat(words[1]);
        temp.z=Float.parseFloat(words[2]);
        newFrame.points.add(j,temp);
      }
      animation.keyFrames.add(i,newFrame);
    }
    
  }
  catch (Exception ex)
  {
    println("Exception: " + ex);
  }

  return animation;
}

void DrawGrid()
{
  // TODO: Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  //Start xCor at -100, zCor-100.//
  stroke(255,255,255);  
  //loop to create the lines
 
  //X Axis lines with blue
  for (int z=-100;z<=100;z+=10)
  {
    //lines every 10 x and y for -100 to 100
    if (z==0)
      stroke(255,0,0);
    line(-100,0,z,100,0,z);
    if (z==0)  
      stroke(255,255,255);
  }
   for (int x=-100;x<=100;x+=10)
  {
    //lines every 10 x and y for -100 to 100
    if(x==0)
      stroke(0,0,255);
    line(x,0,-100,x,0,100);
    if (x==0)
      stroke(255,255,255);
  }
}

//-----Camera Control Method for Draw-------//
void SendCamPos()
{
  //Map Mouse X and Y
  float phi= map(mouseX, 0, width-1, 0, 360/16);  //PHI
  float theta= -map(mouseY, 0, height-1, 0,179/16);  //THETA
  final int  R=200;
  PVector cords= new PVector (0,0,0);
  cords.x=(R*cos(phi)*sin(theta));
  cords.y=R*cos(theta);
  cords.z=R*sin(theta)*sin(phi);
  stroke(0,255,0);
  
  camCon.setPosition(cords.x,cords.y,cords.z);
}


void mouseWheel(MouseEvent e)
{
    camCon.Zoom(e.getCount());
}
