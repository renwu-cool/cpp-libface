CXXFLAGS=   -std=c++11 -Wall $(COPT) -D_FILE_OFFSET_BITS=64
LINKFLAGS=	-lm -lrt -pthread
INCDEPS=        include/segtree.hpp include/sparsetable.hpp include/benderrmq.hpp \
                include/phrase_map.hpp include/suggest.hpp include/types.hpp \
                include/utils.hpp include/httpserver.hpp include/fasttext_impl.hpp \
								include/lrucache.hpp
INCDIRS=        -I . -I deps -I deps/sent2vec/src
OBJDEPS=        src/httpserver.o deps/libuv/libuv.a
FASTTEXTDEPS=   deps/sent2vec/args.o \
				deps/sent2vec/dictionary.o deps/sent2vec/productquantizer.o \
				deps/sent2vec/matrix.o deps/sent2vec/qmatrix.o  deps/sent2vec/vector.o \
				deps/sent2vec/model.o deps/sent2vec/utils.o deps/sent2vec/fasttext.o
HTTPSERVERDEPS= src/httpserver.cpp include/httpserver.hpp include/utils.hpp \
		include/types.hpp

ifeq "$(findstring debug,$(MAKECMDGOALS))" ""
OBJDEPS += deps/http-parser/http_parser.o
else
OBJDEPS += deps/http-parser/http_parser_g.o
endif

.PHONY: all clean debug test perf

all: CXXFLAGS += -O2
all: targets

debug: CXXFLAGS += -g -DDEBUG
debug: targets

test: CXXFLAGS += -g -DDEBUG
perf: CXXFLAGS += -O2

targets: lib-face

lib-face: src/main.cpp $(OBJDEPS) $(FASTTEXTDEPS) $(INCDEPS)
	$(CXX) -o lib-face src/main.cpp $(OBJDEPS) $(FASTTEXTDEPS) $(INCDIRS) $(CXXFLAGS) $(LINKFLAGS)

src/httpserver.o: $(HTTPSERVERDEPS)
	$(CXX) -o src/httpserver.o -c src/httpserver.cpp $(INCDIRS) $(CXXFLAGS)

deps/libuv/libuv.a:
	$(MAKE) -C deps/libuv

deps/http-parser/http_parser_g.o:
	$(MAKE) -C deps/http-parser http_parser_g.o

deps/http-parser/http_parser.o:
	$(MAKE) -C deps/http-parser http_parser.o


# BUILD fasttext dependencies start
deps/sent2vec/fasttext.o:
	$(MAKE) -C deps/sent2vec fasttext.o
deps/sent2vec/args.o:
	$(MAKE) -C deps/sent2vec args.o
deps/sent2vec/dictionary.o:
	$(MAKE) -C deps/sent2vec dictionary.o
deps/sent2vec/productquantizer.o:
	$(MAKE) -C deps/sent2vec productquantizer.o
deps/sent2vec/matrix.o:
	$(MAKE) -C deps/sent2vec matrix.o
deps/sent2vec/qmatrix.o:
	$(MAKE) -C deps/sent2vec qmatrix.o
deps/sent2vec/vector.o:
	$(MAKE) -C deps/sent2vec vector.o
deps/sent2vec/model.o:
	$(MAKE) -C deps/sent2vec model.o
deps/sent2vec/utils.o:
	$(MAKE) -C deps/sent2vec utils.o
deps/sent2vec/fasttext.o:
	$(MAKE) -C deps/sent2vec fasttext.o
# BUILD fasttext dependencies end

test:
	$(CXX) -o tests/containers tests/containers.cpp -I . $(CXXFLAGS)
	tests/containers

perf:
	$(CXX) -o tests/rmq_perf tests/rmq_perf.cpp -I . $(CXXFLAGS)
	tests/rmq_perf

clean:
	$(MAKE) -C deps/libuv clean
	$(MAKE) -C deps/http-parser clean
	$(MAKE) -C deps/sent2vec clean
	rm -f lib-face tests/containers tests/rmq_perf src/httpserver.o
