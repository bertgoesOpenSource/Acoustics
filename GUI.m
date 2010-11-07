function varargout = GUI(varargin)
% GUI M-file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 04-Nov-2010 20:20:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

set(handles.uipanel2,'SelectionChangeFcn',@uipanel2_SelectionChangeFcn);
% Update handles structure
guidata(hObject, handles);
 

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear
global segLength Rate Source_Rate Receiver Angle FFT_Signal...
L_Receiver L_Source time Source offsetVal printNum s_time time_Source;
printNum=0;
segLength = 0.1; %default Beam pattern's time interval

Rate = 50000; %Set sample rate here

T=1/Rate; %sample time;

Source_Rate = 1000;

[foo1,foo2,foo3,foo4,foo5,foo6,foo7,foo8]=textread(...
    'D:\Bert\Acoustics\Receivers\Receivers.txt',...
    '%f %f %f %f %f %f %f %f'); %Read in 8 receivers' data
	%Deal with offsets in MICs' Voltage
	 foo1=foo1-2e-3;
	 foo3=foo3+1e-3;
	 foo6=foo6+2e-3;
	 foo8=foo8+5e-3;
	 
	
	
	
%Receiver=[foo1,foo2,foo3,foo4,foo5,foo6,foo7,foo8]; %uncomment for multiple channels
Receiver = textread('D:\Bert\Acoustics\Receivers\Receiver1.txt');

% [Angle FFT_Signal]= textread(...
    % 'D:\Bert\Acoustics\Receivers\FFT.txt','%f %f');
Source = textread(...
     'D:\Bert\Acoustics\Receivers\Source1.txt','%f');
clear foo1;
clear foo2;
clear foo3;
clear foo4;
clear foo5;
clear foo6;
clear foo7;
clear foo8; %better find another way...
L_Receiver = size(Receiver,1); %Length of receiver.txt, for code efficiency
time =(0:L_Receiver-1)*T;  %time vector
time=time';
time_Source = time'*10;
s_time = size(time,1); %for code efficiency
 L_Source = size(Source,1);
 offsetVal = 0; %time delay of source signal
    % subplot(2,1,1,'Position',[0.1,0.7,0.8,0.2])
       % axis([-90,90,0,0.1]);
       % ylabel('Amplitude')
       % xlabel('Deg')
    % subplot(2,1,2,'Position',[0.1,0.2,0.8,0.4])
       % ylim([-10,10 ]);
       % ylabel('Amplitude')
       % xlabel('time (s)')
       % Source = Source';
	   
	   
	   



% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
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



% --- Executes on slider1 movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider1
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider1
global Source_Rate FFT_Signal time Receiver ...
    mode segLength L_Receiver time_Source L_Source Source Rate offsetVal s_time;


max = s_time/segLength/Rate;
set(hObject,'Max',max);
 set(hObject,'SliderStep',[1/max 2/max]);
magicNum = 2; %Somehow the Source time should be scaled by 2....
time_source = linspace(0,L_Source/Source_Rate,magicNum *L_Source);
ind=get(hObject,'Value');

%select between Beam Pattern and Water Fall plots
switch mode
    case '0'
        disp('error');
    case '1'
        %Beam Pattern Mode

      subplot(2,1,1,'Position',[0.1,0.7,0.8,0.2])
%TODO, fix time scale when Rate is set to other value than 10000
    scatter(linspace(-90,90,segLength*Rate)...
        ,FFT_Signal(segLength*Rate*ind+1:...
        (ind+1)*segLength*Rate),'sizeData',1);
        axis([-90,90,0,0.2]);
      ylabel('Amplitude')
       xlabel('Deg')

      subplot(2,1,2,'Position',[0.1,0.4,0.8,0.2])

   plot(time_source((ind*Source_Rate*segLength+1+offsetVal*Source_Rate):...
        (ind+1)*Source_Rate*segLength+offsetVal*Source_Rate)...
        ,Source((ind*Source_Rate*segLength+1+offsetVal*Source_Rate):...
        (ind+1)*Source_Rate*segLength+offsetVal*Source_Rate));
       ylim([-10,10 ]);
       ylabel('Amplitude')
       xlabel('time (s)')
    case '2'
        
        %WaterFall mode
        %TODO fix fft so the frequency is shown
     
        L = segLength*Rate;
         %number of samples per segLength
         NFFT = 2^nextpow2(L);
   
      
