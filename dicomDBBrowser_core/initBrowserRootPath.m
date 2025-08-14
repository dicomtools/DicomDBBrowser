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
    	
    if isdeployed % User is running an executable in standalone mode. 
        
        if ismac % Mac
            
            sNameOfDeployedApp = 'DICOM Database Browser'; % do not include the '.app' extension
            [~, result] = system(['top -n100 -l1 | grep ' sNameOfDeployedApp ' | awk ''{print $1}''']);
            result=strtrim(result);
            [status, result] = system(['ps xuwww -p ' result ' | tail -n1 | awk ''{print $NF}''']);
            if status==0
                diridx=strfind(result,[sNameOfDeployedApp '.app']);
                sRootDir=result(1:diridx-2);
            else
                msgbox({'realpwd not set:',result})
            end   
            
        elseif ispc % Windows       
            
            [~, result] = system('set PATH'); % Windows
            sRootDir = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
            
        else % Linux
            
            sRootDir = pwd;                                              
        end
      
        if sRootDir(end) ~= '\' || ...
           sRootDir(end) ~= '/'     
            sRootDir = [sRootDir '/'];
        end  
        
        browserRootPath('set', sRootDir);
    else
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
end