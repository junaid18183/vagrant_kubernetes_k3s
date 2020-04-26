# Comparison

##### Function defination

Below is the example of sample python function

kubeless

```
def hello(event, context):
  print event
  return event['data']
```

fission

```
from flask import current_app
def main():
    current_app.logger.info("This is log message")
    return "My First Example"
```

openfass

```
def handle(req):
    print("Hello! You said: " + req)
    return req
```

knative

```
import os
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello_world():
   target = os.environ.get('TARGET', 'World')
   return 'Hello {}!\n'.format(target)
if __name__ == "__main__":
   app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
```



compare to the standard aws lamda function defination

```
def handler_name(event, context): 
    ...
    return some_value
```

Looking at above , the **kubeless is 100% compatible with aws lambda.**

So if you are migrating from existing aws lamda to kubernetes service, this can be a huge win.

------

TODO - Add more details.