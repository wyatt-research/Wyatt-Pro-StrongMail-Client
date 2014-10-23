if [[ -s "/home/vagrant/.rvm/scripts/rvm" ]] ; then
  echo 'RVM installed, skipping RVM install'
else
  curl -sSL https://get.rvm.io | bash -s stable
fi

source '/home/vagrant/.rvm/scripts/rvm'

if rvm list strings | grep -lq ruby-2.1.2 ; then
  echo 'Ruby 2.1.2 installed. Skipping installed.'
else
  rvm autolibs packages
  rvm requirements
  rvm install ruby-2.1.2
  rvm use 2.1.2 --default
  gem update bundler
fi

echo 'Setting Ruby 2.1.2 as default'