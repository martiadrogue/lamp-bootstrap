-- UPDATE mysql.user SET Password=PASSWORD('12345') WHERE User='root';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '12345';
CREATE USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY '12345';
GRANT ALL ON *.* TO 'root'@'localhost';
GRANT ALL ON *.* TO 'user'@'localhost';

ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;