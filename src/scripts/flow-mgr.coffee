
class _FlowMgr extends ContentTools.ComponentUI

    # The content flow manager

    # A map of UI interfaces the manager can load
    @_interface = {}

    constructor: () ->
        super()

        # The content flow currently being managed
        @_flow = null

        # Flag indicating if the app is currently open
        @_open = false

        # @@ flowSelect, toggle, draw

    init: (queryOrDOMElements, namingProp='data-cf-flow') ->
        # Initialize the manager

        # @@ Select content flows within the page

    # Read-only

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

    loadInterface: (name, ...args) ->
        # Load an interface

        # Find the named interface
        interface = @constructor._interfaces[name]
        unless interface
            return

        if interface.safeToClose()
            @_toggle.enable()
        else
            @_toggle.disable()

        # Detatch the current interface
        if @_draw.children().length > 1
            child = @_draw.children()[1]
            child.unmount()
            @_draw.detach(child)

        # Attach and initialize the new interface
        @_draw.attach(interface)
        interface.mount()
        interface.init(...args)

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

    registerInterface: (name, cls) ->
        # Register an interface with the manager
        @_interfaces[name] = cls


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
