function saved_fullFileName = browserBatchConvertWithSubDirs(varargin)
%function saved_fullFileName = batchConvert(sourceDir,destinationDir,zipFlag,mergeScansFlag,singleCerrFileFlag)
%
%Type "init_ML_DICOM; batchConvertWithSubDirs" (without quotes) in Command window to run batch conversion. User will be
%prompted to select source and destination directories. This function converts DICOM and RTOG files
%under sourceDir and subdirectories to CERR format and places them in destinationDir.
%
%APA, 01/22/2009
% AI, 05/26/17 Added mergeScansFlag
%
% Copyright 2010, Joseph O. Deasy, on behalf of the CERR development team.
%
% This file is part of The Computational Environment for Radiotherapy Research (CERR).
%
% CERR development has been led by:  Aditya Apte, Divya Khullar, James Alaly, and Joseph O. Deasy.
%
% CERR has been financially supported by the US National Institutes of Health under multiple grants.
%
% CERR is distributed under the terms of the Lesser GNU Public License.
%
%     This version of CERR is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
% CERR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with CERR.  If not, see <http://www.gnu.org/licenses/>.


% Example-run
% sourceDir = 'J:\bioruser\apte\batch code';
% destinationDir = 'J:\bioruser\apte\batch code\OUT';
% zipFlag = 'No';
% mergeScansFlag = 'No';
% singleCerrFileFlag = 'No';
% batchConvert(sourceDir,destinationDir,zipFlag,mergeScansFlag,singleCerrFileFlag)

    feature accel off

    % Read options file
    pathStr = getCERRPath;
    optName = [pathStr 'CERROptions.json'];
    optS = opts4Exe(optName);

    persistent convertedC planNameC
    if isempty(varargin)
        %init_ML_DICOM
        convertedC = {'Source Directory:'};
        planNameC = {'Converted Plan Name:'};
        sourceDir = uigetdir(cd, 'Select Source directory');
        if isnumeric(sourceDir)
            return;
        end
        destinationDir = uigetdir(cd, 'Select Destination directory');
        if isnumeric(destinationDir)
            return;
        end
        zipFlag = questdlg('Do you want to bz2 zip output CERR files?', 'bz2 Zip files?', 'Yes','No','No');
        mergeScansFlag = 'no';
        singleCerrFileFlag = questdlg('Do you want to import all directories to single CERR file?', 'Single CERR file?', 'Yes','No','No');
    else
        convertedC = {'Source Directory:'};
        planNameC = {'Converted Plan Name:'};
        sourceDir = varargin{1};
        destinationDir = varargin{2};
        zipFlag = varargin{3};
        mergeScansFlag = varargin{4};
        singleCerrFileFlag = 'no';
        if length(varargin) > 4
            singleCerrFileFlag = varargin{5};
        end
    end

    excludePixelDataFlag = true;
   
%    [pathStr,nameStr,extStr] = fileparts(sCurrentPath);
    %[pathStr,nameStr,extStr] = fileparts(allDirS(dirNum).name);
    
    %if allDirS(dirNum).isdir && ~strcmpi(extStr,'.zip') && ~ismember(sourceDir,convertedC)
    
%    disp(['Importing ',sCurrentPath,' ...'])
    try
        
        hWaitbar = waitbar(0, 'Scanning Directory Please wait...');
        CERRStatusString('Scanning DICOM directory');
        
        dcmdirS = [];
        patientNum = 1;
                
        for kk=1:numel(sourceDir)
        
            patient = scandir_mldcm(sourceDir{kk}, hWaitbar, 1, excludePixelDataFlag);
            if ~isempty(patient)
                for j = 1:length(patient.PATIENT)
                    dcmdirS.(['patient_' num2str(patientNum)]) = patient.PATIENT(j);
                    patientNum = patientNum + 1;
                end
            end
        end
                       
        if isempty(dcmdirS)
            close(hWaitbar);
            return;
        end
        
        close(hWaitbar);
        
        patNameC = fieldnames(dcmdirS);

        % combinedDcmdirS = struct('STUDY',dcmdirS.(patNameC{1}).STUDY,'info',dcmdirS.(patNameC{1}).info);
        combinedDcmdirS = struct('STUDY',dcmdirS.(patNameC{1}).STUDY,'info',dcmdirS.(patNameC{1}).info);
        count = 0;
        newCombinedDcmdirS = struct('STUDY','');       
        for studyCount = 1:length(combinedDcmdirS.STUDY)
            for seriesCount = 1:length(combinedDcmdirS.STUDY(studyCount).SERIES)
                count = count + 1;
                newCombinedDcmdirS.STUDY.SERIES(count) = combinedDcmdirS.STUDY(studyCount).SERIES(seriesCount);
            end
        end
        combinedDcmdirS = newCombinedDcmdirS;
        %     for i = 2:length(patNameC)
        %         for j = 1:length(dcmdirS.(patNameC{i}).STUDY.SERIES)
        %             combinedDcmdirS.STUDY.SERIES(end+1) = dcmdirS.(patNameC{i}).STUDY.SERIES(j);
        %         end
        %     end
        for i = 2:length(patNameC)
            for  k = 1:length(dcmdirS.(patNameC{i}).STUDY)
                for j = 1:length(dcmdirS.(patNameC{i}).STUDY(k).SERIES)
                    combinedDcmdirS.STUDY.SERIES(end+1) = dcmdirS.(patNameC{i}).STUDY(k).SERIES(j);
                end
            end
        end
        
        % Pass the java dicom structures to function to create CERR plan
        planC = dcmdir2planC(combinedDcmdirS,mergeScansFlag);
                     
        %Check for duplicate name of sourceDirName

        sourceDirName = sprintf('dicom_db_browser_%s', datetime('now','Format','MMMM-d-y-hhmmss') );
        
        if strcmpi(zipFlag,'Yes')
            saved_fullFileName = fullfile(destinationDir,[sourceDirName,'.mat.bz2']);
        else
            saved_fullFileName = fullfile(destinationDir,[sourceDirName,'.mat']);
        end
        
        if ~exist(fileparts(saved_fullFileName), 'dir')
            mkdir(fileparts(saved_fullFileName))
        end        
        
        save_planC(planC,[], 'passed', saved_fullFileName);
        clear planC
        convertedC{end+1} = sourceDir;
        planNameC{end+1} = [sourceDirName,'.mat.bz2'];
    catch
        convertedC{end+1} = sourceDir;
        planNameC{end+1} = 'NOT CONVERTED';
        disp(['NOT CONVERTED ',sourceDir,' ...'])
    end

    if isempty(varargin)
        for i=1:length(convertedC)
            xlswrite(fullfile(destinationDir,'batch_convert_results.xls'),{convertedC{i}},'Sheet1',['A',num2str(i)])
            xlswrite(fullfile(destinationDir,'batch_convert_results.xls'),{planNameC{i}},'Sheet1',['B',num2str(i)])
        end
    end
end
