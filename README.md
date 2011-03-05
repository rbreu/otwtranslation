== Translation engine for OTWArchive ==

If you need directories other than app, config and lib to be loaded with the gem, please add them to gemspec.
Runtime and development depenencies should be added to otwtranslation.gemspec NOT the Gemfile, they won't be loaded properly by bundler in a rails app otherwise.
You can manually test the engine by going into test_app and starting rails server.
Run cucumber or rspec from the root of the gem, the helper files should load up the test_app to run the actual tests.  I have not touched the rake files but I suspect they will need fixing to work properly.

