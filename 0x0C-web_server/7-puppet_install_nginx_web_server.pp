# Install Nginx
package { 'nginx':
  ensure => installed,
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => Package['nginx'],
}

# Create the Hello World index page
file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0644',
  require => Package['nginx'],
}

# Add 301 redirect configuration to Nginx default site
file_line { 'redirect_me block':
  path  => '/etc/nginx/sites-available/default',
  line  => '    location /redirect_me { return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4; }',
  match => '^\s*location /redirect_me',
  notify => Service['nginx'],
}

# Reload nginx if config is changed
exec { 'reload-nginx':
  command     => '/etc/init.d/nginx reload',
  refreshonly => true,
  subscribe   => File_line['redirect_me block'],
}
