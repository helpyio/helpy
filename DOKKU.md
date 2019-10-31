To install on a Dokku Server:

1. Add the app to the server and configure it

  * dokku apps:create helpy
  * dokku domains:add helpy help.<yourdomain.tld>
  * dokku config:set helpy SECRET_KEY_BASE=<your_30+_character_secret>
  * dokku config:set helpy RAILS_ENV=production

2. Add a Postgres database and link it to the app

  * dokku postgres:create helpy
  * dokku postgres:link helpy helpy

3. Push the app to the server

  * git remote add dokku dokku@<yourserver.yourdomain.tld>
  * git push dokku

4. Prepare the app
  
  * dokku enter helpy web
    - rake db:setup
    - rake db:update
    - rake assets:precompile

5. Enjoy.

* https://www.random.org/strings/?num=10&len=20&digits=on&upperalpha=on&loweralpha=on&unique=on&format=html&rnd=new