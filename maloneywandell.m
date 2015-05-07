function [E, surfArray] = maloneywandell(lightB, surfB, sensorResCur, sensorRes)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Michael Harris, michael.harris@uea.ac.uk
    % University of East Anglia, Norwich, UK
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % modified by Han Gong, gong@fedoraproject.org
    
    % Find nullspace of sensor responses, which gives the normal of the
    % plane in the illuminant space
    EPlaneNorm = null(sensorRes); % null of a nx3 matrix

    baseSurf = zeros(size(surfB,2), size(sensorResCur,2)); % NxP
    for i = 1:size(surfB,2)
        tmp = (repmat(surfB(:,i),1,size(lightB,2)).*lightB)' * sensorResCur; % integrate ESR
        baseSurf(i,:) = tmp * EPlaneNorm; 
    end
    
    epsilon = null(baseSurf);
    
    % The estimate for the illuminant (basis * weights)
    E = lightB * epsilon;

    % Create the lighting matrix using the illuminant estimate
    lightM = zeros(size(lightB,2),size(surfB,2)); % \Lambda PxN
    for k = 1:size(lightB,2)
        for j = 1:size(surfB,2)
            lightM(k,j) = sum(E.*surfB(:,j).*sensorResCur(:,k)); % integration ESR
        end
    end

    % Convert sensor responses into sigma values
    surfArray = zeros(size(surfB, 1), size(sensorRes, 1)); % 31xn
    for i = 1:size(sensorRes, 1)
        surfArray(:,i) = surfB * (lightM\sensorRes(i,:)');
    end

end
