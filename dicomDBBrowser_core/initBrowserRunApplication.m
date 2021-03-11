function initBrowserRunApplication()
%function initBrowserDatabase()
%Init Browser Applications List from application.xml.
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

    sRootPath = browserRootPath('get');

    tXMLList = browser_xml2struct( sprintf('%s/application.xml', sRootPath) );
    if ~isfield(tXMLList, 'dicomDBBrowserProtocol')
        return;
    end

    sAppList = '';

    if isfield(tXMLList.dicomDBBrowserProtocol, 'displayName') && ...
       isfield(tXMLList.dicomDBBrowserProtocol, 'command')     && ...
       isfield(tXMLList.dicomDBBrowserProtocol, 'argument')

        iNbElement = numel(tXMLList.dicomDBBrowserProtocol.displayName);

        for i=1:iNbElement
            if iNbElement == 1
                atAppList(i).sDisplayName = char( struct2cell(tXMLList.dicomDBBrowserProtocol.displayName) ) ;
                atAppList(i).sCommand     = char( struct2cell(tXMLList.dicomDBBrowserProtocol.command    ) );
                atAppList(i).sArgument    = char( struct2cell(tXMLList.dicomDBBrowserProtocol.argument   ) );
            else
                atAppList(i).sDisplayName = char( struct2cell(tXMLList.dicomDBBrowserProtocol.displayName{i}) ) ;
                atAppList(i).sCommand     = char( struct2cell(tXMLList.dicomDBBrowserProtocol.command{i}    ) );
                atAppList(i).sArgument    = char( struct2cell(tXMLList.dicomDBBrowserProtocol.argument{i}   ) );
            end

            if i == 1
                sAppList = sprintf('%s%s'  ,  sAppList, atAppList(i).sDisplayName);
            else
                sAppList = sprintf('%s\n%s',  sAppList, atAppList(i).sDisplayName);
            end
        end
    end

    if numel(sAppList)
        
%        set(btnBrowserRunCommandPtr('get'), 'Value' , 1);
        set(btnBrowserRunCommandPtr('get'), 'String', atAppList(1).sDisplayName);

        browserRunAppList('set', atAppList);
    end
end
