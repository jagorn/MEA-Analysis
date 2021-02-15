function varargout = GUI_electrodes(varargin)
% GUI_ELECTRODES MATLAB code for GUI_electrodes.fig
%      GUI_ELECTRODES, by itself, creates a new GUI_ELECTRODES or raises the existing
%      singleton*.
%
%      H = GUI_ELECTRODES returns the handle to a new GUI_ELECTRODES or the handle to
%      the existing singleton*.
%
%      GUI_ELECTRODES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ELECTRODES.M with the given input arguments.
%
%      GUI_ELECTRODES('Property','Value',...) creates a new GUI_ELECTRODES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_electrodes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_electrodes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_electrodes

% Last Modified by GUIDE v2.5 29-Jan-2014 20:41:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_electrodes_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_electrodes_OutputFcn, ...
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


% --- Executes just before GUI_electrodes is made visible.
function GUI_electrodes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_electrodes (see VARARGIN)

handles.button_names = varargin{1};
handles.electrode_names = varargin{2};
handles.initial_selection = varargin{3};

handles.selection = zeros(size(handles.electrode_names));

for ii = 1:16
    for jj = 1:16
        if handles.initial_selection(ii,jj)*handles.button_names(ii,jj)~=0            
            eval(['set(handles.togglebutton' int2str(handles.button_names(ii,jj)) ',''Value'',1);']);
        end
    end
end

for ii = 1:16
    for jj = 1:16
        if handles.button_names(ii,jj)~=0            
            eval(['set(handles.togglebutton' int2str(handles.button_names(ii,jj)) ',''String'',int2str(handles.electrode_names(ii,jj)));']);
        end
    end
end



handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes GUI_electrodes wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_electrodes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

for ii = 1:16
    for jj = 1:16
        if handles.button_names(ii,jj)~=0            
            eval(['if get(handles.togglebutton' int2str(handles.button_names(ii,jj)) ',''Value'') == 1, handles.selection(ii,jj) = 1; end']);
        end
    end
end


varargout{1} = handles.output;
varargout{2} = handles.selection;

delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for ii = 1:16
    for jj = 1:16
        if handles.button_names(ii,jj)~=0            
            eval(['set(handles.togglebutton' int2str(handles.button_names(ii,jj)) ',''Value'',1);']);
        end
    end
end

guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for ii = 1:16
    for jj = 1:16
        if handles.button_names(ii,jj)~=0            
            eval(['set(handles.togglebutton' int2str(handles.button_names(ii,jj)) ',''Value'',0);']);
        end
    end
end

guidata(hObject, handles);


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton4


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton6


% --- Executes on button press in togglebutton7.
function togglebutton7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton7


% --- Executes on button press in togglebutton8.
function togglebutton8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton8


% --- Executes on button press in togglebutton13.
function togglebutton13_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton13


% --- Executes on button press in togglebutton14.
function togglebutton14_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton14


% --- Executes on button press in togglebutton15.
function togglebutton15_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton15


% --- Executes on button press in togglebutton16.
function togglebutton16_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton16


% --- Executes on button press in togglebutton25.
function togglebutton25_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton25


% --- Executes on button press in togglebutton26.
function togglebutton26_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton26


% --- Executes on button press in togglebutton27.
function togglebutton27_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton27


% --- Executes on button press in togglebutton28.
function togglebutton28_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton28


% --- Executes on button press in togglebutton141.
function togglebutton141_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton141 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton141


% --- Executes on button press in togglebutton142.
function togglebutton142_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton142 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton142


% --- Executes on button press in togglebutton143.
function togglebutton143_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton143 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton143


% --- Executes on button press in togglebutton144.
function togglebutton144_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton144 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton144


% --- Executes on button press in togglebutton145.
function togglebutton145_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton145 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton145


% --- Executes on button press in togglebutton146.
function togglebutton146_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton146 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton146


% --- Executes on button press in togglebutton147.
function togglebutton147_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton147 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton147


% --- Executes on button press in togglebutton148.
function togglebutton148_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton148 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton148


% --- Executes on button press in togglebutton149.
function togglebutton149_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton149 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton149


