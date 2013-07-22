#!/bin/bash

main ()
{
    set_environment
    
    deploy > >(tee deploy.out) 2> deploy.err
}

set_environment ()
{
    export CERN=$PWD
    export CERNLIB_VER=2006
    export CERN_LEVEL="$CERNLIB_VER"
    export CERN_ROOT="$CERN/$CERN_LEVEL"
    export CERN_LIB="$CERN_ROOT/lib"
    export CVSCOSRC="$CERN_ROOT/src"
    export PATH="$PATH:$CERN_ROOT/bin"
    
    TARBALLS="$CERN/tarballs"
    
    lapack_version=3.4.2
    my_lapack="lapack-${lapack_version}"
    
    MCFM_version=6.6
    my_MCFM="MCFM-${MCFM_version}"

    mkdir -p ${CERN_LIB}
}

deploy ()
{
    get_tarballs

    build_blas
    build_lapack
    build_cernlib

    build_mcfm

    debug_echo "*** Deployment finished."
}

get_tarballs ()
{
    debug_echo "*** Fetching tarballs"
    
    if [ ! -d "$TARBALLS" ]; then
        mkdir $TARBALLS
        cd $TARBALLS
        
        get_package http://cernlib.web.cern.ch/cernlib/download/${CERNLIB_VER}_source/tar/${CERNLIB_VER}_src.tar.gz
        get_package http://cernlib.web.cern.ch/cernlib/download/${CERNLIB_VER}_source/tar/include.tar.gz
        get_package http://www.netlib.org/blas/blas.tgz
        get_package http://www.netlib.org/lapack/${my_lapack}.tgz
        get_package http://mcfm.fnal.gov/${my_MCFM}.tar.gz
    fi
}

build_blas ()
{
    debug_echo "*** Building BLAS"

    cd $CERN
    rm -rf BLAS*
    tar zxf $TARBALLS/blas.tgz
    cd BLAS
    
    sed -i 's/g77/gfortran/g' make.inc
    
    make    
    cp blas_LINUX.a ${CERN_LIB}/libblas.a
}

build_lapack ()
{
    debug_echo "*** Building LAPACK ${lapack_version}"

    cd $CERN
    rm -rf lapack*
    tar zxf $TARBALLS/${my_lapack}.tgz
    cd ${my_lapack}
    cp make.inc.example make.inc
    
    sed -i 's/g77/gfortran/g' make.inc
    sed -i 's#../../librefblas.a#'"${CERN_LIB}/libblas.a#g" make.inc
    
    make
    
    cp *.a ${CERN_LIB}
    ln -s ${CERN_LIB}/liblapack.a ${CERN_LIB}/liblapack3.a
}

build_cernlib ()
{
    debug_echo "*** Building CERNLIB ${CERNLIB_VER}"

    rm -rf $CERN_ROOT/bin $CERN_ROOT/build $CERN_ROOT/src 
    cd $CERN
    tar zxf $TARBALLS/${CERNLIB_VER}_src.tar.gz
    tar zxf $TARBALLS/include.tar.gz
    cd $CERN_ROOT
    mkdir -p build bin build/log
    
    for conf_file in $CVSCOSRC/config/linux*.cf; do
        sed -e '/CERNLIB_SHIFT/ s/\/\* # /#/g' -e '/CERNLIB_SHIFT/ s/YES.*/YES/g' -i $conf_file 
        sed -e '/#undef unix/ a\#define Hasgfortran YES' -e '/gcc4/ s//gcc/g' -i $conf_file
    done
    cd $CERN_ROOT/build
    $CVSCOSRC/config/imake_boot
    gmake bin/kuipc > log/kuipc 2>&1
    gmake scripts/Makefile    
    cd scripts
    gmake install.bin > ../log/scripts 2>&1
    gmake install.bin > ../log/scripts 2>&1
    gmake install.bin > ../log/scripts 2>&1
    
    cd $CERN_ROOT/build
    echo "Compiling CERNLIB..."
    gmake > log/make.`date +%m%d` 2>&1
}

build_mcfm ()
{
    debug_echo "*** Building MCFM ${MCFM_version}"
    
    cd $CERN
    rm -rf ${my_MCFM}
    tar xzf $TARBALLS/${my_MCFM}.tar.gz
    cd ${my_MCFM}

    # Syntax corrections required for running as a Bash script
    sed -i 's#set CERNLIB     =#export CERNLIB='"${CERN_LIB}#g" Install
    sed -i 's#\[\$#[ "$#g' Install
    sed -i "s#'\]#' \]#g" Install
    sed -i 's# ==#" ==#g' Install
    ./Install
    
    #sed -i 's/PDFROUTINES = NATIVE/PDFROUTINES = PDFLIB/' makefile
    sed -i 's/NTUPLES = NO/NTUPLES = YES/g' makefile
    
    make
}

debug_echo ()
{
    echo "$@"
    echo "$@" 1>&2
}

get_package ()
{
    local package=$1
    
    local filename=`basename "$package"`
    if [ ! -e "$filename" ]; then
        echo "Downloading $filename"
        wget -q $package
    else
        echo "$filename already exists"
    fi
}

main "$@"

