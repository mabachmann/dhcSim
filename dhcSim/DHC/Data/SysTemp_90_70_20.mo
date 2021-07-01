within dhcSimSep.DHC.Data;
record SysTemp_90_70_20 =
                       dhcSimSep.DHC.Data.SystemTemperatures (
    TRoo_nominal=273.15 + 20,
    TRoo=273.15 + 20,
    TAmb_nominal=273.15 - 15,
    TSup_nominal=273.15 + 90,
    TRet_nominal=273.15 + 70,
    m=1.3) "System temperatures 90/70/20";
