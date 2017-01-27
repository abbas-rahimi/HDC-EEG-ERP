% This program implements the use of hyperdimensional (HD) computing to 
% classify electroencephalography (EEG) error-related potentials for 
% an application in noninvasive brain-computer interfaces.
% Copyright (C) 2017 Abbas Rahimi (e-mail:abbas@eecs.berkeley.edu).

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
		
function message = HD_demo
	assignin('base','initItemMemories', @initItemMemories);
	assignin('base','genRandomHV', @genRandomHV);
	assignin('base','measure_distances', @measure_distances);
	assignin('base','extractFeatures', @extractFeatures);
	assignin('base','trainHD', @trainHD);
	assignin('base','testHD', @testHD);

	message='Done importing functions to workspace';
end


function [AM, NP, angle] = trainHD (trainSet, label, AM, CiM, iM, D, N, precision, cuttingAngle, NP, electrodes) 
    if ~AM.isKey(label)
        AM(label) = zeros (1,D);
        NP(label) = 0;
    end

    ngram = computeNgram (trainSet, CiM, D, N, precision, iM, electrodes);
    angle = cosAngle (ngram, AM (label));
    if angle < cuttingAngle | isnan(angle)
        AM (label) = AM (label) + ngram;
        NP (label) = NP (label) + 1;
    end

	%fprintf ('Class= %s \t mean= %.0f \t num_patterns = %d created \n', label, mean(AM(label)), NP(label));
end

function [distances] = measure_distances (AM)
    allKeys = AM.keys;
    for i = 1:1:size(allKeys, 2)
        for j = 1:1:size(allKeys, 2)
            distances(i,j) = cosAngle (AM(char(allKeys(i))), AM(char(allKeys(j))));
        end
    end
    imagesc(distances);
    colorbar;
end
	
function randomHV = genRandomHV(D)
%
% DESCRIPTION   : generate a random vector with zero mean 
%
% INPUTS:
%   D           : Dimension of vectors
% OUTPUTS:
%   randomHV    : generated random vector

    if mod(D,2)
        disp ('Dimension is odd!!');
    else
        randomIndex = randperm (D);
        randomHV (randomIndex(1 : D/2)) = 1;
        randomHV (randomIndex(D/2+1 : D)) = -1;
    end
end

function [CiM, iM] = initItemMemories (D, MAXL, minv, maxv, precision, electrodes)
%
% DESCRIPTION   : initialize the item Memory  
%
% INPUTS:
%   D           : Dimension of vectors
%   MAXL        : Maximum amplitude of EMG signal
% OUTPUTS:
%   iM          : item memory for IDs of channels
%   CiM         : continious item memory for value of a channel
 
    % MAXL = 21;
	CiM = containers.Map ('KeyType','char','ValueType','any');
	iM  = containers.Map ('KeyType','double','ValueType','any');
    rng('default');
    rng(1);
        
	%init 4 orthogonal vectors for the 4 channels
    for c = 1:1:length(electrodes)
        iM(c) = genRandomHV (D);
    end
    
    for c = 1:1:length(electrodes)
        initHV = genRandomHV (D);
	    currentHV = initHV;
	    randomIndex = randperm (D);
	
        i = 1;
        for j = minv(c):1/precision(c):maxv(c)
            key = strcat(char(electrodes(c)), '_', int2str(int64 (j * precision(c))));
            CiM(key) = currentHV;
		    %D / 2 / MAXL = 238
            SP = floor(D/2/MAXL);
		    startInx = (i*SP) + 1;
		    endInx = ((i+1)*SP) + 1;
		    currentHV (randomIndex(startInx : endInx)) = currentHV (randomIndex(startInx: endInx)) * -1;
            i = i + 1;
        end
    end
end
