#include "invoke.h" // Include the header file that declares the invokeTurnOffGrpcCall function
#include <string>

bool checkIfStringIncludes(const std::string& text, const std::string& substring);

enum Action { TURN_ON, TURN_OFF, DO_NOTHING };

Action convertTextToAction(const std::string& text) {
  if (checkIfStringIncludes(text, "turn off")) {
    return TURN_OFF;
  } else if (checkIfStringIncludes(text, "turn on")) {
    return TURN_ON;
  } else {
    return DO_NOTHING;
  }
}

int convertTextToDeviceNumber(const std::string& text) {
  if (checkIfStringIncludes(text, "turn on device four") || checkIfStringIncludes(text, "turn off device four")) {
    return 4;
  } else if (checkIfStringIncludes(text, "turn on device three") || checkIfStringIncludes(text, "turn off device three")) {
    return 3;
  } else if (checkIfStringIncludes(text, "turn on device two") || checkIfStringIncludes(text, "turn off device one")) {
    return 2;
  } else if (checkIfStringIncludes(text, "turn on device one") || checkIfStringIncludes(text, "turn off device two")) {
    return 1;
  } else {
    return 0;
  }
}

/*
 * substring must be in lower case, this check is case insensitive.
 */
bool checkIfStringIncludes(const std::string& text, const std::string& substring) {
  std::string lowercaseText = text;
  std::transform(lowercaseText.begin(), lowercaseText.end(), lowercaseText.begin(), [](unsigned char c) {
    return std::tolower(c);
  });
    return lowercaseText.find(substring) != std::string::npos;
}

void handleText(const std::string& text) {
    Action action = convertTextToAction(text);
    int deviceNumber = convertTextToDeviceNumber(text);
    switch (action)
    {
        case TURN_ON:
            printf("Turning on the flipper for device %d.\n", deviceNumber);
            invokeTurnOn(deviceNumber);
            break;
        case TURN_OFF:
            printf("Turning off the flipper for device %d.\n", deviceNumber);
            invokeTurnOff(deviceNumber);
            break;
        case DO_NOTHING:
            printf("Doing nothing\n");
            break;
    }
}
