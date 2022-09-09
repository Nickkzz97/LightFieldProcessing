clc;
close all;
clear all;
%load('Bee_2.mat');
load('LightField4D.mat');
%lightField=LFColorCorrectedImage;

frameCount = 1;
pauseTime = 0.5;
tic;
for pixels =-2:0.4:1
    [Iout,lightFieldOut] = refocusLightField(lightField, pixels);
    I2out(frameCount)={Iout};
    frameCount=frameCount+1;
end
toc;
tic;
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'Refocused_image_Dragon.gif';
for i=1:frameCount-1
    I3out=cell2mat(I2out(i));
    I4out(:,:,:,i)=I3out;
    imshow(I3out);
    
    drawnow;
          % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if i == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
  
    pause(pauseTime);   
end
toc

animateLightField(lightFieldOut);
