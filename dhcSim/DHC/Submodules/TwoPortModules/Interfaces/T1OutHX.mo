within dhcSim.DHC.Submodules.TwoPortModules.Interfaces;
function T1OutHX
  "Function calculates return temperature on grid side of indirect heat/cool consumers; Asuming constant nominal mass flow rate on building side."

 input Modelica.SIunits.HeatFlowRate QFlow_nominal "Absolute nominal heat flow rate";
 input Modelica.SIunits.HeatFlowRate QFlow "Actual heat flow rate";
 input Modelica.SIunits.SpecificHeatCapacity cp "Heat capacity of fluid";
 input Modelica.SIunits.Temperature T1In_nominal "Nominal Temperature of inflow at network side";
 input Modelica.SIunits.Temperature T1Out_nominal "Nominal Temperature of outflow at network side";
 input Modelica.SIunits.Temperature T2In_nominal "Nominal Temperature of inflow at building side";
 input Modelica.SIunits.Temperature T2Out_nominal "Nominal Temperature of outflow at building side";
 input Modelica.SIunits.Temperature T1In "Actual temperature of inflow at network side";
 input Modelica.SIunits.Temperature T2Out "Actual temperature of outflow at building side";
 input Boolean FlagHeatCon=true "If true: heat consumer; if false: cold consumer";
 //output Modelica.SIunits.MassFlowRate m_flow_1 "Actual mass flow rate on network side";
 output Modelica.SIunits.Temperature T1Out "Actual temperature of outflow at network side";

protected
  parameter Modelica.SIunits.MassFlowRate m_flow_2 = abs(QFlow_nominal/(cp*(T2In_nominal-T2Out_nominal)))   "mass flow rate on buildings side, asumed to be constant";
  parameter Modelica.SIunits.TemperatureDifference dTm = dhcSim.DHC.Submodules.TwoPortModules.Interfaces.LogMeanTemp(T1In_nominal, T1Out_nominal, T2In_nominal, T2Out_nominal);

  parameter Modelica.SIunits.ThermalConductance UA = abs(QFlow_nominal)/dTm "UA value";

  Modelica.SIunits.Temperature T2In "Return temperature on building side";

  Real Phi2 "Actual characteristic value of heat exchanger on buildings side";

  Real NTU2 "Actual number of transfer units on building side";

  Real R2 "Actual coefficient between heat capacity flows";

algorithm
  if FlagHeatCon==true then
    T2In:=T2Out - abs(QFlow)/(m_flow_2*cp);
  else
    T2In:=T2Out + abs(QFlow)/(m_flow_2*cp);
  end if;
  Phi2:=abs(QFlow/(m_flow_2*cp*(T2In-T1In)));
  NTU2:=abs(UA/cp/m_flow_2);
  R2 := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function dhcSim.DHC.Submodules.TwoPortModules.Interfaces.CharCounterFlowHX(
      Phi=Phi2, NTU=NTU2),
    -Modelica.Constants.inf,
    Modelica.Constants.inf,
    Modelica.Constants.eps*1000);
  if FlagHeatCon==true then
    T1Out:=T1In - abs(QFlow*R2)/m_flow_2/cp;
  else
    T1Out:=T1In + abs(QFlow*R2)/m_flow_2/cp;
  end if;

end T1OutHX;
