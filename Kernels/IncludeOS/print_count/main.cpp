#include "json.hpp"
#include <net/http/client.hpp>
#include <net/interfaces>
#include <os>
#include <service>

using namespace std::literals::string_literals;
using json = nlohmann::json;

static void begin_http(net::Inet &inet)
{
	using namespace http;
	static http::Basic_client basic{ inet.tcp() };
	const auto get_count{ "http://127.0.0.1:7379/GET/usage_count"s };
	const auto pop{ "http://127.0.0.1:7379/BRPOP/print_count_trigger/3"s };
	basic.get(pop, {}, [get_count](Error err, Response_ptr res, Connection &) {
		if (not err)
		{
			json j = json::parse(res->Message::body());
			if (j["BRPOP"][1] == nullptr)
			{
				exit(EXIT_SUCCESS);
			}
			else
			{
				basic.get(get_count, {}, [](Error err, Response_ptr res, Connection &) {
					if (not err)
					{
						std::cout << json::parse(res->Message::body())["GET"] << std::endl;
						exit(EXIT_SUCCESS);
					}
					else
					{
						printf("\nNo response: %s\n", err.to_string().c_str());
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
