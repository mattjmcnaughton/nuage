describe package("haveged") do
  it { should be_installed }
end

describe file('/proc/sys/kernel/random/entropy_avail').content.to_i do
  it { should >= 1000 }
end
