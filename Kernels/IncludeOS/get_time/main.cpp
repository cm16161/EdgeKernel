#include "json.hpp"
#include <isotime>
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
	const auto blocking_pop{ "http://127.0.0.1:7379/RPOP/timestamp"s };
	const auto trigger_counter{ "http://127.0.0.1:7379/LPUSH/to_increment/increment"s };

	basic.get(blocking_pop, {}, [trigger_counter](Error err, Response_ptr res, Connection &) {
		if (not err)
		{
			std::cout << isotime::now() << std::endl;
			basic.get(trigger_counter, {}, [](Error err, Response_ptr res, Connection &) {
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

void Service::start()
{
	auto &inet = net::Interfaces::get(0);
	inet.on_config([](auto &inet) { begin_http(inet); });
}
