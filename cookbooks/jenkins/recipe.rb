case node[:platform]
when "redhat", "fedora"
  execute 'add repogitory' do
    command 'sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo'
    not_if 'test -e /etc/yum.repos.d/jenkins.repo'
  end

  execute 'add repogitory key' do
    command 'sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key'
    not_if 'rpm -qa gpg-pubkey* | grep jenkins'
  end

  package 'java-1.8.0-openjdk-headless'
end
