within dhcSim.DHC.Submodules.MultiPortModules;
model DHC_Storage "Multi port model of DHC_Storage."
  extends
    dhcSim.DHC.Submodules.MultiPortModules.BaseClasses.BaseMultiPortModule;

  parameter Integer iLev1(min=1, max=nLev) = 1 "Grid connection of ports a1 and b1";
  parameter Integer iLev2(min=1, max=nLev) = 2 "Grid connection of ports a2 and b2";

    parameter Integer nSeg = 1 "Number of volume segments";

    parameter Modelica.SIunits.Length length = 1 "Length of storage tank";

    parameter Modelica.SIunits.Volume volume = 1 "Volume of storage tank";

  dhcSim.DHC.Submodules.FourPortModules.DHC_Storage storage(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
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
    final nSeg=nSeg,
    final length=length,
    final volume=volume)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput[nSeg] T_Tank_out
    annotation (Placement(transformation(extent={{-2,76},{18,96}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,84})));
equation
  connect(storage.port_b1, ports_b[iLev1]) annotation (Line(points={{-10,6},{-40,
          6},{-40,20},{-100,20},{-100,0}}, color={0,127,255}));
  connect(storage.port_b2, ports_b[iLev2]) annotation (Line(points={{-10,-6},{-40,
          -6},{-40,-20},{-100,-20},{-100,0}}, color={0,127,255}));
  connect(storage.port_a1, ports_a[iLev1]) annotation (Line(points={{10,6},{40,6},
          {40,20},{100,20},{100,0}}, color={0,127,255}));
  connect(storage.port_a2, ports_a[iLev2]) annotation (Line(points={{10,-6},{40,
          -6},{40,-20},{100,-20},{100,0}}, color={0,127,255}));

  connect(storage.T_Tank_out, T_Tank_out)
    annotation (Line(points={{11,0},{60,0},{60,86},{8,86}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,54},{100,74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
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
          fillColor={255,0,0},
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
          extent={{-50,26},{50,-54}},
          lineColor={0,0,0},
          textString="Storage
"),     Text(
          extent={{-152,-106},{148,-66}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DHC_Storage;
