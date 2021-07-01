within dhcSim.DHC.Submodules.FourPortModules.BaseClasses;
partial model HeatingCurve

  //parameter Real table[:, :] = [0, 50 + 273.15, 20 + 273.15; 258.15, 50 + 273.15, 20 + 273.15; 293.15, 30 + 273.15, 5 + 273.15; 400, 30 + 273.15, 5 + 273.15]
  parameter Real table[:, :] = [0, 50 + 273.15, 10 + 273.15; 258.15, 50 + 273.15, 10 + 273.15; 293.15, 30 + 273.15, 5 + 273.15; 400, 30 + 273.15, 5 + 273.15]
    "Table matrix (grid = first column; e.g., table=[0,2])"
    annotation (Dialog(group="Table data definition",enable=not tableOnFile));

  Modelica.Blocks.Tables.CombiTable1D combiTable1D(
    final tableOnFile=false,
    final table=table,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final columns={2,3})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-30})));
  Modelica.Blocks.Interfaces.RealInput TAmb_in
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
equation
  connect(TAmb_in, combiTable1D.u[1])
    annotation (Line(points={{-60,-120},{-60,-120},{-60,-42}},
                                                        color={0,0,127}));
  connect(TAmb_in, combiTable1D.u[2])
    annotation (Line(points={{-60,-120},{-60,-120},{-60,-42}},
                                                        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatingCurve;
