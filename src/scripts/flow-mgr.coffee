
class _FlowMgr extends ContentTools.ComponentUI

    # The content flow manager

    # A map of UI interfaces the manager can load
    @_uiInterfaces = {}

    constructor: () ->
        super()

        # The API instance used by the manager
        @_api = null

        # The content flow currently being managed
        @_flow = null

        # Flag indicating if the app is currently open
        @_open = false

        # Attach draw, flows and toggle
        @_draw = new ContentFlow.DrawUI()
        @attach(@_draw)

        @_flows = new ContentFlow.FlowsUI()
        @_draw.attach(@_flows)

        @_toggle = new ContentFlow.ToggleUI()
        @attach(@_toggle)

        # Handle interactions
        @_flows.addEventListener 'select', (ev) =>
            @flow(ev.detail().flow)

    init: (
        queryOrDOMElements='[data-cf-flow]',
        idProp='data-cf-flow',
        api=null
        ) ->

        # Initialize the manager
        editor = ContentTools.EditorApp.get()

        # Set the API
        @_api = api or ContentFlow.BaseAPI()

        # Select content flows within the page
        @_domFlows = queryOrDOMElements
        if typeof queryOrDOMElements == 'string' or
                queryOrDOMElements instanceof String
            @_domFlows = document.querySelectorAll(@_domFlows)

        # Handle toggling the manager open/closed
        @_toggle.addEventListener 'open', (ev) =>
            @open()

        @_toggle.addEventListener 'close', (ev) =>
            @close()

        # Hide the toggle when the editor is active and show it when not
        editor.addEventListener 'start', (ev) =>
            @_toggle.hide()

        editor.addEventListener 'stop', (ev) =>
            @_toggle.show()

        # Mount the manager within the DOM
        if @_domFlows.length > 0
            @mount()
            @_toggle.show()

    # Read-only

    api: () ->
        return @_api

    isOpen: () ->
        return @_open

    # Methods

    close: () ->
        # Close the content flow manager
        unless @dispatchEvent(@createEvent('close'))
            return

        # Close manager's UI
        @_draw.close()

        # Allow the editor to be started now the manager is closed
        ContentTools.EditorApp.get().ignition().show()

    flow: (flow) ->
        # Get/set the current content flow being managed

        # If no flow is provided return the current flow
        if flow is undefined
            return flow

        # If the flow hasn't changed there's nothing to do so return
        if @flow is flow
            return

        # Update the flow and load the list snippets interface
        @_flow = flow
        ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    loadInterface: (name, args...) ->
        # Load an interface

        # Find the named interface
        uiInterface = @constructor._uiInterfaces[name]
        unless uiInterface
            return

        if uiInterface.safeToClose()
            @_toggle.enable()
        else
            @_toggle.disable()

        # Detatch the current interface
        if @_draw.children().length > 1
            child = @_draw.children()[1]
            child.unmount()
            @_draw.detach(child)

        # Attach and initialize the new interface
        @_draw.attach(uiInterface)
        uiInterface.mount()
        uiInterface.init(args...)

    mount: () ->
        # Mount the content flow manager
        @_domElement = @constructor.createDiv(['cf-flow-mgr'])
        document.body.insertBefore(@_domElement, null)
        @_addDOMEventListeners()

        # Mount children
        for child in @children()
            child.mount()

    open: () ->
        # Open the content flow manager
        unless @dispatchEvent(@createEvent('open'))
            return

        # Prevent the CT editor from being started while the manager is open
        ContentTools.EditorApp.get().ignition().hide()

        # Open manager's UI
        @_draw.open()

    unmount: () ->
        # Unmount the content flow manager
        unless @isMounted()
            return

        # Remove the manager
        @_domElement.parentNode.removeChild(@_domElement)

        # Remove any DOM event bindings
        @_removeDOMEventListeners()

        # Clear any child references
        @_draw = null
        @_flowSelect = null
        @_toggle = null

    # Class methods

    @registerInterface: (name, cls) ->
        # Register an interface with the manager
        @_uiInterfaces[name] = cls


class ContentFlow.FlowMgr

    # The `ContentFlow.FlowMgr` class is a singleton, this code provides
    # access to the singleton instance of the protected `_FlowMgr` class
    # which is initialized the first time the class method `get` is called.

    # Storage for the singleton instance that will be created for the manager
    instance = null

    @get: () ->
        cls = ContentFlow.FlowMgr.getCls()
        instance ?= new cls()

    @getCls: () ->
        return _FlowMgr
