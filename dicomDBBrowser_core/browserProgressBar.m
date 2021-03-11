function browserProgressBar(lProgress, sStatus)
%function sDirection = browserSortDirection(sAction, sObject, sDirection)
%Set Browser Progess Bar Water Level and Status.
%See DicomDBBrowser.doc (or pdf) for more information about options.
%
%Note: option settings must fit on one line and can contain one semicolon at most.
%Options can be strings, cell arrays of strings, or numerical arrays.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2020, Daniel Lafontaine, on behalf of the TriDFusion development team.
%
% This file is part of The DICOM Database Browser (dicomDBBrowser).
%
% DicomDBBrowser development has been led by: Daniel Lafontaine
%
% DicomDBBrowser is distributed under the terms of the Lesser GNU Public License.
%
%     This version of dicomDBBrowser is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
% DicomDBBrowser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with DicomDBBrowser.  If not, see <http://www.gnu.org/licenses/>.

    uiBar = uiBrowserProgressBarPtr('get');

    set(uiBrowserProgressWindowPtr('get'), 'title'   , sStatus);

    if lProgress == 1
        set(uiBar, 'BackgroundColor', browserBackgroundColor('get'));
    else
        set(uiBar, 'BackgroundColor', 'cyan');
    end

    x = get(uiBar, 'Position');

    x(3) = lProgress;       % Corresponds to % progress if unit = normalized
    set(uiBar, 'Position',x);

    drawnow;

end