% --- Executes on button press in togglebutton150.
function togglebutton150_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton150 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton150


% --- Executes on button press in togglebutton151.
function togglebutton151_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton151 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton151


% --- Executes on button press in togglebutton152.
function togglebutton152_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton152 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton152


% --- Executes on button press in togglebutton153.
function togglebutton153_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton153 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton153


% --- Executes on button press in togglebutton154.
function togglebutton154_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton154 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton154


% --- Executes on button press in togglebutton155.
function togglebutton155_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton155 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton155


% --- Executes on button press in togglebutton170.
function togglebutton170_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton170 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton170


% --- Executes on button press in togglebutton171.
function togglebutton171_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton171 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton171


% --- Executes on button press in togglebutton172.
function togglebutton172_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton172 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton172


% --- Executes on button press in togglebutton173.
function togglebutton173_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton173 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton173


% --- Executes on button press in togglebutton174.
function togglebutton174_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton174 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton174


% --- Executes on button press in togglebutton175.
function togglebutton175_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton175 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton175


% --- Executes on button press in togglebutton176.
function togglebutton176_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton176 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton176


% --- Executes on button press in togglebutton177.
function togglebutton177_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton177 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton177


% --- Executes on button press in togglebutton178.
function togglebutton178_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton178 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton178


% --- Executes on button press in togglebutton179.
function togglebutton179_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton179 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton179


% --- Executes on button press in togglebutton180.
function togglebutton180_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton180 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton180


% --- Executes on button press in togglebutton181.
function togglebutton181_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton181 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton181


% --- Executes on button press in togglebutton182.
function togglebutton182_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton182 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton182


% --- Executes on button press in togglebutton183.
function togglebutton183_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton183 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton183


% --- Executes on button press in togglebutton184.
function togglebutton184_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton184 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton184


% --- Executes on button press in togglebutton187.
function togglebutton187_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton187 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton187


% --- Executes on button press in togglebutton188.
function togglebutton188_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton188 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton188


% --- Executes on button press in togglebutton189.
function togglebutton189_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton189 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton189


% --- Executes on button press in togglebutton190.
function togglebutton190_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton190 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton190


% --- Executes on button press in togglebutton191.
function togglebutton191_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton191 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton191


% --- Executes on button press in togglebutton192.
function togglebutton192_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton192 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton192


% --- Executes on button press in togglebutton193.
function togglebutton193_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton193 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton193


% --- Executes on button press in togglebutton194.
function togglebutton194_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton194 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton194


% --- Executes on button press in togglebutton195.
function togglebutton195_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton195 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton195


% --- Executes on button press in togglebutton196.
function togglebutton196_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton196 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton196


% --- Executes on button press in togglebutton197.
function togglebutton197_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton197 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton197


% --- Executes on button press in togglebutton198.
function togglebutton198_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton198 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton198


% --- Executes on button press in togglebutton199.
function togglebutton199_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton199 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton199


% --- Executes on button press in togglebutton200.
function togglebutton200_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton200


% --- Executes on button press in togglebutton201.
function togglebutton201_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton201 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton201


% --- Executes on button press in togglebutton202.
function togglebutton202_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton202 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton202


% --- Executes on button press in togglebutton203.
function togglebutton203_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton203 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton203


% --- Executes on button press in togglebutton204.
function togglebutton204_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton204 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton204


% --- Executes on button press in togglebutton205.
function togglebutton205_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton205 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton205


% --- Executes on button press in togglebutton206.
function togglebutton206_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton206 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton206


% --- Executes on button press in togglebutton207.
function togglebutton207_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton207 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton207


% --- Executes on button press in togglebutton208.
function togglebutton208_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton208 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton208


% --- Executes on button press in togglebutton209.
function togglebutton209_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton209 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton209


% --- Executes on button press in togglebutton210.
function togglebutton210_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton210 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton210


% --- Executes on button press in togglebutton211.
function togglebutton211_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton211 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton211


