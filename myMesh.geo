/*********************************************************************
 *
 *  Generate background mesh for GL problem
 *	Author: Cheng Gong
 *  Date: 2019-12-11
 *	Email: cheng.gong@it.uu.se
 *
 *********************************************************************/


// Define the rectangle geometry
lc = .1;
Lx = 10.0;
Ly = 1.0;
subx = 5/8*Lx;
suby2 = 1/15*Ly;
suby1 = 1/4*Ly;

Point(1) = {0.0,0.0,0,lc}; 
Point(2) = {Lx,0.0,0,lc};
Point(3) = {Lx,Ly,0,lc};     
Point(4) = {0,Ly,0,lc};

Line(1) = {1,2}; 
Line(2) = {2,3}; 
Line(3) = {3,4}; 
Line(4) = {4,1};

Curve Loop(10) = {1,2,3,4}; 
Plane Surface(12) = {10};

// Define two fields


Field[1] = Box;
Field[1].VIn = lc / 10;
Field[1].VOut = lc;
Field[1].XMin = subx; 
Field[1].XMax = Lx;
Field[1].YMin = suby2;
Field[1].YMax = suby1;


Background Field = 1;


Mesh.CharacteristicLengthExtendFromBoundary = 0;
Mesh.CharacteristicLengthFromPoints = 0;
Mesh.CharacteristicLengthFromCurvature = 0;

//Mesh.Format = 50;



