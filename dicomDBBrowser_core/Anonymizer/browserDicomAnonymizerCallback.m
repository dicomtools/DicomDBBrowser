function browserDicomAnonymizerCallback(~,~)
%function browserDicomAnonymizerCallback(~,~)
%Call DICOM Anonymiser from ui Menu.
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

        gtDisplay = gtBrowserDisplayPtr('get');
        gadOffset = gadBrowserOffsetPtr('get');

        gsBrowserMainWindowDisplay = ...
            gsBrowserMainWindowDisplayPtr('get');

        for i=1: numel(gadOffset)
            if numel(gsBrowserMainWindowDisplay) >= gadOffset{i}

                sLine = gsBrowserMainWindowDisplay{gadOffset{i}};
                if strlength(sLine)

%                            sPath = extractAfter(sLine, 130);
                    sPath = gtDisplay{gadOffset{i}}.sTargetDirectory;

                    try
                        browserInitAnonymizerValues();

                        tValues = browserAnonymizerValues('get');
                        if ~isempty(tValues)
                            sCurrentDir = pwd;
                            sMatFile = [sCurrentDir '/' 'lastUsedDir.mat'];
                            % load last data directory
                            if exist(sMatFile, 'file')
                                % lastDirMat mat file exists, load it
                                load('-mat', sMatFile);
                                if exist('lastUsedDir', 'var')
                                    sCurrentDir = lastUsedDir;
                                end
                                if sCurrentDir == 0
                                    sCurrentDir = pwd;
                                end
                            end

                            sTargetDir = uigetdir(sCurrentDir, ...
                                                  'Select Save Folder' ...
                                                  );
                            if sTargetDir == 0
                                return;
                            end
                            sTargetDir = [sTargetDir '/'];

                            sFileName = sprintf('%s_%s_%s', ...
                                            tValues.PatientName, ...
                                            tValues.PatientID, ...
                                            datetime('now','Format','MMMM-d-y-hhmmss') ...
                                            );

                            sAnoDir   = sprintf('%s%s//', ...
                                            sTargetDir, ...
                                            sFileName ...
                                            );

                            if~(exist(char(sAnoDir), 'dir'))
                                mkdir(char(sAnoDir));
                            end

                            try
                                lastUsedDir = sTargetDir;
                                save(sMatFile, 'lastUsedDir');
                            catch

                                browserProgressBar(1 , sprintf('Warning: Cant save file %s', sMatFile));
%                                h = msgbox(sprintf('Warning: Cant save file %s', sMatFile), 'Warning'); 

%                                        javaFrame = get(h, 'JavaFrame');
%                                        javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
                            end

                            browserDicomAnonymizer(char(sPath)  , ...
                                                   char(sAnoDir), ...
                                                   sFileName    , ...
                                                   tValues ...
                                                   );

                        end
                    catch

                        browserProgressBar(1 , 'Error: browserDicomAnonymizerCallback() error detected!');
                        h = msgbox('Error: browserDicomAnonymizerCallback() error detected!', 'Error');

%                                javaFrame = get(h, 'JavaFrame');
%                                javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
                    end
                end
            end
        end
    end

end
