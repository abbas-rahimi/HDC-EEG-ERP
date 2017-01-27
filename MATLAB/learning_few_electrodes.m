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
		
clear;
% load defined functions into workspace
BICT_functions;

global subject;
global CAR_flag;

% ID of subjects, should be '01' to '06'
subject = '01'; 
% Define the use of CAR filter: 'true' for applying a CAR filter and 'false' for raw data
CAR_flag = true;

global electrodesID;
global Hd;
global ws;
global we;
global nW;

% set window start time (ws), end time (we), and choice of electrodes based on subjects c.f. Table I in paper
switch (subject)
case '01'
    ws = 200;
    we = 450;
    electrodesID = 47:1:48;
case '02'
    ws = 150;
    we = 600;
    electrodesID = 48; %Cz
case '03'
    ws = 200;
    we = 450;
    electrodesID = 47:1:48;
case '04'
    ws = 0;
    we = 600;
    electrodesID = 47; %FCz
case '05'
    ws = 150;
    we = 600;
    electrodesID = 47:1:48;
case '06'
    ws = 150;
    we = 600;
    electrodesID = 47:1:48;
end

% set other parameters
electrodesID = electrodesID';
ws = int64 (ws * 0.001 * 512);
we = int64 (we * 0.001 * 512);
w = we - ws;

switch (subject)
case '04'
	% For S4, we double the length of slices (16 samples in each) that results in 19 slices to cover the window instead of 38.
	N = w / 16;	
otherwise
	% For other subjects, we use slice length of 8 
	N = w / 8; % (512/64)
end
% Cutting angle; rejects vectors that have a cosine similarity of >= 0.5
cuttingAngle = 0.5;

% Preprocessing =================================================================================
% We read dataset for both sessions to be able to compute the min and max of magnitute for each electrode 
% bandpass filter
d = fdesign.bandpass ('N,F3dB1,F3dB2', 4, 1, 10, 512);
Hd = design (d,'butter');

% set nW as the slice size
nW = w / N;
% FD is the feature dimension; FD = 1 means that each electrode has one feature so totally we have 64 features
FD = 1;
clear fSetCs2
clear fSetCs1;
clear fSetWs2;
clear fSetWs1;
% Read dataset session 2
load (strcat('../dataset/Subject', subject, '_s2.mat'));

% Iterate over electrodes
for c = 1:1:length(electrodesID)
	fSetC = zeros (1, FD);
	fSetW = zeros (1, FD);
	for r = 1:1:size(run,2)
		fprintf ('Computing feature statistics: section block = %d and electrode = %d \n', r, electrodesID(c));
		s = run{1, r};
		TYP = s.header.EVENT.TYP;
		POS = s.header.EVENT.POS;  
		
		% determine the use of CAR filter
		if CAR_flag == true
			% CAR filter is applied
			CAR = common_average_reference (s.eeg(:, electrodesID(c)), s.eeg);
			% Then, bandpass filter is applied
			FCAR = filter (Hd, CAR);
		else
			% No CAR filter is applied, only bandpass filter on the raw data
			FCAR = filter (Hd, s.eeg(:, electrodesID(c)));
		end

		for i = 1:1:length(TYP)
			if TYP(i) == 5 || TYP(i) == 10
				features = zeros (1, FD);
				for j = ws:nW:we-nW
					f = extractFeatures (FCAR(POS(i) + j : POS(i) + j + nW));
					features = [features; f];
				end
				features(1,:) = [];
				fSetC = [fSetC; features];
			elseif TYP(i) == 6 || TYP(i) == 9
				features = zeros (1, FD);
				for j = ws:nW:we-nW
					f = extractFeatures (FCAR(POS(i) + j : POS(i) + j + nW));
					features = [features; f];
				end
				features(1,:) = [];
				fSetW = [fSetW; features];
			end
		end
	end
	fSetC (1,:) = [];
	fSetW (1,:) = [];
	fSetCs2 (c,:) = fSetC;
	fSetWs2 (c,:) = fSetW;
end

