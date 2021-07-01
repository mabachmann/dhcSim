within dhcSim.DHC.Submodules.FourPortModules.BaseClasses;
partial model ExternalProfiles
  // Table
  parameter String tableName="table" "Table name" annotation (Dialog(group="Table data"));
  parameter String fileName="NoName" "File name" annotation (
      Dialog(
      group="Table data",
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]={2,3,4} "Columns of table to be interpolated, 2=QFlow, 3=TNetSup, 4=TEva" annotation (Dialog(group="Table data"));

  Modelica.Blocks.Sources.CombiTimeTable loadTable(
    final tableOnFile=true,
    final fileName=fileName,
    final tableName=tableName,
    final columns=columns,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
                             annotation (Placement(transformation(extent={{-80,-10},
            {-60,10}})));
  Modelica.Blocks.Sources.RealExpression QFlow_table annotation (Placement(transformation(extent={{-40,-10},
            {-20,10}})));
end ExternalProfiles;
