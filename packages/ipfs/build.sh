TERMUX_PKG_HOMEPAGE=https://ipfs.io/
TERMUX_PKG_DESCRIPTION="A peer-to-peer hypermedia distribution protocol"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.4.22
TERMUX_PKG_SRCURL=https://github.com/ipfs/go-ipfs/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85849d951ba376266ff8c9f08d53f1feeeda60b688bd6c0a0642a8cbcbacde12

termux_step_make() {
    termux_setup_golang

    export GOPATH=${TERMUX_PKG_BUILDDIR}
    export GOARCH=${TERMUX_ARCH}

    if [ "${TERMUX_ARCH}" = "aarch64" ]; then
        GOARCH="arm64"
    elif [ "${TERMUX_ARCH}" = "i686" ]; then
        GOARCH="386"
    elif [ "${TERMUX_ARCH}" = "x86_64" ]; then
        GOARCH="amd64"
    fi

    mkdir -p "${GOPATH}/src/github.com/ipfs"
    cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ipfs/go-ipfs"
    cd "${GOPATH}/src/github.com/ipfs/go-ipfs"

    make build

    # Fix folders without write permissions preventing which fails repeating builds:
    cd $TERMUX_PKG_BUILDDIR
    find . -type d -exec chmod u+w {} \;
}

termux_step_make_install() {
    mkdir -p "${TERMUX_PREFIX}/bin"
    cp -f "${TERMUX_PKG_BUILDDIR}/src/github.com/ipfs/go-ipfs/cmd/ipfs/ipfs" "${TERMUX_PREFIX}/bin/"
}
