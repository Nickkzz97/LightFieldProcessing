

%clc;

addpath(genpath(pwd));
%% mex function
cd('src'); 
mex REMAP2REFOCUS_mex.c 
mex BLOCKMEAN_mex.c 
cd ..
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
central_view_side=squeeze(LF(UV_radius+1,UV_radius+2,:,:,:));

 leftG=central_view;
 rightG=central_view_side;
% %%disparity map

blockSize=5;
maxd=40;
if length(size(leftG))==3
    % convert it grayscale
    leftG = mean(leftG, 3);
    rightG = mean(rightG, 3);
end

hb=fix(blockSize/2);

dispImg=zeros(size(rightG));
for i=hb+1:size(leftG,1)-hb
     
    for j=hb+1:size(leftG,2)-hb
        
        blockR=rightG(i-hb:i+hb,j-hb:j+hb);
        
        bdiff=[];
        
        for k=0:min(maxd,size(leftG,2)-hb-j)
            blockL=leftG(i-hb:i+hb,j-hb+k:j+hb+k);
            % calculate sum of absolute differences (SAD)
            bdiff(k+1, 1) = sum(abs(blockL(:) - blockR(:)));           
        end
        
        [a1 b1]=min(bdiff);
        
        if size(bdiff,1)>3 & b1>1 & b1<length(bdiff)
            % use minimum disparities left and right block score and find
            % subpixel disparity 
           dispImg(i, j) =  (b1-1) - (0.5 * (bdiff(b1+1,1) - bdiff(b1-1,1)) / (bdiff(b1-1,1) - (2*bdiff(b1,1)) + bdiff(b1+1,1))) ;         
        else
            % use minimum disparit match directly
           dispImg(i, j) = (b1-1);
        end
   
    end
   
 end
imshow(dispImg);title('central image depth disparity');colormap cool;colorbar;
