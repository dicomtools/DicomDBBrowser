function asList = getBrowserDrivesList()
%function asList = getBrowserDrivesList()
%Return the system drives list.
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

    if ispc
        asDrivesLetter = getdrives();
        
        for jj=1:numel(asDrivesLetter)
            asDrivesName{jj} = driveName(asDrivesLetter{jj});
            asList{jj} = sprintf('%s (%s)', asDrivesName{jj}, upper(asDrivesLetter{jj}));
        end
    else
        lsList = ls('/');
        txt2cell = textscan(lsList,'%s','delimiter',' ');
        txt2cell = [{filesep};txt2cell{1}(2:end)];
        txt2cell(strcmp('',txt2cell)) = [];
        asList = txt2cell;
    end
    
    function sDriveName = driveName(sLetter) 
        
        [~,msg] = system( sprintf('dir %s', sLetter) );
        cac = strsplit( msg, '\n' );
        has = contains( cac, 'Volume in drive');
        
        sDriveName = regexp( cac{has}, '(?<= is ).+$', 'match', 'once' );
        if isempty(sDriveName)
            has = contains( cac, 'Volume Serial Number is'); 
            sDriveName = regexp( cac{has}, '(?<= is ).+$', 'match', 'once' );            
        end
        
    end
end