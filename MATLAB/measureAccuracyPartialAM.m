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
		
function [acc_corr, acc_wrong] = measureAccuracyPartialAM (AM, CiM, iM, D, aN, precision, electrodesLabel, FD, fSetC, fSetW)
	
	% the following global variables are already defined in the learning.m file
	global subject;
	global electrodesID;
    global CAR_flag;
    global Hd;
    global ws;
    global we;
    global nW;
	
    % load test session 
	test_session = load (strcat('../dataset/Subject', subject, '_s2.mat'));
	tot_corr = 0;
	num_corr = 0;
	tot_wrng = 0;
	num_wrng = 0;

	for r = 1:1:size(test_session.run,2)
		fprintf ('Testing for section block = %d:\n', r);
		s = test_session.run{1, r};
		TYP = s.header.EVENT.TYP;
		POS = s.header.EVENT.POS;

		clear FCAR;
		for c = 1:1:length(electrodesID)
			if CAR_flag == true
				CAR = common_average_reference (s.eeg(:, electrodesID(c)), s.eeg);
				FCAR(c,:) = filter (Hd, CAR);
			else
				FCAR(c,:) = filter (Hd, s.eeg(:, electrodesID(c)));
			end
		end

		for i = 1:1:length(TYP)
			if TYP(i) == 5 || TYP(i) == 10 
				label = 'correct';
				clear chFeatures;
				for c = 1:1:length(electrodesID) 
					features = zeros (1, FD);
					for j = ws:nW:we-nW
						f = extractFeatures (FCAR(c, POS(i) + j : POS(i) + j + nW));
						features = [features; f];
					end
					features(1,:) = [];
					chFeatures(:,c) = features;
				end
				[pLabel, ang] = testHD (chFeatures, AM, CiM, iM, D, aN, precision, electrodesLabel);
			
				tot_corr = tot_corr + 1;
				if pLabel(1) == label(1)
					num_corr = num_corr + 1;
				end  
			elseif TYP(i) == 6 || TYP(i) == 9
				label = 'wrong';
				clear chFeatures;
				for c = 1:1:length(electrodesID)
					features = zeros (1, FD);
					for j = ws:nW:we-nW
						f = extractFeatures (FCAR(c, POS(i) + j : POS(i) + j + nW));
						features = [features; f];
					end
					features(1,:) = [];
					chFeatures(:,c) = features;
				end
				[pLabel, ang] = testHD (chFeatures, AM, CiM, iM, D, aN, precision, electrodesLabel);
				
				tot_wrng = tot_wrng + 1;
				if pLabel(1) == label(1)
					num_wrng = num_wrng + 1;
				end
			end
		end
	end

	acc_corr  = num_corr/tot_corr;
	acc_wrong = num_wrng/tot_wrng; 
end