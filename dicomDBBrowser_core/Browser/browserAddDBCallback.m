function browserAddDBCallback(~, ~)
%function atAppList = browserRunAppList(sAction, atValue)
%Add a new Entry to database.xml.
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

    sDBPath = uigetdir(char(hjFileChooser.getSelectedFolder()));
    if ~(sDBPath == 0)
        sDBPath = [sDBPath '/'];

        if(~isfolder(sDBPath))              
            browserProgressBar(1, 'Error');
        else
            dScreenSize  = get(groot, 'Screensize');
            dDlgPosition = get(dlgBrowserWindowsPtr('get'), 'position');

            xSize     = dScreenSize(3) * dDlgPosition(3); 
            xPosition = dScreenSize(3) * dDlgPosition(1) + ((xSize /2)-150);

            ySize     = dScreenSize(4) * dDlgPosition(4); 
            yPosition = dScreenSize(4) * dDlgPosition(2) + ((ySize /2)-100);

            dlgDBName = ...
                dialog('Position',[xPosition yPosition 330 110],...
                       'Name'    ,'Database Name'...
                       );                               

            uiDBNameEdit = ...
                uicontrol(dlgDBName, ...
                          'Style'   , 'Edit', ...
                          'Position', [10 78 310 24], ...
                          'String'  , 'DB', ...
                          'FontSize', 10, ...
                          'Enable'  ,'on' ...
                          );    

            sDBName = sprintf('DB%d', numel(browserDBList('get')) +1);              
            set(uiDBNameEdit, 'string', sDBName)              

                uicontrol(dlgDBName,...
                          'string'  , 'Add entry to database.xml',...
                          'position', [10 51 150 20],...
                          'Callback', @addDBToXmlCallback...
                          );                                                                        

                uicontrol(dlgDBName,...
                          'String','Cancel',...
                          'Position',[224 8 100 25],...
                          'Callback', @browserCancelAddDBCallback...
                          );  

                uicontrol(dlgDBName,...
                          'String','Add',...
                          'Position',[120 8 100 25],...
                          'Callback', @browserAddDBNameCallback...
                         );

%                javaFrame = get(dlgDBName, 'JavaFrame');
%                javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
         end            

    end

    function addDBToXmlCallback(hObject, ~)
        
        sRootPath = browserRootPath('get');
        sDatabase = sprintf('%s/database.xml', sRootPath);

        xmlfile = fullfile( sDatabase );
        DOMnode = xmlread(xmlfile);

        root = DOMnode.getDocumentElement;

        displayName = DOMnode.createElement('displayName');
        textDisplay = DOMnode.createTextNode(get(uiDBNameEdit, 'String'));
        displayName.appendChild(textDisplay);
        root.appendChild(displayName);

        dbPath   = DOMnode.createElement('path');
        textPath = DOMnode.createTextNode(sDBPath);            
        dbPath.appendChild(textPath);
        root.appendChild(dbPath);

        xmlwrite(sDatabase, DOMnode);
        type(sDatabase);

        set(hObject, 'Enable', 'off');           

        browserAddDBNameCallback();

    end

    function browserCancelAddDBCallback(~, ~)
        delete(dlgDBName);  
    end 

    function browserAddDBNameCallback(~, ~)   

        hjFileChooser = hjBrowserFileChooserPtr('get');

        tDBList.sDBName = get(uiDBNameEdit, 'string');
        tDBList.sDBPath = sDBPath;

        browserDBList('add', tDBList);

        sSBWindow = '';
        atDBList = browserDBList('get');
        for i=1: numel(atDBList)
            sSBWindow = sprintf('%s%s\n', sSBWindow, atDBList{i}.sDBName);               
        end            

        set(lbBrowserDBWindowPtr('get'), 'string', sSBWindow);    
        set(lbBrowserDBWindowPtr('get'), 'value', i);    

   %     if strcmp(browserCurrentDBPath('get'), '')
            browserCurrentDBPath('set', sDBPath);
            hjFileChooser.setCurrentDirectory(java.io.File(sDBPath)); 

            set(edtBrowserCurrentDirectoryPtr('get'), 'String', sDBPath);        
            browserUpdateDirectoryWindow(sDBPath);
   %     end

        delete(dlgDBName);                     
    end

end