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
		
function [ngram] = computeNgram (buffer, CiM, D, N, precision, iM, electrodes)
	ngram = zeros (1,D);
	for c = 1:1:length(electrodes)
		% Temporal encoding of an electrod values over time
		t = N;
		key = strcat(char(electrodes(c)), '_', int2str(int64 (buffer(t, c) * precision(c))));
		ngram_elec = lookupItemMemory (CiM, key);
		for t = 1:1:N-1
			key = strcat(char(electrodes(c)), '_', int2str(int64 (buffer(t, c) * precision(c))));
			val_elec = lookupItemMemory (CiM, key);
			ngram_elec = ngram_elec .* circshift (val_elec, [1,N-t]);
		end
		% Bind ngram_elec with name of electrod
		ngram = ngram + (ngram_elec .* iM(c));
	end			
end
