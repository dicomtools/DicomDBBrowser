function initBrowserDcm4che3()
%function initBrowserDcm4che3()
%Initialize dcm4che lib.
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

    checkjava = which('org.dcm4che2.io.DicomInputStream');
        
    if isempty(checkjava)
        
        sRootPath = browserRootPath('get');
        libpath = sprintf('%s/lib/', sRootPath); 
        
        javaaddpath([libpath 'dcm4che-core-3.2.1.jar']);
        javaaddpath([libpath 'dcm4che-image-3.2.1.jar']);
        javaaddpath([libpath 'dcm4che-imageio-3.2.1.jar']);
        javaaddpath([libpath 'dcm4che-net-3.2.1.jar'])

        javaaddpath([libpath 'slf4j-api-1.6.1.jar']);
        javaaddpath([libpath 'slf4j-log4j12-1.6.1.jar']);
        javaaddpath([libpath 'log4j-1.2.16.jar']);
        
    end
end