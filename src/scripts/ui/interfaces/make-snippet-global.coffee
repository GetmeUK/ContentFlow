
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

        @_tools.confirm.addEventListener 'click', (ev) =>
            # @@ START HERE - Define the code to call the api to make a
            # snippet global

        @_tools.cancel.addEventListener 'click', (ev) =>

