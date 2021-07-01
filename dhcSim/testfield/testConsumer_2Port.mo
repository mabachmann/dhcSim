within dhcSim.testfield;
model testConsumer_2Port
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Buildings.Media.Water,
    T=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Buildings.Media.Water,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,0})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=40 + 273.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-30})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=10000,                                freqHz=1/3600,
    offset=10000)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  DHC.Submodules.TwoPortModules.Cooler cooler(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=0.12,
    dp_nominal=70000,
    use_Q_flow_in=true,
    use_TSet_in=true,
    fixedGradient=false,
    TGrad=2) annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=0.12)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(bou.ports[1], cooler.port_a)
    annotation (Line(points={{-40,0},{-14,0}}, color={0,127,255}));
  connect(realExpression.y, cooler.TSet_in)
    annotation (Line(points={{29,-30},{0,-30},{0,-8}}, color={0,0,127}));
  connect(sine.y, cooler.QLoad_in)
    annotation (Line(points={{-39,-30},{-8,-30},{-8,-8}}, color={0,0,127}));
  connect(cooler.port_b, senTem.port_a)
    annotation (Line(points={{6,0},{10,0}}, color={0,127,255}));
  connect(senTem.port_b, bou1.ports[1])
    annotation (Line(points={{30,0},{36,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=20000, __Dymola_Algorithm="Dassl"));
end testConsumer_2Port;
