clear all;
load data/GRA31
load data/surfs1995

%%%% THESE CAN BE ADJUSTED TO TEST %%%
nSensors = 3; % number of sensors
nSurfaces = 9; % number of surfaces reflectances to solve
nLight = 3; % number of ambient light basis (nLight < nSurfaces)
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
lightB = GRA31(:,randperm(size(GRA31, 2), nLight)); % ambient light 31xN
surfB = surfs1995(:,randperm(size(surfs1995, 2), nSensors-1)); % reflectance 31xP

% Create an illuminant and some surfaces from the basis functions with random weights
trueIllum = lightB*rand(size(lightB, 2),1); % 31x1
trueSurfA = surfB*rand(size(surfB, 2),nSurfaces); % 31xn

% Generate sensors responses from illuminant and surfaces
sensorRes = (repmat(trueIllum, 1, nSurfaces).*trueSurfA)' * sensorResCur; % nx3

% Run the algorithm
[estIllum, estSurfA] = maloneywandell(lightB, surfB, sensorResCur, sensorRes);

% original lighting and reflectance
sensorRes = repmat(trueIllum, 1, nSurfaces)' * sensorResCur; % nx3
surfRes = trueSurfA' * sensorResCur; % nx3
% recovered lighting and reflectance
EsensorRes = repmat(estIllum, 1, nSurfaces)' * sensorResCur; % nx3
EsurfRes = estSurfA' * sensorResCur; % nx3

% plot them
figure('Name','Simulation Results for All Surface Reflectance Recovery Tests');
for i = 1:nSurfaces
    subplot(3,ceil(nSurfaces/3),i);
    trueSurf = trueSurfA(:,i);
    estSurf = estSurfA(:,i);
    % Plot the true surface reflectance against the estimate
    plot([trueSurf, estSurf]);
    legend('True','Est.');
end

figure;
Eim = reshape(sensorRes,[3,ceil(nSurfaces/3),3]);
Sim = reshape(surfRes,[3,ceil(nSurfaces/3),3]);
eEim = reshape(EsensorRes,[3,ceil(nSurfaces/3),3]);
eSim = reshape(EsurfRes,[3,ceil(nSurfaces/3),3]);
subplot(2,2,1); imshow(Eim); title('original illuminant');
subplot(2,2,2); imshow(Sim); title('original reflectance');
subplot(2,2,3); imshow(eEim); title('estimated illuminant');
subplot(2,2,4); imshow(eSim); title('estimated reflectance');
