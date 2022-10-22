variable "rules" {
  description = "Standard set of predefined rules"
  type        = map(any)

  # [direction, access, protocol, source_port_range, destination_port_range, description]"
  # The following info are in the submodules: source_address_prefix, destination_address_prefix
  default = {
    #ActiveDirectory
    ActiveDirectory-AllowADReplication          = ["Inbound", "Allow", "*", "*", "389", "AllowADReplication"]
    ActiveDirectory-AllowADReplicationSSL       = ["Inbound", "Allow", "*", "*", "636", "AllowADReplicationSSL"]
    ActiveDirectory-AllowADGCReplication        = ["Inbound", "Allow", "Tcp", "*", "3268", "AllowADGCReplication"]
    ActiveDirectory-AllowADGCReplicationSSL     = ["Inbound", "Allow", "Tcp", "*", "3269", "AllowADGCReplicationSSL"]
    ActiveDirectory-AllowDNS                    = ["Inbound", "Allow", "*", "*", "53", "AllowDNS"]
    ActiveDirectory-AllowKerberosAuthentication = ["Inbound", "Allow", "*", "*", "88", "AllowKerberosAuthentication"]
    ActiveDirectory-AllowADReplicationTrust     = ["Inbound", "Allow", "*", "*", "445", "AllowADReplicationTrust"]
    ActiveDirectory-AllowSMTPReplication        = ["Inbound", "Allow", "Tcp", "*", "25", "AllowSMTPReplication"]
    ActiveDirectory-AllowRPCReplication         = ["Inbound", "Allow", "Tcp", "*", "135", "AllowRPCReplication"]
    ActiveDirectory-AllowFileReplication        = ["Inbound", "Allow", "Tcp", "*", "5722", "AllowFileReplication"]
    ActiveDirectory-AllowWindowsTime            = ["Inbound", "Allow", "Udp", "*", "123", "AllowWindowsTime"]
    ActiveDirectory-AllowPasswordChangeKerberes = ["Inbound", "Allow", "*", "*", "464", "AllowPasswordChangeKerberes"]
    ActiveDirectory-AllowDFSGroupPolicy         = ["Inbound", "Allow", "Udp", "*", "138", "AllowDFSGroupPolicy"]
    ActiveDirectory-AllowADDSWebServices        = ["Inbound", "Allow", "Tcp", "*", "9389", "AllowADDSWebServices"]
    ActiveDirectory-AllowNETBIOSAuthentication  = ["Inbound", "Allow", "Udp", "*", "137", "AllowNETBIOSAuthentication"]
    ActiveDirectory-AllowNETBIOSReplication     = ["Inbound", "Allow", "Tcp", "*", "139", "AllowNETBIOSReplication"]

    #Cassandra
    Cassandra = ["Inbound", "Allow", "Tcp", "*", "9042", "Cassandra"]

    #Cassandra-JMX
    Cassandra-JMX = ["Inbound", "Allow", "Tcp", "*", "7199", "Cassandra-JMX"]

    #Cassandra-Thrift
    Cassandra-Thrift = ["Inbound", "Allow", "Tcp", "*", "9160", "Cassandra-Thrift"]

    #CouchDB
    CouchDB = ["Inbound", "Allow", "Tcp", "*", "5984", "CouchDB"]

    #CouchDB-HTTPS
    CouchDB-HTTPS = ["Inbound", "Allow", "Tcp", "*", "6984", "CouchDB-HTTPS"]

    #DNS-TCP
    DNS-TCP = ["Inbound", "Allow", "Tcp", "*", "53", "DNS-TCP"]

    #DNS-UDP
    DNS-UDP = ["Inbound", "Allow", "Udp", "*", "53", "DNS-UDP"]

    #DynamicPorts
    DynamicPorts = ["Inbound", "Allow", "Tcp", "*", "49152-65535", "DynamicPorts"]

    #ElasticSearch
    ElasticSearch = ["Inbound", "Allow", "Tcp", "*", "9200-9300", "ElasticSearch"]

    #FTP
    FTP = ["Inbound", "Allow", "Tcp", "*", "21", "FTP"]

    #HTTP
    HTTP = ["Inbound", "Allow", "Tcp", "*", "80", "HTTP"]

    #HTTPS
    HTTPS = ["Inbound", "Allow", "Tcp", "*", "443", "HTTPS"]

    #IMAP
    IMAP = ["Inbound", "Allow", "Tcp", "*", "143", "IMAP"]

    #IMAPS
    IMAPS = ["Inbound", "Allow", "Tcp", "*", "993", "IMAPS"]

    #Kestrel
    Kestrel = ["Inbound", "Allow", "Tcp", "*", "22133", "Kestrel"]

    #LDAP
    LDAP = ["Inbound", "Allow", "Tcp", "*", "389", "LDAP"]

    #MongoDB
    MongoDB = ["Inbound", "Allow", "Tcp", "*", "27017", "MongoDB"]

    #Memcached
    Memcached = ["Inbound", "Allow", "Tcp", "*", "11211", "Memcached"]

    #MSSQL
    MSSQL = ["Inbound", "Allow", "Tcp", "*", "1433", "MSSQL"]

    #MySQL
    MySQL = ["Inbound", "Allow", "Tcp", "*", "3306", "MySQL"]

    #Neo4J
    Neo4J = ["Inbound", "Allow", "Tcp", "*", "7474", "Neo4J"]

    #POP3
    POP3 = ["Inbound", "Allow", "Tcp", "*", "110", "POP3"]

    #POP3S
    POP3S = ["Inbound", "Allow", "Tcp", "*", "995", "POP3S"]

    #PostgreSQL
    PostgreSQL = ["Inbound", "Allow", "Tcp", "*", "5432", "PostgreSQL"]

    #RabbitMQ
    RabbitMQ = ["Inbound", "Allow", "Tcp", "*", "5672", "RabbitMQ"]

    #RDP
    RDP = ["Inbound", "Allow", "Tcp", "*", "3389", "RDP"]

    #Redis
    Redis = ["Inbound", "Allow", "Tcp", "*", "6379", "Redis"]

    #Riak
    Riak = ["Inbound", "Allow", "Tcp", "*", "8093", "Riak"]

    #Riak-JMX
    Riak-JMX = ["Inbound", "Allow", "Tcp", "*", "8985", "Riak-JMX"]

    #SMTP
    SMTP = ["Inbound", "Allow", "Tcp", "*", "25", "SMTP"]

    #SMTPS
    SMTPS = ["Inbound", "Allow", "Tcp", "*", "465", "SMTPS"]

    #SSH
    SSH = ["Inbound", "Allow", "Tcp", "*", "22", "SSH"]

    #WinRM
    WinRM = ["Inbound", "Allow", "Tcp", "*", "5986", "WinRM"]
  }
}
