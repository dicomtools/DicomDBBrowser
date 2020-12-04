function lbBrowserMainWindowCallback(~, ~)
%function lbBrowserMainWindowCallback(~, ~)
%Main Window Mouse Click Selection.
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

    asMainWindow = ...
        cellstr(get(lbBrowserMainWindowPtr('get'), 'String'));    
    
    if ~isempty(asMainWindow{1})

        gadOffset = gadBrowserOffsetPtr('get');            
        adOffset  = get(lbBrowserMainWindowPtr('get'), 'Value');             

        if numel(adOffset) == 1
            
            asMain = gsBrowserMainWindowDisplayPtr('get');  

            sLine    = asMain{adOffset};
            sNewLine = sprintf('1- %s', sLine);
            asMain{adOffset} = sNewLine;

            gadOffset    = [];               
            gadOffset{1} = adOffset;

            dListboxTop = get(lbBrowserMainWindowPtr('get'), 'ListboxTop');                
            
            set(lbBrowserMainWindowPtr('get'), 'String', asMain);                
            set(lbBrowserMainWindowPtr('get'), 'ListboxTop', dListboxTop);                
        else            
            adNew = [];
            for hh=1:numel(adOffset)
                adNew{hh}.Offset = adOffset(hh);
                adNew{hh}.Flag   = false;
            end

            if numel(adNew) > numel(gadOffset)
                for jj=1:numel(adNew)
                    for kk=1:numel(gadOffset)
                        if adNew{jj}.Offset == gadOffset{kk}
                            adNew{jj}.Flag = true;
                            break;
                        end
                    end
                end

                dOffset = 2;
                for ll=1:numel(adNew)
                    if adNew{ll}.Flag == false

                        asMain = get(lbBrowserMainWindowPtr('get'), 'String');  
                        sLine  = asMain{adNew{ll}.Offset};
                        
                        if (numel(adNew) - numel(gadOffset) ) == 1
                            sNewLine = sprintf('%d- %s', numel(adNew), sLine);
                        else
                            sNewLine = sprintf('%d- %s', dOffset, sLine);
                            dOffset = dOffset+1;
                        end
                        asMain{adNew{ll}.Offset} = sNewLine;

                        dListboxTop = get(lbBrowserMainWindowPtr('get'), 'ListboxTop');                
                        set(lbBrowserMainWindowPtr('get'), 'String', asMain);  
                        set(lbBrowserMainWindowPtr('get'), 'ListboxTop', dListboxTop);                

                        gadOffset{1+numel(gadOffset)} = adNew{ll}.Offset;

                    end
                end
            else
                for bb=1:numel(gadOffset)
                    
                    bOffsetFound = false;
                    for cc=1: numel(adNew)
                        if gadOffset{bb} == adNew{cc}.Offset
                            bOffsetFound = true;
                            break;
                        end
                    end
                    
                    if bOffsetFound == false
                        gadOffset(bb)=[];
                        break;
                    end
                end
                
                asMain = gsBrowserMainWindowDisplayPtr('get');  
                for dd=1:numel(gadOffset)
                    sLine = asMain{gadOffset{dd}};
                    asMain{gadOffset{dd}} = sprintf('%d- %s', dd, sLine);
                end

                dListboxTop = get(lbBrowserMainWindowPtr('get'), 'ListboxTop');
                
                set(lbBrowserMainWindowPtr('get'), 'String', asMain);  
                set(lbBrowserMainWindowPtr('get'), 'ListboxTop', dListboxTop); 
            end
        end

        for i=1: numel(adOffset)

            sLine = asMainWindow(adOffset(i));                      
            if numel(asMainWindow) >= adOffset(i) && ...
               strlength(sLine) 

                set(btnBrowserViewHeaderPtr('get') , 'enable', 'on');
                set(btnBrowserDicomViewerPtr('get'), 'enable', 'on');
                set(btnBrowserRunCommandPtr('get') , 'enable', 'on');  
                set(btnBrowserCerrPtr('get')       , 'enable', 'on');       

                break;
            else
                set(btnBrowserViewHeaderPtr('get') , 'enable', 'off');
                set(btnBrowserDicomViewerPtr('get'), 'enable', 'off');
                set(btnBrowserRunCommandPtr('get') , 'enable', 'off');
                set(btnBrowserCerrPtr('get')       , 'enable', 'off');       
               break;
            end                               

        end

        gadBrowserOffsetPtr('set', gadOffset);

    else
        set(btnBrowserViewHeaderPtr('get') , 'enable', 'off');
        set(btnBrowserDicomViewerPtr('get'), 'enable', 'off');
        set(btnBrowserRunCommandPtr('get') , 'enable', 'off');    
        set(btnBrowserCerrPtr('get')       , 'enable', 'off');       
    end 

    if strcmp(get(dlgBrowserWindowsPtr('get'), 'selectiontype'), 'open') && ...
       ~isempty(asMainWindow{1}) % Double click
          
        dOffset = get(lbBrowserMainWindowPtr('get'), 'Value');
        
        gsBrowserMainWindowDisplay = ...
            gsBrowserMainWindowDisplayPtr('get');
        
        
        sLine = gsBrowserMainWindowDisplay{dOffset};                          
        if strlength(sLine) 

            asList   = browserDoubleClickList();
            sAppName = asList(browserDoubleClickOffset('get'));
            
            browserDoubleClickAction(sAppName);

        end
    end               

end
