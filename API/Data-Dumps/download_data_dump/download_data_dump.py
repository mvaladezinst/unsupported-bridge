# Download data dump. Replace domain & Token values.

import requests
import time

session = requests.Session()
session.headers['User-agent'] = 'BridgeApp Python Library'
session.headers['accept'] = 'application/json'
session.headers['cache-control'] = 'no-cache'
session.headers['content-type'] = 'application/json'
session.headers[
    'Authorization'] = '<TOKEN>'

post = requests.Request('POST', 'https://<bridge-domain>.bridgeapp.com/api/admin/data_dumps')
prep_post = session.prepare_request(post)
post_resp = session.send(prep_post, stream=False, verify=True, proxies={}, allow_redirects=True)

print(post_resp.status_code)
print(post_resp.url)
print(post_resp.headers)

time.sleep(10)

req = requests.Request('GET', 'https://<bridge-domain>.bridgeapp.com/api/admin/data_dumps/download')
prepped = session.prepare_request(req)
resp = session.send(prepped, stream=False, verify=False, proxies={}, allow_redirects=True)

print(resp.status_code)
print(resp.url)
print(resp.headers)

print(resp.history)
