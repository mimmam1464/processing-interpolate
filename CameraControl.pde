public class CameraControl
{
  //camera variables
  PVector cam;
  PVector[] targets;
  int targetCounts=0;
  public PVector currentTarget;
  int targetIndex=0;
  PVector upDir;
  float fov;
  
  public CameraControl()
  {
    //Default positionof the camera when it starts
    cam= new PVector(0,-120,280);
    fov= 50.0f;
    targets= new PVector[7];
    currentTarget = new PVector(0,0,0);
  }
  void Update()
  {
    camera(cam.x, cam.y, cam.z+0.1, //Camera Position
    currentTarget.x, currentTarget.y, currentTarget.z, //Camera Target Position
    0,1,0);
    
    //draw the UI text
    fill(255,255,255);
  }
  
  void Zoom(float amount)
 {
   int zoomMultiplier=3;
   fov+=amount*zoomMultiplier;
   perspective(radians(fov),width/(float)height,2,1000);
 }

 
 void setPosition(float x, float y, float z)
 {
   cam.x=currentTarget.x+x;
   cam.y=currentTarget.y+y;
   cam.z=currentTarget.z+z;
   
 }
 
 void CycleTarget()
 {
   targetIndex++;
   if (targetIndex>=7)
     targetIndex=0;
   
   currentTarget=targets[targetIndex];
 }
 
 void AddLookAtTarget(PVector recTarget)
 {
   targets[targetCounts]=recTarget;
   targetCounts++;
   
 }
 

}
