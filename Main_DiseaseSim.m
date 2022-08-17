%Simulation of virus spreading
%This file simulates spreading of virus within a certain domain in 10 Days
%Strcture Dashboard shows the time from infection to recovery of all
%individuals
%Structure total Shows the number of total individuals with each health
%status at the current time

%housekeeping
clear
clc

%asks the user about the number of individuals to consider 
n=input('Number of individuals,n=? , A good number to consider would be 50 to 100.  ');
%Stating a flag to control number of individuals, n considered

tic
if n<=0
    error('Please put in a positive integer, ideally between 50 to 100')
end

%Defining adequate colors for Orange and Green
COrg=[1 11/17 0];
CGren=[0 0.85 0];

%x-axis values for bar chart
status=categorical({'Healthy','Asymptomatic','Infected','Recovered'});
barx=reordercats(status,{'Healthy','Asymptomatic','Infected','Recovered'});

%generate initial position and velocity of the population
Pos=1000*rand(n,2);
xpos=Pos(:,1);
ypos=Pos(:,2);
angle=rand(n,1)*2*pi;
speed=0.1*rand(n,1)+0.1;
u=speed.*cos(angle); %x-component of the velocity
v=speed.*sin(angle); %y-component of the velocity
velo=[u,v];

%Generate Matrix of population
%Using numbers to label health status of individuals
%0- healthy 1- asymptomatic 3- infected 4 - recovered
pop=zeros(n,1);

%Generate 1 infected person 
nfirst=randi(n);
pop(nfirst)=2;

%Record infected time and recovery time
Dashboard(nfirst).InfTime=datevec(0);
Dashboard(nfirst).RecTime=datevec(3);

%Assigning initial status of population to their corresponding vectors
normpop=find(pop==0);
infpop=find(pop==2);

%Assigning Arrays for historical plot at t=0
hours=0;
count=1;

%Generate figures for initial graph and the other graphs
fig1=figure('Name','Initial Plot of individual locations');
fig2=figure('Name','Multiplots');

%Calculating total time in time steps of 10 seconds
dt=10;
time_total=60*60*24*10/dt;
time_day=60*60*24/dt;

for t=0:time_total 

%Updating population to their corresponding vectors
normpop=find(pop==0);
asympop=find(pop==1);
infpop=find(pop==2);
recpop=find(pop==3);

%Generate Structure Array to keep track status of individual 
Total.Time=datevec(t*dt/86400);
Total.Healthy=length(normpop);
Total.Asymptomatic=length(asympop);
Total.Infected=length(infpop);
Total.Recovered=length(recpop);

%Plot Graphs
    %Populations Chart
if mod(t,60)==0 %Plotting the graph every 10 minutes 
    %Initial plot at t=0
    if t==0
        figure(fig1);
        plot(xpos(normpop),ypos(normpop),'o','Color',CGren,'MarkerFaceColor',CGren)
        hold on
        plot(xpos(infpop),ypos(infpop),'o','Color','r','MarkerFaceColor','r')
        axis([0 1000 0 1000])
        title(['Initial plot of ', num2str(n) ,' individuals'])
        xlabel('Width of the domain')
        ylabel('Height of the domain')
        grid on
        hold off
        saveas(gcf,'InitialPlotDay0.jpeg') %Save the graph as .jpeg file
    end

    %Using tiles to subplot the graphs
    figure(fig2);
    tiledlayout(2,2);
    nexttile
    plot(xpos(normpop),ypos(normpop),'o','Color',CGren,'MarkerFaceColor',CGren)
    hold on
    plot(xpos(asympop),ypos(asympop),'o','Color',COrg,'MarkerFaceColor',COrg)
    plot(xpos(infpop),ypos(infpop),'o','Color','r','MarkerFaceColor','r')
    plot(xpos(recpop),ypos(recpop),'o','Color','b','MarkerFaceColor','b')
    axis([0 1000 0 1000])
    xlabel('Width of the domain')
    ylabel('Height of the domain')
    title([num2str(Total.Time(3)),' Days and ',num2str(Total.Time(4)), ' hours'])
    grid on
    hold off

    %Bar Chart Plot
    nexttile
    bary=[length(normpop) length(asympop) length(infpop) length(recpop)]; %y-axis values
    BChart=bar(barx,bary);
    BChart.FaceColor='flat';
    BChart.CData(1,:)= CGren ;
    BChart.CData(2,:)= COrg ;
    BChart.CData(3,:)=[1 0 0];
    BChart.CData(4,:)=[0 0 1];
    xtips1 = BChart(1).XEndPoints;
    ytips1 = BChart(1).YEndPoints;
    labels1 = string(BChart(1).YData); %Showing numbers on the bar chart
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
    ylim([0 n])
    title([num2str(Total.Time(3)),' Days and ',num2str(Total.Time(4)), ' hours'])

    %Generating arrays for historical plot
    if mod(t,360)==0
        hrarray(count)=hours;
        hours=hours+1;
        count=count+1;
        Healthy(hours)=length(normpop);
        Asym(hours)=length(asympop);
        Inf(hours)=length(infpop);
        Rec(hours)=length(recpop);
    end

    %Historical Plot
    nexttile([1 2])
    plot(hrarray,Healthy,'Color',CGren,'LineWidth',2);
    hold on
    plot(hrarray,Asym,'Color',COrg,'LineWidth',2);
    plot(hrarray,Inf,'r','LineWidth',2);
    plot(hrarray,Rec,'b','LineWidth',2);
    hold off
    legend ('Healthy','Asymptomatic','Infected','Recovered')
    xlabel('Time elapsed in hours')
    ylabel('Population')
    title([num2str(Total.Time(3)),' Days and ',num2str(Total.Time(4)), ' hours'])
    axis([0 240 0 n])