% --- Executes on button press in togglebutton212.
function togglebutton212_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton212 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton212


% --- Executes on button press in togglebutton213.
function togglebutton213_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton213 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton213


% --- Executes on button press in togglebutton214.
function togglebutton214_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton214 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton214


% --- Executes on button press in togglebutton215.
function togglebutton215_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton215 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton215


% --- Executes on button press in togglebutton216.
function togglebutton216_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton216 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton216


% --- Executes on button press in togglebutton217.
function togglebutton217_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton217 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton217


% --- Executes on button press in togglebutton218.
function togglebutton218_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton218 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton218


% --- Executes on button press in togglebutton219.
function togglebutton219_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton219 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton219


% --- Executes on button press in togglebutton220.
function togglebutton220_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton220 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton220


% --- Executes on button press in togglebutton221.
function togglebutton221_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton221 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton221


% --- Executes on button press in togglebutton222.
function togglebutton222_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton222 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton222


% --- Executes on button press in togglebutton223.
function togglebutton223_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton223 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton223


% --- Executes on button press in togglebutton224.
function togglebutton224_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton224 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton224


% --- Executes on button press in togglebutton225.
function togglebutton225_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton225 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton225


% --- Executes on button press in togglebutton226.
function togglebutton226_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton226 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton226


% --- Executes on button press in togglebutton227.
function togglebutton227_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton227 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton227


% --- Executes on button press in togglebutton228.
function togglebutton228_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton228 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton228


% --- Executes on button press in togglebutton229.
function togglebutton229_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton229 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton229


% --- Executes on button press in togglebutton230.
function togglebutton230_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton230 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton230


% --- Executes on button press in togglebutton231.
function togglebutton231_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton231 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton231


% --- Executes on button press in togglebutton232.
function togglebutton232_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton232 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton232


% --- Executes on button press in togglebutton233.
function togglebutton233_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton233 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton233


% --- Executes on button press in togglebutton234.
function togglebutton234_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton234 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton234


% --- Executes on button press in togglebutton235.
function togglebutton235_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton235 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton235


% --- Executes on button press in togglebutton236.
function togglebutton236_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton236 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton236


% --- Executes on button press in togglebutton237.
function togglebutton237_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton237 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton237


% --- Executes on button press in togglebutton238.
function togglebutton238_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton238 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton238


% --- Executes on button press in togglebutton239.
function togglebutton239_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton239 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton239


% --- Executes on button press in togglebutton240.
function togglebutton240_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton240 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton240


% --- Executes on button press in togglebutton241.
function togglebutton241_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton241 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton241


% --- Executes on button press in togglebutton242.
function togglebutton242_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton242 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton242


% --- Executes on button press in togglebutton243.
function togglebutton243_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton243 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton243


% --- Executes on button press in togglebutton244.
function togglebutton244_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton244 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton244


% --- Executes on button press in togglebutton245.
function togglebutton245_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton245 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton245


% --- Executes on button press in togglebutton246.
function togglebutton246_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton246 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton246


% --- Executes on button press in togglebutton247.
function togglebutton247_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton247 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton247


% --- Executes on button press in togglebutton248.
function togglebutton248_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton248 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton248


% --- Executes on button press in togglebutton249.
function togglebutton249_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton249 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton249


% --- Executes on button press in togglebutton250.
function togglebutton250_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton250


% --- Executes on button press in togglebutton251.
function togglebutton251_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton251 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton251


% --- Executes on button press in togglebutton252.
function togglebutton252_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton252 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton252


% --- Executes on button press in togglebutton253.
function togglebutton253_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton253 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton253


% --- Executes on button press in togglebutton254.
function togglebutton254_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton254 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton254


% --- Executes on button press in togglebutton255.
function togglebutton255_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton255 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton255


% --- Executes on button press in togglebutton256.
function togglebutton256_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton256 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton256


% --- Executes on button press in togglebutton257.
function togglebutton257_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton257 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton257


% --- Executes on button press in togglebutton258.
function togglebutton258_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton258 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton258


