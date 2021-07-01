within dhcSim.DHC.Submodules.TwoPortModules.Pipe;
model InsulatedPipe "Two port model of an insulated pipe"
  extends dhcSim.DHC.Submodules.TwoPortModules.Pipe.BaseClasses.BasePipe;

  parameter Boolean useMultipleHeatPorts=false
    "= true to use one heat port for each segment of the pipe, false to use a single heat port for the entire pipe";

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor ResPipWal[nSeg](
    each R=Modelica.Math.log((2*thicknessIns+diameter)/diameter)/(2*Modelica.Constants.pi*length*lambdaIns))
    "Thermal resistance through insulation"
    annotation (Placement(transformation(extent={{-28,-38},{-8,-18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=nSeg) if
       not useMultipleHeatPorts
    "Connector to assign multiple heat ports to one heat port" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-50,10})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if not
    useMultipleHeatPorts
    "Single heat port that connects to outside of pipe wall (default, enabled when useMultipleHeatPorts=false)"
    annotation (Placement(transformation(extent={{-10,92},{10,72}}),
        iconTransformation(extent={{-10,92},{10,72}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nSeg] if
       useMultipleHeatPorts
    "Multiple heat ports that connect to outside of pipe wall (enabled if useMultipleHeatPorts=true)"
    annotation (Placement(transformation(extent={{-10,-90},{11,-70}}),
        iconTransformation(extent={{-30,-92},{30,-72}})));

equation
  connect(ResPipWal.port_b, vol.heatPort) annotation (Line(
      points={{-8,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  if useMultipleHeatPorts then
    connect(heatPorts, ResPipWal.port_a) annotation (Line(
        points={{0.5,-80},{-50,-80},{-50,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
  else
    connect(colAllToOne.port_a, ResPipWal.port_a) annotation (Line(
        points={{-50,4},{-50,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(colAllToOne.port_b, heatPort) annotation (Line(
        points={{-50,16},{-50,82},{0,82}},
        color={191,0,0},
        smooth=Smooth.None));
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,60},{100,72}},
          lineColor={127,127,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{-100,-72},{100,-60}},
          lineColor={127,127,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end InsulatedPipe;
