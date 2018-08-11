
class ContentFlow.ListSnippetsUI extends ContentFlow.InterfaceUI

    # Display a list of snippets for the content flow

    constructor: () ->
        super('Snippets')

        # Add `order` and `add` tools to the header
        @_tools = {
            order: new ContentFlow.InlayToolUI('order', 'Order', true),
            add: new ContentFlow.InlayToolUI('add', 'Add', true)
        }

        # Handle interactions

        @_tools.order.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('order-snippets')

        @_tools.add.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('add-snippet')

    init: () ->
        super()

        # Dim any highlighted snippets
        ContentFlow.dimAllSnippetDOMElements()

        # Load the list of the snippets within the content flow
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getSnippets(flowMgr.flow())
        result.addEventListener 'load', (ev) =>
            flow = ContentFlow.FlowMgr.get().flow()

            # Unpack the response
            payload = JSON.parse(ev.target.responseText).payload

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Set up the tools available for the flow
            flowElm = ContentFlow.getFlowDOMelement(flow)
            maxSnippets = parseInt(flowElm.dataset.cfFlowMaxSnippets) or 0

            # Detatch all tools
            for child in @_header.tools().children
                @_header.tools().detatch(child)

            # Add the 'add' tool if the flow isn't full
            if maxSnippets == 0 or payload.snippets.length < maxSnippets
                @_header.tools().attach(@_tools.add)

            # Add the 'order' tool if the flow isn't frozen
            if flowElm.dataset.cfFlowFrozen == undefined
                @_header.tools().attach(@_tools.order)

            @_header.unmount()
            @_header.mount()

            # Add snippets
            snippetCls = ContentFlow.getSnippetCls(flow)
            for snippetData in payload.snippets
                snippet = snippetCls.fromJSONType(flow, snippetData)
                snippetElm = ContentFlow.getSnippetDOMElement(flow, snippet)

                uiSnippet = new ContentFlow.SnippetUI(
                    snippet,
                    'manage',
                    {
                        'permanent':
                            snippetElm.dataset.cfSnippetPermanent != undefined
                    }
                )
                @_body.attach(uiSnippet)

                # Handle interactions

                # Common
                uiSnippet.addEventListener 'over', (ev) ->
                    ContentFlow.highlightSnippetDOMElement(
                        ContentFlow.FlowMgr.get().flow(),
                        ev.detail().snippet
                    )

                uiSnippet.addEventListener 'out', (ev) ->
                    ContentFlow.dimSnippetDOMElement(
                        ContentFlow.FlowMgr.get().flow(),
                        ev.detail().snippet
                    )

                # Managing of snippets (settings, scope, delete)

                # Settings
                uiSnippet.addEventListener 'settings', (ev) ->
                    ContentFlow.FlowMgr.get().loadInterface(
                        'snippet-settings',
                        ev.detail().snippet
                    )

                # Scope
                uiSnippet.addEventListener 'scope', (ev) ->
                    scope = 'local'
                    if ev.detail().snippet.scope is 'local'
                        scope = 'global'
                    ContentFlow.FlowMgr.get().loadInterface(
                        "make-snippet-#{ scope }",
                        ev.detail().snippet
                    )

                # Delete
                uiSnippet.addEventListener 'delete', (ev) =>
                    msg = ContentEdit._(
                        'Are you sure you want to delete this snippet?'
                    )
                    if confirm(msg)
                        # Call the API to remove the snippet
                        flowMgr = ContentFlow.FlowMgr.get()
                        result = flowMgr.api().deleteSnippet(
                            flowMgr.flow(),
                            ev.detail().snippet
                        )

                        _removeSnippet = (flow, snippet) ->
                            return (ev) ->
                                # Remove the snippet from the page
                                domSnippet = ContentFlow.getSnippetDOMElement(
                                    flow,
                                    snippet
                                )
                                domSnippet.remove()

                                # Show the list of snippets now in the flow. We
                                # re-sync the page flows in case a flow was
                                # removed as part of the snippet, then we force
                                # reselect this flow which ensures the correct
                                # flow is selected and triggers a list-snippets
                                # interface load.
                                flowMgr.syncFlows()
                                flowMgr.flow(flow, force=true)

                        result.addEventListener(
                            'load',
                            _removeSnippet(flowMgr.flow(), ev.detail().snippet)
                        )

            # (Re)mount the body
            @_body.unmount()
            @_body.mount()

    # Read-only

    safeToClose: () ->
        return true

# Register the interface with the content flow manager
ContentFlow.FlowMgr.getCls().registerInterface(
    'list-snippets',
    ContentFlow.ListSnippetsUI
)