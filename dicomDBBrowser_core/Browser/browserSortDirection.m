function sDirection = browserSortDirection(sAction, sObject, sDirection)
%function sDirection = browserSortDirection(sAction, sObject, sDirection)
%Get\Set Browser Dicom Field Sort Direction.
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

    persistent psPatientNameDirection; 
    persistent psPatientIdDirection; 
    persistent psStudyDateDirection; 
    persistent psAccessionDirection; 
    persistent psStudyDescriptionDirection; 
    persistent psSeriesDescriptionDirection; 
    persistent psLocationDirection; 

    if strcmpi(sAction, 'set')

        switch sObject
            case 'PATIENTNAME'
                psPatientNameDirection = sDirection;
            case 'PATIENTID'
                psPatientIdDirection = sDirection;
            case 'STUDYDATE'
                psStudyDateDirection = sDirection;
            case 'ACCESSION'
                psAccessionDirection = sDirection;
            case 'STUDYDESCRIPTION'
                psStudyDescriptionDirection = sDirection;
            case 'SERIESDESCRIPTION'
                psSeriesDescriptionDirection = sDirection;
            case 'LOCATION'
                psLocationDirection = sDirection;

            otherwise
        end
    end

    switch sObject
        case 'PATIENTNAME'
            sDirection = psPatientNameDirection;
        case 'PATIENTID'
            sDirection = psPatientIdDirection;
        case 'STUDYDATE'
            sDirection = psStudyDateDirection;
        case 'ACCESSION'
            sDirection = psAccessionDirection;
        case 'STUDYDESCRIPTION'
            sDirection = psStudyDescriptionDirection;
        case 'SERIESDESCRIPTION'
            sDirection = psSeriesDescriptionDirection;
        case 'LOCATION'
            sDirection = psLocationDirection;

        otherwise
            sDirection = '';
    end        

end