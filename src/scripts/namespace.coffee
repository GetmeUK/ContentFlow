
ContentFlow =

    getFlowCls: () ->
        # Return the flow model class to use for the application
        return ContentFlow.FlowModel

    getSnippetCls: () ->
        # Return the snippet model class to use for the application
        return ContentFlow.SnippetModel

    getSnippetTypeCls: () ->
        # Return the snippet type model class to use for the application
        return ContentFlow.SnippetTypeModel


# Export the namespace

# Browser (via window)
if typeof window != 'undefined'
    window.ContentFlow = ContentFlow

# Node/Browserify
if typeof module != 'undefined' and module.exports
    exports = module.exports = ContentFlow