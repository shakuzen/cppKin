#include <string>
#include <boost/program_options.hpp>
#include "Core/src/Logger.h"
#include "Core/src/TraceListener.h"
#include "src/cppkin.h"

using namespace std;
using namespace core;
using namespace boost::program_options;

int main( int argc, const char *argv[] )
{
    options_description desc{"Options"};
        desc.add_options()
          ("help,h", "Help screen")
          ("transport", value<string>()->default_value("http"), "Transport" )
          ("host", value<string>()->default_value("127.0.0.1"), "Host" )
          ("port", value<int>()->default_value(-1), "Port")
          ("service", value<string>()->default_value("example_service"), "Service");

    variables_map vm;
    store(parse_command_line(argc, argv, desc), vm);
    notify(vm);

    if (vm.count("help")) {
        std::cout << desc << '\n';
        return 0;
    }

    int port = 9411;
    auto transportType = cppkin::TransportType::Http;
    if (vm["transport"].as<string>() == "scribe") {
        transportType = cppkin::TransportType::Scribe;
        if (vm["port"].as<int>() == -1 ) {
            port = 9410;
        }
    }

    cppkin::GeneralParams cppkinParams;
    cppkinParams.AddParam(cppkin::ConfigTags::HOST_ADDRESS, vm["host"].as<string>());
    cppkinParams.AddParam(cppkin::ConfigTags::PORT, port);
    cppkinParams.AddParam(cppkin::ConfigTags::SERVICE_NAME, vm["service"].as<string>());
    cppkinParams.AddParam(cppkin::ConfigTags::DEBUG, true);
    cppkinParams.AddParam(cppkin::ConfigTags::SAMPLE_COUNT, 1);
    cppkinParams.AddParam(cppkin::ConfigTags::TRANSPORT_TYPE, cppkin::TransportType(transportType).ToString());
    cppkinParams.AddParam(cppkin::ConfigTags::ENCODING_TYPE, cppkin::EncodingType(cppkin::EncodingType::Thrift).ToString());
    INIT(cppkinParams);

    CREATE_TRACE("Test");
    TRACE_EVENT("Event1");
    SUBMIT_SPAN();
    CREATE_TRACE("Test2");
    TRACE_EVENT("Event2");
    SUBMIT_SPAN();

    ::sleep(5);
    return 0;
}
