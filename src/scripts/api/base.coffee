
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

    addGlobalSnippet: (flow, globalSnippet) ->
        # Add a global snippet to the content flow
        return @_callEndpoint(
            'POST',
            'add-global-snippet',
            {flow: flow.id, global_snippet: globalSnippet.global_id}
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
                paramsStr = "?#{ pairs.join("&") }"

            when 'delete', 'post', 'post'
                formData = new FormData()
                for k, v of params
                    formData.append(k, v)

        xhr.open(method, "#{ @baseURL }#{ endpoint }#{ paramsStr }")
        xhr.send()

        return xhr


# Mock API classes

class MockRequest

    constructor: (responseText) ->
        # The response to the request
        @_responseText = responseText

        # The listener to call with the response
        @_listener = null

        # Create a mock load event
        mockLoad = () =>
            if @_listener
                @_listener({target: {responseText: responseText}})

        setTimeout(mockLoad, 0)

    addEventListener: (eventType, listener) ->
        # Fake handler for binding event listeners to the request (only
        # supports 'load' event).
        @_listener = listener


class ContentFlow.MockAPI extends ContentFlow.BaseAPI

    # A mock API that returns results than can be tested with

    @_autoInc = 0

    constructor: (baseURL='/', baseParams={}) ->
        super(baseURL='/', baseParams={})

        # A list of snippet types available to the flow
        @_snippetTypes = {
            'article-body': [
                {
                    'id': 'basic',
                    'label': 'Basic'
                }, {
                    'id': 'advanced',
                    'label': 'Advanced'
                }
            ],
            'article-related': [
                {
                    'id': 'basic',
                    'label': 'Basic'
                }, {
                    'id': 'archive',
                    'label': 'Archive'
                }
            ]
        }

        # A list of snippets in the flow
        @_snippets = {
            'article-body': [
                {
                    'id': @constructor._getId(),
                    'type': @_snippetTypes['article-body'][0],
                    'scope': 'local',
                    'settings': {}
                }, {
                    'id': @constructor._getId(),
                    'type': @_snippetTypes['article-body'][1],
                    'scope': 'local',
                    'settings': {}
                }
            ],
            'article-related': [
                {
                    'id': @constructor._getId(),
                    'type': @_snippetTypes['article-related'][1],
                    'scope': 'local',
                    'settings': {}
                }, {
                    'id': @constructor._getId(),
                    'type': @_snippetTypes['article-related'][0],
                    'scope': 'local',
                    'settings': {}
                }
            ]
        }

        # A list of globals snippets available to the flow
        @_globalSnippets = {
            'article-body': [
                {
                    'id': @constructor._getId(),
                    'type': @_snippetTypes['article-body'][0],
                    'scope': 'global',
                    'settings': {},
                    'global_id': 'client-logos',
                    'label': 'Client logos'
                }
            ],
            'article-related': []
        }

    # Class methods

    @_getId: () ->
        # Return a unique ID
        @_autoInc += 1
        return @_autoInc

    # Private methods

    _callEndpoint: (method, endpoint, params={}) ->
        # Fake the response of calling a real API
        switch endpoint

            when 'add-snippet'

                # Find the snippet type
                snippetType = null
                for snippetType in @_snippetTypes[params['flow']]
                    if snippetType.id is params['snippet_type']
                        break

                # Add a new snippet to the state
                snippet = {
                    'id': @constructor._getId(),
                    'type': snippetType,
                    'scope': 'local',
                    'settings': {}
                }
                @_snippets[params['flow']].push(snippet)

                # Generate some HTML for the snippet and return it
                return @_mockResponse({
                    'html': """
<div class="content-snippet" data-cf-snippet="#{ snippet.id }">
    <p>This is a new snippet</p>
</div>
                    """
                })

            when 'add-global-snippet'

                # Find the global snippet
                globalSnippet = null
                for globalSnippet in @_globalSnippets[params['flow']]
                    if globalSnippet.global_id is params['global_snippet']
                        break

                # Add a new snippet to the state
                snippet = {
                    'id': @constructor._getId(),
                    'type': globalSnippet.type,
                    'scope': globalSnippet.scope,
                    'settings': globalSnippet.settings,
                    'global_id': globalSnippet.id,
                    'label': globalSnippet.label
                }
                @_snippets[params['flow']].push(snippet)

                # Generate some HTML for the snippet and return it
                return @_mockResponse({
                    'html': """
<div class="content-snippet" data-cf-snippet="#{ snippet.id }">
    <p>This is a global snippet: #{ snippet.label }</p>
</div>
                    """
                })

            when 'global-snippets'
                return @_mockResponse({
                    'snippets': @_globalSnippets[params['flow']]
                })

            when 'snippets'
                return @_mockResponse({'snippets': @_snippets[params['flow']]})

            when 'snippet-types'
                return @_mockResponse({
                    'snippet_types': @_snippetTypes[params['flow']]
                })

    _mockResponse: (payload) ->
        # Shortcut for building a mock successful API request/response
        return new MockRequest(
            JSON.stringify({'status': 'success', 'payload': payload})
        )
