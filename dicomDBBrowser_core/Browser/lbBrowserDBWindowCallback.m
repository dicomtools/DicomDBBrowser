function lbBrowserDBWindowCallback(~, ~)
%function lbBrowserMainWindowCallback(~, ~)
%Listbox Database Window Click Action.
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

    stDBWindow = ...
        cellstr(get(lbBrowserDBWindowPtr('get'), 'string'));      

    atDBList = browserDBList('get');                
    dOffset  = get(lbBrowserDBWindowPtr('get'), 'Value'); 

    if (dOffset > numel(stDBWindow) ) || ...
        numel(atDBList) < 1
        return;
    end

    set(lbBrowserDBWindowPtr('get'), 'enable', 'off');

    if isfolder(atDBList{dOffset}.sDBPath)

        hjFileChooser = hjBrowserFileChooserPtr('get');

        hjFileChooser.setCurrentDirectory(java.io.File(pwd));
        hjFileChooser.updateUI();
        hjFileChooser.setCurrentDirectory(java.io.File(atDBList{dOffset}.sDBPath));

        set(edtBrowserCurrentDirectoryPtr('get'), ...
            'String', string(hjFileChooser.getSelectedFolder()) ...
            );               
        
        if ispc    
           if ~contains(atDBList{dOffset}.sDBPath(1:3), '\\') && ...
              ~contains(atDBList{dOffset}.sDBPath(1:3), '//')  
                asPath = get(edtBrowserPathSelectPtr('get'), 'String');
                for jj=1:numel(asPath)
                    sPath = asPath{jj};
                    if strcmpi(atDBList{dOffset}.sDBPath(1:3), sPath(end-3:end-1))
                        set(edtBrowserPathSelectPtr('get'), 'Value', jj);
                        break;
                    end
                end
           end
        end

        browserUpdateDirectoryWindow(string(hjFileChooser.getSelectedFolder()));

    else
        browserProgressBar(1, 'Error: lbBrowserDBWindowCallback(): invalid directory name!');
        h = msgbox('Error: lbBrowserDBWindowCallback(): invalid directory name!', 'Error');                          

%                javaFrame = get(h, 'JavaFrame');
%                javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));               
    end

    set(lbBrowserDBWindowPtr('get'), 'enable', 'on');

end 

