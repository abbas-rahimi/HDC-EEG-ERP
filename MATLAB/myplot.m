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
		
plot(acc_correct_vs_np * 100, '- r square');
hold;
plot(acc_wrong_vs_np * 100, '- b square');
ax = gca;
ax.YLim = [0 100];

for i = 1:1:length(block_trans)
    x = block_trans(i);
    y = 0;
    x = [x; block_trans(i)];
    y = [y; 100];
    plot(x,y, '-- k');
end

ax.YLabel.String = 'Accuracy (%)';
ax.XLabel.String = 'Non-redundant training trials';
ax.FontWeight = 'Bold';
ax.FontName = 'Helvetica';
legend('C class', 'W class', 'location', 'best'); 
