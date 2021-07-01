within dhcSim.Fluid.Interfaces;
record LumpedMultiVolumeDeclarations "Declarations for multiple lumped volumes"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);
  parameter Integer nLev(min=2) = 2 "Number of grid levels";
  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=
      energyDynamics
    "Type of independent mass fraction balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Type of trace substance balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics", group="Equations"));
  // Initialization
  parameter Modelica.SIunits.AbsolutePressure[nLev] p_start=fill(Medium.p_default,
      nLev) "Start value of pressure" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature[nLev] T_start=fill(Medium.T_default,
      nLev) "Start value of temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.MassFraction[nLev, Medium.nX] X_start(quantity=Medium.substanceNames)=
       fill(Medium.X_default, nLev) "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty[nLev, Medium.nC] C_start(quantity=Medium.extraPropertiesNames)=
       fill(
    0,
    nLev,
    Medium.nC) "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty[nLev, Medium.nC] C_nominal(quantity=Medium.extraPropertiesNames)=
       fill(
    1E-2,
    nLev,
    Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
    annotation (Dialog(tab="Initialization",enable=Medium.nC > 0));
  final parameter Medium.SpecificEnthalpy[nLev] h_start=Medium.specificEnthalpy(
      state=Medium.setState_pTX(
      p=p_start,
      T=T_start,
      X=X_start));
  parameter Real mSenFac(min=1) = 1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation (Dialog(tab="Dynamics"));
  annotation (preferredView="info", Documentation(info="<html>
<p>
This class contains parameters and medium properties
that are used in the lumped  volume model, and in models that extend the
lumped volume model.
</p>
<p>
These parameters are used by
<a href=\"modelica://dhcSim.Fluid.Interfaces.ConservationEquation\">
dhcSim.Fluid.Interfaces.ConservationEquation</a>,
<a href=\"modelica://dhcSim.Fluid.MixingVolumes.MixingVolume\">
dhcSim.Fluid.MixingVolumes.MixingVolume</a>,
<a href=\"modelica://dhcSim.Rooms.MixedAir\">
dhcSim.Rooms.MixedAir</a>, and by
<a href=\"modelica://dhcSim.Rooms.BaseClasses.MixedAir\">
dhcSim.Rooms.BaseClasses.MixedAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>quantity=Medium.substanceNames</code> for <code>X_start</code>.
</li>
<li>
October 21, 2014, by Filip Jorissen:<br/>
Added parameter <code>mFactor</code> to increase the thermal capacity.
</li>
<li>
August 2, 2011, by Michael Wetter:<br/>
Set <code>substanceDynamics</code> and <code>traceDynamics</code> to final
and equal to <code>energyDynamics</code>,
as there is no need to make them different from <code>energyDynamics</code>.
</li>
<li>
August 1, 2011, by Michael Wetter:<br/>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</code> because
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code> leads
to high order DAE that Dymola cannot reduce.
</li>
<li>
July 31, 2011, by Michael Wetter:<br/>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code>.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LumpedMultiVolumeDeclarations;
