function varargout = hist(varargin)
% HIST MATLAB code for hist.fig
%      HIST, by itself, creates a new HIST or raises the existing
%      singleton*.
%
%      H = HIST returns the handle to a new HIST or the handle to
%      the existing singleton*.
%
%      HIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HIST.M with the given input arguments.
%
%      HIST('Property','Value',...) creates a new HIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hist

% Last Modified by GUIDE v2.5 19-Nov-2015 17:02:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hist_OpeningFcn, ...
                   'gui_OutputFcn',  @hist_OutputFcn, ...
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


% --- Executes just before hist is made visible.
function hist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hist (see VARARGIN)

% Choose default command line output for hist
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hist wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hist_OutputFcn(hObject, eventdata, handles) 
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
[FileName,PathName]=uigetfile({'*.bmp';'*.jpg';'*.png';'*.*'},'選擇一幅圖像');
set(handles.editShowPath,'String',[PathName,FileName]);
if isequal([FileName,PathName],[0,0])
    msgbox('請換圖片！')
    return;
end
handles.image=imread([PathName,FileName]);
axes(handles.axes1);
imshow(handles.image);title('原圖');
k= imresize(handles.image,[500 500]);
[frameHeight, frameWidth, frameDepth] = size(k);
L = zeros(frameHeight, frameWidth);
a = zeros(frameHeight, frameWidth);
b = zeros(frameHeight, frameWidth);
c = zeros(frameHeight, frameWidth);
h = zeros(frameHeight, frameWidth);

axes(handles.axes2);
imhist(k(:, :, 1));title('R直方圖');
axes(handles.axes3);
imhist(k(:, :, 2));title('G直方圖');
axes(handles.axes4);
imhist(k(:, :, 3));title('B直方圖');

double x;
double y;
double z;
double X;
double Y;
double Z;
double L1;
double a1;
double b1;
double d;

for m=1:500 
for l=1:500
    R=k(m,l,1); 
    G=k(m,l,2); 
    B=k(m,l,3); 
    R=double(R);
    G=double(G);
    B=double(B);
    
    x = (R / 255);
    x = double(x^(2.2));
%     fprintf('%f,%d\n',x,R);
    y = double(G / 255);
    y = double(y^(2.2));
    z = double(B / 255);
    z = double(z^(2.2)) ;
	X = double(0.4124*x + 0.3576*y + 0.1805*z);
	Y = double(0.2126*x + 0.7152*y + 0.0722*z);
	Z = double(0.0193*x + 0.1192*y + 0.9505*z);
%     fprintf('%f,%f,%f,%d,%d,%d\n',X,Y,Z,R,G,B);
	d = 1 / 3;
	X = double(X / 0.9504);
	Z = double(Z / 1.0889);
    L1 = double((116 * Y^(d) - 16));
	a1 = double(500 * (X^(d) - Y^(d)));
	b1 = double(200 * (Y^(d) - Z^(d)));
	L(m, l) = (2.5 * L1);
    a(m, l) = (128 + (a1));
	b(m, l) = (128 + (b1));
    %fprintf('%d,%d,%d,%d,%d,%d\n',L(m, l),a(m, l),b(m, l),R,G,B);
	c(m, l) = 2 * sqrt(a1*a1 + b1*b1);
	h1 = atan(b1 / a1) * 180 / 3.14;
	if h1<0
		h1 = h1 + 360;
    end 
	h(m, l) = 255 / 360 * h1;
end
end

axes(handles.axes5);
imshow(L,[]);title('L');
imwrite(L/255,'L.bmp');
axes(handles.axes6);
imshow(a,[]);title('a');
imwrite(a/255,'a.bmp');
axes(handles.axes7);
imshow(b,[]);title('b');
imwrite(b/255,'b.bmp');
axes(handles.axes8);
imshow(c,[]);title('c');
imwrite(c/255,'c.bmp');
axes(handles.axes9);
imshow(h,[]);title('h');
imwrite(h/255,'h.bmp');

L = imread('L.bmp');
axes(handles.axes10); imhist(L); title('L直方圖');
a = imread('a.bmp');
axes(handles.axes11); imhist(a); title('a直方圖');
b = imread('b.bmp');
axes(handles.axes12); imhist(b); title('b直方圖');
c = imread('c.bmp');
axes(handles.axes13); imhist(c); title('c直方圖');
h = imread('h.bmp');
axes(handles.axes14); imhist(h); title('h直方圖');

set(handles.text1,'string',mean(reshape(k(:,:,1),500*500,1)));
set(handles.text2,'string',mean(reshape(k(:,:,2),500*500,1)));
set(handles.text3,'string',mean(reshape(k(:,:,3),500*500,1)));
set(handles.text4,'string',mean(reshape(L(:,:),500*500,1)));
set(handles.text5,'string',mean(reshape(a(:,:),500*500,1)));
set(handles.text6,'string',mean(reshape(b(:,:),500*500,1)));
set(handles.text7,'string',mean(reshape(c(:,:),500*500,1)));
set(handles.text8,'string',mean(reshape(h(:,:),500*500,1)));

kk=double(k);
LL=double(L);
aa=double(a);
bb=double(b);
cc=double(c);
hh=double(h);
set(handles.text16,'string',std(reshape(kk(:,:,1),500*500,1)));
set(handles.text17,'string',std(reshape(kk(:,:,2),500*500,1)));
set(handles.text18,'string',std(reshape(kk(:,:,3),500*500,1)));
set(handles.text19,'string',std(reshape(LL(:,:),500*500,1)));
set(handles.text20,'string',std(reshape(aa(:,:),500*500,1)));
set(handles.text21,'string',std(reshape(bb(:,:),500*500,1)));
set(handles.text22,'string',std(reshape(cc(:,:),500*500,1)));
set(handles.text23,'string',std(reshape(hh(:,:),500*500,1)));
