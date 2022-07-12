function browserViewHeaderCallback(~, ~)
%function browserViewHeaderCallback(~, ~)
%Run DICOM Multi-Files Editor.
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

        gadOffset = gadBrowserOffsetPtr('get');
        gtDisplay = gtBrowserDisplayPtr('get');

        gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');

        for i=1: numel(gadOffset)
            if numel(gsBrowserMainWindowDisplay) >= gadOffset{i}

                sLine = gsBrowserMainWindowDisplay{gadOffset{i}}; 
                if strlength(sLine) 
          %          sPath = strcat('"[', extractAfter(sLine, 130), ']"');         
                    sPath = strcat('"[', gtDisplay{gadOffset{i}}.sTargetDirectory, ']"');         

                 try
                     if browserMultiThread('get')
                         
                        sRootPath = browserRootPath('get');
                        sDicomMultiFilesEditor = sprintf('%sdicomMultiFilesEditor/', sRootPath);

                        cd(sDicomMultiFilesEditor);
                        if ispc % Windows
                            system( char(strcat('dicomMultiFilesEditor.exe', {' '}, sPath, ' [-m] [-h1] &')));
                        elseif isunix % Linux
                            system( char(strcat( sprintf('%s/run_dicomMultiFilesEditor.sh', sDicomMultiFilesEditor), {' '}, sPath, ' [-r./temp] [-m] [-h1] &')));
                        else % Mac not yet supported
                            
                        end
                        cd '..';
                     else
                        if ~isempty(findobj('Name','DICOM Multi-Files Editor'))
                            answer = myquestdlg('browserMultiThreading is currently turn off, Only one instance of DICOM Multi-Files Editor can run at the time. You can activate the Multi Threading from the options menu. Continue will close the open instance.', 'Warning', 'Continue','Return','Continue');
                            switch answer                       
                                case 'Continue'
                                    close('DICOM Multi-Files Editor');
                                case 'Return'
                                    return;
                            end 
                        end
                        clear dicomMultiFilesEditor;
                        dicomMultiFilesEditor(char(sPath), '[-m]', '[-h1]', '[-i]');
                     end
                 catch
                        browserProgressBar(1, 'Error: browserViewHeaderCallback(): error(s) occur while trying to view the header!');
                        h = msgbox('Error: browserViewHeaderCallback(): error(s) occur while trying to view the header!', 'Error');  

%                            javaFrame = get(h, 'JavaFrame');
%                            javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
                 end

          %          cd '.\dicomMultiFilesEditor\';
          %          system( char(strcat('dicomMultiFilesEditor.exe', {' '}, sPath, ' [-tc:\temp] [-m] [-h1] &')));
          %          cd '..';
                end
            end
        end
    end
end
