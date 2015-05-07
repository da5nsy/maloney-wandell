clear all;
load data/GRA31
load data/surfs1995

%%%% THESE CAN BE ADJUSTED TO TEST %%%
nSensors = 3;
nSurfaces = 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nSensors < 3 || nSensors > 4
    throw(MException('ResultChk:OutOfRange', ...
        'Test data is only available for 3 or 4 sensors'));
end

if nSensors == 3
    load data/RGB
    sensorResCur = RGB;
end

if nSensors ==4
    load data/sensor4
    sensorResCur = sensor4;
end

% Select some random bases
lightB = GRA31(:,randperm(size(GRA31, 2), nSensors)); % ambient light 31xN
surfB = surfs1995(:,randperm(size(surfs1995, 2), nSensors-1)); % reflectance 31xP

% Create an illuminant and some surfaces from the basis functions with random weights
trueIllum = lightB*rand(size(lightB, 2),1); % 31x1
trueSurfArray = surfB*rand(size(surfB, 2),nSurfaces); % 31xn

% Generate sensors responses from illuminant and surfaces
sensorRes = (repmat(trueIllum, 1, nSurfaces).*trueSurfArray)' * sensorResCur; % nx3

% Run the algorithm
[estIllum, estSurfArray] = maloneywandell(lightB, surfB, sensorResCur, sensorRes);

% plot them
figure;
for i = 1:nSurfaces
    subplot(3,ceil(nSurfaces/3),i);
    trueSurf = trueSurfArray(:,i);
    estSurf = estSurfArray(:,i);
    % Plot the true surface reflectance against the estimate
    plot([trueSurf, estSurf]);
    legend('True','Est');
end

