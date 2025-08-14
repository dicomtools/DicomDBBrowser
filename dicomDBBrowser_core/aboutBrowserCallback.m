function aboutBrowserCallback(~, ~)
%function aboutBrowserCallback(~, ~)
%Display About Dialog.
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

%     sRootPath = browserRootPath('get');
% 
%     sDisplayBuffer = '';
%     fFileID = fopen( sprintf('%s/about.txt', sRootPath),'r' );
%     if~(fFileID == -1)
%         tline = fgetl(fFileID);
%         while ischar(tline)
%             sDisplayBuffer = sprintf('%s%s\n', sDisplayBuffer, tline);
%             tline = fgetl(fFileID);
%         end
%         fclose(fFileID);            
% 
%         h = msgbox(sDisplayBuffer, 'About');
% 
% %            javaFrame = get(h, 'JavaFrame');
% %            javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));
% 
%      end      

    sRootPath  = browserRootPath('get');
    sAboutFile = sprintf('%s/about.txt', sRootPath);

    sDisplayBuffer = '';

    % Open the file for reading
    fFileID = fopen(sAboutFile, 'r');
    if fFileID == -1
        % If the file couldn't be opened, display a warning and exit
        warning('Could not open file: %s', sAboutFile);
        return;
    end
    
    dNbLines = 0;
    % Read the file line by line
    tline = fgetl(fFileID);
    while ischar(tline)
        % Append the line to the display buffer
        sDisplayBuffer = sprintf('%s%s\n',sDisplayBuffer, tline);  % More efficient string concatenation
        tline = fgetl(fFileID);

        dNbLines = dNbLines+1;
    end
    
    % Close the file after reading
    fclose(fFileID);

    % % Show the content in a message box
    % h = msgbox(sDisplayBuffer, 'About','help');

    xSize = 420;
    ySize = round(27*dNbLines);

    dlgAbout = ...
        uifigure('Position', [(getBrowserMainWindowPosition('xpos')+(getBrowserMainWindowSize('xsize')/2)-xSize/2) ...
                              (getBrowserMainWindowPosition('ypos')+(getBrowserMainWindowSize('ysize')/2)-ySize/2) ...
                              xSize ...
                              ySize ...
                             ],...
               'Resize'     , 'off', ...
               'Color'      , browserBackgroundColor('get'),...
               'WindowStyle', 'modal', ...
               'Name'       , 'About'...
               );

    sRootPath = browserRootPath('get');
            
    if ~isempty(sRootPath) 
                    
        dlgAbout.Icon = fullfile(sRootPath, 'logo.png');
    end

    aDlgPosition = get(dlgAbout, 'Position');

    uicontrol(dlgAbout,...
              'String','OK',...
              'Position',[(aDlgPosition(3)/2)-(75/2) 7 75 25],...
              'BackgroundColor', browserBackgroundColor('get'), ...
              'ForegroundColor', browserForegroundColor('get'), ...               
              'Callback', @okAboutCallback...
              );   

    % Display text with line breaks
    uicontrol(dlgAbout, ...
              'Style'   , 'text', ...
              'HorizontalAlignment','left', ...
              'String'  , sDisplayBuffer, ...
              'Position', [10 40 aDlgPosition(3)-20 aDlgPosition(4)-50], ... % Adjusted padding              'HorizontalAlignment', 'left', ...
              'BackgroundColor', browserBackgroundColor('get'), ...
              'ForegroundColor', browserForegroundColor('get'),...
              'FontSize', 10, ...
              'FontName', 'Arial');
    
    drawnow;

    function okAboutCallback(~, ~)

        delete(dlgAbout);
    end

end 