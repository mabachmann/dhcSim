within dhcSim.DHC.Submodules.TwoPortModules.Pipe;
model BuriedPipe "Model of buried pipe"
  extends dhcSim.DHC.Submodules.TwoPortModules.Pipe.BaseClasses.BasePipe;

  // Heat losses
  replaceable parameter dhcSim.HeatTransfer.Data.BaseClasses.Material material(
    x=1.5,
    k=1.4,
    c=1050,
    d=1650,
    nSta=3) "Ground material" annotation (
    Dialog(group="Heat losses"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-90,70},{-70,90}})));
  parameter Modelica.SIunits.Length uniWidth=1 "Universal width" annotation (Dialog(group="Heat losses"));
  final parameter Boolean steadyStateInitial=(energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyStateInitial or energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start";
  parameter Modelica.SIunits.Temperature T_surf_a_start=293.15
    "Initial temperature at surf_a, used if steadyStateInitial = false"
  annotation (Dialog(tab="Initialization",group="Heat losses"));
  parameter Modelica.SIunits.Temperature T_surf_b_start=283.15
    "Initial temperature at surf_b, used if steadyStateInitial = false"
  annotation (Dialog(tab="Initialization",group="Heat losses"));
  parameter Modelica.SIunits.Temperature T_c_start=(T_surf_a_start+T_surf_b_start)/2
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false"
  annotation(Dialog(tab="Initialization", group="Heat losses"));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conPipWal[nSeg](
    each G=2*Modelica.Constants.pi*lambdaIns*length/nSeg/Modelica.Math.log((
      diameter/2.0 + thicknessIns)/(diameter/2.0)))
    "Thermal conductance through pipe wall"
  annotation (Placement(transformation(extent={{-30,-38},{-10,-18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor RFic[nSeg](
    each final R=Rx*nSeg/(length*uniWidth)) annotation (Placement(transformation(extent={{-58,-38},{-38,-18}})));

  Buildings.HeatTransfer.Conduction.SingleLayer[nSeg] lay_upper(
    each A=length*uniWidth,
    each T_a_start=T_surf_a_start,
    each T_b_start=T_c_start,
    each steadyStateInitial=steadyStateInitial,
    each final material=material,
    each final stateAtSurface_a=false,
    each final stateAtSurface_b=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));

  Buildings.HeatTransfer.Conduction.SingleLayer[nSeg] lay_lower(
    each A=length*uniWidth,
    each T_a_start=T_c_start,
    each T_b_start=T_surf_b_start,
    each steadyStateInitial=steadyStateInitial,
    each final material=material,
    each final stateAtSurface_a=false,
    each final stateAtSurface_b=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-60})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_a
    "Heat port at construction surface"
  annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_b
    "Heat port at construction surface"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne_b(final m=
        nSeg) "Connector to assign multiple heat ports to one heat port"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={0,-80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne_a(final m=
        nSeg) "Connector to assign multiple heat ports to one heat port"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={0,76})));
  final parameter Modelica.SIunits.ThermalInsulance Rx=
    Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance(
      disPip=uniWidth,
      dPipOut=diameter+2*thicknessIns,
      k=material.k,
      sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
      kIns=material.k,
      dIns=material.x)
    "Thermal insulance for average temperature in plane with pipes";
  Modelica.SIunits.MassFraction Xi_in_a[Medium.nXi] = inStream(port_a.Xi_outflow)
    "Inflowing mass fraction at port_a";
  Modelica.SIunits.MassFraction Xi_in_b[Medium.nXi] = inStream(port_b.Xi_outflow)
    "Inflowing mass fraction at port_a";
equation
  connect(conPipWal.port_b, vol.heatPort) annotation (Line(points={{-10,-28},{-10,-28},{-1,-28}},color={191,0,0}));
  connect(RFic.port_b, conPipWal.port_a) annotation (Line(points={{-38,-28},{-38,-28},{-30,-28}}, color={191,0,0}));
  connect(lay_lower.port_a, RFic.port_a) annotation (Line(points={{1.77636e-015,
        -50},{1.77636e-015,-48},{-66,-48},{-66,-28},{-58,-28}},
                                                 color={191,0,0}));
  connect(colAllToOne_a.port_b, surf_a) annotation (Line(points={{6.66134e-016,82},
          {6.66134e-016,100},{0,100}}, color={191,0,0}));
  connect(colAllToOne_b.port_b, surf_b)
    annotation (Line(points={{0,-86},{0,-90},{0,-100}}, color={191,0,0}));
  connect(lay_lower.port_b, colAllToOne_b.port_a)
    annotation (Line(points={{0,-70},{0,-72},{0,-74}}, color={191,0,0}));
  connect(colAllToOne_a.port_a, lay_upper.port_a)
    annotation (Line(points={{0,70},{0,70},{0,60}}, color={191,0,0}));
  connect(lay_upper.port_b, RFic.port_a) annotation (Line(points={{0,40},{-66,40},
        {-66,24},{-66,-28},{-58,-28}},                    color={191,0,0}));
  annotation (
    defaultComponentName="sla",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
          100}})),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={              Rectangle(
        extent={{-100,-60},{100,-100}},
        fillPattern=FillPattern.Solid,
        fillColor={127,0,0},
          pattern=LinePattern.None),
                              Rectangle(
        extent={{-100,100},{100,60}},
        fillPattern=FillPattern.Solid,
        fillColor={127,0,0},
          pattern=LinePattern.None)}));
end BuriedPipe;
