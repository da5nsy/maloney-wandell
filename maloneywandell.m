function [E, surfArray] = maloneywandell(lightB, surfB, sensorResCur, sensorRes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Han Gong, gong@fedoraproject.org
% University of East Anglia, Norwich, UK
% 07/05/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Michael Harris, michael.harris@uea.ac.uk
% University of East Anglia, Norwich, UK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find null space of sensor responses, which gives the normal of the
% plane in the illuminant space
[~,~,v] = svd(sensorRes); % null of a nx3 matrix
EPlaneNorm = v(:,end);

baseSurf = zeros(size(surfB,2), size(lightB,2)); % NxP surface-light base
for i = 1:size(surfB,2) 
    % for each type of surface base (assume the weights for the other surfaces are 0)
    tmp = (repmat(surfB(:,i),1,size(lightB,2)).*lightB)' * sensorResCur; % integrate ESR
    baseSurf(i,:) = tmp * EPlaneNorm; % dot product of P responces and the plane normal
end

% The correct epsilon will give near zero dot products for all type of base illuminants.
% This means that the responses and the normal are indeed orthogonal
[~,~,v] = svd(baseSurf);
epsilon = v(:,end);

% The estimate for the illuminant (basis * weights)
E = lightB * epsilon;

% Create the lighting matrix using the illuminant estimate
lightM = zeros(size(sensorResCur,2),size(surfB,2)); % \Lambda PxN
for k = 1:size(sensorResCur,2)
    for j = 1:size(surfB,2)
        lightM(k,j) = sum(E.*surfB(:,j).*sensorResCur(:,k)); % integration ESR
    end
end

% Convert sensor responses into sigma values
surfArray = zeros(size(surfB, 1), size(sensorRes, 1)); % 31xn
for i = 1:size(sensorRes,1)
    surfArray(:,i) = surfB * (lightM\sensorRes(i,:)');
end

end
