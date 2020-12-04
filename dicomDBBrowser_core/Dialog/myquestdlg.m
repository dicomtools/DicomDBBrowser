
function ButtonName=myquestdlg(Question,Title,Btn1,Btn2,Btn3,Default)
%MYQUESTDLG Question dialog box. Same as QUESTDLG plus solves the issue that if user press ENTER
%  it will return the Default Button and not the selected one.
% See http://tdalon.blogspot.com/2016/09/matlab-bug-questdlg.html
% Moreover the dialog window is now properly centered in the middle of the screen.
% 
% SYNTAX:
%    ButtonName=myquestdlg(Question,Title,Btn1,Btn2,Btn3,Default)
% OUTPUT
%    ButtonName (char) is empty if User ESC the dialog.
%
%  ButtonName = QUESTDLG(Question) creates a modal dialog box that
%  automatically wraps the cell array or string (vector or matrix)
%  Question to fit an appropriately sized window.  The name of the
%  button that is pressed is returned in ButtonName.  The Title of
%  the figure may be specified by adding a second string argument:
%
%    ButtonName = questdlg(Question, Title)
%
%  Question will be interpreted as a normal string.
%
%  QUESTDLG uses UIWAIT to suspend execution until the user responds.
%
%  The default set of buttons names for QUESTDLG are 'Yes','No' and
%  'Cancel'.  The default answer for the above calling syntax is 'Yes'.
%  This can be changed by adding a third argument which specifies the
%  default Button:
%
%    ButtonName = questdlg(Question, Title, 'No')
%
%  Up to 3 custom button names may be specified by entering
%  the button string name(s) as additional arguments to the function
%  call.  If custom button names are entered, the default button
%  must be specified by adding an extra argument, DEFAULT, and
%  setting DEFAULT to the same string name as the button you want
%  to use as the default button:
%
%    ButtonName = questdlg(Question, Title, Btn1, Btn2, DEFAULT);
%
%  where DEFAULT is set to Btn1.  This makes Btn1 the default answer.
%  If the DEFAULT string does not match any of the button string names,
%  a warning message is displayed.
%
%  To use TeX interpretation for the Question string, a data
%  structure must be used for the last argument, i.e.
%
%    ButtonName = questdlg(Question, Title, Btn1, Btn2, OPTIONS);
%
%  The OPTIONS structure must include the fields Default and Interpreter.
%  Interpreter may be 'none' or 'tex' and Default is the default button
%  name to be used.
%
%  If the dialog is closed without a valid selection, the return value
%  is empty.
%
%  Example:
%
%  ButtonName = questdlg('What is your favorite color?', ...
%                        'Color Question', ...
%                        'Red', 'Green', 'Blue', 'Green');
%  switch ButtonName,
%    case 'Red',
%     disp('Your favorite color is Red');
%    case 'Blue',
%     disp('Your favorite color is Blue.')
%     case 'Green',
%      disp('Your favorite color is Green.');
%  end % switch
%
% See also BTNDLG, MYINPUTDLG
% See also DIALOG, ERRORDLG, HELPDLG, INPUTDLG, LISTDLG,
%    MSGBOX, WARNDLG, FIGURE, TEXTWRAP, UIWAIT, UIRESUME.
%


%  Copyright 1984-2010 The MathWorks, Inc.
%  $Revision: 1.8 $

if nargin<1
    error('MATLAB:questdlg:TooFewArguments', 'Too few arguments for QUESTDLG');
end

Interpreter='none';
Question = dialogCellstrHelper(Question);


Black      =[0       0        0      ]/255;
% LightGray  =[192     192      192    ]/255;
% LightGray2 =[160     160      164    ]/255;
% MediumGray =[128     128      128    ]/255;
% White      =[255     255      255    ]/255;


if nargout>1
    error('MATLAB:questdlg:WrongNumberOutputs', 'Wrong number of output arguments for QUESTDLG');
end
if nargin==1,Title=' ';end
if nargin<=2, Default='Yes';end
if nargin==3, Default=Btn1 ;end
if nargin<=3,
    Btn1='Yes'; Btn2='No'; Btn3='Cancel';NumButtons=3;
    BtnStrings={'Yes','No','Cancel'};
