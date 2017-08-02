
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
        return @_callEndpoint('GET', 'snippet-settings', {flow: flow.id})

    # POST

    addSnippet: (flow, snippetType) ->
        # Add a new snippet of the given type to the content flow
        return @_callEndpoint(
            'POST',
            'add-snippet',
            {flow: flow.id, snippet_type: snippetType.id}
        )

    changeSnippetScope: (flow, snippet, scope) ->
        # Change the scope of the given snippet
        return @_callEndpoint(
            'POST',
            'snippet-scope',
            {flow: flow.id, snippet: snippet.id, scope: scope}
        )

    changeSnippetSettings: (flow, snippet, settings) ->
        # Change the settings for the given snippet
        params = {flow: flow.id, snippet: snippet.id}
        for k, v of settings
            params[k] = v
        return @_callEndpoint('POST', 'snippet-settings', params)

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

        switch method.toLowerCase()
            when 'get'
                pairs = Object.keys(params).map (p) ->
                    return [p, params[p]].map(encodeURIComponent).join('=')
                paramsStr "?#{ pairs.join("&") }"

            when 'delete', 'post', 'post'
                formData = new FormData()
                for k, v of params
                    formData.append(k, v)

        xhr.open(method, '#{ @baseURL }#{ endpoint }#{ paramsStr }')

        setTimeout(() -> xhr.send(), 0)

        return xhr