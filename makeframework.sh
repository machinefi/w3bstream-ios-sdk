#!/bin/sh

#参数
project_name="W3bStream"
framework_name=${project_name}
build_dir="build"
out_dir="out"

# 清除缓存
function build_clean {
    echo "======build_clean======"

    rm -rf ${build_dir}
    rm -rf ${out_dir}
}

# 配置
function build_config {
    echo "======build_config======"

    # build版本号：日期
    build_version=`date +%y%m%d%H%M%S` 
    /usr/libexec/PlistBuddy -c "Set :  ${build_version}" ./${project_name}/info.plist

    # build版本号：自增
    # build_version=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "./${project_name}/info.plist" )

    # build_version=$(($build_version + 1))
    # /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${build_version}" ./${project_name}/info.plist
}

# 编译
function build_framework {
   echo "======build_framework======"

    # 若支持bitCode，需加参数：-fembed-bitcode
    xcodebuild -project ${project_name}.xcodeproj -sdk iphoneos -configuration "Release" OTHER_CFLAGS="-fembed-bitcode" BUILD_DIR="./${build_dir}" build || exit 1

    xcodebuild -project ${project_name}.xcodeproj -sdk iphonesimulator -configuration "Release" OTHER_CFLAGS="-fembed-bitcode" BUILD_DIR="./${build_dir}" build || exit 1
}

function update_demo {
    cp -R -f ${build_dir}/Release-iphonesimulator/${framework_name}.framework Example/Teeee/Simulator
    cp -R -f ${build_dir}/Release-iphoneos/${framework_name}.framework Example/Teeee/Device
}


# 合并
function build_fat_framework {
    echo "======build_fat_framework======"
    mkdir -p ${out_dir}

    cp -R ${build_dir}/Release-iphoneos/${framework_name}.framework ${out_dir}/
    update_demo
    lipo -create ${build_dir}/Release-iphonesimulator/${framework_name}.framework/${framework_name} ${build_dir}/Release-iphoneos/${framework_name}.framework/${framework_name} -output ${out_dir}/${framework_name}.framework/${framework_name} || exit 1
}

# 压缩
function build_zip {
    echo "======build_zip======"
    cd ${out_dir}
    time=`date +%y%m%d%H%M%S`
    name=${framework_name}_${time}.zip
    zip -r -m -o ${framework_name}.framework.zip ${framework_name}.framework || exit 1
}

# make xcframewrok
function build_xcframework {
xcodebuild -create-xcframework \
 -framework ${build_dir}/Release-iphoneos/${framework_name}.framework \
 -framework ${build_dir}/Release-iphonesimulator/${framework_name}.framework \
 -output ${out_dir}/${framework_name}.xcframework
}


# 调用
build_clean
build_config
build_framework
# build_fat_framework
build_xcframework
build_zip


