function browserRunCommandCallback(~, ~)
%function browserRunCommandCallback(~, ~)
%Run Application Command Line.
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

    if numel(gsBrowserMainWindowDisplayPtr('get'))

        atAppList = browserRunAppList('get');

        gadOffset = gadBrowserOffsetPtr('get');
        gtDisplay = gtBrowserDisplayPtr('get');

        gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');

        if numel(atAppList)

            bRunCommand = false;

            sPath = '';
            for i=1: numel(gadOffset)
                if numel(gsBrowserMainWindowDisplay) >= gadOffset{i}

                    sLine = gsBrowserMainWindowDisplay{gadOffset{i}};        

                    if strlength(sLine) 
                        bRunCommand = true;
                        if i > 1
                   %         sPath = strcat(sPath, {' '}, '"', extractAfter(sLine, 130), '"');    
                            sPath = strcat(sPath, {' '}, '"', gtDisplay{gadOffset{i}}.sTargetDirectory, '"');    
                        else    
                   %         sPath = strcat('"', extractAfter(sLine, 130), '"');  
                            sPath = strcat('"', gtDisplay{gadOffset{i}}.sTargetDirectory, '"');  
                        end
                    end
                end
            end

            sCommand  = atAppList(get(btnBrowserRunCommandPtr('get'), 'Value')).sCommand;
            sArgument = atAppList(get(btnBrowserRunCommandPtr('get'), 'Value')).sArgument;

            if bRunCommand == true
                if strcmpi(sArgument, 'null')
                    system( char(strcat(sCommand, {' '}, sPath, ' &')) );                       
                else
                    system( char(strcat(sCommand, {' '}, sArgument, {' '}, sPath, ' &')) );                       
                end
            end
        end
    end        
end

