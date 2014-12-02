def my_twitter_client
   Twitter::REST::Client.new do |config|
	  config.consumer_key = 'L354AxtfVYRiSqnriHy014G0z'
	  config.consumer_secret = 'w4rjC8Idsm0sENNk4kZm4WB6k0GTMDZ8GR5othUcQK7euKFS8b'
	  config.access_token = '2900527558-cVOCXYALbuldypoKVHMHSDy1Aclu26cKkDY1Gwz'
	  config.access_token_secret = 'VzIJevkIsNL7aj6cvpM6NtJV1QuLNzA08bUgxSfIxLFWx'
   end
end