FROM nginx:latest
COPY webpage/default.conf /etc/nginx/conf.d/default.conf
COPY webpage/nginx.conf /etc/nginx/nginx.conf
COPY host /usr/share/nginx/html
EXPOSE 80
COPY get_cpu_load.sh /usr/local/bin/get_cpu_load.sh
RUN chmod +x /usr/local/bin/get_cpu_load.sh
COPY wrapper_script_wp.sh wrapper_script.sh 
CMD ./wrapper_script.sh 

