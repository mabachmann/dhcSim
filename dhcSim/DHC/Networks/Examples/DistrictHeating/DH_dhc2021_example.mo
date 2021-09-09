within dhcSim.DHC.Networks.Examples.DistrictHeating;
model DH_dhc2021_example "Example used in DHC 2021 conference"
  import gp = dhcSim.Utilities.getAbsolutePath;
  extends dhcSim.DHC.Networks.BaseClasses.BaseGrid(
    redeclare Submodules.MultiPortModules.Pipe.BuriedPipe pipe(
      each pipeDist=0.1,
      each lambdaIns=0.025,
      each depth=1,
      redeclare dhcSim.Data.SandWet groundMaterial,
      thicknessIns=thicknessIns_input),
    p_start={3e5,3e5,3e5},
    T_start=T_nominal,
    nLev=3,
    nMix=2,
    nPip=4,
    tau=10,
    MixNPrt={1,1},
    pAbs=9e5,
    dpType=dhcSim.DHC.Submodules.TwoPortModules.Pipe.Types.dpTypes.lengthDiameter,
    diameter=diameter_input,
    m_flow_nominal_pip=m_flow_nominal_pip_input,
    length=length_input,
    roughness=1.0e-5);

//    parameter Modelica.SIunits.Length[nPip, nLev] diameter_input= fill(0.431, nPip, nLev);

  parameter Modelica.SIunits.Length[nPip, nLev] diameter_input=
    {{0.0703, 0.0431, 0.0545},
     {0.0545, 0.0545, 0.0372},
     {0.0545, 0.0545, 0.0372},
     {0.0545, 0.0545, 0.0285}} "Input parameter diameter";

  parameter Modelica.SIunits.Length[nPip] length_input= fill(100, nPip) "Input parameter of pipe length";

  parameter Modelica.SIunits.MassFlowRate[nPip, nLev]  m_flow_nominal_pip_input=
    {{2.7, 1.2, 2.2},
     {1.6, 1.4, 0.7},
     {1.6, 2.1, 0.6},
     {1.6, 1.8, 0.35}} "Input parameter nominal mass flow rate of pipes";

   parameter Modelica.SIunits.Length[nPip, nLev]  thicknessIns_input=
    {{0.042, 0.038, 0.040},
     {0.040, 0.040, 0.041},
     {0.040, 0.040, 0.041},
     {0.040, 0.040, 0.038}} "Input parameter of pipe insulation thickness";

  parameter Modelica.SIunits.Temperature[nLev] T_nominal = {273.15 + 80, 273.15+50, 273.15 + 35} "Nominal network temperature";

  // producer and consumer:
  parameter Integer nProCen = 2 "Number of central producers";
  parameter Integer nProDec = 2 "Number of decentral producers";
  parameter Integer nCon = 4 "Number of consumer";

  parameter String[nCon] fileNameCon = {gp("modelica://dhcSim/Resources/LoadProf/NomNet/dynamic/con_1.txt"),
                                        gp("modelica://dhcSim/Resources/LoadProf/NomNet/dynamic/con_1.txt"),
                                        gp("modelica://dhcSim/Resources/LoadProf/NomNet/dynamic/con_2.txt"),
                                        gp("modelica://dhcSim/Resources/LoadProf/NomNet/dynamic/con_1.txt")} "location of consumer profiles";

  dhcSim.Data.SysTemp_70_55_20 sysTem_70_55_20;
  dhcSim.Data.SysTemp_45_35_20 sysTem_45_35_20;

  Submodules.MultiPortModules.DistrictHeating.Producer.DH_ActiveDirectProducer[
    nProCen] centralProducer(
    each nLev=nLev,
    each p_start=p_start,
    each T_start=T_start,
    iLev1={1,2},
    iLev2={2,3},
    each use_T_sup_in=true,
    redeclare each package Medium = Medium,
    TNetSupSet={T_nominal[1],T_nominal[2]},
    TNetRetSet={T_nominal[2],T_nominal[3]},
    dp_nominal={5e4,5e4},
    m_flow_nominal={2.0,1.6})
    annotation (Placement(transformation(extent={{-54,-22},{-34,-2}})));
  Submodules.MultiPortModules.DistrictHeating.Consumer.DH_DirectConsumer[nCon] consumer(
    each nLev=nLev,
    each p_start=p_start,
    each T_start=T_start,
    m_flow_small=0.1 .* {1.02,1.02,0.56,1.02},
    sysTem(
      TRoo_nominal={sysTem_70_55_20.TRoo_nominal,sysTem_45_35_20.TRoo_nominal,
          sysTem_45_35_20.TRoo_nominal,sysTem_70_55_20.TRoo_nominal},
      TRoo={sysTem_70_55_20.TRoo,sysTem_45_35_20.TRoo,sysTem_45_35_20.TRoo,
          sysTem_70_55_20.TRoo},
      TAmb_nominal={sysTem_70_55_20.TAmb_nominal,sysTem_45_35_20.TAmb_nominal,
          sysTem_45_35_20.TAmb_nominal,sysTem_70_55_20.TAmb_nominal},
      TSup_nominal={sysTem_70_55_20.TSup_nominal,sysTem_45_35_20.TSup_nominal,
          sysTem_45_35_20.TSup_nominal,sysTem_70_55_20.TSup_nominal},
      TRet_nominal={sysTem_70_55_20.TRet_nominal,sysTem_45_35_20.TRet_nominal,
          sysTem_45_35_20.TRet_nominal,sysTem_70_55_20.TRet_nominal},
      m={sysTem_70_55_20.m,sysTem_45_35_20.m,sysTem_45_35_20.m,sysTem_70_55_20.m}),
    iLev1={1,2,2,1},
    iLev2={2,3,3,2},
    m_flow_min=0.1 .* consumer.m_flow_nominal,
    fileName=fileNameCon,
    redeclare each package Medium = Medium,
    each TGradHX(displayUnit="K") = 2,
    m_flow_nominal={1.02,1.02,0.56,1.02},
    each use_HeatingCurve=true,
    each dp_nominal=5e4)
    annotation (Placement(transformation(extent={{30,-22},{50,-2}})));

  Modelica.Blocks.Sources.RealExpression pressureDiffExp(y=-300000)
    annotation (Placement(transformation(extent={{-104,-2},{-84,18}})));
  Submodules.MultiPortModules.DistrictHeating.Producer.DH_PrescribedDirectProducer[
    nProDec] decentralProducer(
    redeclare package Medium = Medium,
    each nLev=nLev,
    iLev1={2,2},
    iLev2={3,3},
    each use_T_sup_in=true,
    TNetSupSet={T_nominal[2],T_nominal[2]},
    each use_ProCtrl=true,
    each p_start=p_start,
    each T_start=T_start,
    Q_flow_nominal={17500,17500},
    each m_flow_nominal=0.32,
    each dp_nominal=5e4)
    annotation (Placement(transformation(extent={{-6,-22},{14,-2}})));

  ControlSystems.decentralNetController decentralNetController(
    nPro=2,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    y_reset=1,
    m_flow_nominal=1.6,
    ctrlOffset=0.01,
    reset=dhcSim.Types.Reset.Disabled,
    seq={1, 2},
    y_start=1,
    initType=Modelica.Blocks.Types.InitPID.NoInit,
    sign_inp=1,
    ctrlType=dhcSim.DHC.ControlSystems.Types.ControlerTypes.sequence)
    annotation (Placement(transformation(extent={{-36,30},{-16,50}})));
  dhcSim.Weather.CombinedWeather combinedWeather(fileName=
        dhcSim.Utilities.getAbsolutePath(
        "modelica://dhcSim/Resources/weatherdata/TRY_Potsdam.dat")) annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-166,57})));
  Modelica.Blocks.Sources.RealExpression T_0(y=273.15)
    annotation (Placement(transformation(extent={{-178,24},{-158,44}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-136,38},
            {-116,58}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[0.0,273.15 + 80; 273.15
         - 14,273.15 + 80; 273.15 + 15,273.15 + 68; 373.15,273.15 + 68],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-98,38},{-78,58}})));
  Modelica.Blocks.Sources.RealExpression TNominalExp(y=T_nominal[2])
    annotation (Placement(transformation(extent={{-104,14},{-84,34}})));
