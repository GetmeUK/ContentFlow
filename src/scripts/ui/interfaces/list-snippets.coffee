
class ContentFlow.ListSnippetsUI extends ContentFlow.InterfaceUI

    # Display a list of snippets for the content flow

    constructor: () ->
        super('')

        # Add `order` and `add` tools to the header
        @_tools = {
            order: new ContentFlow.InlayTooUI('order', 'Order', true),
            add: new ContentFlow.InlayTooUI('add', 'Add', true)
        }
        @_header.tools().attach(@_tools.order)
        @_header.tools().attach(@_tools.add)

        # Handle interactions

        @_tools.order.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('order-snippets')

        @_tools.add.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('add-snippet')

    init: (flow, ...args) ->
        super()

        # Set the heading for the interface
        @_header.heading(flow.id)

        # Load the list of the snippets within the content flow
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getSnippets(flowMgr.flow())
        result.addEventListener 'readystatechange', (ev) =>
            unless ev.target.readyState is 4
                return

            # Unpack the response
            payload = JSON.parse(ev.target.responseText)

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Add snippets
            flow = ContentFlow.FlowMgr.get().flow()
            snippetCls = ContentFlow.getSnippetCls()
            for snippetData of payload.snippets
                snippet = snippetCls.fromJSONType(flow, snippetData)
                @_body.attach(new ContentFlow.SnippetUI(snippet, 'manage'))

            # (Re)mount the body
            @_body.unmount()
            @_body.mount()