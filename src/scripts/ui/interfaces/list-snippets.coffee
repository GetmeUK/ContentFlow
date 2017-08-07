
class ContentFlow.ListSnippetsUI extends ContentFlow.InterfaceUI

    # Display a list of snippets for the content flow

    constructor: () ->
        super('Snippets')

        # Add `order` and `add` tools to the header
        @_tools = {
            order: new ContentFlow.InlayToolUI('order', 'Order', true),
            add: new ContentFlow.InlayToolUI('add', 'Add', true)
        }
        @_header.tools().attach(@_tools.order)
        @_header.tools().attach(@_tools.add)

        # Handle interactions

        @_tools.order.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('order-snippets')

        @_tools.add.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('add-snippet')

    init: () ->
        super()

        # Load the list of the snippets within the content flow
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getSnippets(flowMgr.flow())
        result.addEventListener 'load', (ev) =>

            # Unpack the response
            payload = JSON.parse(ev.target.responseText).payload

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Add snippets
            flow = ContentFlow.FlowMgr.get().flow()
            snippetCls = ContentFlow.getSnippetCls(flow)

            for snippetData in payload.snippets
                snippet = snippetCls.fromJSONType(flow, snippetData)
                uiSnippet = new ContentFlow.SnippetUI(snippet, 'manage')
                @_body.attach(uiSnippet)

                # Handler interactions (settings, scope, delete)

                # Settings
                uiSnippet.addEventListener 'settings', (ev) ->
                    ContentFlow.FlowMgr.get().loadInterface(
                        'snippet-settings',
                        ev.detail().snippet
                    )

                # Scope
                uiSnippet.addEventListener 'scope', (ev) ->
                    scope = 'local'
                    if snippet.scope is 'global'
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

                        _removeSnippet = (snippet) ->
                            return (ev) ->
                                # Remove the snippet from the page
                                ContentFlow.getSnippetDOMElement(snippet)
                                ContentFlow.FlowMgr.get().loadInterface(
                                    'list-snippets'
                                )

                        result.addEventListener(
                            'load',
                            _removeSnippet(snippet)
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