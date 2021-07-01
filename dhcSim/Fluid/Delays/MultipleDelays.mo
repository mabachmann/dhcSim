within dhcSim.Fluid.Delays;
model MultipleDelays
  extends Buildings.BaseClasses.BaseIcon;
  extends dhcSim.Fluid.Interfaces.LumpedMultiVolumeDeclarations(final mSenFac=1);
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.SIunits.MassFlowRate mDyn_flow_nominal
    "Nominal mass flow rate for dynamic momentum and energy balance"
    annotation (Dialog(
      tab="Dynamics",
      group="Equations",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  // Port definitions
  parameter Integer nPorts=0 "Number of ports" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));
  Buildings.Fluid.Delays.DelayFirstOrder[nLev] del(
    redeclare each final package Medium = Medium,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    each final use_C_flow=false,
    each final m_flow_nominal=mDyn_flow_nominal,
    each final m_flow_small=1E-4*abs(mDyn_flow_nominal),
    each final tau=tau,
    each final allowFlowReversal=allowFlowReversal,
    each final nPorts=nPorts)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b[nLev, nPorts] ports(
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}}, origin={0,
            -100})));
equation
  for i in 1:nLev loop
    for j in 1:nPorts loop
      connect(del[i].ports[j], ports[i, j]);
    end for;
  end for;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}),Text(
          extent={{-72,24},{68,-16}},
          lineColor={0,0,0},
          textString="tau=%tau")}));
end MultipleDelays;
