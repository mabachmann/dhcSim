within dhcSim.DHC.Submodules.TwoPortModules.Pipe;
model AdiabatePipe "Two port model of adiabate pipe"
  extends dhcSim.DHC.Submodules.TwoPortModules.Pipe.BaseClasses.BasePipe(final
      thicknessIns=0, final lambdaIns=1);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AdiabatePipe;