% Read dataset section 1
load (strcat('../dataset/Subject', subject, '_s1.mat'));
for c = 1:1:length(electrodesID)
	fSetC = zeros (1, FD);
	fSetW = zeros (1, FD);
	for r = 1:1:size(run,2)
		fprintf ('Computing feature statistics: section block = %d and electrode = %d \n', r, electrodesID(c));
		s = run{1, r};
		TYP = s.header.EVENT.TYP;
		POS = s.header.EVENT.POS;  
		% determine the use of CAR filter
		if CAR_flag == true
			% CAR filter is applied
			CAR = common_average_reference (s.eeg(:, electrodesID(c)), s.eeg);
			% Then, bandpass filter is applied
			FCAR = filter (Hd, CAR);
		else
			% No CAR filter is applied, only bandpass filter on the raw data
			FCAR = filter (Hd, s.eeg(:, electrodesID(c)));
		end

		for i = 1:1:length(TYP)
			if TYP(i) == 5 || TYP(i) == 10
				features = zeros (1, FD);
				for j = ws:nW:we-nW
					f = extractFeatures (FCAR(POS(i) + j : POS(i) + j + nW));
					features = [features; f];
				end
				features(1,:) = [];
				fSetC = [fSetC; features];
			elseif TYP(i) == 6 || TYP(i) == 9
				features = zeros (1, FD);
				for j = ws:nW:we-nW
					f = extractFeatures (FCAR(POS(i) + j : POS(i) + j + nW));
					features = [features; f];
				end
				features(1,:) = [];
				fSetW = [fSetW; features];
			end
		end
	end
	fSetC (1,:) = [];
	fSetW (1,:) = [];
	fSetCs1 (c,:) = fSetC;
	fSetWs1 (c,:) = fSetW;
end

% HD training =================================================================================
electrodesLabel = s.header.Label(electrodesID);
% HD dimensionality
D = 10000;
% Maximum number of quantization levels
MAXLEVELS = 100;
% Compute statistics for each electrode
for c = 1:1:length(electrodesID)
	fSet = zeros (1, FD);
	fSet = [fSet; (fSetCs1 (c,:))'];
	fSet = [fSet; (fSetCs2 (c,:))'];
	fSet = [fSet; (fSetWs1 (c,:))'];
	fSet = [fSet; (fSetWs2 (c,:))'];
	maxv(c) = max(fSet) + 2;
	minv(c) = min(fSet) - 2;
	precision(c) = MAXLEVELS / (maxv(c) - minv(c));
end
% Initialize item memories (for mapping inputs to HD space)
[CiM, iM] = initItemMemories (D, MAXLEVELS, minv, maxv, precision, electrodesLabel);
% Initialize associative memory (for storing learned HD vectors)
AM = containers.Map ('KeyType','char','ValueType','any');
% Initialize a countainer for counting the number of patterns stored into associative memory
NP = containers.Map ('KeyType','char','ValueType','int64');
% Maintain the previous number of patterns that is stored into associative memory for correct/wrong classes
prev_NP_correct = 0;
prev_NP_wrong = 0;

% Read dataset for training HD
load (strcat('../dataset/Subject', subject, '_s1.mat'));
for r = 1:1:size(run,2)
	fprintf ('Traning for block = %d:\n', r);
	s = run{1, r};
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
			% Do HD traning for the 'correct' trial
			[AM, NP, angle] = trainHD (chFeatures, label, AM, CiM, iM, D, size(features, 1), precision, cuttingAngle, NP, electrodesLabel); 
			
			% if a new 'correct' pattern is stored into associative memory
			if NP(label) > prev_NP_correct
				% Update counter
				prev_NP_correct = NP(label);
				% set the size of n-gram (N) for testing 
				aN = size(features, 1);
				% Measure accuracy using an AM learned with this much patterns
				[acc_correct_vs_np(prev_NP_correct + prev_NP_wrong), acc_wrong_vs_np(prev_NP_correct + prev_NP_wrong)] = measureAccuracyPartialAM (AM, CiM, iM, D, aN, precision, electrodesLabel, FD, fSetC, fSetW);
                angle_vs_np(prev_NP_correct + prev_NP_wrong) = angle;
                if prev_NP_wrong > 0
                    angle_bw_classes (prev_NP_correct + prev_NP_wrong) = cosAngle (AM('correct'), AM('wrong'));
                end
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
			% Do HD traning for the 'wrong' trial
			[AM, NP, angle] = trainHD (chFeatures, label, AM, CiM, iM, D, size(features, 1), precision, cuttingAngle, NP, electrodesLabel); 
		
			% if a new 'wrong' pattern is stored into associative memory
			if NP(label) > prev_NP_wrong
				% Update counter
				prev_NP_wrong = NP(label);
				% set the size of n-gram (N) for testing 
				aN = size(features, 1);
				% Measure accuracy using an AM learned with this much patterns
				[acc_correct_vs_np(prev_NP_correct + prev_NP_wrong), acc_wrong_vs_np(prev_NP_correct + prev_NP_wrong)] = measureAccuracyPartialAM (AM, CiM, iM, D, aN, precision, electrodesLabel, FD, fSetC, fSetW);
				angle_vs_np(prev_NP_correct + prev_NP_wrong) = angle;
                if prev_NP_correct > 0
                    angle_bw_classes (prev_NP_correct + prev_NP_wrong) = cosAngle (AM('correct'), AM('wrong'));
                end
			end
		end
	end
	% Record where a block transition happens in the training session
	block_trans (r) = prev_NP_correct + prev_NP_wrong;
end
