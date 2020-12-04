function btnBrowserMenuCallback(hObject, ~)
%function btnBrowserMenuCallback(hObject, ~)
%Right Click Run Command Button Application List.
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

    figHandle = ancestor(hObject, 'figure');
    clickType = get(figHandle, 'SelectionType');

    if strcmp(clickType, 'alt')
        btnRunCommand = btnBrowserRunCommandPtr('get');
        uiRunCommand  = uicontextmenu(dlgBrowserWindowsPtr('get'));                   
        btnRunCommand.UIContextMenu = uiRunCommand;

        atAppList = browserRunAppList('get');
        for ll=1:numel(atAppList)
            uimenu(uiRunCommand,'Label', atAppList(ll).sDisplayName, 'Callback', @btnMenuRunCallback);
        end           
    end

    function btnMenuRunCallback(hObject, ~)

        atAppList = browserRunAppList('get');
        for kk=1:numel(atAppList)
            if strcmp(hObject.Label, atAppList(kk).sDisplayName)
                set(btnBrowserRunCommandPtr('get'), 'Value' , kk);
                set(btnBrowserRunCommandPtr('get'), 'String', atAppList(kk).sDisplayName);

       %         browserRunCommandCallback();
                break;
            end
        end
    end
end   