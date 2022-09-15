%% Feature Extraction for Microtrips
clc;
clear all;
close all;
route = {'Route A','Route B','Route C','Route D','Route E'};
file = {'Sheet1','Sheet2','Sheet3','Sheet4','Sheet5'};
part = {'F1:F381','F1:F436','F1:F413','F1:F404','F1:F321'};
for a=1:(length(file))
    spd = xlsread('SpeedData.xlsx',file{a},part{a});
    len = length(spd);
    [ip, avgmt, index, mt] = deal(0);
    avg = [0];
    ipmt = [0];
    set = [0];
    
    for i=1:(len)
        if index==0 && spd(i)~=0
            i = i - 1;
        end
        avgmt = avgmt + spd(i);
        index = index + 1;
        set(index,mt+1) = spd(i);
        %idle
        if spd(i)==0 
        ip=ip+1;
        end
        %avg speed
        if spd(i)==0 && avgmt ~= 0
            mt = mt + 1;
            avg(mt) = avgmt/index;
            ipmt(mt) = ip/index*100;
            [avgmt, index, ip] = deal(0);
        end
    end
    
    microtrips = 1:mt;
    figure(1);
    subplot(3,2,a);
    plot(ipmt,avg,'*b','LineWidth',1);

    title(route{a});
    ylabel('Average speed (m/s)') ;
    xlabel('Idle percentage (%)') ;
    labels = string(1:mt);
    dy = 0.1;
    text(ipmt, avg +dy, labels, "HorizontalAlignment","center","VerticalAlignment","bottom");
    
    Microtrips = microtrips';
    Average_speed = avg';
    Idle_percentage = ipmt';
    T = table(Microtrips,Average_speed,Idle_percentage);
    writetable(T,'SpeedData.xlsx','Sheet',a,'Range','O20');
    T1 = table(set);
    writetable(T1,'SpeedData.xlsx','Sheet',a,'Range','H38');
end
