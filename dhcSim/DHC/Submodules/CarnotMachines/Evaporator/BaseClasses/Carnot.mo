within dhcSim.DHC.Submodules.CarnotMachines.Evaporator.BaseClasses;
partial model Carnot
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(final show_T=true);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics", group="Evaporator and condenser"));

  // Efficiency
  parameter Real etaCarnot_nominal(unit="1")=0.5
    "Carnot effectiveness (=COP/COP_Carnot)"
    annotation (Dialog(group="Efficiency"));
  parameter Boolean use_TCon_in=false "=true to use TCon_in port";
  parameter Boolean use_Q_flow_in=false "=true to use QLoad port";
  parameter Modelica.SIunits.Temperature TCon=Medium.T_default
    "Condenser temperature used to compute efficiency" annotation(Dialog(enable=not use_TCon_in));
  parameter Modelica.SIunits.HeatFlowRate QLoad=0.0 "Constant thermal load" annotation (Dialog(enable=not use_Q_flow_in));
  parameter dhcSim.Fluid.Types.OutletTemperature effInpEva=dhcSim.Fluid.Types.OutletTemperature.gradient
    "Define evaporator temperature"
    annotation (Dialog(group="Efficiency"), Evaluate=True);
  parameter Modelica.SIunits.Temperature TGrad(displayUnit="K")=6
    "Temperature gradient" annotation(Dialog(group="Efficiency", enable=effInpEva
           == dhcSim.Fluid.Types.OutletTemperature.gradient));
  final parameter Modelica.SIunits.SpecificEnthalpy deltah=cp_default*m_flow_small*
      0.01 "Small value for deltah used for regularization";

  //Other
    parameter Modelica.SIunits.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));
  Modelica.SIunits.Temperature TEva(start=T_start)=
    if effInpEva ==dhcSim.Fluid.Types.OutletTemperature.port_b    then
      Medium.temperature(sta_b)
    elseif effInpEva ==dhcSim.Fluid.Types.OutletTemperature.gradient    then
      Medium.temperature(sta_a) - TGrad
    else 0.5*(Medium.temperature(sta_a) + Medium.temperature(sta_b))
    "Evaporator temperature";
  Real COP(
    min=0,
    final unit="1") = min(etaCarnot_nominal*COPCar, 8)
    "Coefficient of performance";
  Real COPCar(min=0) = TCon_internal/dhcSim.Utilities.Math.Functions.smoothMax(
    x1=1,
    x2=TCon_internal - TEva,
    deltaX=0.25) "Carnot efficiency";

  Modelica.SIunits.MassFlowRate m_flow_calc "Mass flow rate of participant";
  Modelica.SIunits.SpecificEnthalpy hIn "Spec. inlet enthalpy";
  Modelica.SIunits.HeatFlowRate Q_flow_abs "Actual heat flow rate";
  Modelica.SIunits.SpecificEnthalpy hEva = Medium.specificEnthalpy(
    state=Medium.setState_pTX(
      p=port_a.p,
      T=TEva,
      X=inStream(port_a.Xi_outflow))) "Spec. condensator outlet enthalpy";
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSource(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final control_m_flow=true,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    show_V_flow=false)
    annotation (Placement(transformation(extent={{-60,70},{-40,50}})));
  Modelica.Blocks.Sources.RealExpression m_in(y=m_flow_calc)
                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,40})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T eva(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final tau=tau) "Evaporator"
    annotation (Placement(transformation(extent={{-10,70},{10,50}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow_out(final quantity=
        "HeatFlowRate", final unit="W") "Actual heating heat flow rate"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealOutput P_out(final quantity="Power", final
      unit="W") "Electric power consumed by compressor" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent=
           {{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow_out(final quantity=
        "HeatFlowRate", final unit="W") "Actual cooling heat flow rate"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealInput TCon_in(unit="K") if use_TCon_in annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Modelica.Blocks.Interfaces.RealInput QLoad_in(unit="W") if use_Q_flow_in "Heat load" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
protected
  Modelica.Blocks.Sources.RealExpression PEle "Electrical power consumption"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.RealExpression TSet(y=TEva)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Modelica.Blocks.Interfaces.RealInput TCon_internal(unit="K");
  Modelica.Blocks.Interfaces.RealInput QLoad_internal(unit="W");
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";
equation
  connect(TCon_in, TCon_internal);
  connect(QLoad_in, QLoad_internal);
  if not use_Q_flow_in then
    QLoad_internal = QLoad;
  end if;
  if not use_TCon_in then
    TCon_internal = TCon;
  end if;
  Q_flow_abs = abs(QLoad_internal);
  hIn = noEvent(inStream(port_a.h_outflow));

  connect(PEle.y, P_out) annotation (Line(points={{-69,0},{-20,0},{-20,-60},{0,
          -60},{0,-60},{110,-60},{110,-60}}, color={0,0,127}));
  connect(m_in.y,idealSource. m_flow_in)
    annotation (Line(points={{-69,40},{-56,40},{-56,52}},   color={0,0,127}));
  connect(idealSource.port_b, eva.port_a)
    annotation (Line(points={{-40,60},{-25,60},{-10,60}}, color={0,127,255}));
  connect(TSet.y, eva.TSet) annotation (Line(points={{-69,20},{-48,20},{-20,20},
          {-20,52},{-12,52}}, color={0,0,127}));
  connect(idealSource.port_a, port_a) annotation (Line(points={{-60,60},{-72,60},
          {-100,60},{-100,0}}, color={0,127,255}));
  connect(eva.port_b, port_b)
    annotation (Line(points={{10,60},{100,60},{100,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(graphics={Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360),Rectangle(
          extent={{-57,9},{57,-9}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={1,59},
          rotation=360),Rectangle(
          extent={{-57,9},{57,-9}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={1,-61},
          rotation=360),Rectangle(
          extent={{-70,5},{70,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={0,59},
          rotation=360),Rectangle(
          extent={{-70,5},{70,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={0,-61},
          rotation=360),Rectangle(
          extent={{-35,-5},{35,5}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={35,59},
          rotation=360),Rectangle(
          extent={{-2,20},{2,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={40,30},
          rotation=360),Rectangle(
          extent={{-2,20},{2,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={40,-32},
          rotation=360),Rectangle(
          extent={{-2,51},{2,-51}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-38,-1},
          rotation=360),Ellipse(
          extent={{-22,-22},{22,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-38,0},
          rotation=360),Polygon(
          points={{0,-18},{-18,16},{18,16},{0,-18}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-38,-4},
          rotation=360),
                  Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255}),
          Line(points={{70,-30},{100,-30}},
                                         color={0,0,255}),Rectangle(
          extent={{-35,-5},{35,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-35,-61},
          rotation=360),Polygon(
          points={{0,6},{-10,-6},{10,-6},{0,6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={40,-6},
          rotation=360),Polygon(
          points={{0,-5},{-10,7},{10,7},{0,-5}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={40,5},
          rotation=360),
          Line(points={{70,-60},{100,-60}},
                                         color={0,0,255})}));
end Carnot;
