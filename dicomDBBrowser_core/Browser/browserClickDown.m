function browserClickDown(~, ~)
%function browserClickDown(~, ~) 
%Main Window Listbox Mouse Action.
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

    if strcmp( get(dlgBrowserWindowsPtr('get'), 'selectiontype'), 'alt' )

        gadOffset = gadBrowserOffsetPtr('get');

        bDispayMenu = false;

        asMainWindow = gsBrowserMainWindowDisplayPtr('get');  
        for i=1: numel(gadOffset)
            if numel(asMainWindow) >= gadOffset{i} 
                
                gsBrowserMainWindowDisplay = ...
                    gsBrowserMainWindowDisplayPtr('get');
                
                sLine = gsBrowserMainWindowDisplay{gadOffset{i}};    
                if strlength(sLine) 
                    bDispayMenu = true;
                end
            end    
        end

        if bDispayMenu == true
            
            c = uicontextmenu(dlgBrowserWindowsPtr('get'));   
            
            lbMainWindow = lbBrowserMainWindowPtr('get');
            lbMainWindow.UIContextMenu = c;

            uimenu(c, ...
                   'Label'   , 'View Header', ...
                   'Callback',@browserViewHeaderCallback ...
                   );                
               
            uimenu(c, ...
                   'Label'   , 'TriDFusion', ...
                   'Callback',@browserDicomViewerCallback ...
                   );                
               
            uimenu(c, ...
                   'Label'   , 'CERR', ...
                   'Callback',@browserCerrCallbak ...
                   ); 
               
            atAppList = browserRunAppList('get');
            for ll=1:numel(atAppList)
                if ll == 1
                    uimenu(c, ...
                           'Label'    , atAppList(ll).sDisplayName, ...
                           'Separator', 'on', ...
                           'Callback' , @browserMenubrowserRunCommandCallback ...
                           );                                        
                else
                    uimenu(c, ...
                           'Label'   , atAppList(ll).sDisplayName, ...
                           'Callback', @browserMenubrowserRunCommandCallback ...
                           );                                        
                end
            end

            uimenu(c, ...
                   'Label'    , 'Open Containing Folder', ...
                   'Separator', 'on', ...
                   'Callback' , @browserLinkToImagesCallback ...
                   );                
               
            uimenu(c, ...
                   'Label'   , 'Export Anonymize', ...
                   'Callback', @browserDicomAnonymizerCallback ...
                   );                
        end
    end

    function browserMenubrowserRunCommandCallback(hObject,~)

        atAppList = browserRunAppList('get');
        for kk=1:numel(atAppList)
            if strcmp(hObject.Label, atAppList(kk).sDisplayName)

                set(btnBrowserRunCommandPtr('get'), 'Value' , kk);
                set(btnBrowserRunCommandPtr('get'), 'String', atAppList(kk).sDisplayName);

                browserRunCommandCallback();
                break;
            end
        end
    end
end
