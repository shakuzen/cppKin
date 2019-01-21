#!/bin/bash

display_help(){
    echo "                                                               "
    echo "cppkin install [options]..."
    echo "Install                       Install related options."
    echo "======="
    echo "--3rd_loc_prefix=<PREFIX>     3rd party install area prefix.   "
    echo "                                                               "
    echo "--output_dir=<DIR>            cppkin binary install dir.       "
    echo "                                                               "
    echo "--debug                       debug build, otherwise - release."
    echo "                                                               "
    echo "Other options                                                  "
    echo "=============                                                  "
    echo "                                                               "
    echo "--with_thrift                 Scribe transportations layer     "
    echo "                              support.                         "
    echo "                                                               "
    echo "--with_tests                  Run and install cppkin tests     "
    echo "                                                               "
    echo "--with_examples               Compile cppkin examples          "
    echo "                                                               "
    echo "--python_binding=<PRODUCT>    cppkin being exported by -       "
    echo "                              sweetPy|pyBind. Default=sweetPy  "
}

clean_cmake_cache(){
    rm -rf CMakeFiles && rm CMakeCache.txt
}

install(){
    WITH_THRIFT=OFF
    WITH_TESTS=OFF
    WITH_EXAMPLES=OFF
    BUILD_TYPE=Release
    THIRD_PARTY_PREFIX=""
    OUTPUT_DIR=""
    PYTHON_BINDING="sweetPy"
    for argument in "${@:2}"
    do
        case $argument in
            --with_thrift)
                WITH_THRIFT=ON
            ;;
            --with_tests)
                WITH_TESTS=ON
            ;;
            --with_examples)
                WITH_EXAMPLES=ON
            ;;
            --debug)
                BUILD_TYPE=Debug
            ;;
            --3rd_loc_prefix=*)
                THIRD_PARTY_PREFIX="${argument#*=}"
            ;;
            --output_dir=*)
                OUTPUT_DIR="${argument#*=}"
            ;;
            --python_binding=*)
                PYTHON_BINDING="${argument#*=}"
            ;;
        esac
    done
    cmake -DPRE_COMPILE_STEP=ON -D3RD_PARTY_INSTALL_STEP=ON -DCOMPILATION_STEP=ON -DWITH_THRIFT=$WITH_THRIFT -D WITH_TESTS=$WITH_TESTS -DWITH_EXAMPLES=$WITH_EXAMPLES -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DPROJECT_3RD_LOC:STRING=$THIRD_PARTY_PREFIX -DOUTPUT_DIR:STRING=$OUTPUT_DIR -DPYTHON_BINDING:STRING=$PYTHON_BINDING . && make
    clean_cmake_cache
}

while true; do
    case $1 in 
        -h | --help)
            display_help
            if [ "$0" = "$BASH_SOURCE" ]
            then
                exit 0
            else
                return 0
            fi
        ;;
        install)
            install $@
            if [ "$0" = "$BASH_SOURCE" ]
            then
                exit 0
            else
                return 0
            fi
        ;;
        clean_cache)
            clean_cmake_cache
            if [ "$0" = "$BASH_SOURCE" ]
            then
                exit 0
            else
                return 0
            fi
        ;;
        *)
            echo "supported commands - --help, install, clean_cache"
            if [ "$0" = "$BASH_SOURCE" ]
            then
                exit 0
            else
                return 0
            fi
        ;;
    esac
done