end
if nargin==4,
    BtnStrings={Btn1};
    Default=Btn2;Btn2=[];Btn3=[];NumButtons=1;
end
if nargin==5,
    BtnStrings={Btn1,Btn2};
    Default=Btn3;Btn3=[];NumButtons=2;
end
if nargin==6,
    BtnStrings={Btn1,Btn2,Btn3};
    NumButtons=3;end
if nargin>6
    error('MATLAB:questdlg:TooManyInputs', 'Too many input arguments');NumButtons=3; %#ok
end

if isstruct(Default),
    Interpreter=Default.Interpreter;
    Default=Default.Default;
end

FigPos    = get(0,'DefaultFigurePosition');
FigPos(3) = 267;
FigPos(4) =  70;
FigPos    = getnicedialoglocation(FigPos, get(0,'DefaultFigureUnits'));

figureHandle=dialog(                                    ...
    'Visible'         ,'off'                      , ...
    'Name'            ,Title                      , ...
    'Pointer'         ,'arrow'                    , ...
    'Position'        ,FigPos                     , ...
    'KeyPressFcn'     ,@cb_KeyPressFcn          , ...
    'IntegerHandle'   ,'off'                      , ...
    'WindowStyle'     ,'normal'                   , ...
    'HandleVisibility','callback'                 , ...
    'CloseRequestFcn' ,@doDelete                  , ...
    'Tag'             ,Title                        ...
    );

%javaFrame = get(figureHandle, 'JavaFrame');
%javaFrame.setFigureIcon(javax.swing.ImageIcon('./logo.png'));

DefOffset  =15;

IconWidth  =0;
IconHeight =0;
IconXOffset=DefOffset;
IconYOffset=FigPos(4)-DefOffset-IconHeight;  %#ok
IconCMap=[Black;get(figureHandle,'Color')];  %#ok

DefBtnWidth =56;
BtnHeight   =22;

BtnYOffset=DefOffset;

BtnWidth=DefBtnWidth;

ExtControl=uicontrol(figureHandle   , ...
    'Style'    ,'pushbutton', ...
    'String'   ,' '          ...
    );

btnMargin=1.4;
set(ExtControl,'String',Btn1);
BtnExtent=get(ExtControl,'Extent');
BtnWidth=max(BtnWidth,BtnExtent(3)+8);
if NumButtons > 1
    set(ExtControl,'String',Btn2);
    BtnExtent=get(ExtControl,'Extent');
    BtnWidth=max(BtnWidth,BtnExtent(3)+8);
    if NumButtons > 2
        set(ExtControl,'String',Btn3);
        BtnExtent=get(ExtControl,'Extent');
        BtnWidth=max(BtnWidth,BtnExtent(3)*btnMargin);
    end
end
BtnHeight = max(BtnHeight,BtnExtent(4)*btnMargin);

delete(ExtControl);

MsgTxtXOffset=IconXOffset+IconWidth;

FigPos(3)=max(FigPos(3),MsgTxtXOffset+NumButtons*(BtnWidth+2*DefOffset));
set(figureHandle,'Position',FigPos);

BtnXOffset=zeros(NumButtons,1);

if NumButtons==1,
    BtnXOffset=(FigPos(3)-BtnWidth)/2;
elseif NumButtons==2,
    BtnXOffset=[MsgTxtXOffset
        FigPos(3)-DefOffset-BtnWidth];
elseif NumButtons==3,
    BtnXOffset=[MsgTxtXOffset
        0
        FigPos(3)-DefOffset-BtnWidth];
    BtnXOffset(2)=(BtnXOffset(1)+BtnXOffset(3))/2;
end

MsgTxtYOffset=DefOffset+BtnYOffset+BtnHeight;
% Calculate current msg text width and height. If negative,
% clamp it to 1 since its going to be recalculated/corrected later
% based on the actual msg string
MsgTxtWidth=max(1, FigPos(3)-DefOffset-MsgTxtXOffset-IconWidth);
MsgTxtHeight=max(1, FigPos(4)-DefOffset-MsgTxtYOffset);

