function setBrowserExtensionCallback(hObject, ~)
%function setBrowserExtensionCallback(hObject, ~)
%Call xmlParametersGui. https://github.com/dicomtools/xmlParametersGui is
%needed
%See DicomDBBrowser.doc (or pdf) for more information about options.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2022, Daniel Lafontaine, on behalf of the TriDFusion development team.
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

    sXmlFileName = get(hObject, 'UserData');
    
    
    if numel(gsBrowserMainWindowDisplayPtr('get')) 

        asPath = '';

        gadOffset = gadBrowserOffsetPtr('get');
        gtDisplay = gtBrowserDisplayPtr('get');

        gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');

        for i=1: numel(gadOffset)
            if numel(gsBrowserMainWindowDisplay) >= gadOffset{i}

                sLine = gsBrowserMainWindowDisplay{gadOffset{i}};                     

                if strlength(sLine) 

%                    if i > 1 && browserMultiThread('get')
%                     %   sPath = strcat(sPath, {' '}, '"[', extractAfter(sLine, 130), ']"');    
%                        asPath = strcat(asPath, {' '}, '"[',  gtDisplay{gadOffset{i}}.sTargetDirectory, ']"');    
%                    else    
%                  %      sPath{i} = char(strcat('"[', extractAfter(sLine, 130), ']"'));  
                        asPath{i} = char(strcat('"[', gtDisplay{gadOffset{i}}.sTargetDirectory, ']"'));  
%                    end
                end
            end
        end

    end
       

    xmlParametersGui(asPath{:}, sprintf('[-p%s]',sXmlFileName));
    
end 