%% Markov
clear all;close all;clc;
file = {'Sheet1','Sheet2','Sheet3','Sheet4','Sheet5','Sheet8'};
part = {'F1:G381','F1:G436','F1:G413','F1:G404','F1:G321','C2:D1956'};
% file = {'Sheet2'};
% part = {'A2:B401','C2:D389'};
% data = xlsread('Markov Details.xlsx',file{1},part{2});
deviate = [0];
data = xlsread('SpeedData.xlsx',file{1},part{1});
len = length(data);
decimal = 1;
data(:,1:2) = round(10^decimal*data)/10^decimal;
% u = accelerations of same velocity
% n = compare data to u(n)
[u,~,n] = unique(data,'rows');
N = length(u);
F = accumarray([n(1:end-1),n(2:end)],1,[N,N]);
T = bsxfun(@rdivide,F,sum(F,2));
transC = [zeros(size(T,1),1), cumsum(T,2)];
% return
for x=1:10
k = 400;
states = zeros(1,k); %storage of states
z_state = 6; %start at state where spd & acc = 0
states(1) = z_state; 
states(k) = z_state; 
rr = rand(1,k);
for ii = 2:k-1
    [ee,states(ii)] = histc(rr(ii),transC(states(ii-1),:));
end
% return
DC=[0,0];
for iii=1:k
    DC(iii,:) = u(states(iii),:);
end
% return
%plot(DC(:,1));
[u2,~,n2] = unique(DC,'rows');
N2 = length(u2);
deviate(x)=((N2-N)/N)*100;
tol = 5 * eps(deviate(x));
if ismembertol(abs(deviate(x)), min(abs(deviate)), tol)
    Y = DC;
    len=length(u2);
end
x
end
plot(Y(:,1));
xlabel('Time (seconds)');ylabel('Velocity (m/s)');T = table(Y(:,1),Y(:,2));
T.Properties.VariableNames = {'Time','Velocity'};
writetable(T,'Markov Details.xlsx','Sheet',2,'Range','A1');
min(abs(deviate))
len
return
time =[1:length(DC(:,1))]';
table = table(time,DC(:,1),DC(:,2));
table.Properties.VariableNames = {'Time','Speed','Acceleration'};
writetable(table,'SpeedData.xlsx','Sheet',10,'Range','P1');