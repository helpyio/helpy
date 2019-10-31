#!/bin/bash
dropdb helpy_production
createdb helpy_production

ssh helpy@help.achi.tech "pg_dump -U helpy -W -F t helpy_production" > helpylive.tar
pg_restore -d helpy_production helpylive.tar -c -U tmerritt -C -x --no-owner

rake assets:precompile && \
  source ~/.rvm/scripts/rvm && \
  rvm use ruby-2.4.6 && \
  SECRET_KEY_BASE=34slqejkrh13kofjh3povi RAILS_ENV=production rails s -b 0 -p 8080
