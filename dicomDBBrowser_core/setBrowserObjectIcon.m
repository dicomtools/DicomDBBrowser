function setBrowserObjectIcon(ptrObject)
%function setBrowserObjectIcon(ptrObject)
%Set Browser icon to a dialog or figure.
%See DicomDBBrowser.doc (or pdf) for more information about options.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2025, Daniel Lafontaine, on behalf of the dicomDBBrowser development team.
%
% This file is part of The DICOM Database Browser (dicomDBBrowser).
%
% dicomDBBrowser development has been led by:  Daniel Lafontaine
%
% dicomDBBrowser is distributed under the terms of the Lesser GNU Public License.
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

    sRootPath = browserRootPath('get');
   
    if ~isempty(sRootPath) 
        
        if ~isMATLABReleaseOlderThan('R2025a') || ...
            browserUIFigure('get') == true
            
            ptrObject.Icon = fullfile(sRootPath, 'logo.png');
            
        else
    
           javaFrame = get(ptrObject, 'JavaFrame');
    
           if ~isempty(javaFrame)
    
               javaFrame.setFigureIcon(javax.swing.ImageIcon(sprintf('%s/logo.png', sRootPath)));       
           end
        end
    end
end