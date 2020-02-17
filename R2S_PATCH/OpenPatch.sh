#!/bin/bash
clear
./scripts/feeds update -a && ./scripts/feeds install -a
#irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config
#定时重启
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#主题
git clone -b master --single-branch https://github.com/QiuSimons/Luci-argon-19 package/new/luci-theme-argon
#git clone -b master --single-branch https://github.com/jerrykuku/luci-theme-argon package/new/luci-theme-argon
#AdGuard
git clone -b master --single-branch https://github.com/rufengsuixing/luci-app-adguardhome package/new/luci-app-adguardhome
#VSSR
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ssr-plus package/lean/luci-app-ssr-plus
sed -i 's/mux = 1/mux = 0/g' package/lean/luci-app-ssr-plus/root/usr/share/shadowsocksr/subscribe.lua
rm -f ./package/lean/luci-app-ssr-plus/luasrc/model/cbi/shadowsocksr/client.lua
wget -P ./package/lean/luci-app-ssr-plus/luasrc/model/cbi/shadowsocksr https://raw.githubusercontent.com/QiuSimons/SSR_PATCH/master/luasrc/model/cbi/shadowsocksr/client.lua
rm -f ./package/lean/luci-app-ssr-plus/root/etc/init.d/shadowsocksr
wget -P ./package/lean/luci-app-ssr-plus/root/etc/init.d https://raw.githubusercontent.com/QiuSimons/SSR_PATCH/master/root/etc/init.d/shadowsocksr
rm -f ./package/lean/luci-app-ssr-plus/root/usr/share/shadowsocksr/genv2config.lua
wget -P ./package/lean/luci-app-ssr-plus/root/usr/share/shadowsocksr https://raw.githubusercontent.com/QiuSimons/SSR_PATCH/master/root/usr/share/shadowsocksr/genv2config.lua
rm -f ./package/lean/luci-app-ssr-plus/root/usr/share/shadowsocksr/genconfig_v2ray_s.lua
wget -P ./package/lean/luci-app-ssr-plus/root/usr/share/shadowsocksr https://raw.githubusercontent.com/QiuSimons/SSR_PATCH/master/root/usr/share/shadowsocksr/genconfig_v2ray_s.lua
#VSSR依赖
rm -rf ./feeds/packages/net/kcptun
#svn co https://github.com/coolsnowwolf/lede/trunk/tools/upx tools/upx
#svn co https://github.com/coolsnowwolf/lede/trunk/tools/ucl tools/ucl
#sed -i 's/zip/zip ucl upx/g' tools/Makefile
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shadowsocksr-libev package/lean/shadowsocksr-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt package/lean/pdnsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray package/lean/v2ray
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/trojan package/lean/trojan
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipt2socks package/lean/ipt2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/kcptun package/lean/kcptun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/simple-obfs package/lean/simple-obfs
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray-plugin package/lean/v2ray-plugin
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/srelay package/lean/srelay
sed -i 's,$(STAGING,#$(STAGING,g' package/lean/v2ray-plugin/Makefile
#清理内存
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ramfree package/lean/luci-app-ramfree
#打印机
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/lean/luci-app-usb-printer
#流量监视
#git clone -b new-dev https://github.com/brvphoenix/luci-app-wrtbwmon package/lean/luci-app-wrtbwmon
#git clone -b new-dev https://github.com/brvphoenix/wrtbwmon package/lean/wrtbwmon
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-wrtbwmon package/lean/luci-app-wrtbwmon
#流量监管
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-netdata package/lean/luci-app-netdata
#OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash
#SeverChan
git clone -b master --single-branch https://github.com/tty228/luci-app-serverchan package/new/luci-app-serverchan
#SmartDNS
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt package/new/smartdns/smart-op
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-smartdns package/new/smartdns/smart-luci
#上网APP过滤
git clone -b master --single-branch https://github.com/destan19/OpenAppFilter package/new/OpenAppFilter
#FullCone补丁
# FullCone 
git clone -b master --single-branch https://github.com/QiuSimons/openwrt-fullconenat package/fullconenat
# FireWall Patch
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch
# Patch LuCI
pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd
# Patch Kernel
pushd target/linux/generic/hack-4.14
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-4.14/952-net-conntrack-events-support-multiple-registrant.patch
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-4.14/202-reduce_module_size.patch
popd
# X86 patch
pushd target/linux/x86/patches-4.14
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/x86/patches-4.14/900-x86-Enable-fast-strings-on-Intel-if-BIOS-hasn-t-already.patch
popd
#最大连接
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#cn转Hans
bash convert_translation.sh
#翻译
#git clone -b master --single-branch https://github.com/QiuSimons/addition-trans-zh-old package/lean/lean-translate
git clone -b master --single-branch https://github.com/QiuSimons/addition-trans-zh package/lean/lean-translate
chmod -R 755 ./
#生成默认配置及缓存
make defconfig
exit 0