MsgTxtForeClr=Black;
MsgTxtBackClr=get(figureHandle,'Color');

CBString='uiresume(gcbf)';

BtnHandle = cell(NumButtons, 1);

% Check to see if the Default string passed does match one of the
% strings on the buttons in the dialog. If not, throw a warning.
for i = 1:NumButtons

    BtnHandle{i}=uicontrol(figureHandle            , ...
        'Style'              ,'pushbutton', ...
        'Position'           ,[ BtnXOffset(1) BtnYOffset BtnWidth BtnHeight ]           , ...
        'KeyPressFcn'        ,@cb_KeyPressFcn , ...
        'Callback'           ,CBString    , ...
        'String'             ,eval(['Btn',num2str(i)]), ...
        'HorizontalAlignment','center'    , ...
        'Tag'                ,['Btn',num2str(i)]     ...
        );
end

[tf]=strcmp(Default,BtnStrings);
DefaultValid=any(tf);
if ~DefaultValid
    %warnstate = warning('backtrace','off');
    warning('AVLab:MYQUESTDLG:stringMismatch','Default string does not match any button string name.');
    %warning(warnstate);
end
DefaultButton=find(tf);


MsgHandle=uicontrol(figureHandle            , ...
    'Style'              ,'text'         , ...
    'Position'           ,[MsgTxtXOffset MsgTxtYOffset 0.95*MsgTxtWidth MsgTxtHeight ]              , ...
    'String'             ,{' '}          , ...
    'Tag'                ,'Question'     , ...
    'HorizontalAlignment','left'         , ...
    'FontWeight'         ,'bold'         , ...
    'BackgroundColor'    ,MsgTxtBackClr  , ...
    'ForegroundColor'    ,MsgTxtForeClr    ...
    );

[WrapString,NewMsgTxtPos]=textwrap(MsgHandle,Question,75);

% NumLines=size(WrapString,1);

AxesHandle=axes('Parent',figureHandle,'Position',[0 0 1 1],'Visible','off');

texthandle=text( ...
    'Parent'              ,AxesHandle                      , ...
    'Units'               ,'pixels'                        , ...
    'Color'               ,get(BtnHandle{1},'ForegroundColor')   , ...
    'HorizontalAlignment' ,'left'                          , ...
    'FontName'            ,get(BtnHandle{1},'FontName')    , ...
    'FontSize'            ,get(BtnHandle{1},'FontSize')    , ...
    'VerticalAlignment'   ,'bottom'                        , ...
    'String'              ,WrapString                      , ...
    'Interpreter'         ,Interpreter                     , ...
    'Tag'                 ,'Question'                        ...
    );

textExtent = get(texthandle, 'Extent');

% (g357851)textExtent and extent from uicontrol are not the same. For window, extent from uicontrol is larger
%than textExtent. But on Mac, it is reverse. Pick the max value.
MsgTxtWidth=max([MsgTxtWidth NewMsgTxtPos(3)+2 textExtent(3)]);
MsgTxtHeight=max([MsgTxtHeight NewMsgTxtPos(4)+2 textExtent(4)]);

MsgTxtXOffset=IconXOffset+IconWidth+DefOffset;
FigPos(3)=max(NumButtons*(BtnWidth+DefOffset)+DefOffset, ...
    MsgTxtXOffset+MsgTxtWidth+DefOffset);


% Center Vertically around icon
if IconHeight>MsgTxtHeight,
    IconYOffset=BtnYOffset+BtnHeight+DefOffset;
    MsgTxtYOffset=IconYOffset+(IconHeight-MsgTxtHeight)/2;
    FigPos(4)=IconYOffset+IconHeight+DefOffset;
    % center around text
else
    MsgTxtYOffset=BtnYOffset+BtnHeight+DefOffset;
    IconYOffset=MsgTxtYOffset+(MsgTxtHeight-IconHeight)/2;
    FigPos(4)=MsgTxtYOffset+MsgTxtHeight+DefOffset;
end

