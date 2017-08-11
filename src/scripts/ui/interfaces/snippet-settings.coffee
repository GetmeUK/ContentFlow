
class ContentFlow.SnippetSettingsUI extends ContentFlow.InterfaceUI

    # Display the settings for a snippet and allow them to be changed

    constructor: () ->
        super('Settings')

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

            # Check there are settings that can be changed for the snippet
            unless @_fields
                ContentFlow.FlowMgr.get().loadInterface('list-snippets')
                return

            # Convert the form values into a settings object
            settings = {}
            for _, field in @_fields
                settings[field.name()] = field.value()

            # Call the API to request the change to the snippet's settings
            flowMgr = ContentFlow.FlowMgr.get()
            result = flowMgr.api().changeSnippetSettings(
                flowMgr.flow(),
                @_snippet,
                settings
            )
            result.addEventListener 'load', (ev) =>

                # Unpack the response
                response = JSON.parse(ev.target.responseText)

                # Handle the response
                if response.status is 'success'
                    flow = ContentFlow.FlowMgr.get().flow()

                    # Find current snippet element in the DOM
                    originalElement = ContentFlow.getSnippetDOMElement(
                        flow,
                        @_snippet
                    )

                    # Build the new element
                    newElement = document.createElement('div')
                    newElement.innerHTML = response.payload['html']
                    newElement = newElement.children[0]

                    # Replace the current element with the new one
                    originalElement.parentNode.replaceChild(
                        newElement,
                        originalElement
                    )

                    # Done! Load the snippets listing
                    ContentFlow.FlowMgr.get().loadInterface('list-snippets')

                else
                    for fieldName, errors in response.payload.errors
                        if @_fields[fieldName]
                            @_fields[fieldName].errors(errors)

        # Cancel
        @_tools.cancel.addEventListener 'click', (ev) =>
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: (snippet) ->

        # The snippet we'll be changing the settings for
        @_snippet = snippet

        # Load the list of the snippet's setting form
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getSnippetSettingsForm(flowMgr.flow(), snippet)
        result.addEventListener 'load', (ev) =>

            # Unpack the response
            payload = JSON.parse(ev.target.responseText).payload

            # Check there's at least one field in the settings form
            unless payload.fields
                # Flag the form as empty
                @_fields = null

                # Add a note letting the user know there's no settings to
                # change.
                note = ContentFlow.InlayNoteUI(
                    'There are no settings defined for this snippet.'
                    )

                # (Re)mount the body
                @_body.unmount()
                @_body.mount()

                return

            # Build the form
            @_fields = {}
            for fieldData in payload.fields
                field = ContentFlow.FieldUI.fromJSONType(fieldData)
                @_fields[field.name()] = field
                @_body.attach(field)

            # (Re)mount the body
            @_body.unmount()
            @_body.mount()

            # Populate the fields
            for k, v in @_snippet.settings
                if @_fields[k]
                    @_fields[k].value(v)


# Register the interface with the content flow manager
ContentFlow.FlowMgr.getCls().registerInterface(
    'snippet-settings',
    ContentFlow.SnippetSettingsUI
)