sudo gem uninstall cocoapods-depend
gem build cocoapods_depend.gemspec
sudo gem install *.gem
rm *.gem
