#include "json.hpp"
#include <net/http/client.hpp>
#include <net/interfaces>
#include <os>
#include <service>
#include <timers>

using namespace std::literals::string_literals;
using json = nlohmann::json;

static void begin_http(net::Inet &inet)
{
	using namespace http;
	static http::Basic_client basic{ inet.tcp() };
	const auto pop{ "http://127.0.0.1:7379/BRPOP/to_increment/3"s };
	const auto incr{ "http://127.0.0.1:7379/INCR/usage_count"s };
	basic.get(pop, {}, [incr](Error err, Response_ptr res, Connection &) {
		if (not err)
		{
			json j = json::parse(res->Message::body());

			if (j["BRPOP"][1] == nullptr)
			{
				std::cout << "EXITING\n";
				exit(EXIT_SUCCESS);
			}
			else
			{
				const auto trigger_printer{ "http://127.0.0.1:7379/LPUSH/print_count_trigger/print"s };
				basic.get(incr, {}, [trigger_printer](Error err, Response_ptr res, Connection &) {
					if (err)
					{
						printf("\nNo response: %s\n", err.to_string().c_str());
					}
					else
					{
						basic.get(trigger_printer, {}, [](Error err, Response_ptr res, Connection &) {
							if (not err)
							{
								exit(EXIT_SUCCESS);
							}
							else
							{
								exit(EXIT_FAILURE);
							}
						});
					}
				});
			}
		}
		else
		{
			printf("\nNo response: %s\n", err.to_string().c_str());
		}
	});
}

void Service::start()
{
	auto &inet = net::Interfaces::get(0);
	inet.on_config([](auto &inet) { begin_http(inet); });
}
