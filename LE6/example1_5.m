%Matlab code for example 1-5, Heat transfer
A = 6*8; 
T_in = 15; %C
T_out = 4; %C
L = 0.25; %m
delta_t = 10; %h
EL_c = 0.08; %$/kWh
 
k = 0.8; %W/m*C 
Q_dot = k*A*(T_in-T_out)/L; 
Q = (Q_dot/1000)*delta_t; %/1000 converts W to kW
Cost = Q*EL_c; %$

%Part a
EL_c_a = linspace(0.02, 2, 100); %$/kWh
Cost_a = Q.*EL_c_a; %$

figure (1);
plot (EL_c_a, Cost_a);
title('Example 1-5')
xlabel('Electricity cost ($/kWh)')
ylabel('Cost ($)')

%Part b
k_b = linspace(0.5, 5, 100); 
Q_dot_b = k_b.*A*(T_in-T_out)/L; 
Q_b = (Q_dot_b./1000)*delta_t; %/1000 converts W to kW
Cost_b = Q_b*EL_c; %$

figure (2);
plot (k_b, Cost_b);
title('Example 1-5')
xlabel('thermal Conductivity (W/m.K)')
ylabel('Cost ($)')