if NumButtons==1,
    BtnXOffset=(FigPos(3)-BtnWidth)/2;
elseif NumButtons==2,
    BtnXOffset=[(FigPos(3)-DefOffset)/2-BtnWidth
        (FigPos(3)+DefOffset)/2
        ];

elseif NumButtons==3,
    BtnXOffset(2)=(FigPos(3)-BtnWidth)/2;
    BtnXOffset=[BtnXOffset(2)-DefOffset-BtnWidth
        BtnXOffset(2)
        BtnXOffset(2)+BtnWidth+DefOffset
        ];
end

set(figureHandle ,'Position',getnicedialoglocation(FigPos, get(figureHandle,'Units')));
assert(iscell(BtnHandle));
BtnPos=cellfun(@(bh)get(bh,'Position'), BtnHandle, 'UniformOutput', false);
BtnPos=cat(1,BtnPos{:});
BtnPos(:,1)=BtnXOffset;
BtnPos=num2cell(BtnPos,2);

assert(iscell(BtnPos));
cellfun(@(bh,pos)set(bh, 'Position', pos), BtnHandle, BtnPos, 'UniformOutput', false);

if DefaultValid
    setdefaultbutton(figureHandle, BtnHandle{DefaultButton});
end

delete(MsgHandle);


set(texthandle, 'Position',[MsgTxtXOffset MsgTxtYOffset 0]);


IconAxes=axes(                                      ...
    'Parent'      ,figureHandle              , ...
    'Units'       ,'Pixels'              , ...
    'Position'    ,[IconXOffset IconYOffset-50 IconWidth IconHeight], ...
    'NextPlot'    ,'replace'             , ...
    'Tag'         ,'IconAxes'              ...
    );

set(figureHandle ,'NextPlot','add');

%load dialogicons.mat questIconData questIconMap;
%IconData=questIconData;
%questIconMap(256,:)=get(figureHandle,'Color');
%IconCMap=questIconMap;

load dialogicons.mat questIconData questIconMap;
IconData=questIconData;
questIconMap(256,:)=get(figureHandle,'Color');
IconCMap=questIconMap;

Img=image('CData',IconData,'Parent',IconAxes);
set(figureHandle, 'Colormap', IconCMap);
set(IconAxes, ...
    'Visible','off'           , ...
    'YDir'   ,'reverse'       , ...
    'XLim'   ,get(Img,'XData'), ...
    'YLim'   ,get(Img,'YData')  ...
    );

% make sure we are on screen
movegui(figureHandle,'center') % TD


set(figureHandle ,'WindowStyle','modal','Visible','on');
drawnow;

if DefaultButton ~= 0
    uicontrol(BtnHandle{DefaultButton});
end

if ishghandle(figureHandle)
    % Go into uiwait if the figure handle is still valid.
    % This is mostly the case during regular use.
    uiwait(figureHandle);
    drawnow % TD
end

% Check handle validity again since we may be out of uiwait because the
% figure was deleted.
if ishghandle(figureHandle)
    ButtonName=getappdata(figureHandle,'ButtonName');
    if isempty(ButtonName), % no KeyPress/ MouseClick,
        ButtonName=get(get(figureHandle,'CurrentObject'),'String');
    end
    doDelete;
else
    ButtonName='';
end

%% Callback functions
    function doDelete(varargin)
        delete(figureHandle);
    end

    function cb_KeyPressFcn(obj,evd) % TD
        switch(evd.Key)
            case {'return','space'} % TD
                ButtonName=get(get(figureHandle,'CurrentObject'),'String');
                setappdata(figureHandle,'ButtonName',ButtonName);
                uiresume(gcbf);
            case 'escape'
                doDelete
        end
    end
end



%% SUBFUNCTION UITOOLS/PRIVATE
function figure_size = getnicedialoglocation(figure_size, figure_units)
% copy of private function <matlab install>\toolbox\matlab\uitools\private\getnicedialoglocation.m
parentHandle = gcbf;
propName = 'Position';
if isempty(parentHandle)
    parentHandle = 0;
    propName = 'ScreenSize';
