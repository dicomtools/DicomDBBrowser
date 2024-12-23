function browserUpdateDirectoryWindow(sDir)
%function browserUpdateDirectoryWindow(sDir)
%Update Directory Listbox Window.
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

%    aList = '';
%    aDirList = dir(sDir);
%    for ii=1:numel(aDirList)
%        if aDirList(ii).isdir && ~strcmpi(aDirList(ii).name, '.')
%            aList{numel(aList)+1} = aDirList(ii).name;
%        end
%    end

  %  set(lbBrowserDirectoryWindowPtr('get'), 'String', aList);
  %  set(lbBrowserDirectoryWindowPtr('get'), 'Value' , 1);

    hjFileChooser = hjBrowserFileChooserPtr('get');

    hjFileChooser.setCurrentDirectory(java.io.File(sDir))


end