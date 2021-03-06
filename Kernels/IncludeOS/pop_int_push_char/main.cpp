#include <memdisk>
#include <net/interfaces>
#include <net/openssl/init.hpp>

#include "json.hpp"
#include <kernel/events.hpp>
#include <net/http/client.hpp>
#include <profile>
#include <service>
#include <sys/time.h>
#include <thread>
#include <timers>
using namespace std::literals::string_literals;
using json = nlohmann::json;

static void begin_http(net::Inet &inet)
{

	using namespace http;
	static http::Basic_client basic{ inet.tcp() };
	const auto blocking_pop{ "http://127.0.0.1:7379/BRPOP/int/3"s };
	const auto push_char{ "http://127.0.0.1:7379/LPUSH/char/a"s };

	basic.get(blocking_pop, {}, [push_char](Error err, Response_ptr res, Connection &) {
		if (not err)
		{
			json j = json::parse(res->Message::body());

			if (j["BRPOP"][1] == nullptr)
			{
				exit(EXIT_SUCCESS);
			}
			else
			{
				basic.get(push_char, {}, [push_char](Error err, Response_ptr res, Connection &) {
					if (not err)
					{
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
