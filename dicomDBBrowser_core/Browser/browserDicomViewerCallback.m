function browserDicomViewerCallback(~, ~)
%function browserRunCommandCallback(~, ~)
%Run TriDFusion Image Viewer.
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

    if numel(gsBrowserMainWindowDisplayPtr('get')) 

        sPath = '';
        bDisplayViewer = false;

        gadOffset = gadBrowserOffsetPtr('get');
        gtDisplay = gtBrowserDisplayPtr('get');

        gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');

        for i=1: numel(gadOffset)
            if numel(gsBrowserMainWindowDisplay) >= gadOffset{i}

                sLine = gsBrowserMainWindowDisplay{gadOffset{i}};                     

                if strlength(sLine) 

                    bDisplayViewer = true;

                    if i > 1 && browserMultiThread('get')
                     %   sPath = strcat(sPath, {' '}, '"[', extractAfter(sLine, 130), ']"');    
                        sPath = strcat(sPath, {' '}, '"[',  gtDisplay{gadOffset{i}}.sTargetDirectory, ']"');    
                    else    
                  %      sPath{i} = char(strcat('"[', extractAfter(sLine, 130), ']"'));  
                        sPath{i} = char(strcat('"[', gtDisplay{gadOffset{i}}.sTargetDirectory, ']"'));  
                    end
                end
            end
        end

        if bDisplayViewer == true
%                cd '.\dicomImageViewer\';

            try
                if browserMultiThread('get')
                    sRootPath = browserRootPath('get');
                    sTriDFusion = sprintf('%sTriDFusion/', sRootPath);

                    cd(sTriDFusion);
                    if ispc % Windows
                        system( char(strcat('TriDFusion.exe', {' '}, sPath, '&')) );
                    elseif isunix % Linux
                        system( char(strcat( sprintf('%s/run_TriDFusion.sh', sTriDFusion), {' '}, sPath, '&')) );
                    else % Mac not yet supported
                    end
                    cd '..';                        
                else    
                    sRootPath = browserRootPath('get');
                    sTriDFusion = sprintf('%sTriDFusion/', sRootPath);     

                    cd(sTriDFusion);

                    if ~isempty(findobj('Name','TriDFusion (3DF) Image Viewer'))
                        answer = myquestdlg('browserMultiThreading is currently turn off, Only one instance of TriDFusion Image Viewer can run at the time. You can activate the Multi Threading from the options menu. Continue will close the open instance.', 'Warning', 'Continue','Return','Continue');
                        switch answer                       
                            case 'Continue'
                                close('TriDFusion (3DF) Image Viewer');
                            case 'Return'
                                return;
                        end 
                    end
                    clear TriDFusion;
                    TriDFusion( sPath{:}, '[-i]');
                    
                    cd '..';                        
                end

            catch
                browserProgressBar(1, 'Error: browserDicomViewerCallback(): error(s) occur while trying to view the image!');
                h = msgbox('Error: browserDicomViewerCallback(): error(s) occur while trying to view the image!', 'Error');     

%                    javaFrame = get(h, 'JavaFrame');
%                    javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
            end
%              system( char(strcat('TriDFusion.exe', {' '}, sPath, ' [-l] [-s] [-r] &')) );
%              cd '..';

        end
    end
end
