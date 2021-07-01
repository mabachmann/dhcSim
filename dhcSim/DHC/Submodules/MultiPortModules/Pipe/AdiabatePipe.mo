within dhcSim.DHC.Submodules.MultiPortModules.Pipe;
model AdiabatePipe
  "Mulit port model of adiabte pipe"
  extends dhcSim.DHC.Submodules.MultiPortModules.Pipe.BaseClasses.BasePipeMulti;

public
   TwoPortModules.Pipe.AdiabatePipe[nLev] pipe(
     redeclare each final package Medium = Medium,
     each final dpType=dpType,
     each final nSeg=nSeg,
     final diameter_set=diameter,
     each final length_set=length,
     final v_nominal=v_nominal,
     each final roughness=roughness,
     final dp_nominal_set=dp_nominal,
     final m_flow_nominal_set=m_flow_nominal,
     each final energyDynamics=energyDynamics,
     each final massDynamics=massDynamics,
     each final mSenFac=mSenFac,
     final p_start=p_start,
     final T_start=T_start,
     final X_start=X_start,
     final C_start=C_start,
     final C_nominal=C_nominal,
     each final allowFlowReversal=allowFlowReversal,
     final m_flow_small=m_flow_small,
     each final from_dp=from_dp,
     each final linearizeFlowResistance=linearizeFlowResistance,
     each final deltaM=deltaM,
     each final ReC=ReC,
     final dp_fixed_nominal=dp_fixed_nominal)
     annotation (Placement(transformation(extent={{-23,-22},{23,22}},
        rotation=180,
        origin={-1,-3.55271e-15})));

equation
  connect(ports_b, pipe.port_b) annotation (Line(points={{-100,0},{-62,0},{-62,-1.44329e-15},
          {-24,-1.44329e-15}},
                            color={0,127,255}));
  connect(pipe.port_a, ports_a) annotation (Line(points={{22,-7.10543e-15},{24,-7.10543e-15},
          {24,0},{100,0}},color={0,127,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,36},{100,16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-100,10},{100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-100,-16},{100,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,34},{100,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-100,8},{100,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-100,-18},{100,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Text(
          extent={{-144,-104},{156,-64}},
          textString="%name",
          lineColor={0,0,255})}),     Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end AdiabatePipe;
