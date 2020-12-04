function browserSortCallback(hObject, ~)
%function browserSortCallback(hObject, ~)
%Sort Browser DICOM Fields.
%See dicomDBBrowser.doc (or pdf) for more information about options.
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
% TriDFusion development has been led by: Daniel Lafontaine
% 
% TriDFusion is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of dicomDBBrowser is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% dicomDBBrowser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with dicomDBBrowser.  If not, see <http://www.gnu.org/licenses/>.

    if isempty(gsBrowserMainWindowDisplayPtr('get'))
        return;
    end

    gtDisplay = gtBrowserDisplayPtr('get');

    switch hObject.String

        case 'PATIENTNAME'
            for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
                asPatientName{ii} = gtDisplay{ii}.sPatientName;                 
            end

            [~, Index] = sort(asPatientName);

        case 'PATIENTID'                
            for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
                asPatientId{ii} = gtDisplay{ii}.sPatientID ;                 
            end

            [~, Index] = sort(asPatientId);

        case 'STUDYDATE'
            for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
                asStudyDate{ii} = gtDisplay{ii}.sStudyDate;                 
            end

            [~, Index] = sort([asStudyDate{:}]);

        case 'ACCESSION'
            for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
                asAccession{ii} = gtDisplay{ii}.sAccessionNumber;                 
            end

            [~, Index] = sort(asAccession);

        case 'STUDYDESCRIPTION'
            for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
                asStudyDescription{ii} = gtDisplay{ii}.sStudyDescription;                 
            end

            [~, Index] = sort(asStudyDescription);
        case 'SERIESDESCRIPTION'
            for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
                asSeriesDescription{ii} =  gtDisplay{ii}.sSeriesDescription;                 
            end

            [~, Index] = sort(asSeriesDescription);

        case 'LOCATION'
           for ii=1: numel(gsBrowserMainWindowDisplayPtr('get'))
        %        asLocation(ii) = extractAfter(asMainWindow(ii), 131);  
                 asLocation{ii} = gtDisplay{ii}.sTargetDirectory;

            end

            [~, Index] = sort(asLocation);   

        otherwise
    end

    if strcmpi(browserSortDirection('get', hObject.String), 'ascend')
        browserSortDirection('set', hObject.String,'descend');
        Index = flip(Index);
     else
        browserSortDirection('set', hObject.String, 'ascend');
    end   

    gtBrowserDisplayPtr('set', gtDisplay(Index));

    gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');
    gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplay(Index);
    gsBrowserMainWindowDisplayPtr('set', gsBrowserMainWindowDisplay);

    set(lbBrowserMainWindowPtr('get'), 'String', gsBrowserMainWindowDisplay);

end
