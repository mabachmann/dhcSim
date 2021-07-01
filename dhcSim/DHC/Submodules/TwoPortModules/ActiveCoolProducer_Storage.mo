within dhcSim.DHC.Submodules.TwoPortModules;
model ActiveCoolProducer_Storage
  "Two port model of active district cooling grid using internal storage unit"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  // parameter Boolean homotopyInitialization = true "= true, use homotopy method"
  //  annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Producer Parameter
  parameter Modelica.SIunits.HeatFlowRate QProNominal = 1000 "Nominal producer cooling power";

 // Storage Parameters
  parameter Modelica.SIunits.Volume VSt "Volume of internal storage tank";

 //Control variables
  parameter Modelica.SIunits.Temperature THigh "High set temperature of storage tank control";

  parameter Modelica.SIunits.Temperature TLow "Low set temperature of storage tank control";

protected
  parameter Medium.ThermodynamicState state_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  parameter Modelica.SIunits.Density rho_default=Medium.density(state_default);
  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(state_default)
    "Dynamic viscosity at nominal condition";
public
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare package Medium = Medium,
    final show_T=show_T,
    final control_m_flow=false,
    final control_dp=true,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    final show_V_flow=false)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealInput dp_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-80})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out(unit="W") annotation (
      Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    final m_flow_nominal=m_flow_nominal,
    final V=VSt,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final allowFlowReversal=allowFlowReversal,
    final use_C_flow=false,
    final nPorts=2,
    redeclare final package Medium = Medium,
    massDynamics=massDynamics) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,10})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,10})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={8,-18})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final pre_y_start=false,
    final uLow=TLow,
    final uHigh=THigh) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-22,-18})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(final realFalse=0,
      final realTrue=-QProNominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-54,-18})));
  Modelica.Blocks.Math.Gain gain(final k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={76,50})));
  Modelica.Blocks.Interfaces.RealOutput TStorage_out annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={108,-20}), iconTransformation(extent={{100,-50},{120,-30}},
          rotation=0)));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearized=linearizeFlowResistance,
    final deltaM=deltaM,
    redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    // final homotopyInitialization=homotopyInitialization,
equation
  connect(ideSou.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(ideSou.port_a, vol.ports[1])
    annotation (Line(points={{60,0},{38,0}}, color={0,127,255}));
  connect(vol.heatPort, temperatureSensor.port) annotation (Line(points={{30,10},
          {20,10},{20,-18},{18,-18}},
                                    color={191,0,0}));
  connect(temperatureSensor.T, hys.u)
    annotation (Line(points={{-2,-18},{-10,-18}},
                                                color={0,0,127}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-34,-18},{-42,-18}},
                                                 color={255,0,255}));
  connect(booToRea.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-66,-18},
          {-80,-18},{-80,10},{-20,10}},color={0,0,127}));
  connect(prescribedHeatFlow.port, vol.heatPort)
    annotation (Line(points={{0,10},{30,10}},   color={191,0,0}));
  connect(ideSou.dp_in, gain.y)
    annotation (Line(points={{76,8},{76,39}}, color={0,0,127}));
  connect(gain.u, dp_in) annotation (Line(points={{76,62},{76,80},{0,80},{0,120}},
        color={0,0,127}));
  connect(booToRea.y, Q_flow_out) annotation (Line(points={{-66,-18},{-80,-18},{
          -80,-80},{110,-80}}, color={0,0,127}));
  connect(temperatureSensor.T, TStorage_out) annotation (Line(points={{-2,-18},{
          -2,-42},{82,-42},{82,-20},{108,-20}}, color={0,0,127}));
  connect(port_a, res.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(res.port_b, vol.ports[2])
    annotation (Line(points={{-40,0},{42,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="actPro",
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
          extent={{0,-6},{100,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,50},{30,-50}},
          lineColor={0,0,0},
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid)}));
end ActiveCoolProducer_Storage;
