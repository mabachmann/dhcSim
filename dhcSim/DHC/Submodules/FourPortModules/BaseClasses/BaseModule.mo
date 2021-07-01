within dhcSim.DHC.Submodules.FourPortModules.BaseClasses;
partial model BaseModule
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance" annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Integer nSpl1(min=1)
    "Number of splitters between port_a1 and port_b1";
  parameter Integer nSpl2(min=1)
    "Number of splitters between port_a2 and port_b2";

  // Initialization
  parameter Medium.AbsolutePressure p_start_1=Medium.p_default
    "Start value of pressure" annotation (Dialog(tab="Initialization", group="Side 1"));
  parameter Medium.Temperature T_start_1=Medium.T_default
    "Start value of temperature" annotation (Dialog(tab="Initialization", group="Side 1"));
  parameter Medium.MassFraction X_start_1[Medium.nX](quantity=Medium.substanceNames)=
       Medium.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group="Side 1", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start_1[Medium.nC](quantity=Medium.extraPropertiesNames)=
       fill(0, Medium.nC) "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group="Side 1", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal_1[Medium.nC](quantity=Medium.extraPropertiesNames)=
       fill(1E-2, Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
    annotation (Dialog(tab="Initialization", group="Side 1",enable=Medium.nC > 0));
  parameter Medium.AbsolutePressure p_start_2=Medium.p_default
    "Start value of pressure" annotation (Dialog(tab="Initialization", group="Side 2"));
  parameter Medium.Temperature T_start_2=Medium.T_default
    "Start value of temperature" annotation (Dialog(tab="Initialization", group="Side 2"));
  parameter Medium.MassFraction X_start_2[Medium.nX](quantity=Medium.substanceNames)=
       Medium.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group="Side 2", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start_2[Medium.nC](quantity=Medium.extraPropertiesNames)=
       fill(0, Medium.nC) "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group="Side 2", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal_2[Medium.nC](quantity=Medium.extraPropertiesNames)=
       fill(1E-2, Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
    annotation (Dialog(tab="Initialization", group="Side 2",enable=Medium.nC > 0));

  Buildings.Fluid.FixedResistances.Junction[nSpl2] spl2(
    redeclare each final package Medium = Medium,
    each final from_dp=from_dp,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start_2,
    each final T_start=T_start_2,
    each final X_start=X_start_2,
    each final C_start=C_start_2,
    each final C_nominal=C_nominal_2,
    each final deltaM=deltaM,
    each final tau=tau,
    each final linearized=linearizeFlowResistance,
    each final m_flow_nominal={100,100,100},
    each final dp_nominal={1,1,1},
    each final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional) if
       use_spl2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-60})));

  Buildings.Fluid.FixedResistances.Junction[nSpl1] spl1(
    redeclare each final package Medium = Medium,
    each final from_dp=from_dp,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start_1,
    each final T_start=T_start_1,
    each final X_start=X_start_1,
    each final C_start=C_start_1,
    each final C_nominal=C_nominal_1,
    each final deltaM=deltaM,
    each final tau=tau,
    each final linearized=linearizeFlowResistance,
    each final m_flow_nominal={100,100,100},
    each final dp_nominal={1,1,1},
    each final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional) if
       use_spl1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,60})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-90,50},{-110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium)
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));
protected
  constant Boolean use_spl1=true;
  constant Boolean use_spl2=true;
equation
  if use_spl1 then
    connect(port_a1, spl1[1].port_1) annotation (Line(points={{100,60},{56,60},{10,60}}, color={0,127,255}));
    for i in 1:nSpl1 - 1 loop
      connect(spl1[i].port_2, spl1[i+1].port_1) annotation (Line(points={{-10,60},{-20,
          60},{-20,80},{20,80},{20,60},{10,60}}, color={0,127,255}));
    end for;
    connect(spl1[nSpl1].port_2, port_b1) annotation (Line(points={{-10,60},{-56,60},{-100,60}}, color={0,127,255}));
  else
    connect(port_a1, port_b1);
  end if;
  if use_spl2 then
    connect(port_a2, spl2[1].port_1) annotation (Line(points={{100,-60},{56,-60},{10,-60}}, color={0,127,255}));
    for i in 1:nSpl2 - 1 loop
      connect(spl2[i].port_2, spl2[i+1].port_1) annotation (Line(points={{-10,-60},{
          -10,-60},{-20,-60},{-20,-80},{20,-80},{20,-60},{10,-60}},
        color={0,127,255}));
    end for;
    connect(spl2[nSpl2].port_2, port_b2) annotation (Line(points={{-10,-60},{-100,
            -60}},                                                                                  color={0,127,255}));
  else
    connect(port_a2, port_b2);
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(graphics={
        Rectangle(
          extent={{-100,50},{100,70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-50},{100,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end BaseModule;
