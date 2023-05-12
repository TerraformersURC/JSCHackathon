function animate_hexarocket(st, sp, center_of_mass, center_of_thrust, mass, gravity)
% ANIMATE_HEXAROCKET - Creates an animation of hexarocket flight given the
% output trajectories.
%
% Syntax: animate_hexarocket(ts, ys, p)
% 
% Inputs:
%   ts - Vector of time values, size 1x1000.

desired_path = plot3(sp(:, 1), sp(:, 2), sp(:, 3));

syms t
vs = int(sp, t);
for t=1:100
    if (t ~= 1)
        vs(t) = vs(t) - vs(t-1);
    end
end

as = int(vs)

Fs = mass * (as - gravity); % NOTE change gravity to carry sign

for a=1:100
    F = transpose(Fs(a, :))
    thrust_comps = differential_thrust(F, center_of_mass, center_of_thrust, mass, gravity);
    % NOTE return the arm vectors as well
    mat = [Fs(a, :),Fs(a, :),Fs(a, :),Fs(a, :),Fs(a, :),Fs(a, :)] + thrust_comps;

    Fs(a, :) = mat(1, :) + mat(2, :) + mat(3, :) + mat(4, :) + mat(5, :) + mat(6, :);
end

xs = diff(Fs/mass, 2);
actual_path = plot3(xs(:, 1), xs(:, 2), xs(:, 3))

end