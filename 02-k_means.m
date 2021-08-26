%% K-means Clustering for Microtrips Driving Cycle
clc;
clear all;
close all;
route = {'Route A'};
routepic = {'Route A.png'};
file = {'Sheet1'};
part = {'P21:Q28'};
for f=1:(length(file))
%% Upload Data
data = xlsread('SpeedData.xlsx',file{f},part{f});
data(:, [1 2]) = data(:, [2 1]);
mt = length(data(:,1));
cluster = 3;  % number of clusters
iteration = 0;
M = max(data(:,2));
range = M/4;
center = [0];
%% Define clusters
for k=1:2
    for h=1:cluster
        if k==1
            center(h,k)=0;
        else
            center(h,k)=range*h;  % cluster centers
        end
    end
end
dl   = zeros(size(data,1),cluster+2);  % distance labels
color    = '+r+b+y';  % color and shape points (red,blue,yellow)
%% K-means
while(1)
   pre_center = center;     
   for i = 1:size(data,1)
      for j = 1:cluster  
        dl(i,j) = norm(data(i,:) - center(j,:));      
      end
      [distance, label] = min(dl(i,1:cluster));  % extract minimum distance and nearest cluster 
      dl(i,cluster+1) = label;  % cluster label
      dl(i,cluster+2) = distance;  % minimum distance
   end
   for i = 1:cluster
      A = (dl(:,cluster+1) == i);  % cluster number (1/2/3)
      center(i,:) = mean(data(A,:));  % new cluster center
      if sum(isnan(center(:))) ~= 0  % replace with random points for non-valid centers
         non_center = find(isnan(center(:,1)) == 1);  % find non-valid center
         for index = 1:size(non_center,1)
         center(non_center(index),:) = data(randi(size(data,1)),:);
         end
      end
   end
   
%% Plot   
clf
fig=figure(1);
hold on
 for i = 1:cluster
     points = data(dl(:,cluster+1) == i,:);  % find points of each cluster    
     plot(points(:,1),points(:,2),color(2*i-1:2*i),'LineWidth',2);  % plot points
     plot(center(:,1),center(:,2),'*k','LineWidth',7);  % plot cluster centers 
 end
labels = string(1:mt);
labels1 = string(1:3);
dy = 0.1;
set(gca,'FontSize',20);
text(data(:,1), data(:,2)+ dy, labels, "HorizontalAlignment","center","VerticalAlignment","bottom");
text(center(:,1), center(:,2)+ dy, labels1, "HorizontalAlignment","center","VerticalAlignment","bottom");
title(route{f});
ylabel('Average speed (m/s)') ;
xlabel('Idle percentage (%)') ;
hold off
grid on
pause(0.1)
iteration = iteration + 1;
if pre_center==center
    break
end
if iteration == 40
    break
end
end
saveas(fig,routepic{f});
T = table(dl(:,4),dl(:,5));
T.Properties.VariableNames = {'Cluster','Distance'};
writetable(T,'SpeedData.xlsx','Sheet',f,'Range','R20');
end
