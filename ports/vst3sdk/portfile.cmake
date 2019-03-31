include(vcpkg_common_functions)

set(VERSION 3.6.12)

vcpkg_download_distfile(ARCHIVE
    URLS "https://download.steinberg.net/sdk_downloads/vstsdk3612_03_12_2018_build_67.zip"
    FILENAME "vst3sdk.zip"
    SHA512 7f39bf01c055c6ae11f8d982222b511446b9dd9d04ba41344d0d9692ecf491f1e994e8e7e432fef3846eb768ba88a537be46a0b2cd6b9793b72f211ea5c67630
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
)

set(VSTGUI_HAVE_TOOLS "OFF")
if("tools" IN_LIST FEATURES)
    set(VSTGUI_HAVE_TOOLS "ON")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/VST3_SDK
    PREFER_NINJA
    OPTIONS
        -DSMTG_ADD_VST3_HOSTING_SAMPLES=OFF
        -DSMTG_ADD_VST3_PLUGINS_SAMPLES=OFF
        -DSMTG_VSTGUI_TOOLS=${VSTGUI_HAVE_TOOLS}
)

vcpkg_build_cmake()

if("tools" IN_LIST FEATURES)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
    file(INSTALL ${CMAKE_BINARY_DIR}/bin/Release/ImageStitcher.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
    file(INSTALL ${CMAKE_BINARY_DIR}/bin/Release/uidesccompressor.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
endif()

file(INSTALL ${SOURCE_PATH}/VST3_SDK/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk/copyright)
