function initBrowserRootPath()
%function initBrowserRootPath()
%Initialize Browser Root path.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2020, Daniel Lafontaine, on behalf of the TriDFusion development team.
% 
% This file is part of The Triple Dimention Fusion (TriDFusion).
% 
% DicomDBBrowser development has been led by:  Daniel Lafontaine
% 
% DicomDBBrowser is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of TriDFusion is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% DicomDBBrowser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with TriDFusion.  If not, see <http://www.gnu.org/licenses/>.  

    browserRootPath('set', '');
             
    sRootDir = pwd;
    if sRootDir(end) ~= '\' || ...
       sRootDir(end) ~= '/'     
        sRootDir = [sRootDir '/'];
    end   
        
    if isfile(sprintf('%sdisclamer.txt', sRootDir))
        browserRootPath('set', sRootDir);
    else 
        sRootDir = fileparts(mfilename('fullpath'));
        sRootDir = erase(sRootDir, 'dicomDBBrowser_core');        

        if isfile(sprintf('%sdisclamer.txt', sRootDir))
            browserRootPath('set', sRootDir);
        end
    end    
end