FROM zalox/manjaro
MAINTAINER SSE4 <tomskside@gmail.com>

RUN pacman-db-upgrade && \
    pacman --noconfirm -Syyu && \
    pacman --noconfirm -S python-pip


ENV CMAKE_VERSION=3.11.4

RUN pacman --noconfirm -S tar gzip && \
    curl https://cmake.org/files/v3.11/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz | tar -xz

RUN pacman --noconfirm -S shadow && \
    python -m pip install -q --no-cache-dir conan && \
    groupadd users && \
    groupadd wheel && \
    groupadd g2000 -g 2000 && \
    useradd -ms /bin/bash conan -G g2000 && \
    printf "conan:conan" | chpasswd && \
    usermod -aG wheel conan && \
    printf "conan ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

RUN pacman --noconfirm -S clang
RUN pacman --noconfirm -S make sudo grep sed diffutils autoconf automake pkgconfig

USER conan
WORKDIR /home/conan
RUN mkdir -p /home/conan/.conan

ENV PATH=$PATH:/cmake-${CMAKE_VERSION}-Linux-x86_64/bin
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++

CMD ["/bin/bash"]
