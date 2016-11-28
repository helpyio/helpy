How to install on Heroku
========================

If you wish to install Helpy on Heroku, there are some changes you will need to
make, documented here for reference.

1. To start out, clone the repo to you localhost:
`git clone https://github.com/helpyio/helpy.git`

2. Next, open the `Gemfile` and add the required 12factor gem for Heroku.  You
can do this by uncommenting the line in the `production` section at the bottom of
the file:

`gem 'rails_12factor'`

3. From Helpy 1.x onwards, Helpy uses Carrierwave with the filesystem backend for
file storage.  This is NOT compatible with Heroku, and you will need to add the
fog gem and specify a cloud storage provider.

You can alternatively configure Helpy to use Cloudinary in the settings UI under
integrations.

Once you have done these things, you should be able to push to Heroku and your
site will be live.
