# Global options
# --------------
 set :ssh_options, {
   keys: DEPLOY_SSH_KEYS,
   forward_agent: false,
   auth_methods: %w(publickey)
 }