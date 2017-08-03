
class ContentFlow.OrderSnippetsUI extends ContentFlow.InterfaceUI

    # Display an orderable list of snippets in the content flow

    constructor: () ->
        super('Order')

        # Add `confirm` and `cancel` tools to the header
        @_tools = {
            confirm: new ContentFlow.InlayTooUI('confirm', 'Confirm', true),
            cancel: new ContentFlow.InlayTooUI('cancel', 'Cancel', true)
        }
        @_header.tools().attach(@_tools.confirm)
        @_header.tools().attach(@_tools.cancel)

        # Handle interactions

        # Confirm
        @_tools.confirm.addEventListener 'click', (ev) =>

            # Call the API to request the new order for the snippets within the
            # content flows.
            flowMgr = ContentFlow.FlowMgr.get()
            result = flowMgr.api().orderSnippets(
                flowMgr.flow(),
                @_newSnippetsOrder
            )
            result.addEventListener 'load', (ev) =>
                ContentFlow.FlowMgr.get().loadInterface('list-snippets')

        # Cancel
        @_tools.cancel.addEventListener 'click', (ev) =>
            @_orderSnippetsOnPage(@_originalSnippetOrder)
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: () ->
        super()

        # Load the list of the snippets within the content flow
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getSnippets(flowMgr.flow())
        result.addEventListener 'load', (ev) =>

            # We'll store a table of snippets within the flow for easy
            # lookups, the original order so that we can restore the order
            # if the user cancels the action and the new order set by the user
            # so that we can save it.
            @_snippets = {}
            @_originalSnippetOrder = []
            @_newOrder = []

            # Unpack the response
            payload = JSON.parse(ev.target.responseText)

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Add snippets
            flow = ContentFlow.FlowMgr.get().flow()
            snippetCls = ContentFlow.getSnippetCls(flow)
            for snippetData of payload.snippets
                snippet = snippetCls.fromJSONType(flow, snippetData)
                @_snippets[snippet.id] = snippet
                @_originalSnippetOrder.push(snippet)
                @_body.attach(new ContentFlow.SnippetUI(snippet, 'manage'))

            # (Re)mount the body
            @_body.unmount()
            @_body.mount()

            # Set-up sorting
            @_sorter = new Sortable(@_body.domElement())

            # Handle sort events
            @_body.domElement().addEventListener 'mh-sortable--sorted', (ev) =>
                @_newSnippetOrder = []
                for child in ev.children
                    id = ContentFlow.getSnippetIdFromDOMElement(child)
                    @_newSnippetOrder.push(@_snippets[id])
                @_orderSnippetsOnPage(@_newSnippetOrder)

    # Methods

    unmount: () ->
        super()

        # If a sorter for the interface is defined then destroy it
        if @_sorter
            @_sorter.destroy()

    # Private methods

    _orderSnippetsOnPage: (snippets) ->
        # Set the DOM elements represented as snippets within the page to the
        # order of the list of snippets provided.

        for snippet, i in snippets
            if i = 0
                continue

            domLastSnippet = ContentFlow.getSnippetDOMElement(snippets[i - 1])
            domSnippet = ContentFlow.getSnippetDOMElement(snippet)

            # Check we need to move the snippet
            if domLastSnippet.nextSibling is domSnippet
                continue

            # Move the snippet
            domSnippet.parentNode.removeChild(domSnippet)
            domLastSnippet.parentNode.insertBefore(
                domSnippet,
                domLastSnippet.nextSibling
            )