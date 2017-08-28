
class ContentFlow.BaseAPI

    # ContentFlow interfaces use API classes to request information or changes
    # (typically from a remote server). Each application ContentFlow is
    # integrated into will likely have its own API class or will implement its
    # API around the base API for ContentFlow.

    constructor: (baseURL='/', baseParams={}) ->

        # A base URL to be prepended to all API endpoints
        @baseURL = baseURL

        # A base table of parameters that will be attached to all API requests
        @baseParams = baseParams

    # API methods

    # GET

    getGlobalSnippets: (flow) ->
        # Request a list of gloval snippets for the given content flow
        return @_callEndpoint('GET', 'global-snippets', {flow: flow.id})

    getSnippets: (flow) ->
        # Request a list of snippets for the given content flow
        return @_callEndpoint('GET', 'snippets', {flow: flow.id})

    getSnippetTypes: (flow) ->
        # Request a list of snippet types for the given content flow
        return @_callEndpoint('GET', 'snippet-types', {flow: flow.id})

    getSnippetSettingsForm: (flow, snippet) ->
        # Request a list of fields for the the snippet settings form
        return @_callEndpoint(
            'GET',
            'update-snippet-settings',
            {flow: flow.id, snippet: snippet.id}
            )

    # POST

    addSnippet: (flow, snippetType) ->
        # Add a new snippet of the given type to the content flow
        return @_callEndpoint(
            'POST',
            'add-snippet',
            {flow: flow.id, snippet_type: snippetType.id}
        )

    addGlobalSnippet: (flow, globalSnippet) ->
        # Add a global snippet to the content flow
        return @_callEndpoint(
            'POST',
            'add-global-snippet',
            {flow: flow.id, global_snippet: globalSnippet.globalId}
        )

    changeSnippetScope: (flow, snippet, scope, label=null) ->
        # Change the scope of the given snippet
        return @_callEndpoint(
            'POST',
            'change-snippet-scope',
            {flow: flow.id, snippet: snippet.id, scope: scope, label: label}
        )

    updateSnippetSettings: (flow, snippet, settings) ->
        # Update the settings for the given snippet
        params = {flow: flow.id, snippet: snippet.id}
        for k, v of settings
            params[k] = v
        return @_callEndpoint('POST', 'update-snippet-settings', params)

    deleteSnippet: (flow, snippet) ->
        # Delete a snippet from the given content flow
        return @_callEndpoint(
            'POST',
            'delete-snippet',
            {flow: flow.id, snippet: snippet.id}
        )

    orderSnippets: (flow, snippets) ->
        # Order the snippets in the given content flow
        return @_callEndpoint(
            'POST',
            'order-snippets',
            {flow: flow.id, snippets: (s.id for s in snippets)}
        )

    # Private methods

    _callEndpoint: (method, endpoint, params={}) ->
        # Call an API endpoint and return the result

        xhr = new XMLHttpRequest()
        formData = null
        paramsStr = ''

        # Merge params and base params
        for k, v of @baseParams
            if params[k] is undefined
                params[k] = v

        switch method.toLowerCase()
            when 'get'
                pairs = Object.keys(params).map (p) ->
                    if Array.isArray(params[p])
                        params[p] = JSON.stringify(params[p])
                    return [p, params[p]].map(encodeURIComponent).join('=')
                paramsStr = "?#{ pairs.join("&") }&_=#{ Date.now() }"

            when 'delete', 'post', 'post'
                formData = new FormData()
                for k, v of params
                    if Array.isArray(v)
                        v = JSON.stringify(v)
                    formData.append(k, v)

        xhr.open(method, "#{ @baseURL }#{ endpoint }#{ paramsStr }")
        xhr.send(formData)

        return xhr