% --- Executes on button press in togglebutton259.
function togglebutton259_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton259 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton259


% --- Executes on button press in togglebutton260.
function togglebutton260_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton260 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton260


% --- Executes on button press in togglebutton261.
function togglebutton261_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton261 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton261


% --- Executes on button press in togglebutton262.
function togglebutton262_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton262 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton262


% --- Executes on button press in togglebutton263.
function togglebutton263_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton263 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton263


% --- Executes on button press in togglebutton264.
function togglebutton264_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton264 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton264


% --- Executes on button press in togglebutton265.
function togglebutton265_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton265 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton265


% --- Executes on button press in togglebutton266.
function togglebutton266_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton266 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton266


% --- Executes on button press in togglebutton267.
function togglebutton267_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton267 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton267


% --- Executes on button press in togglebutton268.
function togglebutton268_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton268 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton268


% --- Executes on button press in togglebutton269.
function togglebutton269_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton269 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton269


% --- Executes on button press in togglebutton270.
function togglebutton270_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton270 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton270


% --- Executes on button press in togglebutton271.
function togglebutton271_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton271 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton271


% --- Executes on button press in togglebutton272.
function togglebutton272_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton272 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton272


% --- Executes on button press in togglebutton273.
function togglebutton273_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton273 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton273


% --- Executes on button press in togglebutton274.
function togglebutton274_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton274 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton274


% --- Executes on button press in togglebutton275.
function togglebutton275_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton275 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton275


% --- Executes on button press in togglebutton276.
function togglebutton276_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton276 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton276


% --- Executes on button press in togglebutton277.
function togglebutton277_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton277 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton277


% --- Executes on button press in togglebutton278.
function togglebutton278_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton278 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton278


% --- Executes on button press in togglebutton279.
function togglebutton279_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton279 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton279


% --- Executes on button press in togglebutton280.
function togglebutton280_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton280 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton280


% --- Executes on button press in togglebutton281.
function togglebutton281_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton281 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton281


% --- Executes on button press in togglebutton282.
function togglebutton282_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton282 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton282


% --- Executes on button press in togglebutton283.
function togglebutton283_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton283 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton283


% --- Executes on button press in togglebutton284.
function togglebutton284_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton284 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton284


% --- Executes on button press in togglebutton285.
function togglebutton285_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton285 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton285


% --- Executes on button press in togglebutton286.
function togglebutton286_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton286 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton286


% --- Executes on button press in togglebutton287.
function togglebutton287_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton287 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton287


% --- Executes on button press in togglebutton288.
function togglebutton288_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton288 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton288


% --- Executes on button press in togglebutton289.
function togglebutton289_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton289 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton289


% --- Executes on button press in togglebutton290.
function togglebutton290_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton290 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton290


% --- Executes on button press in togglebutton291.
function togglebutton291_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton291 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton291


% --- Executes on button press in togglebutton292.
function togglebutton292_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton292 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton292


% --- Executes on button press in togglebutton293.
function togglebutton293_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton293 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton293


% --- Executes on button press in togglebutton294.
function togglebutton294_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton294 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton294


% --- Executes on button press in togglebutton295.
function togglebutton295_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton295 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton295


% --- Executes on button press in togglebutton296.
function togglebutton296_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton296 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton296


% --- Executes on button press in togglebutton297.
function togglebutton297_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton297 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton297


% --- Executes on button press in togglebutton298.
function togglebutton298_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton298 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton298


% --- Executes on button press in togglebutton299.
function togglebutton299_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton299 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton299


% --- Executes on button press in togglebutton300.
function togglebutton300_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton300 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton300


% --- Executes on button press in togglebutton301.
function togglebutton301_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton301 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton301


% --- Executes on button press in togglebutton302.
function togglebutton302_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton302 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton302


% --- Executes on button press in togglebutton303.
function togglebutton303_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton303 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton303


% --- Executes on button press in togglebutton304.
function togglebutton304_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton304 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton304


