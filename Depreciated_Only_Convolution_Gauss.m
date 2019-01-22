clc; clear variables; clear G_Shape; close all;

%% Parameters
Obj = imread('GaussN(10S_0M).png');

%% Generation of Gaussian kernel (normalized) for further convolution
double s; s=40; double sum; sum=0; % s - sigma (equal to size of initial object)
Gauss = zeros(3*s+1,3*s+1,'double'); % initialize Gaussian kernel
av=1.5*s+1;
for i = 1:1:3*s+1
    for j = 1:1:3*s+1
        x=i-av; y=j-av;  
        Gauss(i,j)= exp(-(x^2+y^2)/(2*(s^2))); % classical Gaussian
        sum = sum + Gauss(i,j); % for calibration of a distribution
    end
end

%% Convolution
Obj=cast(Obj,'double'); % sample image
ObjGauss = imfilter(Obj,Gauss,'replicate')/sum; % it's possible to use imfilter
double maxLG; maxLG = max(max(ObjGauss)); ObjGauss = ObjGauss*(255/maxLG); % converstion the intensity values
double maxGL; maxGL = max(max(Gauss)); Gauss = Gauss*(255/maxGL); % % converstion the intensity values
minL = min(min(ObjGauss)); ObjGauss=ObjGauss-minL; % substract smallest value
double maxLG; maxLG = max(max(ObjGauss)); ObjGauss = ObjGauss*(255/maxLG); % converstion the intensity values
ObjGauss = cast(ObjGauss,'uint8'); Obj = cast(Obj,'uint8'); Gauss=cast(Gauss,'uint8'); % final conversion

%% show opened, generated mask and resulting images
figure; imshow(Obj,[]); figure; imshow(Gauss,[]); figure; imshow(ObjGauss,[]); 

%% save the result
% imwrite(ObjGauss,'GaussN(10S_0M)_Gauss_40s.png');