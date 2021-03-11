function browserDicomAnonymizer(sInputFolder, sOutputFolder, sIsntanceName, values) 
%function browserDicomAnonymizer(sInputFolder, sOutputFolder, sIsntanceName, values) 
%Run Matlab dicomanon() using factory dicom Dictionary.
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

    dicomdict('factory');  

    if ~(sInputFolder(end) == '\') || ...
       ~(sInputFolder(end) == '/')    
        sInputFolder = [sInputFolder '/'];
    end

    if ~(sOutputFolder(end) == '\') || ...
       ~(sOutputFolder(end) == '/')     
        sOutputFolder = [sOutputFolder '/'];
    end

%    aList = dir(sInputFolder);
    f = java.io.File(char(sInputFolder));
    aList = f.listFiles();

    dFileID = 0;
    for dOffset = 1 : numel(aList) 
        if ~aList(dOffset).isDirectory 

            if isdicom([sInputFolder char(aList(dOffset).getName())])
                dFileID = dFileID+1;

                sNewName = sprintf('anon%d_%s.dcm', dFileID, sIsntanceName);

                dicomanon([sInputFolder char(aList(dOffset).getName())], ...
                          [sOutputFolder sNewName], 'update', values);

                browserProgressBar(dOffset /  numel(aList) , 'Processing Anonymization');   

            end
         end  
    end  

    if dFileID ~= 0
        sMessage = ... 
            sprintf('Saved %d file(s) to %s', dFileID, sOutputFolder); 

        browserProgressBar(1, sMessage);             
    else
        browserProgressBar(1, 'Ready');             
    end

end