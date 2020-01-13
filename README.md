# Matlab Code to generate background mesh of MISMIP experiments 

## Generate background mesh

The mesh with locally refinement at the ice shelf is defined in myMesh.geo, where the domain is of size `Lx=10.0` and `Ly=1.0`.
This can generate a `myMesh.m` file with Gmsh:

`gmsh myMesh.geo -2 -format 'm'`

Then, `myMesh.m` is used in `createBackgroundmesh.m` 


## Generate surfaces

run createBackgroundmesh.m

In that file, `Nx` is the number of grid points in generating the surfaces.

`surf` contains the (x,y) coordinates of the top surface in a 2D vector of size (nx2).
`bed` contains the (x,y) coordinates of the bottom surface in a 2D vector of size (nx2).

This .m file also rescale and move the background mesh from myMesh.m, to the same domain as for `surf` and `bed`.

The final mesh is in:
`nodes` which is a (Nx2) vector with (x,y) coordinates of each node,
`elements` which is a (Ex3) vector contains the three nodes for each element.

