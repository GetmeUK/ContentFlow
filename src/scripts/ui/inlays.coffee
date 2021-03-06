
class ContentFlow.InlayUI extends ContentTools.ComponentUI

    # An inlay panel (typically displayed within a DrawUI component)

    constructor: (heading) ->
        super()

        # Inlays are made up of a head and body section which we add below.

        # Attach the header component to the inlay
        @_header = new ContentFlow.InlayHeaderUI(heading)
        @attach(@_header)

        # Attach the body component to the inlay
        @_body = new ContentFlow.InlayBodyUI()
        @attach(@_body)

    # Read-only

    body: () ->
        return @_body

    header: () ->
        return @_header

    # Methods

    mount: () ->
        super()

        # Create the DOM element for the inlay and mount it
        @_domElement = @constructor.createDiv(['ct-inlay'])
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

        # Mount the header and body components
        @_header.mount()
        @_body.mount()


class ContentFlow.InlayBodyUI extends ContentTools.ComponentUI

    # The body component within an InlayUI component

    mount: () ->
        super()

        # Create the DOM element for the body and mount it
        @_domElement = @constructor.createDiv(['ct-inlay__body'])
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

        # Mount children
        for child in @children()
            child.mount()


class ContentFlow.InlayHeaderToolsUI extends ContentTools.ComponentUI

    # A tools component within an InlayHeaderUI that tools are mounted to

    mount: () ->
        super()

        # Create the DOM element for the tools and mount it
        @_domElement = @constructor.createDiv(['ct-inlay__tools'])
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

        # Mount children
        for child in @children()
            child.mount()


class ContentFlow.InlayHeaderUI extends ContentTools.ComponentUI

    # The header component within an InlayUI component

    constructor: (heading) ->
        super()

        # The heading text that will be displayed in the component
        @_heading = heading

        # Attach a tools component to allow tools to be mounted in the header
        @_tools = new ContentFlow.InlayHeaderToolsUI()
        @attach(@_tools)

    # Read-only

    tools: () ->
        return @_tools

    # Methods

    heading: (heading) ->
        # Get/set the heading for the header

        # If no heading value is provided return the current heading
        if heading is undefined
            return @_heading

        # Update the heading
        @_heading = heading
        if @isMounted()
            @_domHeading.textContent = ContentEdit._(heading)

    # Methods

    mount: () ->
        super()

        # Create the DOM elements for the header and heading and mount them
        @_domElement = @constructor.createDiv(['ct-inlay__header'])
        @_domHeading = @constructor.createDiv(['ct-inlay__heading'])
        @_domHeading.textContent = ContentEdit._(@_heading)
        @_domElement.appendChild(@_domHeading)
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

        # Mount the tools
        @_tools.mount()

    unmount: () ->
        super()

        # Remove references to other elements
        this._domHeading = null


class ContentFlow.InlayNoteUI extends ContentTools.ComponentUI

    # A note displayed within body or a section within the body of the InlayUI
    # component.

    constructor: (content) ->
        super()

        # The content of the note
        @_content = content

    # Methods

    content: (content) ->
        # Get/set the content for the note

        # If no content value is provided return the current content
        if content is undefined
            return @_content

        # Update the heading
        @_content = content
        if @isMounted()
            @_domElement.innerHTML = content

    mount: () ->
        super()

        # Create the DOM element for the note and mount it
        @_domElement = @constructor.createDiv(['ct-inlay-note'])
        @_domElement.innerHTML = @_content
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()


class ContentFlow.InlaySectionUI extends ContentTools.ComponentUI

    # A section component with an InlayBodyUI component used to help separate
    # blocks of content into related sections.

    constructor: (heading) ->
        super()

        # The heading text that will be displayed in the component
        @_heading = heading

    # Methods

    heading: (heading) ->
        # Get/set the heading for the section

        # If no heading value is provided return the current heading
        if heading is undefined
            return @_heading

        # Update the heading
        @_heading = heading
        if @isMounted()
            @_domHeading.textContent = ContentEdit._(heading)

    mount: () ->
        super()

        # Create the DOM elements for the header and heading and mount them
        @_domElement = @constructor.createDiv(['ct-inlay-section'])
        @_domHeading = @constructor.createDiv(['ct-inlay-section__heading'])
        @_domHeading.textContent = ContentEdit._(@_heading)
        @_domElement.appendChild(@_domHeading)
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

        # Mount children
        for child in @children()
            child.mount()

    unmount: () ->
        super()

        # Remove references to other elements
        this._domHeading = null


class ContentFlow.InlayToolUI extends ContentTools.ComponentUI

    # A tool component mounted to the tools section of an InlayHeaderUI

    constructor: (toolName, tooltip) ->
        super()

        # The name of the tools (should be the same as the CSS modifier)
        @_toolName = toolName

        # The tooltip displayed for the tool
        @_tooltip = tooltip

    # Read-only

    toolName: () ->
        return @_toolName

    tooltip: () ->
        return @_tooltip

    # Methods

    mount: () ->
        super()

        # Create the DOM elements for the header and heading and mount them
        @_domElement = @constructor.createDiv([
            'ct-inlay__tool',
            'ct-inlay-tool',
            "ct-inlay-tool--#{ @_toolName }"
            ])
        @_domElement.setAttribute('data-ct-tooltip', ContentEdit._(@_tooltip))
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

    # Private methods

    _addDOMEventListeners: () ->
        super()

        # Click
        @_domElement.addEventListener 'click', (ev) =>
            @dispatchEvent(@createEvent('click'))
