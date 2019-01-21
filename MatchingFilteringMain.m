clc; clear variables; close all; % clearing Command Window and all variables from the Workspace
b1=Picture(500);
b1.bckgr;
b2=FluObj(10,'G');
figure; imshow(b1.I);
b1.fuse(10,'G',40,40)
figure; imshow(b1.I);