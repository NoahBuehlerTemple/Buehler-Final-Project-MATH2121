%Forest Fire Simulation

%This program simulates a forest fire occuring in a set grid. The user is
%asked to input if a river is wanted and if wind is wanted and the program
%will change accordingly. Variables like "width", "height", and "steps" can
%all be easily changed by the user to change the domain and length of the
%simulation.


%Created by Noah Buehler
set(gca,'YTick',[]) %gets rid of grid for y axis
set(gca,'XTick',[]) %gets rid of grid for x axis
mod1=0; %sets wind modifier to 0
mod2=0; %sets wind modifier to 0
height=20; %Sets height of forest in agents
width=20; %Sets width of forest in agents
fire(1:height,1:width)=0; %Creates array of agents
onFire(1:height,1:width)=0; %Creates array that keeps track of agents on fire and how long
fire=string(fire); %Turns numberical array into string array
steps=40; %Steps for simulation to run for
simutype=input("\n Type 'regular' for a randomly created forest or 'river' for a randomly made forest with a river in it \n","s");
wind=input("\n Type 'wind' for wind and 'none' for no wind \n","s");
%Randomly generates the grid with 95% forest tiles and 5% water tiles
if strcmp(simutype,"regular") %User selected a regular simulation without a river
    for i = 1:height 
        for j = 1:width
            if rand >.05 
            fire(i,j)="gs"; %"gs" stands for green squares when plotting the grid, these represent forest tiles
            else
            fire(i,j)="bs"; %"bs" stands for blue squares when plotting the grid, these represent water tiles
            end
        end
    end
else %User selected a simulation with a river
    for i = 1:height 
        for j = 1:width
            if rand >.05 
            fire(i,j)="gs"; %"gs" stands for green squares when plotting the grid, these represent forest tiles
            else
            fire(i,j)="bs"; %"bs" stands for blue squares when plotting the grid, these represent water tiles
            end
        end
    end
    i=randsample(width,1); %A random x value in the grid is chosen
    for j = 1:height 
        %Each agent with that x value becomes a water agent, creating a
        %river
        fire(i,j)="bs";
    end
end
firestartx=randi([1 width]); %Picks a random x coordinate for fire to start at
firestarty=randi([1 height]); %Picks a random y coordinate for fire to start at
while strcmp(fire(firestartx,firestarty),"bs") % makes sure that a fire agent is not overwriting a water agent
    firestartx=randi([1 width]); %Picks a random x coordinate for fire to start at
    firestarty=randi([1 height]); %Picks a random y coordinate for fire to start at
end
fire(firestartx,firestarty)="rs"; %Turns one tile into the starting fire tile
for i = 1:height
        for j = 1:width
            hold on
            %Takes color from string array to be plotted
            temp=char(fire(i,j));
            markercolor=temp(1);
            %Plots differently colored markers with black outlines
            plot(i,j,'ks','Markersize',15,'Markerfacecolor',markercolor)
        end
end
if strcmp(wind,"wind") %If user wanted wind in the simulation, wind is added
    randdirection=rand; % a random decimal number from 0 to 1 is created
    if randdirection >.75 % 25% chance up wind directed right
        mod1=1;
    elseif randdirection >.5 % 25% chance up wind directed left
        mod1=-1;
    elseif randdirection >.25 % 25% chance up wind directed up
        mod2=1;
    else % 25% chance up wind directed down
        mod2=-1;
    end
end
%Loops for each step and agent
for n=1:steps
    for a = 1:height
        for b = 1:width
            %Checks if current agent is on fire
            if strcmp(fire(a,b),"rs")
                %For all of the following if statements, the wind modifiers
                %mod1 and mod2 account for any direction of wind. These
                %modifiers also change the boundaries being checked to
                %ensure errors do not occur.
                %25 chance of tile to the right catching on fire without
                %wind
                if (rand > .75)&&(b+mod2 < width)&&(a+mod1>0)&&(a+mod1<height+1)
                    if(strcmp(fire(a+mod1,b+1+mod2),"gs"))
                        fire(a+mod1,b+1+mod2)="rs";
                    end
                end
                %25 chance of tile to the left catching on fire without
                %wind
                if (rand > .75)&&(b+mod2 >1)&&(a+mod1>0)&&(a+mod1<height+1)
                    if(strcmp(fire(a+mod1,b-1+mod2),"gs"))
                        fire(a+mod1,b-1+mod2)="rs";
                    end
                end
                %25 chance of tile above catching on fire without
                %wind
                if (rand > .75)&&(a+mod1 < height)&&(b+mod2>0)&&(b+mod2<height+1)
                    if(strcmp(fire(a+1+mod1,b+mod2),"gs"))
                        fire(a+1+mod1,b+mod2)="rs";
                    end
                end
                %25 chance of tile below catching on fire without
                %wind
                if (rand > .75)&&(a+mod1 > 1)&&(b+mod2>0)&&(b+mod2<height+1)
                    if(strcmp(fire(a-1+mod1,b+mod2),"gs"))
                        fire(a-1+mod1,b+mod2)="rs";
                    end
                end
                %This final check only affects simulaions where wind is
                %involved. It prevents gaps in the fire from being created
                %by making sure if the fire spreads over a forest agent,
                %that forest agent becomes a fire agent.
                if (rand > .75)&&(b+mod2>0)&&(b+mod2<height+1)&&(a+mod1>0)&&(a+mod1<height+1)
                    if(strcmp(fire(a+mod1,b+mod2),"gs"))
                        fire(a+mod1,b+mod2)="rs";
                    end
                end
                %Updates the time the tile has spent on fire
                onFire(a,b)=onFire(a,b)+1;
                %If on fire longer than 6 steps, the tile becomes charred
                if onFire(a,b) > 6
                    fire(a,b)= "ks";
                end
            end
        end
    end
    %Pauses simulation so that the user can see changes easily
    pause(.5)
    %Plots the grid with forest, fire, or water tiles
    for i = 1:height
        for j = 1:width
            hold on
            %Takes color from string array to be plotted
            temp=char(fire(i,j));
            markercolor=temp(1);
            %Plots differently colored markers with black outlines
            plot(i,j,'ks','Markersize',15,'Markerfacecolor',markercolor)
        end
    end
end




