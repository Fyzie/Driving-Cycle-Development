%% Speed data parameters analysis
clc;
clear all;
close all;
route = {'Route A','Route B','Route C','Route D','Route E','Overall','Markov'};
file = {'Sheet1','Sheet2','Sheet3','Sheet4','Sheet5','Sheet10','Sheet2'};
party = {'W20:W393','W20:W450','Y20:Y493','X20:X413','X20:X334','U1:U388','D2:D401'};
partv = {'V20:V393','V20:V450','X20:X493','W20:W413','W20:W334','T1:T388','C2:C401'};
for b=1:(length(file))
    %acceleration
    acc=xlsread('SpeedData.xlsx',file{b},party{b});
       
    %velocity
    v=xlsread('SpeedData.xlsx',file{b},partv{b});
    
    [acc,d,ta,td,vel,tvr,ve,ap,ip,dp,cp,rmc]=deal(0);
    x = [0];
    z = [0];
    spd = [0];
    len = length(y);
    
    for i=1:(len)
        %mphs-1 to ms-2
        x(i)=y(i)/2.237;
        %mph to kmh
        z(i)=v(i)*1.609;
        spd(i)=v(i)/2.237;
    end
    %average acc n dec
    for i=1:(len)
        if x(i)>0
            acc=acc+x(i);
            ta=ta+1;
            rmc=rmc+(x(i))^2;
        elseif x(i)<0
            d=d+x(i);
            td=td+1;
        end
    end
    %v average n v running
    for i=1:(len)
        ve=ve+z(i);
        if z(i)>0
            vel=vel+z(i);
            tvr=tvr+1;
        end
    end
    %percent
    for i=1:(len)
        %idle
        if y(i)==0 && v(i)==0
            ip=ip+1;
            %acc
        elseif y(i)>0
            ap=ap+1;
        %dec
        elseif y(i)<0
            dp=dp+1;
            %cruise
        elseif y(i)==0 && v(i)>0
            cp=cp+1;
        end
    end
    kacc=acc/ta;            %avg acceleration
    kdec=d/td;            %avg deceleration
    kvr=vel/tvr;          %avg speed(running)
    kvavg=ve/(len);       %avg speed(whole)
    kip=ip/(len)*100;     %idle (percent)
    kap=ap/(len)*100;     %acc (percent)
    kdp=dp/(len)*100;     %dec (percent)
    kcp=cp/(len)*100;     %cruise (percent)
    krmc=(rmc/ta)^(1/2);  %rms
    t=ip+ap+dp+cp;        %total duration  
    tp=kip+kap+kdp+kcp;   %total percent (100%)
    
    data = {'average speed',kvavg,'km/h';
            'average running speed',kvr,'km/h';
            'average acceleration',kacc,'m/s^2';
            'average deceleration',kdec,'m/s^2';
            'RMS',krmc,'m/s^2';
            'idle percentage',kip,'%';
            'cruise percentage',kcp,'%';
            'acceleration percentage',kap,'%';
            'deceleration percentage',kdp,'%'};
    figure(1);
    subplot(2,3,b);
    plot(1:len,spd);title(route{b});
    ylabel('Average speed (m/s)') ;
    xlabel('Time (seconds)') ;
    xlswrite(name_file{o},data,file{b},'L20');
end
