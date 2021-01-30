abstract class Interpolator
{
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  float offsetTime=0;
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  PShape currentShape;
  boolean reverse=false;
  int currentKey=0;
  int nextKey()
  {
    if(!reverse)
    {
    if (currentKey+1<animation.keyFrames.size())
      return currentKey+1;
    else
      return 0;
    }
    else
    {
      if(currentKey-1>=0)
        return currentKey-1;
      else
        return animation.keyFrames.size()-1;
    }
  }
  
  void SwitchKey()
  {
    int getKey=nextKey();
    currentKey=getKey;
  }
  
  void SetAnimation(Animation anim)
  {
    animation = anim;
  }
  
  void SetReverse(boolean rev)
  {
    reverse=rev;
    currentKey=animation.keyFrames.size()-1;
  }
  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }
  
   void SetColor(color col)
  {
    currentShape.setFill(col);
  }
  
  PShape GetShape()
  {
    return currentShape;
  }
  
  boolean once=true;
  float passedTime;
  void UpdateTime(float time)
  {
    noStroke();
    currentTime=(time+offsetTime) % (animation.GetDuration()+(animation.GetDuration()/animation.keyFrames.size()));
    if (reverse)
      currentTime= (animation.GetDuration()+(animation.GetDuration()/animation.keyFrames.size()))-currentTime;
    if (!reverse)
    {
      if(nextKey()!=0)
    {
      if (currentTime>=animation.keyFrames.get(nextKey()).time)
      {
        SwitchKey();
        once=false;
      }
    }
    
    else if (currentTime>0 & currentTime< animation.keyFrames.get(1).time &!once)
      {
        SwitchKey();
      }
    }
    
    else //if reverse
        {
      if(nextKey()!=animation.keyFrames.size()-1)
    {
      if (currentTime<=animation.keyFrames.get(nextKey()).time)
      {
        SwitchKey();
        once=false;
      }
    }
    
    else if ((currentTime<animation.keyFrames.get(animation.keyFrames.size()-1).time) & (currentTime>animation.keyFrames.get(animation.keyFrames.size()-2).time) & (!once))
      {
        SwitchKey();
      }
    }
  }
  
  void OffSetAnimation(float seconds)
  {
    offsetTime+=seconds;
  }
  
  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float times);
}


//**ABSTRACT CLASS ENDS, ITS IMPLEMETATIONS BELOW**//
class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  ShapeInterpolator()
  {
    //Default Constructor doing the monsters//
   currentShape= new PShape();
  }
  
  void Update(float time)
  {
    // TODO: Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
     //**Set Current shape equal to the new shape according to the animation**//
     if (snapping || currentShape.getVertexCount()==0)
     {
     ArrayList<PVector> thisPoint= animation.keyFrames.get(currentKey).points;
     PShape newShape= createShape();
     newShape.beginShape(TRIANGLE);
     for (int i=0; i<thisPoint.size();i++)
     {
       newShape.vertex(thisPoint.get(i).x,thisPoint.get(i).y,thisPoint.get(i).z);
     }
     newShape.endShape(CLOSE);
     currentShape= newShape;
     UpdateTime(millis()*time);
     }
     
     else if (!snapping)
     {
       //get the sphere to interpolate
       KeyFrame prevFrame= animation.keyFrames.get(currentKey);
       KeyFrame nextFrame= animation.keyFrames.get(nextKey());
       float timeDiff;
       if (nextKey()!=0)
       timeDiff=nextFrame.time-prevFrame.time;
       else
       timeDiff=nextFrame.time;
       if (time<0)
       time*=-1;
       float elapsedTime=currentTime-animation.keyFrames.get(currentKey).time;
       float ratio=elapsedTime/timeDiff;
       //used in the loop
       float prevx;
       float prevy;
       float prevz;
       float xdif;
       float ydif;
       float zdif;
       
       PShape newShape= createShape();
       newShape.beginShape(TRIANGLE);
       for(int i=0; i<nextFrame.points.size();i++)
       {
         prevx=animation.keyFrames.get(currentKey).points.get(i).x;
         prevy=animation.keyFrames.get(currentKey).points.get(i).y;
         prevz=animation.keyFrames.get(currentKey).points.get(i).z;
         
         xdif= (animation.keyFrames.get(nextKey()).points.get(i).x)-(animation.keyFrames.get(currentKey).points.get(i).x);
         ydif= (animation.keyFrames.get(nextKey()).points.get(i).y)-(animation.keyFrames.get(currentKey).points.get(i).y);
         zdif= (animation.keyFrames.get(nextKey()).points.get(i).z)-(animation.keyFrames.get(currentKey).points.get(i).z);
         
         if(ratio>=0.0f &ratio<=1.0f)
         {
           xdif*=ratio;
           ydif*=ratio;
           zdif*=ratio;
           newShape.vertex(prevx+xdif, prevy+ydif, prevz+zdif);
         }
         
         else
         {
           newShape.endShape();
           newShape=currentShape;
           break;
         }
       }
         newShape.endShape();
         currentShape=newShape;
         UpdateTime(millis()*time);
     }
     }
}
//*SHAPE INTERPOLATOR ENDS**//
class PositionInterpolator extends Interpolator
{
  PVector currentPosition= new PVector(0,0,0);
  int typeP=0;
  
