# # encoding: utf-8

# Inspec test for recipe gl_mysql::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe group('mysql') do
  it { should exist }
end

describe user('mysql') do
  it { should exist }
  its('group') { should eq 'mysql' }
end
