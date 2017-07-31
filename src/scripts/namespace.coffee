
ContentFlow = {}

# Export the namespace

# Browser (via window)
if typeof window != 'undefined'
    window.ContentFlow = ContentFlow

# Node/Browserify
if typeof module != 'undefined' and module.exports
    exports = module.exports = ContentFlow