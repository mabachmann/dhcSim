within dhcSim.testfield;
model testStorage_2Port
  DHC.Submodules.TwoPortModules.ActiveStorage ActPro(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=1,
    dp_nominal=10000,
    T_start=313.15,
    nSeg=10,
    tau=0.01,
    dT_small=1)
             annotation (Placement(transformation(extent={{-18,-18},{18,16}})));
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
  Modelica.Blocks.Sources.RealExpression realExpression(y=80 + 273.15)
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Sine sine(amplitude=100000,
                                                    freqHz=1/3600)
    annotation (Placement(transformation(extent={{-62,36},{-42,56}})));
equation
  connect(bou.ports[1], ActPro.port_a) annotation (Line(points={{-40,0},{-30,0},
          {-30,-1},{-18,-1}}, color={0,127,255}));
  connect(ActPro.port_b, bou1.ports[1]) annotation (Line(points={{18,-1},{28,-1},
          {28,0},{36,0}}, color={0,127,255}));
  connect(realExpression.y, ActPro.T_sup_in)
    annotation (Line(points={{1,56},{12.6,56},{12.6,12.6}}, color={0,0,127}));
  connect(sine.y, ActPro.Q_flow_sto_in)
    annotation (Line(points={{-41,46},{0,46},{0,12.6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=20000, __Dymola_Algorithm="Dassl"));
end testStorage_2Port;
