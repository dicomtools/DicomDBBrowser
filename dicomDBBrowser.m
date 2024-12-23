function dicomDBBrowser(varargin)      
%function dicomDBBrowser(varargin)
%DICOM Database Browser.
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

    browserUIFigure('set', false); % Tested wih Matlab 2023b

    initBrowserGlobal();
    
    initBrowserRootPath();

    browserLbBackgroundColor('set', [0.149 0.149 0.149]);
    browserLbForegroundColor('set', [0.98 0.98 0.98]);
    browserBackgroundColor('set', [0.16 0.18 0.20]);
    browserForegroundColor('set', [0.94 0.94 0.94]);
    browserHighlightColor ('set', [0.94 0.94 0.94]);
    browserShadowColor    ('set', [0.94 0.94 0.94]);
    browserButtonBackgroundColor('set', [0.53 0.63 0.40]);
    browserButtonForegroundColor('set', [0.10 0.10 0.10]);    
    browserButtonPushedBackgroundColor('set', [0.2 0.039 0.027]);
    browserButtonPushedForegroundColor('set', [0.94 0.94 0.94]);
    
    browserMultiThread('set', true);
    browserFastSearch ('set', true);
    
    dScreenSize  = get(groot  , 'Screensize');

    dMainWindowSizeX = dScreenSize(3);
    dMainWindowSizeY = dScreenSize(4);

    dPositionX = (dScreenSize(3) /2) - (dMainWindowSizeX /2);
    dPositionY = (dScreenSize(4) /2) - (dMainWindowSizeY /2);    
   
    if browserUIFigure('get') == true
        dlgWindows = ...
            uifigure('Position', [dPositionX ...
                                dPositionY ...
                                dMainWindowSizeX ...
                                dMainWindowSizeY ...
                                ],...
                    'Name'       , 'DICOM DB Browser',...
                    'NumberTitle', 'off',...                           
                    'units'      , 'normalized',...
                    'AutoResizeChildren', 'off', ...
                    'resize'     , 'on',...
                    'MenuBar'    , 'none',...
                    'Toolbar'    , 'none',...
                    'Color'      , browserBackgroundColor('get'), ...
                    'SizeChangedFcn',@resizeBrowserDialog...
                  );
    else
        dlgWindows = ...
            figure('Position', [dPositionX ...
                                dPositionY ...
                                dMainWindowSizeX ...
                                dMainWindowSizeY ...
                                ],...
                    'Name'       , 'DICOM DB Browser',...
                    'NumberTitle', 'off',...                           
                    'units'      , 'normalized',...
                    'resize'     , 'on',...
                    'MenuBar'    , 'none',...
                    'Toolbar'    , 'none',...
                    'Color'      , browserBackgroundColor('get'), ...
                    'SizeChangedFcn',@resizeBrowserDialog...
                  );        
    end

    dlgBrowserWindowsPtr('set', dlgWindows);
    
    dDlgPosition = get(dlgWindows, 'position');

    dDialogSize = dScreenSize(4) * dDlgPosition(4); 
    yPosition   = dDialogSize - 30;

    xSize = dScreenSize(3) * dDlgPosition(3); 
    ySize = dDialogSize - 30;                    

    sRootPath = browserRootPath('get');

    if ~isempty(sRootPath)

        javaFrame = get(dlgBrowserWindowsPtr('get'), 'JavaFrame');

        if ~isempty(javaFrame)
            
            javaFrame.setFigureIcon(javax.swing.ImageIcon(sprintf('%s/logo.png', sRootPath)));       
        end
    end

    uiMainWindow = ...
        uipanel(dlgWindows,...
                'Units'   , 'pixels',...
                'position', [0 ...
                             30 ...
                             xSize ...
                             ySize-30 ...
                             ],...
                'BackgroundColor', browserBackgroundColor ('get'), ...
                'ForegroundColor', browserForegroundColor('get'), ...                             
                'title'   , 'DICOM Database List'...            
                );
    uiBrowserMainWindowPtr('set', uiMainWindow);
                    
    uiProgressWindow = ...
        uipanel(dlgWindows,...
                'Units'   , 'pixels',...
                'position', [0 ...
                             0 ...
                             xSize ...
                             30 ...
                             ],...
                'title'   , 'Ready', ...
                'BackgroundColor', browserBackgroundColor ('get'), ...
                'ForegroundColor', browserForegroundColor('get') ...                 
                );                    
    uiBrowserProgressWindowPtr('set', uiProgressWindow);
                    
    lbDBWindow = ...
        uicontrol(uiMainWindow,...
                  'style'   , 'listbox',...
                  'position', [5 ...
                               dDialogSize-75-250 ...
                               300 ...
                               250-5 ...
                               ],...
                  'fontsize'       , 10,...
                  'Fontname'       , 'Monospaced',...
                  'BackgroundColor',  [1 1 1], ...
                  'Value'          , 1 ,...
                  'Selected'       , 'on',...
                  'enable'         , 'on',...
                  'string'         , ' ',... 
                  'Callback'       , @lbBrowserDBWindowCallback...
                  );
    lbBrowserDBWindowPtr('set', lbDBWindow);
    
    set(lbDBWindow,'Max',1,'Min',0);
 

