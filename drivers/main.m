% Orientation Matrix
theta_pitch = pi/4;
rot_mat_pitch = [
    1, 0, 0;
    0, cos(theta_pitch), -sin(theta_pitch);
    0, sin(theta_pitch), cos(theta_pitch)
];

theta_yaw = pi;
rot_mat_yaw = [
    cos(theta_yaw), 0, sin(theta_yaw);
    0, 1, 0;
    -sin(theta_yaw), 0, cos(theta_yaw)
];

rot_mat = rot_mat_yaw * rot_mat_pitch; 

% Variables
center_of_mass = rot_mat * [0; 0; 0]; % meters
center_of_thrust = rot_mat * [0; 0; 3]; % meters

gravity = 3.71;
mass = 10 * 1000; % 90 tons hanging from a string

F = rot_mat*[0;0;1]

x_hat = differential_thrust(F, center_of_mass, center_of_thrust, gravity, mass)

disp("End of POC")
% Animation

% Utils
syms x
rot_mat_pitch = [
    1, 0, 0;
    0, cos(x), -sin(x);
    0, sin(x), cos(x)
];

rot_mat_yaw = [
    cos(x), 0, sin(x);
    0, 1, 0;
    -sin(x), 0, cos(x)
];

% Pseudo Random Number Generator Variables
a = 21
m = 11
b = 1

% Series

% Time Series
st = zeros(100, 1, 1);
% Position pairs
sp = zeros(100, 3);
for a=1:100
    st(a) = a;
    sp(a, :) = [sin(a * pi/20); cos(a * pi/20); a];
end

animate_hexarocket(st, sp, center_of_mass, center_of_thrust, mass, gravity);
