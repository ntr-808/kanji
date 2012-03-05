Browser = require 'zombie'
assert = require 'assert'

#// Load the page from localhost
browser = new Browser
# browser.debug = true

browser.visit "http://localhost:1984/", () =>
  browser.wait 1000, () ->
    console.log browser.html()