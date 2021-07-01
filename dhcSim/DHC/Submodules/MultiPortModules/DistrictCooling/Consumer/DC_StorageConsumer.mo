within dhcSim.DHC.Submodules.MultiPortModules.DistrictCooling.Consumer;
model DC_StorageConsumer
  "Multi port model of district cooling consumer using storage tank"
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

   // Storage Parameters
   parameter Modelica.SIunits.Volume VSt "Volume of internal storage tank";

 //Control parameter
   parameter Modelica.SIunits.Temperature THigh "High set temperature of storage tank control";

   parameter Modelica.SIunits.Temperature TLow "Low set temperature of storage tank control";

  //other
  final parameter Real ProfCtrl = 1 "Control parameter for profile usage";
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance";

  // Table
  final parameter String tableName="table" "Table name" annotation (Dialog(group="Table data"));
  parameter String fileName="NoName" "File name" annotation (
      Dialog(
      group="Table data",
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));

  Modelica.Blocks.Interfaces.RealOutput Q_flow_out annotation (Placement(
        transformation(extent={{100,50},{120,70}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,90})));
  dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.DC_StorageConsumer
    Con(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final tableName=tableName,
    final fileName=fileName,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final from_dp=from_dp,
    final show_T=show_T,
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
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final VSt=VSt,
    final THigh=THigh,
    final TLow=TLow,
    final m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput dp_out annotation (Placement(
        transformation(extent={{100,80},{120,100}}), iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={-60,90})));

equation
  connect(Con.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,6},
          {-40,20},{-100,20},{-100,0}}, color={0,127,255}));
  connect(Con.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,-6},
          {-40,-20},{-100,-20},{-100,0}}, color={0,127,255}));
  connect(Con.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},{40,
          20},{100,20},{100,0}}, color={0,127,255}));
  connect(Con.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,-6},
          {40,-20},{100,-20},{100,0}}, color={0,127,255}));

     for i in 1:nLev loop
       if ((i <> iLev1) and (i <> iLev2)) then
         connect(ports_b[i], ports_a[i]);
       end if;
     end for;

  connect(Con.Q_flow_out, Q_flow_out) annotation (Line(points={{11,-2},{60,-2},{
          60,60},{110,60}}, color={0,0,127}));
  connect(Con.dp_out, dp_out) annotation (Line(points={{11,2},{56,2},{56,90},{110,
          90}}, color={0,0,127}));
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
          extent={{-50,38},{50,-42}},
          lineColor={0,0,0},
          textString="StC"),
        Text(
          extent={{-152,-106},{148,-66}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DC_StorageConsumer;
