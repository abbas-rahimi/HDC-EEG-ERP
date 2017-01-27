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
		
function [predicLabel, maxAngle] = testHD (testSet, AM, CiM, iM, D, N, precision, electrodesLabel)
    keySet = AM.keys;
 
    sigHV = computeNgram (testSet, CiM, D, N, precision, iM, electrodesLabel);

    maxAngle = -1;
    for label = 1:1:length(keySet)
        angle = cosAngle(AM(char(keySet(label))), sigHV);
        if (angle > maxAngle)
            maxAngle = angle;
            predicLabel = char(keySet(label));
        end
    end
    %predicLabel = predicLabel(1);
end
