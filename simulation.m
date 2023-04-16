format long

%
%
%
%
%


% Planet Parameters
g = 3.72; % m/s^2

% Rocket Engine Parameters
Isp = 343.0;

C = Isp*g; % Effective exhaust velocity

% Drone & Payload Parameters
M = 100000.0;
M_fuel = 10000.0;

M_min = M - M_fuel;

x_0 = 0.0;
y_0 = 110.0;

x_f = 500.0;
y_f = 0.0;

v_t = 10.0;

% Height of reaching terminal velocity

%a_x = (4*x_f)/t^2
%a = sqrt(g^2+a_x^2)

% ProofOfConcept
a_x = 3.5;
a = (2*a_x)/sqrt(3);
a_y = 0.5*a
t=sqrt((2*y_0)/(g-a_y));
fuel_x = (M*a*t)/(Isp*g)
d_v = (g-a_y)*t
fuel = fuel_x + M*d_v/(Isp*g)
d = (a_x*t^2)/4

% Graph
figure(1);

set(gcf, 'NumberTitle', 'off');
set(gcf, 'Name', 'Fuel Expendature Simulation');
xlabel('Distance (m)')
ylabel('Altitude (m)')

v_x = 0;
v_y = 0;
hold on
dt = 0.1;
for t_ = drange(1:t/dt)
    t__ = t_ * dt;
    if (t__ > t/2)
        x = d/2 - (a_x*(t__-t/2)^2)/2 + a_x*(t/2)*(t__-(t/2));
    else 
        x = (a_x*t__^2)/2;
    end

    y = y_0 - ((g-a_y) * t__^2)/2;

    fuel_x_ = (M*a*t__)/(Isp*g);

    if (fuel_x_ >= 3000)
        plot(x, y, 'r*');
    elseif (fuel_x_ >= 2000)
        plot(x, y, 'y*');
    else
        plot(x, y, 'g*');
    end
    xlim([0, 200]);
    ylim([0, 150]);
    pause(0.5*dt);
end

figure(2)

set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Fuel Depletion Rate')
xlabel('Time (s)')
ylabel('Fuel Remaining (kg)')

v_x = 0;
v_y = 0;
hold on
dt = 0.01;
for t_ = drange(1:t/dt)
    t__ = t_*dt;
    if (t__ > t/2)
        x = d/2 - (a_x*(t__-t/2)^2)/2 + a_x*(t/2)*(t__-(t/2));
    else 
        x = (a_x*t__^2)/2;
    end

    y = y_0 - ((g-a_y) * t__^2)/2;

    fuel_x_ = (M*a*t__)/(Isp*g);

    plot(t__, M_fuel-fuel_x_, 'r.')
    xlim([0, t])
    ylim([0, M_fuel])
    pause(0.5*dt)
end
