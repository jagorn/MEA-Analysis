function varargout = GUI_selected_time_STA(varargin)
% GUI_SELECTED_TIME_STA MATLAB code for GUI_selected_time_STA.fig
%      GUI_SELECTED_TIME_STA, by itself, creates a new GUI_SELECTED_TIME_STA or raises the existing
%      singleton*.
%
%      H = GUI_SELECTED_TIME_STA returns the handle to a new GUI_SELECTED_TIME_STA or the handle to
%      the existing singleton*.
%
%      GUI_SELECTED_TIME_STA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SELECTED_TIME_STA.M with the given input arguments.
%
%      GUI_SELECTED_TIME_STA('Property','Value',...) creates a new GUI_SELECTED_TIME_STA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_selected_time_STA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_selected_time_STA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_selected_time_STA

% Last Modified by GUIDE v2.5 31-Jan-2014 16:58:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_selected_time_STA_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_selected_time_STA_OutputFcn, ...
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


% --- Executes just before GUI_selected_time_STA is made visible.
function GUI_selected_time_STA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_selected_time_STA (see VARARGIN)

load('Index_buttons.mat');  % contains the names of the buttons for GUI_electrodes
load('Index_names.mat'); % contains the names (numbers) associated to the electrodes, used for the cell table treated.STA and plotdata.STAtime, plotdata.STAspace

handles.Index_buttons = Index_buttons;
handles.Index_names = Index_names;
handles.selection = ones(16,16); % initially, we plot all electrodes together

handles.STAtime = varargin{1}.STAtime;

axes(handles.axes1);
hold on 

for ii = 1:16
    for jj = 1:16
        if Index_buttons(ii,jj)~=0
            handles.trajs{ii,jj} = plot(0:20,handles.STAtime{handles.Index_names(ii,jj)}); %/////modify that
        end
    end 
end

set(handles.text4,'String',varargin{1}.lastsavefile);


% Choose default command line output for GUI_selected_time_STA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_selected_time_STA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_selected_time_STA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[~,selection] = GUI_electrodes(handles.Index_buttons,handles.Index_names,handles.selection);
handles.selection = selection;

aux_select_traj(handles.trajs,handles.selection);
guidata(hObject, handles);


guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
    case 'Time'

    case 'Space'
        
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function aux_select_traj(trajs,selection)
for ii = 1:16
    for jj = 1:16
        if selection(ii,jj)~=0
           set(trajs{ii,jj},'Visible','on');
        else
            set(trajs{ii,jj},'Visible','off');
        end
    end
end
