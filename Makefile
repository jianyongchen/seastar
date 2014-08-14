
mode = release

sanitize.debug = -fsanitize=address -fsanitize=leak -fsanitize=undefined
sanitize.release =

opt.debug = -O0
opt.release = -O2 -flto

sanitize = $(sanitize.$(mode))
opt = $(opt.$(mode))

CXXFLAGS = -std=gnu++1y -g -Wall -Werror $(opt) -MD -MT $@ -MP -flto $(sanitize) -fvisibility=hidden

tests = test-reactor

all: seastar $(tests) httpd

clean:
	rm seastar $(tests) *.o

seastar: main.o reactor.o
	$(CXX) $(CXXFLAGS) -o $@ $^

test-reactor: test-reactor.o reactor.o
	$(CXX) $(CXXFLAGS) -o $@ $^

httpd: httpd.o reactor.o
	$(CXX) $(CXXFLAGS) -o $@ $^

-include *.d