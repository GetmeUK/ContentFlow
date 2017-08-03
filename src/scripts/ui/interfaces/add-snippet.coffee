
class ContentFlow.AddSnippetUI extends ContentFlow.InterfaceUI

    # Present a list of snippet types to the user to select from in order to
    # add a new snippet to the content flow.

    constructor: () ->
        super('Add')

        # Add `cancel` tool to the header
        @_tools = {
            cancel: new ContentFlow.InlayTooUI('order', 'Order', true)
        }
        @_header.tools().attach(@_tools.cancel)

        # Handle interactions

        @_tools.cancel.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: () ->
        super()

        # Load the list of snippets and snippet types available to the content
        # flow.
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getGlobalSnippets(flowMgr.flow())
        result.addEventListener 'load', (ev) =>
            flow = ContentFlow.FlowMgr.get().flow()

            # Unpack the response
            payload = JSON.parse(ev.target.responseText)

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Add a list of snippet types to choose from
            @_local = new ContentFlow.InlaySectionUI('Local')
            for snippetType in flow.snippetTypes
                @_local.attach(
                    new ContentFlow.SnippetUI(snippetType.toSnippet())
                )

                # Handle the user picking a snippet type
                snippet.addEventListener 'pick', (ev) ->

                    # Call the API to add the new snippet
                    flowMgr = ContentFlow.FlowMgr.get()
                    result = flowMgr.api().addSnippet(
                        flowMgr.flow(),
                        ev.detail().snippet.type
                    )
                    result.addEventListener 'load', (ev) =>
                        ContentFlow.FlowMgr.get().loadInterface('list-snippets')

            @_body.attach(@_local)

            # Add a list of global snippets to choose from
            @_global = new ContentFlow.InlaySectionUI('Global')
            for snippetData in payload.snippets
                snippet = snippetCls.fromJSONType(flow, snippetData)
                @_global.attach(
                    new ContentFlow.SnippetUI(snippet)
                )

                # Handle the user picking a global snippet
                snippet.addEventListener 'pick', (ev) ->

                    # Call the API to add the new snippet
                    flowMgr = ContentFlow.FlowMgr.get()
                    result = flowMgr.api().addGlobalSnippet(
                        flowMgr.flow(),
                        ev.detail().snippet
                    )
                    result.addEventListener 'load', (ev) =>
                        ContentFlow.FlowMgr.get().loadInterface('list-snippets')

            @_body.attach(@_global)

            # (Re)mount the body
            @_body.unmount()
            @_body.mount()