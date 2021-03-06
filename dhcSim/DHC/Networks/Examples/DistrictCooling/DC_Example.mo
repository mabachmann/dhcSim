within dhcSim.DHC.Networks.Examples.DistrictCooling;
model DC_Example
  "Example of a simple district heating grid of active producer and direct consumer"
  import gp = dhcSim.Utilities.getAbsolutePath;
  extends dhcSim.DHC.Networks.BaseClasses.BaseGrid(
    p_start={5*101325,5*101325},
    T_start={273.15 + 6,273.15 + 12},
    nLev=2,
    nMix=2,
    nPip=9,
    redeclare Submodules.MultiPortModules.Pipe.AdiabatePipe pipe,
    tau=10,
    MixNPrt={3,3},
    pAbs=300000);

  // Producer and consumer:
  parameter Integer nPro = 1 "Number of producer";
  parameter Integer nCon = 5 "Number of consumer";
  parameter String[nCon] fileNameCon = fill(gp("modelica://dhcSim/Resources/LoadProf/default/consumerNom.txt"), nCon);

  dhcSim.DHC.Submodules.MultiPortModules.DistrictCooling.Producer.DC_ActiveDirectProducer[
    nPro] pro(
    each nLev=2,
    each p_start=p_start,
    each T_start=T_start,
    each dp_nominal=1000,
    each iLev1=1,
    each iLev2=2,
    redeclare each package Medium = Medium,
    each m_flow_nominal=1,
    each TNetSupSet=279.15,
    each TNetRetSet=285.15)
    annotation (Placement(transformation(extent={{-30,12},{-10,32}})));
  dhcSim.DHC.Submodules.MultiPortModules.DistrictCooling.Consumer.DC_DirectConsumer[
    nCon] con(
    each nLev=2,
    each p_start=p_start,
    each T_start=T_start,
    each iLev1=1,
    each iLev2=2,
    fileName=fileNameCon,
    redeclare each package Medium = Medium,
    each dp_nominal=1000,
    each m_flow_nominal=1,
    each TNetRetSet=273.15 + 13,
    each deltaT(displayUnit="K") = 5,
    each Q_flow_nominal=10000,
    each retTempType=dhcSim.Fluid.Types.FeedingTemperatureCon.heatExchanger,
    each TNetIn_nominal=279.15,
    each TNetOut_nominal=285.15,
    each TBuiIn_nominal=286.65,
    each TBuiOut_nominal=280.65)
    annotation (Placement(transformation(extent={{14,12},{34,32}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=200000)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation

    // Grid connections
    for i in 1:nLev loop
    connect(pro[1].ports_b[i], pipe[1].ports_a[i]);
    connect(pipe[1].ports_b[i], con[1].ports_a[i]);
    connect(con[1].ports_b[i], pipe[2].ports_a[i]);
    connect(pipe[2].ports_b[i], mix[1].ports[i, 1]);
    connect(mix[1].ports[i, 2], pipe[3].ports_a[i]);
    connect(pipe[3].ports_b[i], con[2].ports_a[i]);
    connect(con[2].ports_b[i], pipe[4].ports_a[i]);
    connect(pipe[4].ports_b[i], con[3].ports_a[i]);
    connect(con[3].ports_b[i], pipe[5].ports_a[i]);
    connect(pipe[5].ports_b[i], mix[2].ports[i, 1]);
    connect(mix[2].ports[i, 2], pipe[8].ports_a[i]);
    connect(pipe[8].ports_b[i], con[5].ports_a[i]);
    connect(con[5].ports_b[i], pipe[9].ports_a[i]);
    connect(pipe[9].ports_b[i], pro[1].ports_a[i]);
    connect(mix[1].ports[i, 3], pipe[7].ports_a[i]);
    connect(pipe[7].ports_b[i], con[4].ports_a[i]);
    connect(con[4].ports_b[i], pipe[6].ports_a[i]);
    connect(pipe[6].ports_b[i], mix[2].ports[i, 3]);
    end for;

    // Pressure point
  connect(expansionVessel.port_a, pro[1].ports_a[1]);

  connect(realExpression1.y, pro[1].dp_in)
    annotation (Line(points={{-79,30},{-32,30}}, color={0,0,127}));
   annotation (Line(points={{-10,-120},{
          -10,-130},{70,-130},{70,-120}}, color={0,127,255}),
              experiment(StopTime=3.1536e+07, __Dymola_NumberOfIntervals=8760),
    Diagram(graphics={
        Line(points={{-30,22},{-38,22},{-60,22},{-60,-60},{-40,-60},{-40,-58},{-40,
              -60},{-20,-60},{-20,-50},{-10,-50}}, color={28,108,200}),
        Line(points={{10,-50},{20,-50},{20,-60},{40,-60},{40,-58},{40,-60},{60,-60},
              {60,22},{34,22}}, color={28,108,200}),
        Line(points={{14,22},{-10,22}}, color={28,108,200})}),
    Icon(graphics={
        Line(points={{-80,20},{-80,80},{80,80},{80,20}}, color={178,0,248}),
        Line(points={{20,80},{20,20}}, color={178,0,248}),
        Rectangle(
          extent={{-100,20},{-60,-20}},
          lineColor={0,0,0},
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,12},{-58,-26}},
          lineColor={0,0,0},
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid,
          textString="P")}));
end DC_Example;
