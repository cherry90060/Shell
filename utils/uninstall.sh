shadowsocks_uninstall(){
    if [ "$(command -v ss-server)" ]; then
        # check Shadowsocks-libev status
        ${SHADOWSOCKS_LIBEV_INIT} status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ${SHADOWSOCKS_LIBEV_INIT} stop > /dev/null 2>&1
        fi
        local ss_service_name=$(basename ${SHADOWSOCKS_LIBEV_INIT})
        if check_sys packageManager yum; then
            chkconfig --del ${ss_service_name}
        elif check_sys packageManager apt; then
            update-rc.d -f ${ss_service_name} remove
        fi
    elif [ "$(command -v ssserver)" ]; then
        # check Shadowsocks-rust status
        ${SHADOWSOCKS_RUST_INIT} status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ${SHADOWSOCKS_RUST_INIT} stop > /dev/null 2>&1
        fi
        local ss_service_name=$(basename ${SHADOWSOCKS_RUST_INIT})
        if check_sys packageManager yum; then
            chkconfig --del ${ss_service_name}
        elif check_sys packageManager apt; then
            update-rc.d -f ${ss_service_name} remove
        fi
    fi
    
    # uninstall ss-libev
    rm -fr $(dirname ${SHADOWSOCKS_CONFIG})
    rm -f /usr/local/bin/ss-local
    rm -f /usr/local/bin/ss-tunnel
    rm -f /usr/local/bin/ss-server
    rm -f /usr/local/bin/ss-manager
    rm -f /usr/local/bin/ss-redir
    rm -f /usr/local/bin/ss-nat
    rm -f /usr/local/lib/libshadowsocks-libev.a
    rm -f /usr/local/lib/libshadowsocks-libev.la
    rm -f /usr/local/include/shadowsocks.h
    rm -f /usr/local/lib/pkgconfig/shadowsocks-libev.pc
    rm -f /usr/local/share/man/man1/ss-local.1
    rm -f /usr/local/share/man/man1/ss-tunnel.1
    rm -f /usr/local/share/man/man1/ss-server.1
    rm -f /usr/local/share/man/man1/ss-manager.1
    rm -f /usr/local/share/man/man1/ss-redir.1
    rm -f /usr/local/share/man/man1/ss-nat.1
    rm -f /usr/local/share/man/man8/shadowsocks-libev.8
    rm -fr /usr/local/share/doc/shadowsocks-libev
    rm -f ${SHADOWSOCKS_LIBEV_INIT}
    
    # uninstall ss-rust
    rm -f /usr/local/bin/ssserver
    rm -f /usr/local/bin/sslocal
    rm -f /usr/local/bin/ssdns
    rm -f /usr/local/bin/ssurl
    rm -f ${SHADOWSOCKS_RUST_INIT}
}

v2ray_plugin_uninstall(){
    # kill v2ray-plugin 、obfs-server、gq-server ck-server
    ps -ef |grep -v grep | grep v2ray-plugin |awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
    
    # uninstall v2ray-plugin
    rm -f /var/run/v2ray-plugin.pid
    rm -f /usr/local/bin/v2ray-plugin

}

kcptun_uninstall(){
    # check kcptun status
    if [ -e ${KCPTUN_INIT} ]; then
        ${KCPTUN_INIT} status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ${KCPTUN_INIT} stop > /dev/null 2>&1
        fi
        local kcp_service_name=$(basename ${KCPTUN_INIT})
        if check_sys packageManager yum; then
            chkconfig --del ${kcp_service_name}
        elif check_sys packageManager apt; then
            update-rc.d -f ${kcp_service_name} remove
        fi
    fi
    
    # uninstall kcptun
    rm -fr ${KCPTUN_INSTALL_PATH} > /dev/null 2>&1
    rm -fr $(dirname ${KCPTUN_CONFIG}) > /dev/null 2>&1
    rm -fr ${KCPTUN_LOG_DIR} > /dev/null 2>&1
    rm -f ${KCPTUN_INIT} > /dev/null 2>&1
}

simple_obfs_uninstall(){
    ps -ef |grep -v grep | grep obfs-server |awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
    
    # uninstall simple-obfs
    rm -f /var/run/simple-obfs.pid
    rm -f /usr/local/bin/obfs-local
    rm -f /usr/local/bin/obfs-server
}

goquiet_uninstall(){
    ps -ef |grep -v grep | grep gq-server |awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
    
    # uninstall goquiet
    rm -f /var/run/goquiet.pid
    rm -f /usr/local/bin/gq-server
}

cloak_uninstall(){
    # check cloak status
    if [ -e ${CLOAK_INIT} ]; then
        ${CLOAK_INIT} status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ${CLOAK_INIT} stop > /dev/null 2>&1
        fi
        local ck_service_name=$(basename ${CLOAK_INIT})
        if check_sys packageManager yum; then
            chkconfig --del ${ck_service_name}
        elif check_sys packageManager apt; then
            update-rc.d -f ${ck_service_name} remove
        fi
    fi
    
    ps -ef |grep -v grep | grep ck-server |awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
    
    # uninstall cloak
    rm -f /usr/local/bin/ck-server
    rm -f /usr/local/bin/ck-client
    rm -f ${CLOAK_INIT}
    rm -fr $(dirname ${CK_CLIENT_CONFIG}) > /dev/null 2>&1
}

caddy_uninstall(){
    if [[ -e ${CADDY_BIN_PATH} ]]; then
        PID=`ps -ef |grep "caddy" |grep -v "grep" |grep -v "init.d" |grep -v "service" |grep -v "caddy_install" |awk '{print $2}'`
        [[ ! -z ${PID} ]] && kill -9 ${PID}
        if check_sys packageManager yum; then
            chkconfig --del caddy
        elif check_sys packageManager apt; then
            update-rc.d -f caddy remove
        fi
        [[ -s /tmp/caddy.log ]] && rm -rf /tmp/caddy.log
        rm -rf $(dirname ${CADDY_BIN_PATH})
        rm -rf /etc/init.d/caddy
        rm -rf /usr/bin/caddy
    fi
}

nginx_uninstall(){
    if [[ -e ${NGINX_BIN_PATH} ]]; then
        if check_sys packageManager yum; then
            sudo yum remove -y nginx > /dev/null 2>&1
            rm -rf $(dirname ${NGINX_CONFIG})
        elif check_sys packageManager apt; then
            sudo apt remove -y nginx --purge > /dev/null 2>&1
            rm -rf $(dirname ${NGINX_CONFIG})
        fi
    fi
}

# acme_uninstall(){
    # uninstall acme.sh
    # ~/.acme.sh/acme.sh --uninstall > /dev/null 2>&1 && rm -rf ~/.acme.sh
# }

ipcalc_uninstall(){
    # uninstall ipcalc-0.41
    rm -rf /usr/local/bin/ipcalc-0.41
}









