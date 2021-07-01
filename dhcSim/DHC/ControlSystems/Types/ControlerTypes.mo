within dhcSim.DHC.ControlSystems.Types;
type ControlerTypes = enumeration(
    synchron "Synchron producer control",
    sequence "Sequential producer control")
  "Enumeration to define type of producer control"
                                                 annotation (
    Documentation(info="<html>

<p>
Enumeration to define the choice of pressure loss calculations (to be selected via choices menu):
</p>

<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
<th>Description</th></tr>

<tr><td>no_dp</td>
<td>dp_nominal = 0 (lossles pipe)</td></tr>

<tr><td>dp_nominal</td>
<td>Pressure drop defined by ratio m_flow_nominal/sqrt(dp_nominal)</td></tr>

<tr><td>LengthDiameter</td>
<td>Pressure drop defined by ratio m_flow_nominal/sqrt(dp_nominal); diameter, length and m_flow_nominal used to compute dp_nominal</td></tr>

<tr><td>v_nominal</td>
<td>Pressure drop defined by ratio m_flow_nominal/sqrt(dp_nominal); v_nominal used to compute m_flow_nominal</td></tr>


</table>


</html>"));