%    txtCurrentDirectory =  ...
%        uicontrol(dlgWindows,...
%                  'style'     , 'text',...
%                  'string'    , 'Current Directory',...
%                  'FontWeight', 'Bold', ...
%                  'horizontalalignment', 'center',...
%                  'position'  , [5 ...
%                                 dDialogSize-75-250-20-10 ...
%                                 290 ...
%                                 20 ...
%                                 ], ...
%                  'BackgroundColor', browserBackgroundColor('get'), ...
%                  'ForegroundColor', browserForegroundColor('get') ...                                 
%                  );
%    txtBrowserCurrentDirectoryPtr('set', txtCurrentDirectory);
                           
%    edtCurrentDirectory =  ...
%        uicontrol(dlgWindows,...
%                  'enable'    , 'on',...
%                  'style'     , 'edit',...
%                  'Background', 'white',...
%                  'string'    , '',...
%                  'position'  , [5 ...
%                                dDialogSize-75-250-20-5 ...
%                                290 ...
%                                 25 ...
%                                 ],...
%                  'BackgroundColor', browserBackgroundColor('get'), ...
%                  'ForegroundColor', browserForegroundColor('get'), ...                                      
%                  'Callback'  , @browserCurrentDirectoryCallback...
%                  );   
%    edtBrowserCurrentDirectoryPtr('set', edtCurrentDirectory);
 
%    uiPathSelect = ...
%        uicontrol(dlgWindows, ...
%                  'Style'   , 'popup', ...
%                  'position', [5 ...
%                               dDialogSize-75-250-20-70 ...
%                               290 ...
%                               25 ...
%                               ],...
%                  'String'  , getBrowserDrivesList(), ...
%                  'Value'   , 1,...
%                  'FontSize', 10, ...
%                  'Enable'  , 'on', ...
%                  'BackgroundColor', browserBackgroundColor('get'), ...
%                  'ForegroundColor', browserForegroundColor('get'), ...                       
%                  'Callback', @browseDrivesListCallback...
%                  );  
%    edtBrowserPathSelectPtr('set', uiPathSelect);
  
%    lbDirectoryWindow = ...
%        uicontrol(uiMainWindow,...
%                  'style'   , 'listbox',...
%                  'position', [5 ...
%                               5 ...
%                               290 ...
%                               dDialogSize-75-250-20-110 ...
%                               ],...
%                  'fontsize', 10,...
%                  'Fontname', 'Monospaced',...
%                  'Value'   , 1 ,...
%                  'Selected', 'on',...
%                  'enable'  , 'on',...
%                  'string'  , ' ',...              
%                  'Callback', @lbBrowserDirectoryWindowCallback...
%                  );
%    lbBrowserDirectoryWindowPtr('set', lbDirectoryWindow);

%    set(lbDirectoryWindow,'Max',1,'Min',0);

    uiJFileChooser = ...
        uipanel(uiMainWindow,...
                'Units'   , 'pixels',...
                'position', [5 ...
                             5 ...
                             300 ...
                             dDialogSize-75-250-35 ...
                             ],...
                'BackgroundColor', browserBackgroundColor ('get'), ...
                'ForegroundColor', browserForegroundColor('get') ...                          
                );
    lbBrowserDirectoryWindowPtr('set', uiJFileChooser);

    initBrowserJFolderChooser(uiJFileChooser);


%    javaComponentName = 'javax.swing.JFileChooser';
%    [hjFileChooser, hContainer] = javacomponent(javaComponentName, [0,0,290,dDialogSize-75-250-20-110], uiJFileChooser);
%    hjFileChooser.setCurrentDirectory(java.io.File(pwd));
%    hjFileChooser.setMultiSelectionEnabled(false);
%    hjFileChooser.setFileSelectionMode(1);