end %end of plotting graphs

%Checking shortest distance of each individuals between boundaries
%Change direction if applicable
for i=1:n
    [u(i),v(i)]=boundarycheck(xpos(i),ypos(i),u(i),v(i),speed(i));
end

%Generate new positions of the population
xpos=xpos+dt*u;
ypos=ypos+dt*v;

%Check distance between individual populations
for n0=1:length(infpop)  
    for n1=1:length(normpop)    
        if distpts(xpos(infpop(n0)),ypos(infpop(n0)),xpos(normpop(n1)),ypos(normpop(n1))) <=2     
            if rand >0.5 %50% of chance becoming asymptomatic
                pop(normpop(n1))=0; %Not infected
            else
                %Record infected time and recovery time if infected
                Dashboard(normpop(n1)).AsymTime=datevec(t*dt/86400); 
                Dashboard(normpop(n1)).InfTime=datevec(2+(t*dt/86400));
                Dashboard(normpop(n1)).RecTime=datevec(5+(t*dt/86400));
                pop(normpop(n1))=1;
            end
        end
    end
end

for n2=1:length(asympop) 
    for n3=1:length(normpop)
        if distpts(xpos(asympop(n2)),ypos(asympop(n2)),xpos(normpop(n3)),ypos(normpop(n3))) <=2   
            if rand >0.3 %30% of chance becoming asymptomatic
                pop(normpop(n3))=0; %Not infected 
            else
                %Record infected time and recovery time if infected
                Dashboard(normpop(n3)).AsymTime=datevec(t*dt/86400);
                Dashboard(normpop(n3)).InfTime=datevec(2+(t*dt/86400));
                Dashboard(normpop(n3)).RecTime=datevec(5+(t*dt/86400));
                pop(normpop(n3))=1;
            end
        end
    end
end

%Change status of individual when they recover after being sick for 3 days
for k=1:length(infpop)
    if Dashboard(infpop(k)).RecTime==Total.Time
        pop(infpop(k))=3 ;
    end
end

%Change status of asymptomatic individual to sick & symptomatic after 2 days 
for o=1:length(asympop)
    if Dashboard(asympop(o)).InfTime==Total.Time
        pop(asympop(o))=2;
    end
end

%Save the graph every 2,4,6 days
%Time for one day with time steps of dt is calculated as above
if t == time_day*2
    saveas(gcf,'MultiPlotDay2.jpeg')
elseif t==time_day*4
    saveas(gcf,'MultiPlotDay4.jpeg')
elseif t==time_day*6
    saveas(gcf,'MultiPlotday6.jpeg')
end

%Output Daily Summary
if mod(t,time_day)==0 
    fprintf('Daily Summary for Day %.0f \n', t/8640)
    fprintf('Total Number of Healthy people : %.0f \n',Total.Healthy')
    fprintf('Total Number of Infected but Asymptomatic People: %.0f \n',Total.Asymptomatic')
    fprintf('Total Number of Infected and Sick People: %.0f \n',Total.Infected')
    fprintf('Total Number of Recovered People: %.0f \n \n',Total.Recovered')
end

drawnow
end

toc