  PositionInterpolator(String type)
  {
    if(type=="box")
    {
      currentShape=createShape(BOX,20);
      typeP=1;
    }
    else
    {
      typeP=2;
    }
  }
  
  float GetX()
  {
    return currentPosition.x;
  }
  
    float GetY()
  {
    return currentPosition.y;
  }
  
    float GetZ()
  {
    return currentPosition.z;
  }
  
  PVector GetCurrentPosition (float time, int typeP)
  {
    //Yellow Cool Ones
    if(snapping)
    {
      float xVal=animation.keyFrames.get(currentKey).points.get(0).x;
      float yVal=animation.keyFrames.get(currentKey).points.get(0).y;
      float zVal=animation.keyFrames.get(currentKey).points.get(0).z;
      return new PVector(xVal,yVal,zVal);
    }
    
    else if (typeP==1)
    {
    float curX=animation.keyFrames.get(currentKey).points.get(0).x;
    float curY=animation.keyFrames.get(currentKey).points.get(0).y;
    float startZ=animation.keyFrames.get(currentKey).points.get(0).z;
    float endZ=animation.keyFrames.get(nextKey()).points.get(0).z;
    float allowedTime=animation.keyFrames.get(nextKey()).time
        -animation.keyFrames.get(currentKey).time;   
    float zRatio= (endZ-startZ)/allowedTime;
    if (nextKey()==1)
      return new PVector(curX,curY,zRatio*time);
    else if(nextKey()==2)
      return new PVector(curX,curY,-200+zRatio*time);
    else if(nextKey()==3)
      return new PVector(curX,curY,-200+zRatio*time);  
    //When its 0 its a whole another story
    {
    allowedTime=animation.keyFrames.get(1).time;   
    zRatio= (endZ-startZ)/allowedTime;
    return new PVector(curX,curY,400+zRatio*time);
    }
    }
    
    else //typeP2
    {
    float startX=animation.keyFrames.get(currentKey).points.get(0).x;
    float endX=animation.keyFrames.get(nextKey()).points.get(0).x;
    float curY=endX=animation.keyFrames.get(nextKey()).points.get(0).y;
    float startZ=animation.keyFrames.get(currentKey).points.get(0).z;
    float endZ=animation.keyFrames.get(nextKey()).points.get(0).z;
    float allowedTime=animation.keyFrames.get(nextKey()).time
        -animation.keyFrames.get(currentKey).time;   
    float zRatio= (currentTime-animation.keyFrames.get(currentKey).time)*(endZ-startZ)/allowedTime;
    float xRatio= (currentTime-animation.keyFrames.get(currentKey).time)*(endX-startX)/allowedTime;
    if (nextKey()==1)
      return new PVector(startX,0,startZ+zRatio);
    else if(nextKey()==2)
      return new PVector(startX+2*xRatio,0,startZ);
    else if(nextKey()==3)
      return new PVector(startX,0,startZ+zRatio);  
    //When its 0 its a whole another story
    {
    return new PVector(startX-8*xRatio,0,startZ);
    }
    }
  }
  
  void Update(float time)
  {
    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
    UpdateTime(time);
    currentPosition=GetCurrentPosition(currentTime, typeP);
  }
}