%    set(hContainer, 'units','normalized','position',[0 0 1 1.0]);
%    set(hContainer, 'BackgroundColor',browserBackgroundColor ('get'));
%    hjFileChooser.ActionPerformedCallback = @browserJavaDirectory;

    lbMainWindow = ...
       uicontrol(uiMainWindow,...
                 'style'   , 'listbox',...
                 'position', [300 ...
                              5 ...
                              xSize-300 ...
                              dDialogSize-105 ...
                              ],...
                 'fontsize'       , 10,...
                 'Fontname'       , 'Monospaced',...
                 'BackgroundColor',  [1 1 1], ...
                 'Value'          , 1 ,...
                 'Selected'       , 'on',...
                 'enable'         , 'on',...
                 'string'         , ' ',...              
                 'Callback'       , @lbBrowserMainWindowCallback...
                 );
    lbBrowserMainWindowPtr('set', lbMainWindow);
                    
    set(lbMainWindow, 'Max',2, 'Min',0);
                     
    btnPatientName = ...
         uicontrol(uiMainWindow,...
                   'Position', [300+130 ...
                                dDialogSize-95-5 ...
                                180 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'PATIENTNAME',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                     
                   'Callback', @browserSortCallback...                   
                   );    
    btnBrowserPatientNamePtr('set', btnPatientName);
                   
    btnPatientID = ...
         uicontrol(uiMainWindow,...
                   'Position', [480+130 ...
                                dDialogSize-95-5 ...
                                95 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'PATIENTID',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserSortCallback...                   
                   );    
    btnBrowserPatientIDPtr('set', btnPatientID);
                    
    btnStudyDate = ...
         uicontrol(uiMainWindow,...
                   'Position', [575+130 ...
                                dDialogSize-95-5 ...
                                95 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'STUDYDATE',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserSortCallback...                   
                   ); 
    btnBrowserStudyDatePtr('set', btnStudyDate);
                    
    btnAccession = ...
         uicontrol(uiMainWindow,...
                   'Position', [670+130 ...
                                dDialogSize-95-5 ...
                                95 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'ACCESSION',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserSortCallback...                   
                   ); 
    btnBrowserAccessionPtr('set', btnAccession);
                    
    btnStudyDesc = ...
         uicontrol(uiMainWindow,...
                   'Position', [765+130 ...
                                dDialogSize-95-5 ...
                                250 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'STUDYDESCRIPTION',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserSortCallback...                   
                   ); 
    btnBrowserStudyDescPtr('set', btnStudyDesc);
                    
    btnSeriesDesc = ...
         uicontrol(uiMainWindow,...
                   'Position', [1015+130 ...
                                dDialogSize-95-5 ...
                                325 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'SERIESDESCRIPTION',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserSortCallback...                   
                   ); 
    btnBrowserSeriesDescPtr('set', btnSeriesDesc);
                    
    btnLocation = ...
         uicontrol(uiMainWindow,...
                   'Position', [1340+130 ...
                                dDialogSize-95-5 ...
                                xSize-1243 ...
                                20 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'LOCATION',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserSortCallback...                   
                   ); 
    btnBrowserLocationPtr('set', btnLocation);
                    
    uiSearchBy = ...
        uicontrol(dlgWindows, ...
                  'Style'   , 'popup', ...
                  'position', [5 ...
                               yPosition ...
                               153 ...
                               25 ...
                               ],...
                  'String'  , {'Patient Name'      , ...
                               'Patient ID'        , ...
                               'Study Date'        , ...
                               'Study description' , ...
                               'Series description', ...
                               'Accession Number' ...
                               }, ...
                  'Value'   , 2 ,...
                  'FontSize', 10, ...
                  'BackgroundColor', browserBackgroundColor('get'), ...
                  'ForegroundColor', browserForegroundColor('get'), ...                          
                  'Enable'  , 'on' ...
                  );  
    uiBrowserSearchByPtr('set', uiSearchBy);
                         
    edtFindValue =  ...
        uicontrol(dlgWindows,...
                  'enable'    , 'on',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , '',...
                  'position'  , [160 ...
                                 yPosition ...
                                 200 ...
                                 25 ...
                                 ],...
                  'BackgroundColor', browserBackgroundColor('get'), ...
                  'ForegroundColor', browserForegroundColor('get'), ...                                         
                  'Callback'  , @browserSearchTagCallback...
                  );   
    edtBrowserFindValuePtr('set', edtFindValue);
                     
    btnSearchTag = ...
        uicontrol(dlgWindows,...
                  'Position', [361 ...
                               yPosition-1 ...
                               50 ...
                               27 ...
                               ],...
                  'enable'  , 'on',...
                  'String'  , 'Search',...
                  'BackgroundColor', browserButtonBackgroundColor('get'), ...
                  'ForegroundColor', browserButtonForegroundColor('get'), ...                          
                  'Callback', @browserSearchTagCallback...
                  );                     
    btnBrowserSearchTagPtr('set', btnSearchTag);                    
                    
    btnAddDB = ...
         uicontrol(uiMainWindow,...
                   'Position', [5 ...
                                dDialogSize-75-250-20-5 ...
                                290 ...
                                20 ...
                                ],...
                   'FontWeight','bold',...
                   'enable'  , 'on',...
                   'String'  , 'ADD TO DATABASE',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserAddDBCallback...
                   ); 
    btnBrowserAddDBPtr('set', btnAddDB);                    
                                        
    btnOptions = ...
         uicontrol(dlgWindows,...
                   'Position', [420 ...
                                yPosition ...
                                120 ...
                                25 ...
                                ],...
                   'String'  , 'Options',...
                   'enable'  , 'on',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @setBrowserOptionsCallback...
                   );
    btnBrowserOptionsPtr('set', btnOptions);                    
                    
    btnViewHeader = ...
         uicontrol(dlgWindows,...
                   'Position', [549 ...
                                yPosition ...
                                120 ...
                                25 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'View Header',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserViewHeaderCallback...
                   );                      
    btnBrowserViewHeaderPtr('set', btnViewHeader);                    
                    
    btnDicomViewer = ...
         uicontrol(dlgWindows,...
                   'Position', [671 ...
                                yPosition ...
                                120 ...
                                25 ...
                                ],...
                   'enable'  , 'off',...
                   'String'  , 'TriDFusion (3DF)',...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback', @browserDicomViewerCallback...
                   );    
    btnBrowserDicomViewerPtr('set', btnDicomViewer);                    
    
%    btnCerr = ...
%         uicontrol(dlgWindows,...
%                   'Position', [723 ...
%                                yPosition ...
%                                100 ...
%                                25 ...
%                                ],...
%                   'enable'  , 'off',...
%                   'String'  , 'CERR',...
%                   'BackgroundColor', browserBackgroundColor('get'), ...
%                   'ForegroundColor', browserForegroundColor('get'), ...                           
%                   'Callback', @browserCerrCallbak...
%                   );    
%    btnBrowserCerrPtr('set', btnCerr);     
    
    btnRunCommand = ...
         uicontrol(dlgWindows,...
                   'Style'        , 'pushbutton', ...
                   'Position'     , [793 ...
                                     yPosition ...
                                     200 ...
                                     25 ...
                                     ],...
                   'enable'       , 'off',...
                   'ButtonDownFcn', @btnBrowserMenuCallback,...
                   'BackgroundColor', browserBackgroundColor('get'), ...
                   'ForegroundColor', browserForegroundColor('get'), ...                           
                   'Callback'     , @btnBrowserRunCallback...
                   ); 
    btnBrowserRunCommandPtr('set', btnRunCommand);                                        
    
    browserMainWindowMenu();
                 

%    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  
    
%    javaFrame = get(dlgWindows, 'JavaFrame');
%    javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
    
%   [img,map] = imread('.\icons\play.png');
%   img = double(img)/255;
%   set(btnRunCommand,'CData', img);           
               
    set(dlgWindows, 'WindowButtonDownFcn', @browserClickDown);

    gsBrowserMainWindowDisplayPtr('set', '');    

    initBrowserDcm4che3();

    browserDBList('clear');
    browserCancelSearch('set', false);
    
    uiBar = uipanel(uiBrowserProgressWindowPtr('get'));
    
    set(uiBar, 'BackgroundColor', browserBackgroundColor('get'));
    set(uiBar, 'ForegroundColor', browserForegroundColor('get'));     
    % set(uiBar, 'ShadowColor'    , browserBackgroundColor('get'));
    % set(uiBar, 'HighlightColor' , browserBackgroundColor('get'));    
    
    uiBrowserProgressBarPtr('set', uiBar);

    set(dlgWindows, 'WindowState', 'maximized');

    set(uiBar, 'Position', [0 0 dScreenSize(3) 10]);     

    refresh(dlgWindows);  

    initBrowserDisclamer();           
  
    initBrowserDatabase();

    initBrowserRunApplication();
    
    initBrowserDoubleClick('Open Containing Folder');               

end



