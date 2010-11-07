%---------------------------Acoustics Research----------------------------%
%---Author: Bert Jiang, University of Michigan, Mechanical Engineering----%
%---------------------umid:36218779, umjiang@umich.edu--------------------%   
%----------------------------2010/Oct/20----------------------------------%
clear;
segLength = 0.1; %Beam pattern's time interval
Rate = 1000; %Set sample rate here
Source_Rate = 1000;

[foo1,foo2,foo3,foo4,foo5,foo6,foo7,foo8]=textread(...
    'D:\Bert\Acoustics\Receivers\Receivers.txt',...
    '%f %f %f %f %f %f %f %f'); %Read in 8 receivers' data
Receiver=[foo1,foo2,foo3,foo4,foo5,foo6,foo7,foo8];
[Angle FFT_Signal]= textread(...
    'D:\Bert\Acoustics\Receivers\FFT.txt','%f %f');
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
 L_Source = size(Source,1);
time =linspace(0,L_Receiver/Rate,L_Receiver);

%TODO  1.Break the samples into Source_Rate/Rate time intervals
%      each segments expands -90deg..90deg, which corresponds to
%      Source_Rate/Rate second's beam pattern --done 10:50p.m. Oct/20
%      2.Obtain source frequency by examine the non-zero source length
%      3.provide beam pattern given frequency
%      4.GUI implement



cont=1;
% time_scaled = Rate/Source_Rate;
time_source = linspace(0,L_Source/Source_Rate,L_Source);
while cont==1
    %Time Elapse
    start_intv= input(...
    'Please select the starting interval number you would like to inspect'...
    ,'s');
    end_intv= input(...
    'Please select the ending interval number you would like to inspect'...
    ,'s');
     start_intv= str2double(start_intv);
    end_intv = str2double(end_intv);
    for i=start_intv:end_intv
        subplot(2,1,1);
    
    scatter(linspace(-90,90,Source_Rate)...
        ,FFT_Signal(i*Source_Rate+1:...
        (i+1)*Source_Rate),'sizeData',1);
        axis([-90,90,0,0.1]);
    subplot(2,1,2);
 
    scatter(time_source(i*Source_Rate*segLength+1:...
        (i+1)*Source_Rate*segLength)...
        ,Source(i*Source_Rate*segLength+1:...
        (i+1)*Source_Rate*segLength),'sizeData',1);
       ylim([-10,10 ]);
    pause(.1);
    end
%     num_intv = input(...
%     'Please select the interval number you would like to inspect[1-10]'...
%     ,'s');
%     num_intv=str2double(num_intv);
%     subplot(2,1,1);
%     scatter(linspace(-90,90,Source_Rate)...
%         ,FFT_Signal(num_intv*Source_Rate+1:...
%         (num_intv+1)*Source_Rate),'sizeData',1);
%     subplot(2,1,2);
%     scatter(time_source(num_intv*Source_Rate*segLength+1:...
%         (num_intv+1)*Source_Rate*segLength)...
%         ,Source(num_intv*Source_Rate*segLength+1:...
%         (num_intv+1)*Source_Rate*segLength),'sizeData',1);

    cont = input('Continue? [1 for Yes, 0 for No]','s');
    cont = str2double(cont);
 end

