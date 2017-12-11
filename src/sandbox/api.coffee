
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


class MockAPI extends ContentFlow.BaseAPI

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
                    'global_id': @constructor._getId(),
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
    <section
        data-cf-flow="new"
        data-cf-flow-label="New"
        >
    </section>
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

            when 'delete-snippet'
                # Remove the snippet from the flow
                snippets = @_snippets[params['flow']]
                newSnippets = []
                for snippet in snippets
                    unless snippet.id is params['snippet']
                        newSnippets.push(snippet)
                @_snippets[params['flow']] = newSnippets

                return @_mockResponse()

            when 'global-snippets'
                return @_mockResponse({
                    'snippets': @_globalSnippets[params['flow']]
                })

            when 'order-snippets'
                # Build a look up table for snippets by Id
                snippets = {}
                for snippet in @_snippets[params['flow']]
                    snippets[snippet.id] = snippet

                # Order the snippets
                newSnippets = []
                for id in params['snippets']
                    newSnippets.push(snippets[id])
                @_snippets[params['flow']] = newSnippets

                return @_mockResponse()

            when 'snippets'
                return @_mockResponse({'snippets': @_snippets[params['flow']]})

            when 'change-snippet-scope'
                # Find the snippet
                snippet = null
                for otherSnippet in @_snippets[params['flow']]
                    if otherSnippet.id is params['snippet']
                        snippet = otherSnippet
                        break

                if params['scope'] is 'local'
                    # Make the snippet local
                    snippet.scope = 'local'
                    delete snippet.global_id
                    delete snippet.label
                    return @_mockResponse()

                else
                    # Make the snippet global

                    # Validate a label has been provided
                    unless params['label']
                        return @_mockError({'label': 'This field is required'})

                    # Add the snippet to the global snippets for the flow
                    globalId = @constructor._getId()
                    @_globalSnippets[params['flow']].push({
                        'id': @constructor._getId(),
                        'type': snippet.type,
                        'scope': 'global',
                        'settings': snippet.settigns,
                        'global_id': globalId,
                        'label': params['label']
                    })

                    # Convert the snippet to a global snippet
                    snippet.scope = 'global'
                    snippet.global_id = globalId
                    snippet.label = params['label']

                    return @_mockResponse()

            when 'update-snippet-settings'
                if method.toLowerCase() is 'get'

                    # Build a dummy set of fields for the response
                    fields = [
                        {
                            'type': 'boolean',
                            'name': 'boolean_example',
                            'label': 'Boolean example',
                            'required': false,
                            'value': true
                        }, {
                            'type': 'select',
                            'name': 'select_example',
                            'label': 'Select example',
                            'required': true,
                            'value': 1,
                            'choices': [
                                [1, 'One'],
                                [2, 'Two'],
                                [3, 'Three'],
                            ]
                        }, {
                            'type': 'text',
                            'name': 'Text_example',
                            'label': 'Text example',
                            'required': true,
                            'value': 'foo'
                        },
                    ]
                    return @_mockResponse({'fields': fields})

                else
                return @_mockResponse({
                    'html': """
<div class="content-snippet" data-cf-snippet="#{ params['snippet'] }">
    <p>This is a snippet with updated settings</p>
</div>
                    """
                })

            when 'snippet-types'
                return @_mockResponse({
                    'snippet_types': @_snippetTypes[params['flow']]
                })

    _mockError: (errors) ->
        # Shortcut for building a mock failed API request/response
        response = {'status': 'fail'}
        if errors
            response['errors'] = errors
        return new MockRequest(JSON.stringify(response))

    _mockResponse: (payload) ->
        # Shortcut for building a mock successful API request/response
        response = {'status': 'success'}
        if payload
            response['payload'] = payload
        return new MockRequest(JSON.stringify(response))