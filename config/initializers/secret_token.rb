# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
NdiDatabase::Application.config.secret_key_base = '037ac9d08101727a04cc52a7a55f39526d540ee56bb850bc7a30e1f19443370c654e549ebfc4d158e491af136a6c0cc43a34d1c1ba15d8bd1584c88105429c93'
