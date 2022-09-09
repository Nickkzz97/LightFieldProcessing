clc;
close all;
clear all;
%cd ..
load('C:\Users\Nicky Nirlipta\Desktop\Nicky Nirlipta Sahoo_EE19S042_Assignment3\Image\LightField4D.mat')

dmin=-1;
dmax=2;
N=6;% subpixel aproximation
M=1;%
K=9;
lf=lightField;
[t,s,v,u,c]=size(lf);
[ depth,~ ] = Dept_vol_subpixel_2( lightField, dmin, dmax ,'s' ,K ,2,4 ,N,M);
%LF,...%LF in LF(t,s,v,u,c) c=colour channels input 1 dmin, dmax, ...
% min and max "slopes" or diparities an integer value input 2, 3angularop,
...% angular dimmention for the epipolar image input 4,outer,...varest,...aggregation,...N,M)
%[ depth,idx ] = Dept_vol_subpixel_2( LF , dmin, dmax ,angularop,outer,varest,N,M)

PlotDepthdisparity( 1, medfilt2(depth,[M*N,M*N]),dmin,dmax ,'Depthdisparity')
PlotDepthdisparity( 2, depth,dmin,dmax ,'Depthdisparity')