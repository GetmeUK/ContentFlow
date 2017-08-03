
class ContentFlow.MakeSnippetGlobalUI extends ContentFlow.InterfaceUI

    # Ask a user to confirm they wish to make a snippet global

    constructor: () ->
        super('Make global')

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

            # Call the API to request the snippet is made global
            flowMgr = ContentFlow.FlowMgr.get()
            result = flowMgr.api().changeSnippetScope(
                flowMgr.flow(),
                @_snippet,
                'global'
            )
            result.addEventListener 'load', (ev) =>

                # Unpack the response
                payload = JSON.parse(ev.target.responseText)

                # Handle the response
                if response.status is 'success'
                    ContentFlow.FlowMgr.get().loadInterface('list-snippets')
                else
                    @_labelField.errors([response.payload.reason])

        # Cancel
        @_tools.cancel.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: (snippet) ->
        super()

        # The snippet to change the scope of
        @_snippet = snippet

        # Global snippets require a unique label so we present the user with a
        # field to enter a label in.
        @_body.attach(@_labelField)

        # Provide some context on global snippets to the user
        note = new ContentFlow.InlayNoteUI(ContentEdit._('''
            Once you make a snippet global it can be dragged into other pages
            and changes made to the snippet&apos;s content or settings will be
            applied to all instances of the snippet.
            '''
        ))
        @_body.attach(note)

        # (Re)mount the body
        @_body.unmount()
        @_body.mount()