%       
        for mic = 1:size(Receiver,2);
        start = ind*segLength; %starting time
        ending = (ind+1)*segLength;
        f=Rate/2*linspace(0,1,NFFT/2+1);
    
        subplot(9,2,mic*2-1,'Position',[0.1,0.98-0.06*mic,0.4,0.04])

        ft = fft(Receiver((start*Rate+1):ending*Rate,mic),NFFT); %
			
        plot(time(round(start*Rate+1):round(ending*Rate)),...
            Receiver(round(start*Rate+1):round(ending*Rate),mic));
         xlim([start ending])
		
          %ylim([-5e-3,5e-3]);
         subplot(9,2,mic*2,'Position',[.55,.98-0.06*mic,.3,.04])
          plot(f,2*abs(ft(1:NFFT/2+1)));
		   set(gca,'XTick',0:2000:15000)
         ylim([0,1]);
	
        end

        % subplot(9,2,17,'Position',[0.1,0.4,0.8,0.1])
		%for one mic
			  %	----------------%Plot Source Signal
		source_offset = 0;

		 subplot(2,1,2,'Position',[0.1,0.4,0.8,0.2])
        plot(time_Source(round(start*Source_Rate+source_offset+1):round(ending*Source_Rate+source_offset))...
        ,Source(round(start*Source_Rate+source_offset+1):round(ending*Source_Rate+source_offset)));
		
       % ylim([-10,10]);

        xlim([start,ending]);
       ylabel('Amplitude')
       xlabel('time (s)')
		%----------------------Source Signal End
	
%         round(start*Rate)
%         round(ending*Rate)

	


        
        
end

        
% set(handles.edit1,'String', num2str(i));

guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider1 controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


   



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in setIntv.
function setIntv_Callback(hObject, eventdata, handles)
% hObject    handle to setIntv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global segLength Rate numSample;
segLength = get(handles.edit1,'String');
segLength = str2num(segLength);
numSample = 2^nextpow2(segLength*Rate);
guidata(hObject,handles);



function offsetVal_Callback(hObject, eventdata, handles)
% hObject    handle to offsetVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offsetVal as text
%        str2double(get(hObject,'String')) returns contents of offsetVal as a double


% --- Executes during object creation, after setting all properties.
function offsetVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in offset.
function offset_Callback(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of offset
global offsetVal 
state =  get(hObject,'Value');
if state ==1
offsetVal = get(handles.offsetVal,'String');
offsetVal = str2num(offsetVal);
else
    offsetVal = 0;
end


% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%TODO add 2 buttons

function uipanel2_SelectionChangeFcn(hObject, eventdata)
 global mode;   
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'enableFFT'
      %execute this code when fontsize08_radiobutton is selected
      mode = '1';
 
    case 'enableWaterFall'
      %execute this code when fontsize12_radiobutton is selected
      mode = '2';

    otherwise
       % Code for when there is no match.
      mode = '0';
end
%updates the handles structure
guidata(hObject, handles);

% --- Executes on button press in enableFFT.
function enableFFT_Callback(hObject, eventdata, handles)
% hObject    handle to enableFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enableFFT
global mode
mode = get(hObject,'Value');
mode = num2str(mode)
guidata(hObject, handles);

% --- Executes on button press in enableWaterFall.
function enableWaterFall_Callback(hObject, eventdata, handles)
% hObject    handle to enableWaterFall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enableWaterFall


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d = regexprep(datestr(now,0),':','-');
filename = ['D:\Bert\Acoustics\screenshots\' d '.bmp'];
saveas(gcf,filename,'bmp')





% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5. apply filter
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Receiver Num Receiver_orig;
den=1;
% list_entries = get(handles.listbox1,'String');
% Num = list_entries(1)
Receiver_orig=Receiver;
 Receiver = filter(Num,den,Receiver);
guidata(hObject,handles);


% --- Executes on button press in pushbutton6. update workspace
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vars = evalin('base','who');
set(handles.listbox1,'String',vars)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Receiver Receiver_orig;
Receiver = Receiver_orig;
guidata(hObject,handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
