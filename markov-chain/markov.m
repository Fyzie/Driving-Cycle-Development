transC = [zeros(size(T,1),1), cumsum(T,2)];
for x=1:1000000
k = 400;
states = zeros(1,k); %storage of states
z_state = 6; %start at state where spd & acc = 0
states(1) = z_state; 
states(k) = z_state; 
rr = rand(1,k);
for ii = 2:k-1
    [~,states(ii)] = histc(rr(ii),transC(states(ii-1),:));
end
DC=[0,0];
for iii=1:k
    DC(iii,:) = u(states(iii),:);
end
%plot(DC(:,1));
[u2,~,n2] = unique(DC,'rows');
N2 = length(u2);
deviate(x)=((N2-N)/N)*100;
tol = 5 * eps(deviate(x));
if ismembertol(abs(deviate(x)), min(abs(deviate)), tol)
    Y = DC;
    len=length(u2);
end
end
plot(Y(:,1));
xlabel('Time (seconds)');ylabel('Velocity (m/s)');T = table(Y(:,1),Y(:,2));
T.Properties.VariableNames = {'Time','Velocity'};
writetable(T,'Markov.xlsx','Sheet',2,'Range','A1');
min(abs(deviate))
len
return
time =[1:length(DC(:,1))]';
table = table(time,DC(:,1),DC(:,2));
table.Properties.VariableNames = {'Time','Speed','Acceleration'};
writetable(table,'SpeedData.xlsx','Sheet',10,'Range','P1');
