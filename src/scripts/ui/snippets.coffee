
class ContentFlow.SnippetUI extends ContentTools.ComponentUI

    # A UI component representing a snippet within a content flow

    constructor: (snippet, behaviour) ->
        super()

        # The snippet the component represents
        @_snippet = snippet

        # The behaviour the snippet will support:
        #
        # - 'pick'   allow the snippet to be picked (you pick a snippet when
        #            adding one).
        # - 'manage' allow the snippet to be managed (settings, scrope and
        #            delete tools will be displayed within the snippet).
        # - 'order'  allow the snippet to be dragged within a its siblings to
        #            changes its position (the order).
        @_behaviour = behaviour

    # Methods

    mount: () ->
        super()

        # Create the DOM elements for the snippet, preview image, label and
        # tools

        # Snippet
        this._domElement = @constructor.createDiv([
            'ct-snippet',
            'ct-snippet--behaviour-' + @_behaviour,
            'ct-snippet--scope-' + @_snippet.scope
        ])
        this._domElement.setAttribute('data-snippet-id', @_snippet.id)

        # Preview image
        @_domPreview = @constructor.createDiv(['ct-snippet__preview'])
        if @_snippet.type.imageURL
            bkgURL = "url(#{ @_snippet.type.imageURL })"
            @_domPreview.style.backgroundImage = bkgURL
        @_domElement.appendChild(@_domPreview)

        # Label
        @_domLabel = @constructor.createDiv(['ct-snippet__label'])
        if @_snippet.label
            @_domLabel.textContent = @_snippet.label
        else
            @_domLabel.textContent = @_snippet.type.label
        @_domElement.appendChild(@_domLabel)

        # Tools (settings, scope, delete)
        if @_behaviour is 'manage'
            @_domTools = @constructor.createDiv(['ct-snippet__tools'])

            # Settings
            @_domSettingsTool = @constructor.createDiv([
                'ct-snippet__tool',
                'ct-snippet__tool--settings'
            ])
            @_domSettingsTool.setAttribute(
                'data-ct-tooltip',
                ContentEdit._('Settings')
            )
            @_domTools.appendChild(@_domSettingsTool)

            # Scope
            @_domScopeTool = @constructor.createDiv([
                'ct-snippet__tool',
                'ct-snippet__tool--scope'
            ])
            @_domScopeTool.setAttribute(
                'data-ct-tooltip',
                ContentEdit._('Scope')
            )
            @_domTools.appendChild(@_domScopeTool)

            # Delete
            @_domDeleteTool = @constructor.createDiv([
                'ct-snippet__tool',
                'ct-snippet__tool--delete'
            ])
            @_domDeleteTool.setAttribute(
                'data-ct-tooltip',
                ContentEdit._('Delete')
            )
            @_domTools.appendChild(@_domDeleteTool)

            @_domElement.appendChild(@_domTools)

        # Mount the snippet to the DOM
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

    # Private methods

    _addDOMEventListeners: () ->
        super()

        # Add common event handlers (over/out)
        @_domElement.addEventListener 'mouseover', (ev) =>
            @dispatchEvent(@createEvent('over', {snippet: @_snippet}))

        @_domElement.addEventListener 'mouseout', (ev) =>
            @dispatchEvent(@createEvent('out', {snippet: @_snippet}))

        if @_behaviour is 'manage'

            # Add event handlers for manage (settings, scope and delete)
            @_domSettingsTool.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('settings', {snippet: @_snippet}))

            @_domScopeTool.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('scope', {snippet: @_snippet}))

            @_domDeleteTool.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('delete', {snippet: @_snippet}))

        else if @_behaviour is 'pick'
            # Add event handlers for pick
            @_domElement.addEventListener 'click', (ev) =>
                @dispatchEvent(@createEvent('pick', {snippet: @_snippet}))