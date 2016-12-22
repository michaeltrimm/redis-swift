FROM perfectlysoft/ubuntu1510
RUN /usr/src/Perfect-Ubuntu/install_swift.sh --sure
RUN git clone https://github.com/michaeltrimm/redis-swift /usr/src/redis-swift
WORKDIR /usr/src/redis-swift
RUN swift build
CMD .build/debug/redis-swift --port 80