% --- Executes on button press in togglebutton305.
function togglebutton305_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton305 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton305


% --- Executes on button press in togglebutton306.
function togglebutton306_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton306 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton306


% --- Executes on button press in togglebutton307.
function togglebutton307_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton307 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton307


% --- Executes on button press in togglebutton308.
function togglebutton308_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton308 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton308


% --- Executes on button press in togglebutton309.
function togglebutton309_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton309 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton309


% --- Executes on button press in togglebutton310.
function togglebutton310_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton310 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton310


% --- Executes on button press in togglebutton311.
function togglebutton311_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton311 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton311


% --- Executes on button press in togglebutton312.
function togglebutton312_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton312 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton312


% --- Executes on button press in togglebutton313.
function togglebutton313_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton313 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton313


% --- Executes on button press in togglebutton314.
function togglebutton314_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton314 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton314


% --- Executes on button press in togglebutton315.
function togglebutton315_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton315 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton315


% --- Executes on button press in togglebutton316.
function togglebutton316_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton316 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton316


% --- Executes on button press in togglebutton317.
function togglebutton317_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton317 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton317


% --- Executes on button press in togglebutton318.
function togglebutton318_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton318 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton318


% --- Executes on button press in togglebutton319.
function togglebutton319_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton319 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton319


% --- Executes on button press in togglebutton320.
function togglebutton320_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton320 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton320


% --- Executes on button press in togglebutton321.
function togglebutton321_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton321 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton321


% --- Executes on button press in togglebutton322.
function togglebutton322_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton322 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton322


% --- Executes on button press in togglebutton323.
function togglebutton323_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton323 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton323


% --- Executes on button press in togglebutton324.
function togglebutton324_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton324 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton324


% --- Executes on button press in togglebutton325.
function togglebutton325_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton325 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton325


% --- Executes on button press in togglebutton326.
function togglebutton326_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton326 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton326


% --- Executes on button press in togglebutton327.
function togglebutton327_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton327 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton327


% --- Executes on button press in togglebutton328.
function togglebutton328_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton328 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton328


% --- Executes on button press in togglebutton329.
function togglebutton329_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton329 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton329


% --- Executes on button press in togglebutton330.
function togglebutton330_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton330 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton330


% --- Executes on button press in togglebutton331.
function togglebutton331_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton331 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton331


% --- Executes on button press in togglebutton332.
function togglebutton332_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton332 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton332


% --- Executes on button press in togglebutton333.
function togglebutton333_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton333 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton333


% --- Executes on button press in togglebutton334.
function togglebutton334_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton334 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton334


% --- Executes on button press in togglebutton335.
function togglebutton335_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton335 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton335


% --- Executes on button press in togglebutton336.
function togglebutton336_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton336 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton336


% --- Executes on button press in togglebutton337.
function togglebutton337_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton337 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton337


% --- Executes on button press in togglebutton338.
function togglebutton338_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton338 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton338


% --- Executes on button press in togglebutton339.
function togglebutton339_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton339 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton339


% --- Executes on button press in togglebutton340.
function togglebutton340_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton340 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton340


% --- Executes on button press in togglebutton341.
function togglebutton341_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton341 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton341


% --- Executes on button press in togglebutton342.
function togglebutton342_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton342 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton342


% --- Executes on button press in togglebutton343.
function togglebutton343_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton343 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton343


% --- Executes on button press in togglebutton344.
function togglebutton344_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton344 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton344


% --- Executes on button press in togglebutton345.
function togglebutton345_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton345 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton345


% --- Executes on button press in togglebutton346.
function togglebutton346_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton346 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton346


% --- Executes on button press in togglebutton347.
function togglebutton347_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton347 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton347


% --- Executes on button press in togglebutton348.
function togglebutton348_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton348 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton348


% --- Executes on button press in togglebutton349.
function togglebutton349_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton349 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton349


% --- Executes on button press in togglebutton350.
function togglebutton350_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton350 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton350


