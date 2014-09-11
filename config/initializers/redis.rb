# Set current Redis instance for Redis-Objects
# May need to abstract this out to a yaml file
# for deployment
Ohm.redis = Redic.new('redis://127.0.0.1:6379')