# Este script instala HAPROXY y lo configura

# Instalación de Consul
sudo apt-get update -y
sudo apt-get install net-tools -y
sudo apt-get install nano -y
sudo apt-get install vim -y
sudo apt install git -y


#Instalacion de HAProxy
sudo apt update -y
sudo apt upgrade -y
sudo apt install haproxy -y
sudo systemctl enable haproxy
sudo systemctl start haproxy

# Definir el archivo a modificar
echo "Modificando haproxy.cfg"

sudo echo 'global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
        ssl-default-bind-options no-sslv3

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http


backend web-backend
   balance roundrobin
   server-template consul_node 2 _web._tcp.service.consul resolvers consul check
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats

frontend http
  bind *:80
  default_backend web-backend

resolvers consul
    nameserver consul 192.168.100.5:8600
	nameserver consul2 192.168.100.6:8600
    accepted_payload_size 8192
    hold valid 5s' > /etc/haproxy/haproxy.cfg
	
echo 'HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Error 503 - Servicio No Disponible</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f8f8;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .error-container {
            text-align: center;
        }

        h1 {
            font-size: 2em;
            color: #dc3545;
            margin-bottom: 10px;
        }

        p {
            font-size: 1.2em;
            color: #555;
            margin-top: 0;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Lo sentimos, estamos experimentando problemas</h1>
        <p>En este momento, no podemos atender tu solicitud. Por favor, inténtalo de nuevo más tarde.</p>
    </div>
</body>
</html>
' > /etc/haproxy/errors/503.http

echo "Archivo de configuración actualizado con éxito."

sudo systemctl restart haproxy
sudo systemctl status haproxy

