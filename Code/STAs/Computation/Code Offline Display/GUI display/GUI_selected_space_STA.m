function varargout = GUI_selected_space_STA(varargin)
% GUI_SELECTED_SPACE_STA MATLAB code for GUI_selected_space_STA.fig
%      GUI_SELECTED_SPACE_STA, by itself, creates a new GUI_SELECTED_SPACE_STA or raises the existing
%      singleton*.
%
%      H = GUI_SELECTED_SPACE_STA returns the handle to a new GUI_SELECTED_SPACE_STA or the handle to
%      the existing singleton*.
%
%      GUI_SELECTED_SPACE_STA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SELECTED_SPACE_STA.M with the given input arguments.
%
%      GUI_SELECTED_SPACE_STA('Property','Value',...) creates a new GUI_SELECTED_SPACE_STA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_selected_space_STA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_selected_space_STA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_selected_space_STA

% Last Modified by GUIDE v2.5 31-Jan-2014 16:57:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_selected_space_STA_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_selected_space_STA_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end


% --- Executes just before GUI_selected_space_STA is made visible.
function GUI_selected_space_STA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_selected_space_STA (see VARARGIN)

load('Index_buttons.mat');  % contains the names of the buttons for GUI_electrodes
load('Index_names.mat'); % contains the names (numbers) associated to the electrodes, used for the cell table treated.STA and plotdata.STAtime, plotdata.STAspace

handles.Index_buttons = Index_buttons;
handles.Index_names = Index_names;
handles.selection = ones(16,16); % initially, we plot all electrodes together

handles.STAspace = varargin{1}.STAspace;
set(handles.text4,'String',varargin{1}.lastsavefile);

handles.disp_mat = zeros(20,20);

for ii = 1:16
    for jj = 1:16
        if Index_buttons(ii,jj)~=0
            handles.disp_mat = handles.disp_mat + abs(handles.STAspace{handles.Index_names(ii,jj)});
        end
    end
end

axes(handles.axes1);

colormap Jet
imagesc(handles.disp_mat);
set(gca, 'XTick', []);
set(gca, 'YTick', []);

% Choose default command line output for GUI_selected_space_STA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_selected_space_STA wait for user response (see UIRESUME)
%uiwait(handles.figure1);

end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_selected_space_STA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[~,selection] = GUI_electrodes(handles.Index_buttons,handles.Index_names,handles.selection);
handles.selection = selection;
guidata(hObject, handles);

aux_plot(hObject,handles);
guidata(hObject, handles);

end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

guidata(hObject, handles);

aux_plot(hObject,handles);
guidata(hObject, handles);

end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function aux_plot(hObject,handles)
handles.disp_mat = zeros(20,20);

val = get(handles.popupmenu1,'Value');
str = get(handles.popupmenu1, 'String');
    
%fprintf(str{val});

if strcmp(str{val},'Sum')
    for ii = 1:16
        for jj = 1:16
            if handles.selection(ii,jj)*handles.Index_buttons(ii,jj)~=0
                if handles.Index_names(ii,jj)==1
                    fprintf('found \n');
                end
                handles.disp_mat = handles.disp_mat + handles.STAspace{handles.Index_names(ii,jj)};
            end
        end
    end
    fprintf('with sum \n');
else
    for ii = 1:16
        for jj = 1:16
            if handles.selection(ii,jj)*handles.Index_buttons(ii,jj)~=0
                %handles.disp_mat = handles.disp_mat + abs(handles.STAspace{handles.Index_names(ii,jj)});
                handles.disp_mat = handles.disp_mat + handles.STAspace{handles.Index_names(ii,jj)};
            end
        end
    end
    fprintf('with abs sum \n');
end

%fprintf('%d ,',handles.STAspace{1});
%fprintf('\n');

axes(handles.axes1);
imagesc(handles.disp_mat);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
fprintf('%d ,',handles.disp_mat);
fprintf('\n');
guidata(hObject, handles);
end
