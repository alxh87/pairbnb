
web: 			bundle exec unicorn -p $PORT -c ./config/unicorn.rb

worker: 	bundle exec sidekiq -q default -q mailers -c 5
# redis:		bundle exec redis-server
# rails: 		rails s

# sidekiq:	bundle exec sidekiq
# elastic:	elasticsearch