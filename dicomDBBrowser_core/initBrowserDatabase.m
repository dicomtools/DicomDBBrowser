function initBrowserDatabase()
%function initBrowserDatabase()
%Init Browser Database List from database.xml.
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

    tXMLList = browser_xml2struct('./database.xml');
    if ~isfield(tXMLList, 'dicomDBBrowserProtocol')
        return;
    end

    hjFileChooser = hjBrowserFileChooserPtr('get');

    sDBPath = '';
    sDBList = '';

    if isfield(tXMLList.dicomDBBrowserProtocol, 'displayName') && ...
       isfield(tXMLList.dicomDBBrowserProtocol, 'path')

        iNbElement = numel(tXMLList.dicomDBBrowserProtocol.displayName);

        for i=1:iNbElement

            if iNbElement == 1
                tDBList.sDBName = char( struct2cell(tXMLList.dicomDBBrowserProtocol.displayName) );
                tDBList.sDBPath = char( struct2cell(tXMLList.dicomDBBrowserProtocol.path       ) );
            else
                tDBList.sDBName = char( struct2cell(tXMLList.dicomDBBrowserProtocol.displayName{i}) );
                tDBList.sDBPath = char( struct2cell(tXMLList.dicomDBBrowserProtocol.path{i}       ) );
            end

            browserDBList('add', tDBList);

            if i == 1
                sDBPath = tDBList.sDBPath;
                sDBList = sprintf('%s%s'  ,  sDBList, tDBList.sDBName);
            else
                sDBList = sprintf('%s\n%s',  sDBList, tDBList.sDBName);
            end

        end
    end

    if numel(sDBList)

        set(lbBrowserDBWindowPtr('get'), 'String', sDBList);

        if strcmp(browserCurrentDBPath('get'), '')
            if contains(sDBPath(1:3), '//') || ...
                contains(sDBPath(1:3), '\\')

%                    answer = myquestdlg('Network path detected, the system can hang for a minute, please mount the drive to your computer to avoid this.', 'Warning', 'Continue','Return','Continue');
%                    switch answer
%                        case 'Continue'
                        browserCurrentDBPath('set', sDBPath);
                        hjFileChooser.setCurrentDirectory(java.io.File(sDBPath));
                        set(edtBrowserCurrentDirectoryPtr('get'), 'String', sDBPath);

                        browserUpdateDirectoryWindow(sDBPath);
%                         case 'Return'
                      %  return;
%                    end
            else
                browserCurrentDBPath('set', sDBPath);
                hjFileChooser.setCurrentDirectory(java.io.File(sDBPath));
                set(edtBrowserCurrentDirectoryPtr('get'), 'String', sDBPath);

                if ispc
                    asPath = get(edtBrowserPathSelectPtr('get'), 'String');
                    for jj=1:numel(asPath)
                        sPath = asPath{jj};
                        if strcmpi(sDBPath(1:3), sPath(end-3:end-1))
                            set(edtBrowserPathSelectPtr('get'), 'Value', jj);
                            break;
                        end
                    end
                end
                browserUpdateDirectoryWindow(sDBPath);
            end

        end
    else

        asPath = get(edtBrowserPathSelectPtr('get'), 'String');
        dValue = get(edtBrowserPathSelectPtr('get'), 'Value' );
        sDBPath = char(asPath(dValue));

        browserCurrentDBPath('set', sDBPath);
        hjFileChooser.setCurrentDirectory(java.io.File(sDBPath));
        set(edtBrowserCurrentDirectoryPtr('get'), 'String', sDBPath);

        browserUpdateDirectoryWindow(sDBPath);
    end
end
