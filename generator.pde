/**
 * Date : september 13th 2024
 * Location : France
 * Author : Jérôme Chauvet
 * 
 * This piece of program is the algorithm which renders the global
 * structure of a human brain according to our theory based on
 * Bejan's constructal principle and enhanced by myself.
 *
 * This is pre-published result intended for reviewing and testing by peers.
 *
 */

    
/* initiate graphics */
size(800, 480); 
//noSmooth(); 
background(0); 
translate(400, 240);

/* choose view mode : top, side or back */
String view = "top";

/* dynamical parameters */
int t_max = 256; float dt = .25;

/* numeric parameters for the constructal structure */
int r0 = 1;
int r1 = 2; 
int r2 = 3;
int D = r0*r1*r2; // Overall logarithmic depth of the capillary bundle

/* tables for the whole bundle according to our parametized multi-functional model */  
float[][] wgh = new float[D][floor(pow(2,D))];
float[][] amp = new float[D][floor(pow(2,D))];
float[][] sgn = new float[D][floor(pow(2,D))];
float[][] phs = new float[D][floor(pow(2,D))];
  
/* generate tree structure */
for(int k = 0; k < D; k++) {
  for(int n = 0; n < pow(2,D) ; n++) {
    wgh[k][n] = -1;
    amp[k][n] = 1/pow(2,D-k-1) ;
    phs[k][n] = (k+1)*4;
  }
}
  
sgn[0][0] = 1;
for(int n = 1; n < pow(2,D) ; n++) {
  sgn[0][n] = 1 - sgn[0][n - 1];
}

for(int k = 1; k < D; k++) {
  for(int n = 0; n < pow(2,D) ; n++) {
    sgn[k][n] = sgn[0][floor(n/pow(2,k))];
  }
}
  
for(int k = 0; k < D; k++) {
  for(int n = 0; n < pow(2,D) ; n++) {
    //sgn[k][n] = 2*sgn[k][n] - 1 ;
    sgn[k][n] = (sgn[k][n] - 1) ; 
  }
}

/* declare rendering table and control values for output */
float[][] outp = new float[floor(pow(2,D))][t_max];
float Add = 0;
float t = 0;
boolean ReCalc = true;

 /* compute generative model */
if(ReCalc==true){ 
    for (int i = 0; i < t_max; i++) {                      
      for (int n = 0; n < pow(2,D); n++) {        
        Add = 0;        
        for (int j = 0; j < D; j++) {    
          Add = Add + sgn[j][n]*amp[j][n]*(atan(wgh[j][n]*(t - phs[j][n]))/PI+0.5);
        }
        outp[n][i]  = Add;
      }
      t = t + dt;
    }
  ReCalc = false;  
}
 
/* render graphic output in bitmap according to chosen view mode */
if (view.equals("top")){
  /* background for reference */
  PImage img;
    img = loadImage("IRM_top.jpg");
    img.resize(0, 400);
    image(img, -325, -200);

  strokeWeight(1.5);
  //float v = 256/pow(2,D) ; 
  for (int i = 0; i < t_max-1; i++) {
    for (int n = 0; n < pow(2,D); n++) {
      //stroke(255-n*v,0,n*v);
      stroke(0,255,0);
      line(i*r1, outp[n][i]*100, (i+1)*r1, outp[n][i+1]*100);  // backbrain
      line(-i*r2, outp[n][i]*100, -(i+1)*r2, outp[n][i+1]*100);// forebrain
    }
  }  
}

if (view.equals("side")){
  /* background for reference */
  PImage img;
    img = loadImage("IRM_side.jpg");
    img.resize(0, 400);
    image(img, -325, -200);
    
  strokeWeight(1.5);
  //float v = 256/pow(2,D) ;  
  for (int i = 0; i < t_max-1; i++) {
    for (int n = 0; n < pow(2,D); n++) {
      //stroke(255-n*v,0,n*v);
      stroke(0,255,0);
      line(i*r1, outp[n][i]*100, (i+1)*r1, outp[n][i+1]*100);  // backbrain
      line(-i*r2, outp[n][i]*100, -(i+1)*r2, outp[n][i+1]*100);// forebrain
    }
  }      
       
}

if (view.equals("back")){
  /* background for reference */
  PImage img;
    img = loadImage("IRM_back.jpg");
    img.resize(0, 400);
    image(img, -200, -220);
    
  strokeWeight(1.5);
  //float v = 256/pow(2,D) ;  
  for (int i = 0; i < t_max-1; i++) {
    for (int n = 0; n < pow(2,D); n++) {
      //stroke(255-n*v,0,n*v);
      stroke(0,255,0);
      line( outp[n][i]*100,i*r0, outp[n][i+1]*100,(i+1)*r0);  // bottom backbrain
      line( outp[n][i]*100,-i*r1, outp[n][i+1]*100,-(i+1)*r1);// top cortical hull
    }
  }    
    
}

/* END */
