within dhcSim.DHC.Submodules.TwoPortModules;
model ActiveStorage "Active storage in district heating grid"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter Integer nSeg(min=1) = 10 "Number of volume segments";
  parameter Modelica.SIunits.Length thicknessIns = 0.1 "Thickness of insulation";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns = 0.05
    "Heat conductivity of insulation";
  parameter Modelica.SIunits.Length diameter = 1
    "Pipe diameter (without insulation)";
  parameter Modelica.SIunits.Volume volume = 1 "Volume of storage tank";
  parameter Modelica.SIunits.Time tau=1
    "Time constant at nominal flow for dynamic energy and momentum balance" annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  parameter Modelica.SIunits.TemperatureDifference dT_up_min = 5 "Discharging: minimum temperature difference between supply set temperature and actual supply temperature were discharging is still possible";
  parameter Modelica.SIunits.TemperatureDifference dT_lo_min = 5 "Charging: minimum temperature difference between incomming temperature and lower storage temperature until discharging is still possible";

  parameter Modelica.SIunits.TemperatureDifference dT_small = 0.5 "Minimum temperature difference to compute storage mass flow rate. Used to negleced deviation by zero";

  Modelica.SIunits.Temperature T_sto_up "Upper storage temperature";
  Modelica.SIunits.Temperature T_sto_lo "Lower storage temperature";
  Modelica.SIunits.Temperature T_sto_up_in "Upper incomming storage temperature (charging)";
  Modelica.SIunits.Temperature T_sto_lo_in "Lower incomming storage temperature (discharging)";

  Modelica.SIunits.MassFlowRate m_flow_sto "Mass flow rate of storage";

  Modelica.SIunits.HeatFlowRate Q_flow_actual "Actual heat flow rate of storage";
  Modelica.SIunits.HeatFlowRate Q_flow_residual "Residual heat flow rate of storage (Q_flow_sto_in - Q_flow_actual)";

protected
  parameter Modelica.SIunits.Length length= 4*volume/Modelica.Constants.pi/diameter/diameter  "Length of the pipe";
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_default = Medium.specificHeatCapacityCp(state_default) "default specific heat capacity";


  Medium.ThermodynamicState state_upper=Medium.setState_pTX(
      p=port_a.p,
      T=noEvent(senTem_in_up.T),
      X=noEvent(inStream(port_a.Xi_outflow))) "Upper storage state";

  Medium.ThermodynamicState state_lower=Medium.setState_pTX(
      p=port_b.p,
      T=noEvent(senTem_in_lo.T),
      X=noEvent(inStream(port_b.Xi_outflow))) "Lower storage state";


public
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final control_m_flow=true,
    final control_dp=false,
    final m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_sto_upper_out(unit="K") annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-110}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-70})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final replaceable package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearized=linearizeFlowResistance,
    final deltaM=deltaM)
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  Buildings.Fluid.FixedResistances.Pipe sto(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final from_dp=from_dp,
    final dp_nominal=sto.dpStraightPipe_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final nSeg=nSeg,
    final thicknessIns=thicknessIns,
    final lambdaIns=lambdaIns,
    final diameter=diameter,
    final length=length,
    final useMultipleHeatPorts=true)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nSeg]
    "Multiple heat ports that connect to outside of storage wall"
    annotation (Placement(transformation(extent={{-10,-110},{11,-90}}),
        iconTransformation(extent={{-30,-60},{30,-40}})));
  Modelica.Blocks.Interfaces.RealOutput T_sto_lower_out(unit="K") annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-110}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-70})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_sto_in(unit="W")
    "Heat flow input (pos: charge, neg: discharge)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,80})));
  Modelica.Blocks.Sources.RealExpression realExpression_m_flow_sto(y=-
        m_flow_sto)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={52,26})));
  Modelica.Blocks.Sources.RealExpression realExpression_T_sto_upper(y=
        T_sto_up) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-46,-62})));
  Modelica.Blocks.Sources.RealExpression realExpression_T_sto_lower(y=
        T_sto_lo) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={42,-62})));
  Modelica.Blocks.Interfaces.RealInput T_sup_in(unit="K") "Supply temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={70,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_in_up(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final tau=tau,
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final T_start=T_start,
    final transferHeat=false)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_in_lo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final tau=tau,
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final T_start=T_start,
    final transferHeat=false)
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));

