within dhcSim.DHC.Submodules.TwoPortModules;
model CoolConsumer_Storage
  "Two port district cooling consumer using internal storange unit"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
    computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

 // Storage Parameters
 parameter Modelica.SIunits.Volume VSt "Volume of internal storage tank";

 //Control variables
 parameter Modelica.SIunits.Temperature THigh "High set temperature of storage tank control";

 parameter Modelica.SIunits.Temperature TLow "Low set temperature of storage tank control";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    final nPorts=2,
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final V=VSt,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final allowFlowReversal=allowFlowReversal,
    final use_C_flow=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={68,10})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium,
    l=0.0001,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final CvData=dhcSim.Fluid.Types.CvTypes.OpPoint,
    final deltaM=deltaM,
    final dpValve_nominal=dp_nominal,
    final use_inputFilter=false,
    final linearized=linearizeFlowResistance,
    final dpFixed_nominal=0)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,70})));
  Modelica.Blocks.Interfaces.RealInput QLoad_in(unit="W") annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-80})));
  Modelica.Blocks.Interfaces.RealOutput TStorage_out annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,50}),  iconTransformation(extent={{100,-50},{120,-30}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={38,10})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final pre_y_start=false,
    final uLow=TLow,
    final uHigh=THigh) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(final realTrue=1,
      final realFalse=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-46,50})));
  Modelica.Blocks.Sources.RealExpression set_dp(final y=dp)
                                                      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={68,-40})));
  Modelica.Blocks.Interfaces.RealOutput dp_out "Pressure drop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-40}), iconTransformation(extent={{100,70},{120,90}})));
public
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out "Heat flow" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,80}), iconTransformation(extent={{100,-80},{120,-60}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final replaceable package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearized=linearizeFlowResistance,
    final deltaM=deltaM)
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
equation

  connect(port_a, val.port_a)
    annotation (Line(points={{-100,0},{-70,0}}, color={0,127,255}));
  connect(vol.ports[1], port_b)
    annotation (Line(points={{66,0},{100,0}}, color={0,127,255}));
  connect(prescribedHeatFlow.port, vol.heatPort)
    annotation (Line(points={{46,60},{46,10},{58,10}},
                                                     color={191,0,0}));
  connect(QLoad_in, prescribedHeatFlow.Q_flow) annotation (Line(points={{-60,120},
          {-60,80},{46,80}},       color={0,0,127}));
  connect(temperatureSensor.port, vol.heatPort)
    annotation (Line(points={{48,10},{58,10}}, color={191,0,0}));
  connect(temperatureSensor.T, TStorage_out)
    annotation (Line(points={{28,10},{20,10},{20,50},{110,50}},
                                                         color={0,0,127}));
  connect(temperatureSensor.T, hys.u) annotation (Line(points={{28,10},{20,10},{
          20,50},{2,50}}, color={0,0,127}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-22,50},{-34,50}}, color={255,0,255}));
  connect(booToRea.y, val.y)
    annotation (Line(points={{-58,50},{-60,50},{-60,12}}, color={0,0,127}));
  connect(set_dp.y, dp_out)
    annotation (Line(points={{79,-40},{110,-40}}, color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, Q_flow_out)
    annotation (Line(points={{46,80},{110,80}}, color={0,0,127}));
  connect(res.port_a, val.port_b)
    annotation (Line(points={{-6,0},{-50,0}},  color={0,127,255}));
  connect(res.port_b, vol.ports[2])
    annotation (Line(points={{14,0},{70,0}},color={0,127,255}));
  annotation (
  defaultComponentName="con",
  Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-8},{0,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,4},{100,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,50},{30,-50}},
          lineColor={0,0,0},
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid)}));
end CoolConsumer_Storage;
