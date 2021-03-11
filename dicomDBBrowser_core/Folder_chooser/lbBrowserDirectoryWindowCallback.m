function lbBrowserDirectoryWindowCallback(hObject, ~)
%function lbBrowserDirectoryWindowCallback(hObject, ~)
%Listbox Click on Directory Window ui Callback.
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

    hjFileChooser = hjBrowserFileChooserPtr('get');

    set(hObject, 'Enable', 'Off');

    sCurrentDir = get(edtBrowserCurrentDirectoryPtr('get'), 'String');

    asNewDir = get(hObject, 'String');
    dValue   = get(hObject, 'Value');

    if numel(dValue) >1         
        set(hObject, 'Enable', 'On');
        return;
    end

    if dValue > numel(asNewDir) || dValue < 1           
        set(hObject, 'Enable', 'On');
        return;
    end


    sNewDir  = char(asNewDir(dValue));

    if sCurrentDir(end) ~= '/' || ...
      sCurrentDir(end) ~= '\'
        sCurrentDir = [sCurrentDir '/'];      
    end

    asNewPath = dir(sprintf('%s%s', sCurrentDir, sNewDir));
    
    if ~isempty(asNewPath)
        sNewPath = asNewPath(1).folder;


        set(edtBrowserCurrentDirectoryPtr('get'), 'String', sNewPath);

        browserUpdateDirectoryWindow(sNewPath);

        hjFileChooser.setCurrentDirectory(java.io.File(sNewPath));
    end
    
    set(hObject, 'Enable', 'On');

end