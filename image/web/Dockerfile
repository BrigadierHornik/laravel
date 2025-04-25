FROM nginx:1.27.5
COPY default.conf /etc/nginx/conf.d/
RUN sed -i 's/#gzip  on;/ #gzip  on\n\
proxy_buffer_size   128k;\n\
proxy_buffers   4 256k;\n\
proxy_busy_buffers_size   256k;\n\
fastcgi_buffers 8 16k;\n\
fastcgi_buffer_size 32k;\n\
fastcgi_connect_timeout 90;\n\
fastcgi_send_timeout 90;\n\
fastcgi_read_timeout 90;/g' /etc/nginx/nginx.conf