initial equation

  //der(m_flow_sto) = 0;

equation

  Q_flow_actual = m_flow_sto * (Medium.specificEnthalpy(state=state_upper) - Medium.specificEnthalpy(state=state_lower)); ///  Medium.heatCapacity_cp(state_sto_lo) * (T_sto_up - T_sto_lo_in);


  Q_flow_residual = Q_flow_sto_in - Q_flow_actual;

  T_sto_up = sto.heatPorts[nSeg].T;
  T_sto_lo = sto.heatPorts[1].T;
  T_sto_up_in = Medium.temperature(state=state_upper);
  T_sto_lo_in = Medium.temperature(state=state_lower);

  /*
  if Q_flow_sto_in >= 0 then  // discharging
    if (T_sup_in - T_sto_up <= dT_up_min) then
      m_flow_sto = Q_flow_sto_in / Medium.heatCapacity_cp(state_sto_lo) / max(T_sto_up - T_sto_lo_in, dT_small);
    else
      m_flow_sto = m_flow_small;
    end if;
  else  // charging
    if (T_sto_up_in - T_sto_lo) >= dT_lo_min then
      m_flow_sto = Q_flow_sto_in / Medium.heatCapacity_cp(state_sto_up) / max(T_sto_up_in - T_sto_lo, -dT_small);
    else
      m_flow_sto = -m_flow_small;
    end if;
  end if;
  */

  if Q_flow_sto_in >= 0 then
    if (T_sup_in - T_sto_up_in) <= dT_lo_min then
      m_flow_sto = Q_flow_sto_in / max(Medium.specificEnthalpy(state=state_upper) - Medium.specificEnthalpy(state=state_lower), cp_default*dT_small);
    else
      m_flow_sto = m_flow_small;
    end if;
  else
    if (T_sto_up_in - T_sto_lo_in) >= dT_lo_min then
      m_flow_sto = Q_flow_sto_in / max(Medium.specificEnthalpy(state=state_upper) - Medium.specificEnthalpy(state=state_lower), cp_default*dT_small);
    else
      m_flow_sto = -m_flow_small;
    end if;
  end if;





  connect(realExpression_m_flow_sto.y, ideSou.m_flow_in)
    annotation (Line(points={{41,26},{16,26},{16,8}},   color={0,0,127}));
  connect(sto.heatPorts, heatPorts) annotation (Line(points={{-48,-5},{-48,-28},
          {0.5,-28},{0.5,-100}}, color={127,0,0}));
  connect(realExpression_T_sto_upper.y, T_sto_upper_out) annotation (Line(
        points={{-57,-62},{-60,-62},{-60,-110}}, color={0,0,127}));
  connect(realExpression_T_sto_lower.y, T_sto_lower_out)
    annotation (Line(points={{53,-62},{60,-62},{60,-110}}, color={0,0,127}));
  connect(port_b, res.port_b)
    annotation (Line(points={{100,0},{72,0}}, color={0,127,255}));
  connect(res.port_a, ideSou.port_b)
    annotation (Line(points={{52,0},{32,0}}, color={0,127,255}));
  connect(ideSou.port_a, senTem_in_lo.port_b)
    annotation (Line(points={{12,0},{-6,0}}, color={0,127,255}));
  connect(senTem_in_lo.port_a, sto.port_b)
    annotation (Line(points={{-26,0},{-38,0}}, color={0,127,255}));
  connect(sto.port_a, senTem_in_up.port_b)
    annotation (Line(points={{-58,0},{-68,0}}, color={0,127,255}));
  connect(senTem_in_up.port_a, port_a)
    annotation (Line(points={{-88,0},{-100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="ActSto",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,-6},{96,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,52},{26,-54}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,52},{66,-54}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end ActiveStorage;
