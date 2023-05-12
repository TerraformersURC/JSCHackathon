g = 3.71; % m/s^2

mUAV = 10; % T
dC = 3; % m, dist upwards cM to cT
aInc = pi/2; % rad, inclination of propellers
r = 14.5; % m, radius of propellers
aYaw = 0; % rad, roll position

Tg = mUAV * g * dC * sin(aInc); % torque from gravity

dT = Tg/(2);

y1 = r * sin(aYaw);
y2 = r * sin(aYaw+pi/3);
y3 = r * sin(aYaw+2*pi/3);
x1 = r * cos(aYaw);
x2 = r * cos(aYaw+pi/3);
x3 = r * cos(aYaw+2*pi/3);

M = [y2 y3; x2 x3]
c1 = [dT; 0]
s1 = M\c1

c21 = dT/1.5;
c22 = -dT/3;
c2 = [c21; c22];
s2 = M\c2;

c31 = dT/2;
c32 = -dT/2;
c3 = [c31; c32];
s3 = M\c3;

mp21 = (dT/3)^2;
mp22 = (dT/3);
mp31 = (dT/2)^2;
mp32 = (dT/2);
Mp = [0 0 1; mp21 mp22 1; mp31 mp32 1];
cp1 = s1(1)^2 + s1(2)^2;
cp2 = s2(1)^2 + s2(2)^2 + (dT/3)^2;
cp3 = s3(1)^2 + s3(2)^2 + (dT/2)^2;
cp = [cp1; cp2; cp3];
p = Mp\cp;

x = -p(2) / 2 / p(1);
c41 = dT-x; 
c42 = -x;
c4 = [c41; c42];
s4 = M\c4;

% s4(end + 1) = x; 
s4 = [x, s4(1), s4(2)] 
s5 = -1 * s4;

dT*r
% sum = s4(1) + s4(2) + s4(3):
[s4 s5]

% syms x;
% 
% c1(x) = dT - x * c2;
% f1(x) = - x * c2;
% 
% Ct1(x) = (c1 - b1*( (a1 * f1 - c1 * d1) / (a1 * e1 - b1 * d1) )) / a1;
% Ct2(x) = (a1 * f1 - c1 * d1) / (a1 * e1 - b1 * d1);
% Ct3(x) = -x;
% 
% y(x) = Ct1^2 + Ct2^2 + Ct3^2;
% 
% fplot(y)

