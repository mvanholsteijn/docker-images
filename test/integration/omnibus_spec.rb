case os.family
when 'redhat'
  pkgs = %w(curl wget ca-certificates iproute rsync openssh-clients)
  toolchain_ver = /^1\.1\.109/
  case os.name
  when 'centos'
    case os.release.to_i
    when 8, 7
      pkgs << 'java-11-openjdk-devel'
    when 6
      pkgs << 'java-1.8.0-openjdk-devel'
    end
  when 'amazon'
    pkgs << 'java-11-amazon-corretto-headless'
  end
when 'debian'
  pkgs = %w(curl wget ca-certificates iproute2 rsync openssh-client libssl-dev)
  case os.arch
  when 'x86_64'
    toolchain_ver = /^1\.1\.109/
  when 'aarch64'
    toolchain_ver = /^2\.0\.2/
  end
  case os.name
  when 'debian'
    case os.release.to_i
    when 10
      pkgs << 'openjdk-11-jdk-headless'
    when 9
      pkgs << 'openjdk-8-jdk-headless'
    when 8
      pkgs << 'openjdk-7-jre-headless'
    end
  when 'ubuntu'
    case os.release.to_i
    when 20
      pkgs << 'openjdk-14-jdk-headless'
    when 18
      pkgs << 'openjdk-11-jdk-headless'
    when 16
      pkgs << 'openjdk-9-jdk-headless'
    end
  end
when 'suse'
  pkgs = %w(curl wget iproute2 rsync openssh tar gzip hostname rpm-build java-11-openjdk-devel)
  case os.arch
  when 'x86_64'
    toolchain_ver = /^1\.1\.109/
  when 'aarch64'
    toolchain_ver = /^2\.0\.2/
  end
end

describe file '/home/omnibus/load-omnibus-toolchain.sh' do
  its('content') { should_not match /^env/ }
end

describe command '/home/omnibus/load-omnibus-toolchain.sh' do
  its('exit_status') { should eq 0 }
end

describe directory '/opt/omnibus-toolchain' do
  it { should exist }
end

describe package 'omnibus-toolchain' do
  it { should be_installed }
  its('version') { should match toolchain_ver }
end

describe command 'gcc --version' do
  its('exit_status') { should eq 0 }
end

pkgs.each do |pkg|
  describe package pkg do
    it { should be_installed }
  end
end

describe package 'chef' do
  it { should_not be_installed }
end
