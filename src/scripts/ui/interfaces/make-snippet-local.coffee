
class ContentFlow.MakeSnippetLocaUI extends ContentFlow.InterfaceUI

    # Ask a user to confirm they wish to make a snippet local

    constructor: () ->
        super('Make local')

        # Add `confirm` and `cancel` tools to the header
        @_tools = {
            confirm: new ContentFlow.InlayToolUI('confirm', 'Confirm', true),
            cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
        }
        @_header.tools().attach(@_tools.confirm)
        @_header.tools().attach(@_tools.cancel)

        # Handle interactions

        # Confirm
        @_tools.confirm.addEventListener 'click', (ev) =>

            # Call the API to request the snippet is made local
            flowMgr = ContentFlow.FlowMgr.get()
            result = flowMgr.api().changeSnippetScope(
                flowMgr.flow(),
                @_snippet,
                'local'
            )
            result.addEventListener 'load', (ev) =>
                ContentFlow.FlowMgr.get().loadInterface('list-snippets')

        # Cancel
        @_tools.cancel.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: (snippet) ->
        super()

        # The snippet to change the scope of
        @_snippet = snippet

        # Provide some context on local snippets to the user
        note = new ContentFlow.InlayNoteUI(ContentEdit._('''
            This action replaces the global snippet within the page with a
            local version of the snippet. Changes to local snippets are only
            applied to that instance of the snippet.
            '''
        ))
        @_body.attach(note)

        # (Re)mount the body
        @_body.unmount()
        @_body.mount()


# Register the interface with the content flow manager
ContentFlow.FlowMgr.getCls().registerInterface(
    'make-snippet-local',
    ContentFlow.MakeSnippetLocaUI
)