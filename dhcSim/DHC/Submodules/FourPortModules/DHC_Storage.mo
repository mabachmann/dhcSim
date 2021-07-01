within dhcSim.DHC.Submodules.FourPortModules;
model DHC_Storage
  "Four port model of district heating consumer model."
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends
    dhcSim.DHC.Submodules.FourPortModules.Interfaces.FourPortModulesParameters;
  extends dhcSim.DHC.Submodules.FourPortModules.BaseClasses.BaseModule(final
      nSpl1=1, final nSpl2=1);

    parameter Integer nSeg = 1 "Number of volume segments";

    parameter Modelica.SIunits.Length length = 1 "Length of storage tank";

    parameter Modelica.SIunits.Volume volume = 1 "Volume of storage tank";

  Buildings.Fluid.FixedResistances.Pipe pip(
    final energyDynamics=energyDynamics,
    final massDynamics=energyDynamics,
    final p_start=p_start_1,
    final T_start=T_start_1,
    final X_start=X_start_1,
    final C_start=C_start_1,
    final C_nominal=C_nominal_1,
    final mSenFac=1,
    final allowFlowReversal=allowFlowReversal,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final thicknessIns=0.1,
    final lambdaIns=0.001,
    final useMultipleHeatPorts=true,
    final nSeg=nSeg,
    final diameter=(4*volume/Modelica.Constants.pi/length)^0.5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    final dp_nominal=pip.dpStraightPipe_nominal,
    final length=length) annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=270,
        origin={1.77636e-15,0})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[nSeg] temperatureSensor
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={28,0})));
  Modelica.Blocks.Interfaces.RealOutput[nSeg] T_Tank_out
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation

  connect(temperatureSensor.port, pip.heatPorts)
    annotation (Line(points={{18,0},{10,0},{10,1.55431e-15},{-8,1.55431e-15}},
                                              color={191,0,0}));
  connect(pip.port_a, spl1[1].port_3)
    annotation (Line(points={{0,16},{0,50}}, color={0,127,255}));
  connect(pip.port_b, spl2[1].port_3)
    annotation (Line(points={{0,-16},{0,-50}}, color={0,127,255}));
  connect(temperatureSensor.T, T_Tank_out)
    annotation (Line(points={{38,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="storage", Icon(graphics={
        Rectangle(
          extent={{-25,-6},{25,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,25},
          rotation=90),
        Rectangle(
          extent={{-25,6},{25,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={0,-25},
          rotation=90),
        Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-34,34},{34,-34}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="Storage")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end DHC_Storage;
