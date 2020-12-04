function browserProcessDirectory(targetDirectory, sTocken, iSearchElementOffset)
%function browserProcessDirectory(targetDirectory, sTocken, iSearchElementOffset)
%Embeded Function that scan all Directory and SubDirectory.
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

    %	NET.addAssembly('mscorlib.dll');

    % Process the list of files found in the directory.
    % fileEntries = System.IO.Directory.GetFiles(targetDirectory);

    % f = java.io.File(targetDirectory);
    
    fileEntries = targetDirectory.listFiles();

    gtDisplay = gtBrowserDisplayPtr('get');

    for i=1:numel(fileEntries)
        if fileEntries(i).isFile()
            try
                tNiftiInfo = niftiinfo(char(fileEntries(i)));
                if ~isempty(tNiftiInfo)
                    
                    dLineOffset = 1+numel(gtDisplay);

                    gtDisplay{dLineOffset}.sPatientName = tNiftiInfo.Version;
                    gtDisplay{dLineOffset}.sPatientID   = '';
                    gtDisplay{dLineOffset}.sStudyDate   = tNiftiInfo.Filemoddate;
                    gtDisplay{dLineOffset}.sAccessionNumber   = '';
                    gtDisplay{dLineOffset}.sStudyDescription  = '';
                    gtDisplay{dLineOffset}.sSeriesDescription = '';
                    gtDisplay{dLineOffset}.sTargetDirectory   = char(targetDirectory.getPath());

                    gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');                        
                    gsBrowserMainWindowDisplay{dLineOffset} = sprintf('%-21s %-11s %-11s %-11s %-30s %-40s %s', ...
                         browserElementMaxLength(gtDisplay{dLineOffset}.sPatientName      , 21), ...
                         browserElementMaxLength(gtDisplay{dLineOffset}.sPatientID        , 11),...
                         browserElementMaxLength(gtDisplay{dLineOffset}.sStudyDate        , 11),...
                         browserElementMaxLength(gtDisplay{dLineOffset}.sAccessionNumber  , 11),...
                         browserElementMaxLength(gtDisplay{dLineOffset}.sStudyDescription , 30),...
                         browserElementMaxLength(gtDisplay{dLineOffset}.sSeriesDescription, 40), ...
                         gtDisplay{dLineOffset}.sTargetDirectory);                         
                    gsBrowserMainWindowDisplayPtr('set', gsBrowserMainWindowDisplay);
                    
                    break;
                end
            catch
                
                tDicomInfo = browserDicomInfo4che3(fileEntries(i));            
                if ~isempty(tDicomInfo)

                 %   if ~(isempty(tDicomInfo.PatientName))

                        aStructCell = struct2cell(tDicomInfo);
                        if contains(lower(aStructCell{iSearchElementOffset}), lower(sTocken)) ||...
                           strcmp(sTocken, '')                           

                  %         || strcmp(sTocken, '')                           

%                            if ~numel(gsBrowserMainWindowDisplayPtr('get'))
%                                set(btnBrowserViewHeaderPtr('get') , 'enable', 'on');
%                                set(btnBrowserDicomViewerPtr('get'), 'enable', 'on');
%                                set(btnBrowserRunCommandPtr('get') , 'enable', 'on');                              
%                                set(btnBrowserCerrPtr('get')       , 'enable', 'on');                               
%                            end

                            dLineOffset = 1+numel(gtDisplay);

                            gtDisplay{dLineOffset}.sPatientName = tDicomInfo.PatientName;
                            gtDisplay{dLineOffset}.sPatientID   = tDicomInfo.PatientID;
                            if strlength(tDicomInfo.StudyDate) == 8
                                gtDisplay{dLineOffset}.sStudyDate  = datetime(tDicomInfo.StudyDate,'InputFormat','yyyyMMdd');
                            else
                                gtDisplay{dLineOffset}.sStudyDate  = tDicomInfo.StudyDate;
                            end
                            gtDisplay{dLineOffset}.sAccessionNumber   = tDicomInfo.AccessionNumber;
                            gtDisplay{dLineOffset}.sStudyDescription  = tDicomInfo.StudyDescription;
                            gtDisplay{dLineOffset}.sSeriesDescription = tDicomInfo.SeriesDescription;
                            gtDisplay{dLineOffset}.sTargetDirectory   = char(targetDirectory.getPath());

                            gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');                        
                            gsBrowserMainWindowDisplay{dLineOffset} = sprintf('%-21s %-11s %-11s %-11s %-30s %-40s %s', ...
                                 browserElementMaxLength(gtDisplay{dLineOffset}.sPatientName      , 21), ...
                                 browserElementMaxLength(gtDisplay{dLineOffset}.sPatientID        , 11),...
                                 browserElementMaxLength(gtDisplay{dLineOffset}.sStudyDate        , 11),...
                                 browserElementMaxLength(gtDisplay{dLineOffset}.sAccessionNumber  , 11),...
                                 browserElementMaxLength(gtDisplay{dLineOffset}.sStudyDescription , 30),...
                                 browserElementMaxLength(gtDisplay{dLineOffset}.sSeriesDescription, 40), ...
                                 gtDisplay{dLineOffset}.sTargetDirectory);                         
                            gsBrowserMainWindowDisplayPtr('set', gsBrowserMainWindowDisplay);

                        end
                        break;
                %    end
                end
            end
        end
    end

    gtBrowserDisplayPtr('set', gtDisplay);

    % Recurse into subdirectories of this directory.
%      subdirectory = System.IO.Directory.GetDirectories(targetDirectory);

%       f = java.io.File(char(targetDirectory));
    subdirectory = targetDirectory.listFiles();
%       subdirectory(~arrayfun(@isDirectory, subdirectory, 'UniformOutput', true)) =[];

    if numel(subdirectory)
 %       for j=1: subdirectory.Length
        for j=1: numel(subdirectory)
            if browserCancelSearch('get') 
       %         clearAllMemoizedCaches;
                return;
            end
            if subdirectory(j).isDirectory
                browserProgressBar(1, ['Analyzing:' char(subdirectory(j))]);
                browserProcessDirectory(subdirectory(j), sTocken, iSearchElementOffset);
            else
                if browserFastSearch('get')
                    break;
                end
            end
        end
    end

    dListboxTop = get(lbBrowserMainWindowPtr('get'), 'ListboxTop');                

    set(lbBrowserMainWindowPtr('get'), 'String'    , gsBrowserMainWindowDisplayPtr('get'));  
    set(lbBrowserMainWindowPtr('get'), 'Value'     , dListboxTop);         
    set(lbBrowserMainWindowPtr('get'), 'ListboxTop', dListboxTop);         
%     lbMainWindow.String = gsBrowserMainWindowDisplayPtr('get');

%       clearAllMemoizedCaches;

end
