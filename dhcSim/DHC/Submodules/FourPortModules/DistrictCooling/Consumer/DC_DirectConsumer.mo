within dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer;
model DC_DirectConsumer
  "Four port model of district cooling consumer with continous demand."
  extends
    dhcSim.DHC.Submodules.FourPortModules.DistrictCooling.Consumer.BaseClasses.DC_DirectConsumer;

equation

  Q_flowTot = max(loadTable.y[1], 0.0);

end DC_DirectConsumer;
