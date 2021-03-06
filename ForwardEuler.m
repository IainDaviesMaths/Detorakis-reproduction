function [V,theta,spikes] = ForwardEuler( a, A1, A2, V0, theta0, Iext )
%FORWARDEULER solves for the membrane potential, threshold
%potential and the positions of the spikes.

%Parameters
k1=0.2; k2=0.02;
G=0.05; E=-70;
b=0.01;
thetainf=-50;
Vr=-70;
thetar=-60;
R1=0; R2=1;

%Spikes
spikes=zeros(1,2);
count=1;

%Forward Euler Integration
numtimesteps=length(Iext)-1;
dt=0.01;

%State variables
V=zeros(1,numtimesteps+1);
theta=zeros(1,numtimesteps+1);
I1=zeros(1,numtimesteps+1);
I2=zeros(1,numtimesteps+1);

%Initial Conditions
V(1)=V0;
theta(1)=theta0;
I1(1)=0.010;
I2(1)=0.001;

%Evolve initial conditions
for time=1:numtimesteps
    I1(time+1)=I1(time)+dt*(-k1*I1(time));
    I2(time+1)=I2(time)+dt*(-k2*I2(time));
    V(time+1)=V(time)+dt*(Iext(time)+I1(time)+I2(time)-G*(V(time)-E));
    theta(time+1)=theta(time)+dt*(a*(V(time)-E)-b*(theta(time)-thetainf));
    
    if V(time+1)>=theta(time+1)
        %Neuron has spiked - record position of spike.
        spikes(count,1)=time*0.00001;
        spikes(count,2)=V(time);
        count=count+1;
        
        %Update the state variables according to the update rules.
        V(time+1)=Vr;
        theta(time+1)=max(theta(time+1),thetar);
        I1(time+1)=R1*I1(time+1)+A1;
        I2(time+1)=R2*I2(time+1)+A2;
    end
end


end

