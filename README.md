# Write-up

# Rocket Engine:

## Thrust calculations for each arm:

$$
F_t = \frac{Mg_{mars} s_f}{6} = \frac{100000kg*3.72\frac{m}{s^2}*2}{6} = 124kN
$$

Where:

$s_f = 2$ - safety factor, which makes sure that we can lift the whole system with with half of the engines 

## Rutherford Engine Specification

$I_{sp}$ = 343 -  in vacuum

$F_{thrust} = 25 kN$

Fuel: **RP-1**

Oxidizer: **LOX** 

Electrical pumps

### Number of engines:

$$
\frac{124kN}{25kN} \approx 5
$$

# Structural Load Calculations

# Fuel Calculations

$$
I_{sp} = \frac{I}{\Delta m_{propellant}g}\\ \\\Delta m_{propellant} \approx \frac{Mat}{I{sp}*g}
$$

We don’t include changing mass in impulse calculations, as we’re calculating the upper bounds of the fuel usage

### Fuel simulation results:

$$
\Delta m_{proppellant} = 5.11 t
$$

For the initial height $h_0 = 110m$ and horizontal distance traveled $d = 113m$

# Rocket Simulation Equations

$M$ - Total mass

$C$ - Effective exhaust velocity

$\dot{m}$ - Fuel flow rate

## Force Decomposition

$$
F_x = F_{thruster}\sin{\theta
} \\
F_y = F_{thruster}\cos{\theta
}
$$

## Position

$$
v(t) = \sqrt{v_x(t)^2+v_y(t)^2}
$$

### x - direction

$$
\Delta v_x = C\ln(\frac{m_0}{M})sin(\theta)
 \\
v_x(t) = C\ln(\frac{M-\dot{m}t}{M})sin(\theta) + v_{x0}
$$

$$
x(t)=Csin(\theta)((t-\frac{M}{\dot{m}})\ln(1-\frac{\dot{m}t}{M})-t)+v_{xo}t+x_0
$$

### y - direction

$$
\Delta v_y = C\ln(\frac{m_0}{M})cos(\theta) - gt
 \\
v(t)_y = C\ln(\frac{M-\dot{m}t}{M})cos(\theta) + v_{y0}-gt
$$

$$
y(t)=Ccos(\theta)((t-\frac{M}{\dot{m}})\ln(1-\frac{\dot{m}t}{M})-t)-\frac{gt^2}{2}+v_{y0}+y_0
$$

# Optimization

    To determine the ideal path for the vehicle to travel to the ground we designed and ran a regression simulation to optimize a parametric equation. The equation trained on the fuel lost over each leg of a progressively more optimized journey.

### Algorithm

```jsx
w_x = [x_0, w_1, w_2, ..., w_f]  // Weight final ensures that x_final is hit
w_y = [y_0, y_1, y_2, ..., y_f]  // Weight final ensures that y_final is hit

The target varible is the fuel usage
```

# Drivers

### 6-copter rotation driver

Because of the layout of our thrusters in a hexagonal shape, we wanted with time to develop a clean solution for fully utilizing the thrusters for any maneuver. For that reason we developed the mapping from $(x, y) \mapsto (x, \lambda, \delta)$ where lambda and delta are the decomposition of a y-axis. We arrived at the Pseudo Inverse Matrix:

$$
A^+=\begin{bmatrix}
2/5 & 0 \\
\sqrt{3}/5 & 1 \\
\sqrt{3}/5 & 1
\end{bmatrix}
$$

This defines a space for any rotations to manipulate and to unify the Thrust vectors of all 6 nozzles into a manageable platform that behaves as if it were a single gimbled thrust platform. This should allow for complete and clean control of any 6-copter.