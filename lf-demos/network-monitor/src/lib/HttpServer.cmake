list(APPEND CMAKE_PREFIX_PATH /usr/local /opt/homebrew)
find_library(MICROHTTPD_LIB microhttpd REQUIRED)
find_path(MICROHTTPD_INCLUDE_DIR microhttpd.h REQUIRED)

target_link_libraries(${LF_MAIN_TARGET} PRIVATE ${MICROHTTPD_LIB})
target_include_directories(${LF_MAIN_TARGET} PRIVATE ${MICROHTTPD_INCLUDE_DIR})
