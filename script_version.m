clear, clc, close all

%% Configration 
nSensors = 3; % number of sensors
nSurfaces = 100; % number of surfaces

%% Load Data

%load CIE basis functions
load B_cieday.mat B_cieday S_cieday
lightB = B_cieday;

%load Vrhel natural surfaces basis functions
load B_vrhel.mat B_vrhel S_vrhel
B_vrhel = SplineSrf(S_vrhel,B_vrhel,S_cieday,1);
surfB = B_vrhel(:,1:nSensors-1);

load T_cones_ss10.mat
sensorResCur = SplineCmf(S_cones_ss10,T_cones_ss10,S_cieday,1)';

%% Decide true illum

rng(1) % Turn off for true random

IllumWeights = rand(size(lightB, 2),1);
trueIllum = lightB*IllumWeights; % 31x1

SurfWeights = rand(size(surfB, 2),nSurfaces);
trueSurfA = surfB * SurfWeights; % 31xn

%% Compute sensor responses

sensorRes = (repmat(trueIllum, 1, nSurfaces).*trueSurfA)' * sensorResCur; % nx3

%%
