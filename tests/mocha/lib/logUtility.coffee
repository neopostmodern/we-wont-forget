@log = (message, framework, level) ->
  framework ?= 'mocha'
  HTTP.post "http://localhost:3000/log",
    data: { message: message, framework: framework, level: level}
    (error) -> console.dir error