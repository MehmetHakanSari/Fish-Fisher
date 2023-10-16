clear 
clc
close all


N = 512;
Time = 1000;

x = 1:N; y = 1:N;

terr = terrain;
water = terrain;
grass = terrain;
forest = terrain;
mountain = terrain;

water.color = [29, 85, 252];  %waters
water(2).color = [3, 55, 211];  %meadium water
water(3).color = [2, 38, 145];  %deep water
grass.color = [28, 232, 48]; %step


colorized = [grass.color / 255; water(1).color / 255; [125, 219, 225]/ 255; [254 109 48] / 255];

z = map;
z.name = "baku.png";
z.rbglattice = z.import();
z.terrain_ID = z.get_terrainvalues();
z.terrain_names = z.get_terrainnames();
z.population = zeros(N);
z.visualize(colorized);

%%

%Initilize locaitons and randomly distribure fishermans
fishingshipnames = ["taka61", "poyraz","yıldız", "bezdum","marti61","sevdaluk","kocari", "duman", "narino", "kohle", "zera", "kurubi", "galevera", "karayemus", "civra61"];
fisherman_number = 15;
for i = 1:fisherman_number
   ship(i) = fisherman; 
   ship(i).name = fishingshipnames(i);
%    ship(i).radar_radius = 5;
   ship(i).location = randi([1 N],1,2);
   ship(i) = ship(i).initialcheck(z);
   [ship(i), z] = ship(i).register(z); %61 is the code of the fisherman

end

%Initilize fish schools 
school_number = 70; 
for i = 1:school_number
    school(i) = fish;
    school(i).size = randi([8 25]); 
    school(i).location = randi([25 N-25],1,2);
    school(i) = school(i).initialcheck(z);
    [school(i), z] = school(i).save(z);
end

z.visualize(colorized);


%%
fish_pop_time = zeros(1,Time);
source_time = zeros(1,Time);
fuel_time = zeros(1,Time);

for t = 1:1000
       
    Fish_Population = 0;
    Total_Source = 0;
    Total_Fuel = 0;

   for i = 1:school_number
       [population_sensed,land_dis,bound_dis] = school(i).sense(school(i).location,z);
       [school(i),z.population] = school(i).wander(z.population, land_dis,bound_dis);
       Fish_Population = Fish_Population + school(i).size;
   end

   for i = 1:fisherman_number
       [pop, landscape, distance] = ship(i).radar(ship(i).location,z);

       if sum(any(pop == 11)) > 0  %if there is fish in the radar 
           [ship(i),z.population,school] = ship(i).chase(z.population,distance,school);
       else
           [ship(i),z.population] = ship(i).wander(z.population,distance);
       end
       
       Total_Source = Total_Source + ship(i).source;
       Total_Fuel = Total_Fuel + ship(i).fuel;
           
   end
   
   if mod(t,10) == 0           %give birth at every 10 t. 
       for i = 1:school_number
           school(i) = school(i).birth();
       end
   end

   z.visualize(colorized)
   figure(1);
   title("Fish population: " + string(Fish_Population) + "  Time: " + string(t))
   pause(0.08)
   
   fish_pop_time(t) = Fish_Population;
   source_time(t) = Total_Source;
   fuel_time(t) = Total_Fuel;
%    t

end

%%

figure(2)
plot(1:t-1,fish_pop_time(1:t-1),"LineWidth",2.2)
xlabel("Time")
ylabel("Fish population")
title("Fish  population vs time. If any error occured in simulation, t = " + string(t))

figure(3)
plot(abs(fuel_time(1:t-1)),source_time(1:t-1),"LineWidth",2.2)
ylabel("Gathered Source")
xlabel("Spent Fuel")
title("Fuel-Source Diagram, t = " + string(t))



           
           
%            
%             core = position(away+1:end-away,away+1:end-away);
%             core + position(away:end-away-1,away+1:end-away) + position(away+2:end-away+1,away+1:end-away) + position(away+1:end-away,away:end-away-1) + position(away+1:end-away,away+2:end-away+1);
            
             


