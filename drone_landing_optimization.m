format shortEng

%
% 
%
%
%

syms m_dot t theta

set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Drone Landing Optimization')
xlabel("Distance (m)");
ylabel("Altitude (m)");

% Planet Parameters
g = 3.721; % m/s^2

% Rocket Engine Parameters
Isp = 343;

C = Isp*g; % Effective exhaust velocity

% Drone & Payload Parameters
M = 100000
M_fuel = 10000

M_min = M - M_fuel

x_0 = 0
y_0 = 110

x_f = 100
y_f = 0

t_f = 10;


syms t w_f

params = 2

w_x = rand(params,1) * 10;
w_y = [1,0] %rand(params,1) * 10;

p_x(t) = x_0 + 0*t;
p_y(t) = y_0 + 0*t;

for w_i = drange(1:params) 
    p_y = p_y + w_y(w_i)*t^w_i;
    p_x = p_x + w_x(w_i)*t^w_i;

end

p_x = p_x + solve(x_f==p_x(t_f)+w_f*t_f^(params+1), w_f)*t^(params+1);
p_y = p_y + solve(y_f==p_y(t_f)+w_f*t_f^(params+1), w_f)*t^(params+1);

disp(vpa(p_y))
disp(vpa(p_x))


dirs_x = [-1, -1, -1, -1]
dirs_y = [-1, -1, -1, -1]


hold on
for param = drange(1:params*5)
    prev_perform_x = 0.000001 % probably not reachable
    curr_perform_x = 0.000001
    
    param_ = mod(param-1, params)+1
    
    for r = drange(1:10)
    
        if (prev_perform_x ~= 0.000001)
            if (curr_perform_x > prev_perform_x)
                dirs_x(param_) = -dirs_x(param_)/2
            end
        end

        if (curr_perform_x ~= 0.000001)
            w_x(param_) = w_x(param_) + dirs_x(param_);
        end

        
        % Rebuild Params
        p_x(t) = x_0 + 0*t;
        p_y(t) = y_0 + 0*t;
        
        for w_i = drange(1:params) 
            p_y = p_y + w_y(w_i)*t^w_i;
            p_x = p_x + w_x(w_i)*t^w_i;
        end

        p_x = p_x + solve(x_f==p_x(t_f)+w_f*t_f^(params+1), w_f)*t^(params+1);
        p_y = p_y + solve(y_f==p_y(t_f)+w_f*t_f^(params+1), w_f)*t^(params+1);

        dt = 1;
        M_curr = M;
        x_curr = x_0;
        for t_ = drange(1:10/dt)
            t__ = t_ * dt;
            
            dm = (p_x(t__)-x_curr)*M_curr/(C*dt);
            x_curr = p_x(t__);
            M_curr = M_curr - dm;
        end
    
        prev_perform_x = curr_perform_x;
        curr_perform_x = M - M_curr;    

        disp(vpa(prev_perform_x))
    
    end


    disp(vpa(p_y))
    disp(vpa(p_x))

    dirs_x(param_) = -1;
    dirs_y(param_) = -1;

    t_ = linspace(0, 30)
    xlim([0,200])
    ylim([0,200])
    X = p_x(t_)
    Y = p_y(t_)
    plot(X, Y);
    pause(0.05)
end
