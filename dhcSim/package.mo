within ;
package dhcSim "Extension library of Modelica Buildings Library for district heating and cooling components"
annotation (uses(
    Modelica(version="3.2.3"),
    dhcSim(version="5.0.1"),
    Buildings(version="9.0.0"),
    ModelicaServices(version="3.2.3")),
  version="1",
  conversion(noneFromVersion=""),
  Documentation(info="<html>
<p>
The <code>dhcSim</code> library is a free open-source library with basic models to allow dynamic sumlation of complex 
district heating and cooling (DHC) networks. It was developed to ease the modeling of complex DHC systems
from two level concepts (supply and return) up to a large number of parallel network levels. This
library was developed supplementary to the <a href=\"https://github.com/lbl-srg/modelica-buildings\">Modelica Buildings Library</a>.
The dhcSim aims to provide a simple and clear model structure that is user-friendly and applicable to many 
custom network concepts. This library can be used for smaller as well as significantly larger DHC networks.

The figure below shows a section of the schematic view of the model
<a href=\"modelica://dhcSim.DHC.Networks.Examples.DistrictHeating\">

</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://dhcSim/Resources/Images/dhcSimExample.png\" border=\"1\"/>
</p>
<p>

Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end dhcSim;
