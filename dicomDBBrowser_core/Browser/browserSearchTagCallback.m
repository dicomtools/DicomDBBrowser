function browserSearchTagCallback(~, ~)
%function browserSearchTagCallback(~, ~)
%Search under all Directory and SubDirectory a tag.
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

    hjFileChooser = hjBrowserFileChooserPtr('get');

    browserSortDirection('set', 'PATIENTNAME'      , 'null');
    browserSortDirection('set', 'PATIENTID'        , 'null');
    browserSortDirection('set', 'STUDYDATE'        , 'null');
    browserSortDirection('set', 'ACCESSION'        , 'null');
    browserSortDirection('set', 'STUDYDESCRIPTION' , 'null');
    browserSortDirection('set', 'SERIESDESCRIPTION', 'null');
    browserSortDirection('set', 'LOCATION'         , 'null');                   

    if strcmp(get(btnBrowserSearchTagPtr('get'), 'String'), 'Abort')

        set(btnBrowserSearchTagPtr('get'), 'background', 'default');
        set(btnBrowserSearchTagPtr('get'), 'String', 'Search');
        browserCancelSearch('set', true);
    else

    %    if (numel(stDBWindow) >= dOffset)

           set(lbBrowserMainWindowPtr('get'), 'Value', 1); 

           set(btnBrowserViewHeaderPtr('get') , 'enable', 'off');
           set(btnBrowserDicomViewerPtr('get'), 'enable', 'off');
           set(btnBrowserRunCommandPtr('get') , 'enable', 'off');                                        
           set(btnBrowserCerrPtr('get')       , 'enable', 'off');       

           gsBrowserMainWindowDisplayPtr('set', '');    

    %                    gsBrowserMainWindowDisplay = sprintf('%-21s %-11s %-11s %-11s %-30s %-40s %s\n',...
    %                        'PATIENTNAME', 'PATIENTID', 'STUDYDATE', 'ACCESSION', 'STUDYDESCRIPTION', 'SERIESDESCRIPTION', 'LOCATION');                 

    %                    gsBrowserMainWindowDisplay = sprintf('%s%s\n', gsBrowserMainWindowDisplay, repmat('-', [1 155])); %155

           set(lbBrowserMainWindowPtr('get'),'string', gsBrowserMainWindowDisplayPtr('get')); 

    %                    browserCurrentDBPath('set', atDBList{dOffset}.sDBPath);

           set(btnBrowserSearchTagPtr('get'), 'String', 'Abort');
           set(btnBrowserSearchTagPtr('get'), 'background', 'w');

           set(btnBrowserPatientNamePtr('get'), 'Enable', 'Off');
           set(btnBrowserPatientIDPtr('get')  , 'Enable', 'Off');
           set(btnBrowserStudyDatePtr('get')  , 'Enable', 'Off');
           set(btnBrowserAccessionPtr('get')  , 'Enable', 'Off');
           set(btnBrowserStudyDescPtr('get')  , 'Enable', 'Off');
           set(btnBrowserSeriesDescPtr('get') , 'Enable', 'Off');
           set(btnBrowserLocationPtr('get')   , 'Enable', 'Off');

           browserCancelSearch('set', false);

           asSearchType = get(uiBrowserSearchByPtr('get'), 'String');

           switch char(asSearchType(get(uiBrowserSearchByPtr('get'), 'Value')))
               case 'Patient Name'
                   iStructElementOffset = 1; % browserDicomInfo4che3() return structure element offset 

               case 'Patient ID'
                   iStructElementOffset = 2;

               case 'Study Date'
                   iStructElementOffset = 5;

               case 'Study description'
                   iStructElementOffset = 11;

               case 'Series description'
                   iStructElementOffset = 10;

               case 'Accession Number'
                   iStructElementOffset = 9;

               otherwise            
                   browserProgressBar(1, 'Error: browserSearchTagCallback(): no search tag detected!');
                   h = msgbox('Error: browserSearchTagCallback(): no search tag detected!', 'Error');

    %                            javaFrame = get(h, 'JavaFrame');
    %                            javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
                  return;
           end

    %             clear browserProcessDirectory;
           gtBrowserDisplayPtr('set', []);

           browserProcessDirectory(hjFileChooser.getSelectedFolder(), get(edtBrowserFindValuePtr('get'), 'String'), iStructElementOffset);

           asMainWindow = cellstr(get(lbBrowserMainWindowPtr('get'), 'String'));  
           if isempty(char(asMainWindow(end)))
               asMainWindow = asMainWindow(1:end-1);

               dListboxTop = get(lbBrowserMainWindowPtr('get'), 'ListboxTop');                
               set(lbBrowserMainWindowPtr('get'), 'String', asMainWindow);  
               set(lbBrowserMainWindowPtr('get'), 'Value', dListboxTop);         
               set(lbBrowserMainWindowPtr('get'), 'ListboxTop', dListboxTop);
           end

           if browserCancelSearch('get') == false
               browserProgressBar(1, 'Ready');
           end

           set(btnBrowserSearchTagPtr('get'), 'background', 'default');
           set(btnBrowserSearchTagPtr('get'), 'String', 'Search');

           set(btnBrowserPatientNamePtr('get'), 'Enable', 'On');
           set(btnBrowserPatientIDPtr('get')  , 'Enable', 'On');
           set(btnBrowserStudyDatePtr('get')  , 'Enable', 'On');
           set(btnBrowserAccessionPtr('get')  , 'Enable', 'On');
           set(btnBrowserStudyDescPtr('get')  , 'Enable', 'On');
           set(btnBrowserSeriesDescPtr('get') , 'Enable', 'On');
           set(btnBrowserLocationPtr('get')   , 'Enable', 'On');


           if numel(gsBrowserMainWindowDisplayPtr('get')) == 0
               myquestdlg('No entries found. Please vefify the search criteria and try again.', 'No entries notice', 'Ok','Ok');
           end
        %end
    end
end

