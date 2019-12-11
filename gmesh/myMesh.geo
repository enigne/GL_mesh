/*********************************************************************
 *
 *  Generate background mesh for GL problem
 *	Author: Cheng Gong
 *  Date: 2019-12-11
 *	Email: cheng.gong@it.uu.se
 *
 *********************************************************************/


// Define the rectangle geometry
lc = .05;
Lx = 1.0;
Ly = 1.0;
subx = 2/3;
suby2 = 1/15;
suby1 = 1/4;

Point(1) = {0.0,0.0,0,lc}; 
Point(2) = {Lx,0.0,0,lc};
Point(3) = {Lx,Ly,0,lc};     
Point(4) = {0,Ly,0,lc};

Point(5) = {subx,suby2,0,lc/4};
Point(6) = {Lx,suby2,0,lc/4};
Point(7) = {Lx,suby1,0,lc/4};
Point(8) = {subx,suby1,0,lc/4};

Line(1) = {1,2}; 
Line(2) = {2,6}; 
Line(3) = {3,4}; 
Line(4) = {4,1};
Line(5) = {5,6};
Line(6) = {6,7};
Line(7) = {7,8};
Line(8) = {8,5};
Line(9) = {7,3}; 

Curve Loop(10) = {1,2,-5,-8,-7,9,3,4}; 
Curve Loop(11) = {5,6,7,8}; 
Plane Surface(12) = {10};
Plane Surface(13) = {11};

// Say we would like to obtain mesh elements with size lc/30 near curve 2 and
// point 5, and size lc elsewhere. To achieve this, we can use two fields:
// "Distance", and "Threshold". We first define a Distance field (Field[1]) on
// points 5 and on curve 2. This field returns the distance to point 5 and to
// (100 equidistant points on) curve 2.


