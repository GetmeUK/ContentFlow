
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

        # The CSS query or list of DOM elements used to select the flows within
        # the page.
        @_flowQuery = null

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

    init: (flowQuery='[data-cf-flow]', api=null) ->

        # Initialize the manager
        editor = ContentTools.EditorApp.get()

        # Set the API
        @_api = api or new ContentFlow.BaseAPI()

        # Handle toggling the manager open/closed
        @_toggle.addEventListener 'on', (ev) =>
            @open()

        @_toggle.addEventListener 'off', (ev) =>
            @close()

        # Hide the toggle when the editor is active and show it when not
        editor.addEventListener 'start', (ev) =>
            @_toggle.hide()

        editor.addEventListener 'stopped', (ev) =>
            @_toggle.show()

        # Sync the flows with the page
        @syncFlows(flowQuery)

        # Mount the manager within the DOM
        if @_domFlows.length > 0
            @mount()
            @_toggle.show()

            # Select the first flow found
            @flow(@_flows.flows()[0])

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

        # Remove flag that the flow manager is open from the body of the page
        document.body.classList.remove('cf--flow-mgr-open')

        # Close manager's UI
        @_draw.close()

        # Allow the editor to be started now the manager is closed
        editor = ContentTools.EditorApp.get()

        # Only show the editor tool if there are regions to edit
        editor.syncRegions()
        if editor.domRegions().length
            editor.ignition().show()

    flow: (flow, force=false) ->
        # Get/set the current content flow being managed

        # If no flow is provided return the current flow
        if flow is undefined
            return @_flow

        # If the flow hasn't changed there's nothing to do so return
        if not force and @_flow is flow
            return

        # Update the flow and load the list snippets interface
        @_flow = flow
        @_flows.select(flow)
        ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    loadInterface: (name, args...) ->
        # Load an interface

        # Find the named interface
        uiInterface = new @constructor._uiInterfaces[name]()
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

        # Flag that the flow manager is open against the body of the page
        document.body.classList.add('cf--flow-mgr-open')

        # Prevent the CT editor from being started while the manager is open
        ContentTools.EditorApp.get().ignition().hide()

        # Open manager's UI
        @_draw.open()

    syncFlows: (flowQuery) ->
        # Synchronize the flows within the page

        # If a new query or set of DOM elements have been provided set them
        if flowQuery
            @_flowQuery = flowQuery

        # Select content flows within the page
        @_domFlows = []
        if @_flowQuery

            # If a string is provided attempt to select the DOM flows using a
            # CSS selector.
            if typeof @_flowQuery == 'string' or
                    @_flowQuery instanceof String
                @_domFlows = document.querySelectorAll(@_flowQuery)

            # Otherwise assume a valid list of DOM elements has been provided
            else
                @_domFlows = @_flowQuery

            # Sort the flows based on their position attribute
            @_domFlows = Array.from(@_domFlows)

            cmp = (a, b) ->
                aPos = parseFloat(a.dataset.cfFlowPosition)
                if isNaN(aPos)
                    aPos = 999999
                bPos = parseFloat(b.dataset.cfFlowPosition)
                if isNaN(bPos)
                    bPos = 999999
                return aPos - bPos

            @_domFlows.sort(cmp)

            # Convert the flows found in the DOM into models and populate the
            # flows UI compontent.
            flows = []
            for domFlow in @_domFlows
                flows.push(new ContentFlow.FlowModel(
                    ContentFlow.getFlowIdFromDOMElement(domFlow),
                    ContentFlow.getFlowLabelFromDOMElement(domFlow)
                ))
            @_flows.flows(flows)

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
