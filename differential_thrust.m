% Differential Thrust equations for hexarocket

% Orientation Matrix
theta = pi/4;
rot_mat = [
    1, 0, 0;
    0, cos(theta), -sin(theta);
    0, sin(theta), cos(theta)
];

% Variables
center_of_mass = rot_mat * [0; 0; 0]; % meters
center_of_thrust = rot_mat * [0; 0; 3]; % meters
cot_offset = center_of_thrust - center_of_mass;

gravity = 3.71;
mass = 10 * 1000; % 90 tons hanging from a string

force_gravity = [0; 0; -gravity * mass]; % Nutons

% Torq Gravity
torq_gravity = cross(force_gravity, cot_offset)

% Arms Representation
syms x
thruster_dist_rot_mat(x) = [
    cos(x), -sin(x), 0;
    sin(x), cos(x), 0;
    0, 0, 1
];
thruster_distance = 14.5; % meters
arm_vecs = rot_mat * [
    [1; 0; 0], ...
    thruster_dist_rot_mat(pi/3) * [1; 0; 0], ...
    thruster_dist_rot_mat(2*pi/3) * [1; 0; 0], ...
    [-1; 0; 0], ...
    thruster_dist_rot_mat(4*pi/3) * [1; 0; 0], ...
    thruster_dist_rot_mat(5*pi/3) * [1; 0; 0]
] * thruster_distance;

% Thruster Torq Direction
thruster_torq_dir = [
    cross(arm_vecs(:,1), cot_offset), ...
    cross(arm_vecs(:,2), cot_offset), ...
    cross(arm_vecs(:,3), cot_offset), ...
    cross(arm_vecs(:,4), cot_offset), ...
    cross(arm_vecs(:,5), cot_offset), ...
    cross(arm_vecs(:,6), cot_offset)
];
% Normalize Thruster Torq Directions
thruster_torq_dir(:, 1) = thruster_torq_dir(:, 1) / norm(thruster_torq_dir(:, 1));
thruster_torq_dir(:, 2) = thruster_torq_dir(:, 2) / norm(thruster_torq_dir(:, 2));
thruster_torq_dir(:, 3) = thruster_torq_dir(:, 3) / norm(thruster_torq_dir(:, 3));
thruster_torq_dir(:, 4) = thruster_torq_dir(:, 4) / norm(thruster_torq_dir(:, 4));
thruster_torq_dir(:, 5) = thruster_torq_dir(:, 5) / norm(thruster_torq_dir(:, 5));
thruster_torq_dir(:, 6) = thruster_torq_dir(:, 6) / norm(thruster_torq_dir(:, 6));

% Torq Thrusters
torq_thrusters = [
    thruster_distance * thruster_torq_dir(:,1), ...
    thruster_distance * thruster_torq_dir(:,2), ...
    thruster_distance * thruster_torq_dir(:,3), ...
    thruster_distance * thruster_torq_dir(:,4), ...
    thruster_distance * thruster_torq_dir(:,5), ...
    thruster_distance * thruster_torq_dir(:,6)
]

% Solve the system
% syms a b c d e g
% solve(-torq_gravity == ...
%     a*torq_thrusters(:,1) + b*torq_thrusters(:,2) + c*torq_thrusters(:,3) + ...
%     d*torq_thrusters(:,4) + e*torq_thrusters(:,5) + g*torq_thrusters(:,6))
%
% Least Squares Problem
% Ax = b
% b = [
%       -torq_gravity;
%       0; 0; 0;
%       0
% ]
% A = [
%       torq_thrusters;
%       [1,0,0,1,0,0]; [0,1,0,0,1,0]; [0,0,1,0,0,1];
%       [0,0,0,1,0,0]
% ]
% (A^T)Ax = (A^T)b
% does not work because ((A^T)A) is not invertable

b = [
    -torq_gravity;
    0; 0; 0;
    0 % lock in one free variable
];
A = [
    torq_thrusters;
    [1,0,0,1,0,0]; [0,1,0,0,1,0]; [0,0,1,0,0,1];
    [0,0,0,1,0,0] % lock in one free variable
]

proj = inv(transpose(A)*A) * transpose(A)*b;
round(proj)

% Minimize free variable manually
b_1 = [
    -torq_gravity;
    0; 0; 0;
    -10 % lock in one free variable
];
b_2 = [
    -torq_gravity;
    0; 0; 0;
    0 % lock in one free variable
];
b_3 = [
    -torq_gravity;
    0; 0; 0;
    100 % lock in one free variable
];
A = [
    torq_thrusters;
    [1,0,0,1,0,0]; [0,1,0,0,1,0]; [0,0,1,0,0,1];
    [0,0,0,1,0,0] % lock in one free variable
]

x_hat_1 = inv(transpose(A)*A) * transpose(A)*b_1;
x_hat_2 = inv(transpose(A)*A) * transpose(A)*b_2;
x_hat_3 = inv(transpose(A)*A) * transpose(A)*b_3;

% Minimize redundant thrust with last pair of free thrusters
x_hat_1_calc = x_hat_1(1) + x_hat_1(2) + x_hat_1(3)
x_hat_2_calc = x_hat_2(1) + x_hat_2(2) + x_hat_2(3)
x_hat_3_calc = x_hat_3(1) + x_hat_3(2) + x_hat_3(3)

x = [-10; 0; 100]
y = [x_hat_1_calc; x_hat_2_calc; x_hat_3_calc]
poly = fit(x,y,'poly2')

min = -poly.p2 / (2 * poly.p3)

% Caclulate the actual thrust
b_final = [
    -torq_gravity;
    0; 0; 0;
    min
];

x_hat_final = round(inv(transpose(A)*A) * transpose(A)*b_final)