% --- Executes on button press in togglebutton351.
function togglebutton351_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton351 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton351


% --- Executes on button press in togglebutton367.
function togglebutton367_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton367 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton367


% --- Executes on button press in togglebutton368.
function togglebutton368_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton368 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton368


% --- Executes on button press in togglebutton369.
function togglebutton369_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton369 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton369


% --- Executes on button press in togglebutton370.
function togglebutton370_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton370 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton370


% --- Executes on button press in togglebutton371.
function togglebutton371_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton371 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton371


% --- Executes on button press in togglebutton372.
function togglebutton372_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton372 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton372


% --- Executes on button press in togglebutton373.
function togglebutton373_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton373 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton373


% --- Executes on button press in togglebutton374.
function togglebutton374_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton374 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton374


% --- Executes on button press in togglebutton375.
function togglebutton375_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton375 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton375


% --- Executes on button press in togglebutton376.
function togglebutton376_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton376 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton376


% --- Executes on button press in togglebutton377.
function togglebutton377_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton377 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton377


% --- Executes on button press in togglebutton378.
function togglebutton378_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton378 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton378


% --- Executes on button press in togglebutton379.
function togglebutton379_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton379 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton379


% --- Executes on button press in togglebutton380.
function togglebutton380_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton380 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton380


% --- Executes on button press in togglebutton381.
function togglebutton381_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton381 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton381


% --- Executes on button press in togglebutton382.
function togglebutton382_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton382 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton382


% --- Executes on button press in togglebutton383.
function togglebutton383_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton383 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton383


% --- Executes on button press in togglebutton384.
function togglebutton384_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton384 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton384


% --- Executes on button press in togglebutton385.
function togglebutton385_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton385 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton385


% --- Executes on button press in togglebutton386.
function togglebutton386_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton386 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton386


% --- Executes on button press in togglebutton387.
function togglebutton387_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton387 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton387


% --- Executes on button press in togglebutton388.
function togglebutton388_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton388 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton388


% --- Executes on button press in togglebutton389.
function togglebutton389_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton389 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton389


% --- Executes on button press in togglebutton390.
function togglebutton390_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton390 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton390


% --- Executes on button press in togglebutton391.
function togglebutton391_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton391 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton391


% --- Executes on button press in togglebutton392.
function togglebutton392_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton392 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton392


% --- Executes on button press in togglebutton393.
function togglebutton393_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton393 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton393


% --- Executes on button press in togglebutton394.
function togglebutton394_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton394 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton394


% --- Executes on button press in togglebutton395.
function togglebutton395_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton395 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton395


% --- Executes on button press in togglebutton396.
function togglebutton396_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton396 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton396


% --- Executes on button press in togglebutton397.
function togglebutton397_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton397 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton397


% --- Executes on button press in togglebutton398.
function togglebutton398_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton398 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton398


% --- Executes on button press in togglebutton399.
function togglebutton399_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton399 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton399


% --- Executes on button press in togglebutton400.
function togglebutton400_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton400 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton400


% --- Executes on button press in togglebutton401.
function togglebutton401_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton401 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton401


% --- Executes on button press in togglebutton402.
function togglebutton402_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton402 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton402


% --- Executes on button press in togglebutton403.
function togglebutton403_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton403 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton403


% --- Executes on button press in togglebutton404.
function togglebutton404_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton404 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton404


% --- Executes on button press in togglebutton405.
function togglebutton405_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton405 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton405


% --- Executes on button press in togglebutton406.
function togglebutton406_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton406 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton406


% --- Executes on button press in togglebutton407.
function togglebutton407_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton407 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton407


% --- Executes on button press in togglebutton408.
function togglebutton408_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton408 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton408


% --- Executes on button press in togglebutton409.
function togglebutton409_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton409 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton409


% --- Executes on button press in togglebutton410.
function togglebutton410_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton410 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton410


% --- Executes on button press in togglebutton411.
function togglebutton411_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton411 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton411


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(gcbf)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, use UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
