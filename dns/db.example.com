;
; Arquivo de zona para example.com
;

$TTL    604800
@       IN      SOA     ns1.example.com. admin.example.com. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

; Definições de servidores de nomes
@       IN      NS      ns1.example.com.

; Mapeamento de nomes para endereços IP
ns1     IN      A       192.0.2.1
