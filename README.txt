% README.txt

Spring-Wing simulation
In order to break down the important elements of spring-wing dynamics, we need a framework that enables us to quickly swap out and compare different versions of the model. In general,

Where  is the inertia of the system, which may be a function of time,  is the drag function (aero, viscous, friction, structural, etc.),  is the elasticity function (linear spring, hardening or softening spring, etc.), and  is the force applied to the system, which may be a function of the state and/or time.
I'd like to write a function that allows us to specify each of those functions - , , ,  - explicitly to maintain some consistency.