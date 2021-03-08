function browserCerrCallbak(~, ~)   

    if numel(gsBrowserMainWindowDisplayPtr('get')) 

        asPath = '';

        gadOffset = gadBrowserOffsetPtr('get');
        gtDisplay = gtBrowserDisplayPtr('get');

        gsBrowserMainWindowDisplay = gsBrowserMainWindowDisplayPtr('get');

        for i=1: numel(gadOffset)
            if numel(gsBrowserMainWindowDisplay) >= gadOffset{i}

                sLine = gsBrowserMainWindowDisplay{gadOffset{i}};                     

                if strlength(sLine) 
                    asPath{i} = gtDisplay{gadOffset{i}}.sTargetDirectory;  
                end
            end
        end

    end
        
    asDicomPath = '';
    asNiftiPath = '';
        
    for jj=1:numel(asPath)
        f = java.io.File(asPath{jj});
        atListing = f.listFiles();        
        for ll=1:numel(atListing)
            if atListing(ll).isFile()
                try
                    tNiftiInfo = niftiinfo(char(atListing(ll)));
                    if ~isempty(tNiftiInfo)    
                        asNiftiPath{numel(asNiftiPath)+1} = asPath{jj}; 
                        break;
                    end                    
                catch
                    tDicomInfo = browserDicomInfo4che3(char(atListing(ll)));            
                    if ~isempty(tDicomInfo)    
                        asDicomPath{numel(asDicomPath)+1} = asPath{jj}; 
                        break;
                    end
                end
            end   
        end   
    end
         
    if isempty(asDicomPath)
        return;
    end
    
    % Delete tmp .mat files
    
    f = java.io.File(tempdir);
    atListing = f.listFiles();

    for kk=1:numel(atListing)
        if atListing(kk).isFile()
            sEntryName = char(atListing(kk));
            if contains(sEntryName, '.mat')
                delete( sEntryName );
            end
        end
    end
    
    % 1 Convert DICOM to planC. (NOTE: In CERROptions.json, set importDICOMsubDirs=’yes’ to import sub-directories into planC. It is set to ‘no’ by default on GitHub. Also, set saveDICOMheaderInPlanC=’no’ to avoid importing the entire header to planC. This speeds up the import). The output  .mat file has same name as the source directory
    destinationDir = tempdir;
    zipFlag = 'No';
    mergeScansFlag = 'No';
    singleCerrFileFlag = 'Yes';
    init_ML_DICOM;    

    sCerrMatFile = browserBatchConvertWithSubDirs(asPath, destinationDir, zipFlag, mergeScansFlag, singleCerrFileFlag);  
    
    % 2.	Load planC from file in Matlab workspace:
    planC = loadPlanC(sCerrMatFile, tempdir);
    planC = updatePlanFields(planC);
    planC = quality_assure_planC(sCerrMatFile, planC);
    
    % 3.	Add nifty segmentation to planC:
    if ~isempty(asNiftiPath)
        for tt=1:numel(asNiftiPath)
            f = java.io.File(asNiftiPath{tt});
            atListing = f.listFiles();             
            for yy=1:numel(atListing)
                if atListing(yy).isFile()
                    try
                        tNiftiInfo = niftiinfo(char(atListing(yy)));
                        if ~isempty(tNiftiInfo)
                            for nn=1:numel(planC{3})
                                if strcmpi(planC{3}(nn).scanInfo(1).imageType, 'pt')
                                    try
                                        planC = importNiftiSegToPlanC(planC, char(atListing(yy)), nn);

                                    catch
                                    end
                                end
                            end
                        end
                    catch
                    end
                end
            end            
        end
    end
    
    % 4.	Open planC from file in Viewer:
    sliceCallBack('init'); 
 %   sliceCallBack('openNewPlanC', sCerrMatFile)
    sliceCallBack('Load', planC);

end
