#include <cstring>
#include <iostream>
#include <net/interfaces>
#include <net/vlan>
#include <os>

void Service::start()
{
	// Get the IP stack thats already been automatically configured
	auto &inet = net::Interfaces::get(0);
	inet.network_config({ 10, 0, 0, 42 }, { 255, 255, 255, 0 }, { 10, 0, 0, 1 });
	// Setup a TCP echo server on port 7 (echo port)
	auto &server = inet.tcp().listen(7);
	printf("Listening at 10.0.0.42:7\n");
	server.on_connect([](auto conn) {
		// Log incoming connections on the console:
		std::cout << "Connection " << conn->to_string() << " established\n";
		// When data is received, echo back
		conn->on_read(1024, [conn](auto buf) {
			std::cout << "[SERVER] Received: " << buf->data() << std::endl;
			conn->write(buf);
			std::cout << "[SERVER] Sent: " << buf->data() << std::endl;
			if(std::strcmp(reinterpret_cast<char*>(buf->data()), "EXIT\n")==0){
			  exit(EXIT_SUCCESS);
			}
		});
	});
}
