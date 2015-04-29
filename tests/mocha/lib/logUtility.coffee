@log = (message, level, framework) ->
  if message? and typeof message is 'object'
    message = JSON.stringify message

  framework ?= 'mocha'
  HTTP.post "http://localhost:3000/log",
    data: { message: message, framework: framework, level: level}
    (error) ->
      if error?
        console.dir error