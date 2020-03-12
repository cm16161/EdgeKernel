#include <memdisk>
#include <net/interfaces>
#include <net/openssl/init.hpp>

#include "json.hpp"
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
	const auto size_command{ "http://127.0.0.1:7379/LRANGE/echo/0/-1"s };
	Timers::periodic(1s, 1s, [size_command](auto) {
		basic.get(size_command, {}, [size_command](Error err, Response_ptr res, Connection &) {
			if (not err)
			{
				json j = json::parse(res->Message::body());
				int queue_size = j["LRANGE"].size();
				if (queue_size == 0)
				{
					exit(EXIT_SUCCESS);
				}
				else
				{

					const auto url{ "http://127.0.0.1:7379/LPOP/echo"s };
					basic.get(url, {}, [url](Error err, Response_ptr res, Connection &) {
						if (not err)
						{
							json j = json::parse(res->Message::body());
							std::cout << j["LPOP"] << std::endl;
						}
						else
						{
							printf("\n%s - No response: %s\n", url.c_str(), err.to_string().c_str());
							printf("Make sure the virtual machine can reach internet.\n");
						}
					});
				}
			}
			else
			{
				printf("\n%s - No response: %s\n", size_command.c_str(), err.to_string().c_str());
				printf("Make sure the virtual machine can reach internet.\n");
			}
		});
	});
}

void Service::start()
{
	auto &inet = net::Interfaces::get(0);
	inet.on_config([](auto &inet) { begin_http(inet); });
	// Timers::oneshot(std::chrono::milliseconds(5000), [](auto) {
	//	std::cout << "TSET\n";
	//	exit(EXIT_SUCCESS);
	// });
}
