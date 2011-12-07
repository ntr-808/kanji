name: 'vocab'

description: "Because the ones that exist suck."

keywords: ['']

version: require('fs').readFileSync('./VERSION', 'utf8')

author: 'Nathan Rashleigh'

contributors: [
  'Nathan Rashleigh <n.rashleigh@gmail.com>'
]

main: 'server.coffee'

dependencies:
  browserify: '*'
  colors: '*'
  connect: '*'
  stylus: '*'
  underscore: '*'

engines:
  node: '~0.4.0'
  npm: '~1.0.0'