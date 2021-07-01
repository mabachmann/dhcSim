within dhcSim.DHC.Submodules.MultiPortModules.Pipe;
model BuriedPipe
  "Mulit port model of multiple burried pipes. Steady state heat transfer to environement and parallel pipes."
  extends dhcSim.DHC.Submodules.MultiPortModules.Pipe.BaseClasses.BasePipeMulti;

  parameter Modelica.SIunits.Length[nLev] thicknessIns "Thickness of insulation";
  parameter Modelica.SIunits.Length pipeDist "Equal distance between adjacent pipes";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns = 0.025
    "Heat conductivity of insulation";
  parameter Modelica.SIunits.Length depth = 1 "Depth of equally burried pipes";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_gs = 14.6 "Heat transfer coefficient at ground sourface";

  replaceable parameter Buildings.HeatTransfer.Data.BaseClasses.ThermalProperties groundMaterial(
    k=1.4,
    c=1050,
    d=1650,
    final steadyState=true)
            "Ground material" annotation (
    Dialog(group="Heat losses"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-90,70},{-70,90}})));

protected
  parameter Modelica.SIunits.Length corDepth = depth + groundMaterial.k/h_gs  "Corrected pipe depth (layer with equivalent soil temperature and correction of heat transfer ground to environement)";
  parameter Modelica.SIunits.ThermalResistance[nLev] RGround = log(2*corDepth./(diameter.+2*thicknessIns)+sqrt((2*corDepth./(diameter+2*thicknessIns)).^(2).-1))./(2*Modelica.Constants.pi*groundMaterial.k*length);
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

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor[nLev-1, nSeg] ResInterPip(each final R=
        Modelica.Math.log(1 + (2*corDepth/pipeDist)^2)/(4*Modelica.Constants.pi*groundMaterial.k*length))
    "Thermal resistance between adjacent pipes"    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor ResPipGrnd[nLev, nSeg](
    R=transpose(fill(RGround, nSeg)))
    "Thermal resistance between pipes, ground and environement"
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
      connect(pipe[j].heatPorts[i], ResInterPip[j, i].port_a);
      connect(pipe[j+1].heatPorts[i], ResInterPip[j, i].port_b);
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
                              Rectangle(
        extent={{-100,100},{100,60}},
        fillPattern=FillPattern.Solid,
        fillColor={127,0,0},
          pattern=LinePattern.None),
                              Rectangle(
        extent={{-100,-60},{100,-100}},
        fillPattern=FillPattern.Solid,
        fillColor={127,0,0},
          pattern=LinePattern.None),
        Text(
          extent={{-146,-150},{154,-110}},
          textString="%name",
          lineColor={0,0,255})}),     Diagram(coordinateSystem(
          preserveAspectRatio=false), graphics={Line(points={{-20,18},{-26,18},{-26,-40},{26,-40},{26,18},{-20,18}},
                                                      color={162,29,33})}));
end BuriedPipe;
