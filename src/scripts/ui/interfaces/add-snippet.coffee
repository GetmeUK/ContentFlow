
class ContentFlow.AddSnippetUI extends ContentFlow.InterfaceUI

    # Present a list of snippet types to the user to select from in order to
    # add a new snippet to the content flow.

    constructor: () ->
        super('Add')

        # Add `cancel` tool to the header
        @_tools = {
            cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
        }
        @_header.tools().attach(@_tools.cancel)

        # Handle interactions

        @_tools.cancel.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: () ->
        super()

        # Load the list of snippet types, then globals snippets for the user
        # to pick from.
        flowMgr = ContentFlow.FlowMgr.get()

        # Snippet types
        result = flowMgr.api().getSnippetTypes(flowMgr.flow())
        result.addEventListener 'load', (ev) =>
            flow = ContentFlow.FlowMgr.get().flow()

            # Unpack the response
            payload = JSON.parse(ev.target.responseText).payload

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Add a list of snippet types to choose from
            @_local = new ContentFlow.InlaySectionUI('Local scope')
            for snippetTypeData in payload['snippet_types']

                # Convert the snippet type to a model
                snippetType = ContentFlow.SnippetTypeModel.fromJSONType(
                    flow,
                    snippetTypeData
                )

                # Add a snippet UI component for the snippet type
                uiSnippet = new ContentFlow.SnippetUI(
                    snippetType.toSnippet(),
                    'pick'
                )
                @_local.attach(uiSnippet)

                # Handle the user picking a snippet type
                uiSnippet.addEventListener 'pick', (ev) ->

                    # Call the API to add the new snippet
                    flowMgr = ContentFlow.FlowMgr.get()
                    result = flowMgr.api().addSnippet(
                        flowMgr.flow(),
                        ev.detail().snippet.type
                    )
                    result.addEventListener 'load', (ev) =>
                        ContentFlow.FlowMgr.get().loadInterface('list-snippets')

            @_body.attach(@_local)

            # Global snippets
            result = flowMgr.api().getGlobalSnippets(flowMgr.flow())
            result.addEventListener 'load', (ev) =>
                flow = ContentFlow.FlowMgr.get().flow()

                # Unpack the response
                payload = JSON.parse(ev.target.responseText).payload

                # Add a list of global snippets to choose from
                @_global = new ContentFlow.InlaySectionUI('Global scope')
                for snippetData in payload.snippets

                    # Convert the global snippet data to a model
                    snippet = snippetCls.fromJSONType(flow, snippetData)

                    # Add a snippet UI component for the global snippet
                    uiSnippet = new ContentFlow.SnippetUI(snippet, 'pick')
                    @_global.attach(uiSnippet)

                    # Handle the user picking a global snippet
                    uiSnippet.addEventListener 'pick', (ev) ->

                        # Call the API to add the new snippet
                        flowMgr = ContentFlow.FlowMgr.get()
                        result = flowMgr.api().addGlobalSnippet(
                            flowMgr.flow(),
                            ev.detail().snippet
                        )
                        result.addEventListener 'load', (ev) =>
                            ContentFlow.FlowMgr.get().loadInterface(
                                'list-snippets'
                            )

                if @_global.children().length > 0
                    @_body.attach(@_global)

                # (Re)mount the body
                @_body.unmount()
                @_body.mount()


# Register the interface with the content flow manager
ContentFlow.FlowMgr.getCls().registerInterface(
    'add-snippet',
    ContentFlow.AddSnippetUI
)