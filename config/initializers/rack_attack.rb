Rack::Attack.throttle('requests/ip', limit: 300, period: 5.minutes) do |req|
  req.ip
end

Rack::Attack.throttle('logins/email', limit: 5, period: 20.seconds) do |req|
  if req.path == '/api/v1/auth/login' && req.post?
    req.params['email'].to_s.downcase.strip
  end
end

# Blocklist common attack patterns
Rack::Attack.blocklist('fail2ban-login') do |req|
  Rack::Attack::Fail2Ban.filter(req.ip, maxretry: 5, findtime: 1.minute, bantime: 5.minutes) do
    req.path == '/api/v1/auth/login' && req.post? && req.params['password'].to_s.length < 5
  end
end
