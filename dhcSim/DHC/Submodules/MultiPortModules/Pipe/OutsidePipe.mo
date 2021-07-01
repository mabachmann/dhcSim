within dhcSim.DHC.Submodules.MultiPortModules.Pipe;
model OutsidePipe
  "Mulit port model of pipes in outdoor environement."
  extends dhcSim.DHC.Submodules.MultiPortModules.Pipe.BaseClasses.BasePipeMulti;

  parameter Modelica.SIunits.Length[nLev] thicknessIns "Thickness of insulation";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns = 0.025
    "Heat conductivity of insulation";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 14.6 "Heat transfer coefficient";

protected
  parameter Modelica.SIunits.ThermalResistance R = 1/(h*2*Modelica.Constants.pi*length);
public
   TwoPortModules.Pipe.InsulatedPipe[nLev] pipe(
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
     final dp_fixed_nominal=dp_fixed_nominal,
     final thicknessIns=thicknessIns,
     each final lambdaIns=lambdaIns,
    each final useMultipleHeatPorts=true)
     annotation (Placement(transformation(extent={{-23,-22},{23,22}},
        rotation=180,
        origin={-1,-3.55271e-15})));

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor ResPipGrnd[nLev, nSeg](
    R=fill(R, nLev, nSeg))
    "Thermal resistance between pipes and environement"
                                                       annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={0,50})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,78})));
  Modelica.Blocks.Interfaces.RealInput Tamb_in annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
equation
  connect(ports_b, pipe.port_b) annotation (Line(points={{-100,0},{-62,0},{-62,-1.44329e-15},
          {-24,-1.44329e-15}},
                            color={0,127,255}));
  connect(pipe.port_a, ports_a) annotation (Line(points={{22,-7.10543e-15},{24,-7.10543e-15},
          {24,0},{100,0}},color={0,127,255}));

  for i in 1:nSeg loop
    for j in 1:nLev-1 loop
    end for;
    for j in 1:nLev loop
        connect(prescribedTemperature.port, ResPipGrnd[j, i].port_b)
            annotation (Line(points={{-1.77636e-15,68},{-1.77636e-15,60},{
              6.66134e-16,60}},              color={191,0,0}));
          connect(ResPipGrnd[j, i].port_a, pipe[j].heatPorts[i])
    annotation (Line(points={{0,40},{0,18.04},{-1,18.04}},        color={191,0,0}));
    end for;

  end for;

  connect(Tamb_in, prescribedTemperature.T) annotation (Line(points={{0,120},{0,
          90},{2.22045e-15,90}},                                                      color={0,0,127}));

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
        Line(points={{-40,80},{42,80},{32,90}}, color={28,108,200}),
        Line(points={{42,80},{32,70}}, color={28,108,200}),
        Line(points={{-38,-80},{44,-80},{34,-70}}, color={28,108,200}),
        Line(points={{44,-80},{34,-90}}, color={28,108,200}),
        Text(
          extent={{-144,-134},{156,-94}},
          textString="%name",
          lineColor={0,0,255})}),     Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end OutsidePipe;
