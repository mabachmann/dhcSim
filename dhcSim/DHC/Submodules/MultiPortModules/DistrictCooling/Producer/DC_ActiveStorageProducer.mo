within dhcSim.DHC.Submodules.MultiPortModules.DistrictCooling.Producer;
model DC_ActiveStorageProducer
  "Multi port module of ActiveCoolProducer_Storage. Prescribed maximum cooling power and hysteresis control of storage."
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";

  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

    // Producer Parameter
  parameter Modelica.SIunits.HeatFlowRate QProNominal = 1000 "Nominal producer cooling power";

 // Storage Parameters
  parameter Modelica.SIunits.Volume VSt "Volume of internal storage tank";

 // Control variables
  parameter Modelica.SIunits.Temperature THigh "High set temperature of storage tank control";

  parameter Modelica.SIunits.Temperature TLow "Low set temperature of storage tank control";

  // Other

  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  parameter Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation(Dialog(tab="Dynamics"));

  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance";

  dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Producer.DC_ActiveStorageProducer
    ActPro(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final p_start_1=p_start[iLev1],
    final T_start_1=T_start[iLev1],
    final X_start_1=X_start[iLev1, :],
    final C_start_1=C_start[iLev1, :],
    final C_nominal_1=C_nominal[iLev1, :],
    final p_start_2=p_start[iLev2],
    final T_start_2=T_start[iLev2],
    final X_start_2=X_start[iLev2, :],
    final C_start_2=C_start[iLev2, :],
    final C_nominal_2=C_nominal[iLev2, :],
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final QProNominal=QProNominal,
    final VSt=VSt,
    final THigh=THigh,
    final TLow=TLow,
    final massDynamics=massDynamics,
    final mSenFac=mSenFac)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput dp_in annotation (Placement(
        transformation(extent={{-14,-138},{-54,-98}}), iconTransformation(
          extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,80})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out annotation (Placement(
        transformation(extent={{100,70},{120,90}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,90})));

equation

  connect(ActPro.dp_in, dp_in)
    annotation (Line(points={{6,-12},{6,-118},{-34,-118}},
                                                         color={0,0,127}));
  connect(ActPro.Q_flow_out, Q_flow_out) annotation (Line(points={{11,-3},{26,-3},
          {26,80},{110,80}}, color={0,0,127}));
  connect(ActPro.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,
          6},{-40,20},{-100,20},{-100,0}},
                            color={0,127,255}));
  connect(ActPro.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,
          -6},{-40,-20},{-100,-20},{-100,0}},
                             color={0,127,255}));
  connect(ActPro.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},
          {40,20},{100,20},{100,0}},
                       color={0,127,255}));
  connect(ActPro.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,-6},
          {40,-20},{100,-20},{100,0}},
                          color={0,127,255}));

     for i in 1:nLev loop
       if ((i <> iLev1) and (i <> iLev2)) then
         connect(ports_b[i], ports_a[i]);
       end if;
     end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,54},{100,74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-46},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-25,-6},{25,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={178,0,248},
          fillPattern=FillPattern.Solid,
          origin={0,29},
          rotation=90),
        Rectangle(
          extent={{-25,6},{25,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={0,-21},
          rotation=90),
        Rectangle(
          extent={{-50,44},{50,-36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{-48,6},{52,-74}},
          lineColor={0,0,0},
          textString="ASP
"),     Text(
          extent={{-152,-106},{148,-66}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DC_ActiveStorageProducer;
