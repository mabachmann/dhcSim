within dhcSim.DHC.Submodules.CarnotMachines.Condenser.BaseClasses;
partial model Carnot_dp

  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(final show_T=true);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  Modelica.SIunits.HeatFlowRate Q_flowEva "Heat flow of evaporator";
  Modelica.SIunits.HeatFlowRate Q_flowCon "Heat flow of condensator";
  Modelica.SIunits.Power PEl "Electrical Power";

  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics", group="Evaporator and condenser"));

  // Efficiency
  parameter Real etaCarnot_nominal(unit="1")=0.5
    "Carnot effectiveness (=COTEvaP/COP_Carnot)"
    annotation (Dialog(group="Efficiency"));
  parameter Boolean use_TEva_in=false "=true to use TEva_in port";
  parameter Boolean use_TCon_in=false "=true to use TEva_in port";
  parameter Modelica.SIunits.Temperature TEvaSet(displayUnit="K")=Medium.T_default
    "Evaporator temperature used to compute efficiency" annotation(Dialog(enable=not use_TEva_in));
  parameter Modelica.SIunits.Temperature TConSet(displayUnit="K")=Medium.T_default
    "Evaporator temperature used to compute efficiency" annotation(Dialog(enable=not use_TCon_in));
  parameter dhcSim.Fluid.Types.OutletTemperature effInpCon=dhcSim.Fluid.Types.OutletTemperature.gradient
    "Define condensator temperature"
    annotation (Dialog(group="Efficiency"), Evaluate=True);
  parameter Modelica.SIunits.Temperature TGrad(displayUnit="K")=6
    "Temperature gradient" annotation(Dialog(group="Efficiency", enable=effInpCon
           == dhcSim.Fluid.Types.OutletTemperature.gradient));

  //Other
    parameter Modelica.SIunits.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

   Modelica.SIunits.Temperature TCon(start=T_start) "Condensator temperature";
   Modelica.SIunits.Temperature TEva(start=T_start) "Evaporator  temperature";

  Real COP(
    min=0,
    final unit="1") = min(etaCarnot_nominal*COPCar, 8)
    "Coefficient of performance";
  Real COPCar(min=0) = TEva_internal/dhcSim.Utilities.Math.Functions.smoothMax(
    x1=1,
    x2=TCon - TEva_internal,
    deltaX=0.25) "Carnot efficiency";

  Modelica.SIunits.SpecificEnthalpy hIn "Spec. inlet enthalpy";
  Modelica.SIunits.SpecificEnthalpy hCon = Medium.specificEnthalpy(
    state=Medium.setState_pTX(
      p=port_a.p,
      T=TCon,
      X=inStream(port_a.Xi_outflow))) "Spec. condensator outlet enthalpy";
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSource(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final control_m_flow=false,
    final control_dp=true,
    final m_flow_small=m_flow_small,
    final show_T=show_T)
    annotation (Placement(transformation(extent={{-60,70},{-40,50}})));
  Buildings.Fluid.HeatExchangers.Heater_T con(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=false,
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final tau=tau) "Condensator"
    annotation (Placement(transformation(extent={{-10,70},{10,50}})));
    //final homotopyInitialization=homotopyInitialization
  Modelica.Blocks.Interfaces.RealOutput QCon_flow_out(final quantity=
        "HeatFlowRate", final unit="W") "Actual heating heat flow rate"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput P_out(final quantity="Power", final
      unit="W") "Electric power consumed by compressor" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent=
           {{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow_out(final quantity=
        "HeatFlowRate", final unit="W") "Actual cooling heat flow rate"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealInput TEva_in(unit="K") if use_TEva_in annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Modelica.Blocks.Interfaces.RealInput dp_in(unit="Pa")
    "pressure difference"                                                                        annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealInput TCon_in(unit="K") if use_TCon_in
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));
protected
  Modelica.Blocks.Sources.RealExpression PEle "Electrical power consumption"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.RealExpression TSet(y=TCon)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Interfaces.RealInput TEva_internal(unit="K");
  Modelica.Blocks.Interfaces.RealInput TCon_internal(unit="K");
  parameter Modelica.SIunits.SpecificEnthalpy deltah=cp_default*m_flow_small*
      0.01 "Small value for deltah used for regularization";
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity at default medium state";
equation
  connect(TEva_in, TEva_internal);
  connect(TCon_in, TCon_internal);
  if not use_TEva_in then
    TEva_internal = TEvaSet;
  end if;
  if not use_TCon_in then
    TCon_internal = TConSet;
  end if;

  hIn = noEvent(inStream(port_a.h_outflow));

  if use_TCon_in then
    TCon = TCon_internal;
  else
    if effInpCon == dhcSim.Fluid.Types.OutletTemperature.port_b then
      TCon = Medium.temperature(sta_b);
    elseif effInpCon == dhcSim.Fluid.Types.OutletTemperature.gradient then
      TCon = Medium.temperature(sta_a) + TGrad;
    elseif effInpCon == dhcSim.Fluid.Types.OutletTemperature.prescribed then
      TCon = TCon_internal;
    else
      TCon = 0.5*(Medium.temperature(sta_a) + Medium.temperature(sta_b));
    end if;
  end if;

  TEva = TEva_internal;

  connect(PEle.y, P_out) annotation (Line(points={{-69,0},{-20,0},{-20,-60},{
          110,-60}}, color={0,0,127}));
  connect(idealSource.port_b, con.port_a) annotation (Line(points={{-40,60},{-26,
          60},{-10,60}},                                                               color={0,127,255}));
  connect(TSet.y, con.TSet) annotation (Line(points={{-69,20},{-20,20},{-20,52},
          {-12,52}}, color={0,0,127}));
  connect(port_a, idealSource.port_a)
    annotation (Line(points={{-100,0},{-100,0},{-100,60},{-60,60}},
                                                           color={0,127,255}));
  connect(con.port_b, port_b) annotation (Line(points={{10,60},{100,60},{100,0}},
                    color={0,127,255}));
  connect(dp_in, idealSource.dp_in) annotation (Line(points={{0,-120},{0,-80},{-44,
          -80},{-44,52}}, color={0,0,127}));
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
          extent={{-57,5},{57,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
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
          extent={{-28,-5},{28,5}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-28,-61},
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
          extent={{-22,22},{22,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={40,0},
          rotation=360),Polygon(
          points={{0,18},{-18,-16},{18,-16},{0,18}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={40,4},
          rotation=360),
                  Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255}),
          Line(points={{70,-30},{100,-30}},
                                         color={0,0,255}),Rectangle(
          extent={{-35,-5},{35,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={35,59},
          rotation=360),Polygon(
          points={{0,6},{-10,-6},{10,-6},{0,6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-38,-6},
          rotation=360),Polygon(
          points={{0,-5},{-10,7},{10,7},{0,-5}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-38,5},
          rotation=360),
          Line(points={{70,-60},{100,-60}},
                                         color={0,0,255})}));
end Carnot_dp;
