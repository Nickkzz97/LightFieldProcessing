

%clc;

addpath(genpath(pwd));
%% mex function
cd('src'); 
mex REMAP2REFOCUS_mex.c 
mex BLOCKMEAN_mex.c 
cd ..
load('LightField4D.mat');
disp('Processing LF to Remap image...');
LF=lightField;
LF=LF(:,:,:,:,1:3);
[UV_diameter,~,y_size,x_size,c]=size(LF);

%  get LF remap and pinhole image before refocusing
LF_Remap = LF2Remap(LF);
% get params
LF_x_size = x_size * UV_diameter;
LF_y_size = y_size * UV_diameter;
UV_radius = (UV_diameter-1)/2;
UV_size   = UV_diameter*UV_diameter;

% collect data
LF_parameters       = struct(...
                             'LF_x_size',LF_x_size,...
                             'LF_y_size',LF_y_size,...
                             'x_size',x_size,...
                             'y_size',y_size,...
                             'UV_radius',(UV_diameter-1)/2,...
                             'UV_diameter',UV_diameter,...
                             'UV_size',UV_diameter*UV_diameter) ;


% show figure
central_view=squeeze(LF(UV_radius+1,UV_radius+1,:,:,:));
figure; imshow(central_view);
title('central view');set(gcf,'color',[1 1 1]);
