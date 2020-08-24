#
#class profile::base::access (
#	Array[ String[1] ] $required_pkgs,
#	Hash $access_allow,
#	Hash $access_deny,
#	Hash $access_deny_before,
#	Hash $pam_config,
#) {
class profile::base::access {

	# Make sure pam is installed.
  $required_pkgs = [
    'pam',
    'pam_krb5'
  ]
	ensure_packages( $required_pkgs )

	# Configure access.conf
	pam_access::entry { 'Default Allow - all root from local':
		user       => 'root',
		origin     => 'LOCAL cron crond 127.0.0.1 :0 tty',
		permission => '+',
		position   => 'before',
	}

	pam_access::entry { 'Default Deny':
		user       => 'ALL',
		origin     => 'ALL',
		permission => '-',
		position   => 'after',
	}

#	each($access_allow) |String[1] $key, Hash $value| {
#		pam_access::entry { $key:
#			*          => $value,
#			permission => '+',
#			position   => '-1',
#		}
#	}
#
#	each($access_deny) |String[1] $key, Hash $value| {
#		pam_access::entry { $key:
#			*          => $value,
#			permission => '-',
#			position   => 'after',
#		}
#	}
#
#	each($access_deny_before) |String[1] $key, Hash $value| {
#		pam_access::entry { $key:
#			*          => $value,
#			permission => '-',
#			position   => 'before',
#		}
#	}

	# Configure pam
	each($pam_config) |String[1] $key, Hash $value| {
		pam { $key:
			* => $value,
		}
  }

}