end

old_u = get(parentHandle,'Units');
set(parentHandle,'Units',figure_units);
container_size=get(parentHandle,propName);
set(parentHandle,'Units',old_u);

figure_size(1) = container_size(1)  + 1/2*(container_size(3) - figure_size(3));
figure_size(2) = container_size(2)  + 2/3*(container_size(4) - figure_size(4));

end % private/getnicedialoglocation

function setdefaultbutton(figHandle, btnHandle)
% WARNING: This feature is not supported in MATLAB and the API and
% functionality may change in a future release.

%SETDEFAULTBUTTON Set default button for a figure.
%  SETDEFAULTBUTTON(BTNHANDLE) sets the button passed in to be the default button
%  (the button and callback used when the user hits "enter" or "return"
%  when in a dialog box.
%
%  This function is used by inputdlg.m, msgbox.m, questdlg.m and
%  uigetpref.m.
%
%  Example:
%
%  f = figure;
%  b1 = uicontrol('style', 'pushbutton', 'string', 'first', ...
%       'position', [100 100 50 20]);
%  b2 = uicontrol('style', 'pushbutton', 'string', 'second', ...
%       'position', [200 100 50 20]);
%  b3 = uicontrol('style', 'pushbutton', 'string', 'third', ...
%       'position', [300 100 50 20]);
%  setdefaultbutton(b2);
%

%  Copyright 2005-2007 The MathWorks, Inc.

%--------------------------------------- NOTE ------------------------------------------
% This file was copied into matlab/toolbox/local/private.
% These two files should be kept in sync - when editing please make sure
% that *both* files are modified.

% Nargin Check
if nargin<1, error('MATLAB:setdefaultbutton:InvalidNumberOfArguments','Too few arguments for setdefaultbutton'); end
if nargin>2, error('MATLAB:setdefaultbutton:InvalidNumberOfArguments','Too many arguments for setdefaultbutton'); end

if (usejava('awt') == 1)
    % We are running with Java Figures
    useJavaDefaultButton(figHandle, btnHandle)
else
    % We are running with Native Figures
    useHGDefaultButton(figHandle, btnHandle);
end

    function useJavaDefaultButton(figH, btnH)
        % Get a UDD handle for the figure.
        fh = handle(figH);
        % Call the setDefaultButton method on the figure handle
        fh.setDefaultButton(btnH);
    end

    function useHGDefaultButton(figHandle, btnHandle)
        % First get the position of the button.
        btnPos = getpixelposition(btnHandle);

        % Next calculate offsets.
        leftOffset   = btnPos(1) - 1;
        bottomOffset = btnPos(2) - 2;
        widthOffset  = btnPos(3) + 3;
        heightOffset = btnPos(4) + 3;

        % Create the default button look with a uipanel.
        % Use black border color even on Mac or Windows-XP (XP scheme) since
        % this is in natve figures which uses the Win2K style buttons on Windows
        % and Motif buttons on the Mac.
        h1 = uipanel(get(btnHandle, 'Parent'), 'HighlightColor', 'black', ...
            'BorderType', 'etchedout', 'units', 'pixels', ...
            'Position', [leftOffset bottomOffset widthOffset heightOffset]);

        % Make sure it is stacked on the bottom.
        uistack(h1, 'bottom');
    end
end

function outStr = dialogCellstrHelper (inputStr)
%   Copyright 2010-2011 The MathWorks, Inc.

% Helper used by MSGBOX, ERRORDLG, WARNDLG, QUESTDLG to parse the input
% string vector, matrix or cell array or strings.
% This works similar to the CELLSTR function but does not use deblank, like
% cellstr, to eliminate any trailing white spaces.

% Validate input string type.
validateattributes(inputStr, {'char','cell'}, {'2d'},mfilename);

% Convert to cell array of strings without eliminating any user input.
if ~iscell(inputStr)
    inputCell = {};
    for siz = 1:size(inputStr,1)
        inputCell{siz} =inputStr(siz,:); %#ok<AGROW>
    end
    outStr = inputCell;
else
    outStr = inputStr;
end
end