equation

    // Grid connections
    for i in 1:nLev loop
    connect(mix[1].ports[i, 1], centralProducer[1].ports_a[i]);
    connect(centralProducer[1].ports_b[i], centralProducer[2].ports_a[i]);
    connect(centralProducer[2].ports_b[i], pipe[1].ports_a[i]);
    connect(pipe[1].ports_b[i], consumer[1].ports_a[i]);
    connect(consumer[1].ports_b[i], consumer[2].ports_a[i]);
    connect(consumer[2].ports_b[i], pipe[2].ports_a[i]);
    connect(pipe[2].ports_b[i], consumer[3].ports_a[i]);
    connect(consumer[3].ports_b[i], pipe[3].ports_a[i]);
    connect(pipe[3].ports_b[i], decentralProducer[1].ports_a[i]);
    connect(decentralProducer[1].ports_b[i], pipe[4].ports_a[i]);
    connect(pipe[4].ports_b[i], decentralProducer[2].ports_a[i]);
    connect(decentralProducer[2].ports_b[i], consumer[4].ports_a[i]);
    connect(consumer[4].ports_b[i], mix[2].ports[i, 1]);
    end for;

    // Pressure point
  connect(expansionVessel.port_a, centralProducer[1].ports_a[1]);

   // Differential pressure of producer:
   for i in 1:nProCen loop
     connect(pressureDiffExp.y, centralProducer[i].dp_in) annotation (Line(points=
          {{-83,8},{-62,8},{-62,-5.6},{-56,-5.6}}, color={0,0,127}));
   end for;

   for i in 1:nProDec loop
    connect(TNominalExp.y, decentralProducer[i].TSup_in) annotation (Line(
          points={{-83,24},{-24,24},{-24,-18},{-8,-18},{-8,-17.6}}, color={0,0,
            127}));
   end for;

  connect(combinedWeather.TempOut, add.u1)
    annotation (Line(points={{-156,54},{-138,54}},
                                               color={0,0,127}));
  connect(T_0.y, add.u2) annotation (Line(points={{-157,34},{-150,34},{-150,42},
          {-138,42}}, color={0,0,127}));
  for i in 1:nCon loop
    connect(add.y, consumer[i].TAmb_in) annotation (Line(points={{-115,48},{
            -110,48},{-110,2},{20,2},{20,-17.6},{28,-17.6}},
                                                           color={0,0,127}));
  end for;
  for i in 1:nPip loop
    connect(add.y, pipe[i].Tamb_in) annotation (Line(points={{-115,48},{-110,48},
            {-110,-70},{0,-70},{0,-62}}, color={0,0,127}));
  end for;

  connect(centralProducer[2].m_flow_out, decentralNetController.m_flow_input)
    annotation (Line(points={{-45,-3},{-45,40},{-38,40}}, color={0,0,127}));

  connect(add.y, combiTable1Ds.u) annotation (Line(points={{-115,48},{-100,48}},
                         color={0,0,127}));
  connect(combiTable1Ds.y[1], centralProducer[1].TSup_in) annotation (Line(
        points={{-77,48},{-68,48},{-68,-17.6},{-56,-17.6}},
                                                          color={0,0,127}));
  connect(TNominalExp.y, centralProducer[2].TSup_in) annotation (Line(points={{
          -83,24},{-68,24},{-68,-17.6},{-56,-17.6}}, color={0,0,127}));

  connect(decentralNetController.ProCtrl_out, decentralProducer.ProCtrl_in)
    annotation (Line(points={{-15,40},{-8,40},{-8,-5.6}},
        color={0,0,127}));

      annotation (Line(points={{-10,-120},{
          -10,-130},{70,-130},{70,-120}}, color={0,127,255}),
              experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"),
    Diagram(coordinateSystem(extent={{-180,-80},{80,80}}),
            graphics={
        Line(points={{10,-50},{20,-50},{20,-60},{40,-60},{40,-58},{40,-60},{60,
              -60},{60,-12},{52,-12}},
                                color={28,108,200}),
        Line(points={{30,-12},{14,-12}},color={28,108,200}),
        Line(points={{-6,-12},{-34,-12}},
                                        color={28,108,200}),
        Line(points={{-54,-12},{-64,-12},{-64,-60},{-40,-60},{-40,-58},{-40,-60},
              {-20,-60},{-20,-50},{-10,-50}},color={28,108,200})}),
    Icon(coordinateSystem(extent={{-180,-80},{80,80}})),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>

This network can be characterized as a three-level district heating network with decentralized feed-in. 
A graphical scheme of this network is shown in the figure (a) and (b) below.
The horizontal structure of the district heating (DH) network from Figure (a) represents the geographical alignment
of the network. It shows a simple branch structure without loops, to which four consumers (C1-C4), two central
producers (P1, P2) and two decentral producers (DP1 and DP2) are connected.
The vertical network structure of the used example from Figure (b) represents a vertical plane perspective of the
network in which the multiple network levels and their interaction with consumers and producers can be identified.
Within the vertical network structure three network levels called L1, L2 and L3 are available. It is assumed that the
network set temperatures decrease from L1 to L3. This network concept can be advantageous in areas with existing
and new buildings and several available heat sources.
Consumers C1 and C4 can be characterized as high temperature consumers which are located between L1 and L2. 
These types of consumers are assumed to meet their space heating demand through radiators with system design 
temperatures of 70/50 °C and their domestic hot water (DHW) demand through storage tank charging systems. 
This limits the lowest possible supply temperature on the building side to 60 °C due to thermal disinfection requirements for DHW. 
Therefore, the set temperature of L1 varies within a temperature range between 80-65 °C with regards to the ambient temperature. 
Consumer C2 and C3 can be characterized as low temperature consumer types which are located between L2 and L3. These types of
consumers are assumed to meet their space heating demands by floor heating systems with design temperatures of
45/35 °C. It is assumed that these consumer types cover their space heating demands through floor heating systems
with design temperatures of 45/35 °C and their hot water demand through freshwater stations. Thus, supply
temperatures can be significantly lower than 60 °C. Based on this characterization, the set temperature of L2 is
defined to be constant at 50 °C throughout the year. The resulting nominal temperature of L3 is 37 °C. It is assumed
that all consumers are designed passively, i.e., the load control is realized by valves. This requires a sufficient pressure
difference between supply and return at each consumer substation.
Heat production in the network is realized by two central producer units P1 and P2 which are located between L1
and L2 as well as L2 and L3. Furthermore, two decentralized producer units DP1 and DP2 are located between L2 and
L3 and provide a constant heat flow to the network. Centralized and decentralized producer types are actively
designed, i.e., their individual pumps ensure a sufficient pressure difference to feed the network.

</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://dhcSim/Resources/Images/Fig1.png\" width=\"1500\" />
</p>
<p>


</html>"));
end DH_dhc2021_example;
