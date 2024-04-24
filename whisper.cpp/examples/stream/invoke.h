/*
* Triggers invoke system to call the URLScheme.
*/
#include <cstdlib>
#include <string>

int invokeTurnOn(int deviceNumber) {
    std::string command = "open \"blehub:action?device=" + std::to_string(deviceNumber) + "&action=turn_on\"";
    return system(command.c_str());
}

int invokeTurnOff(int deviceNumber) {
    std::string command = "open \"blehub:action?device=" + std::to_string(deviceNumber) + "&action=turn_off\"";
    return system(command.c_str());
}