FROM nginx:latest
COPY host /usr/share/nginx/html
COPY reverse-proxy/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY reverse-proxy/nginx.conf /etc/nginx/nginx.conf
COPY reverse-proxy/conf.d/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY reverse-proxy/conf.d/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
EXPOSE 80
COPY log_daemon.sh /usr/local/bin/log_daemon.sh
RUN chmod +x /usr/local/bin/log_daemon.sh
COPY wrapper_script_rp.sh wrapper_script.sh 
CMD ./wrapper_script.sh 