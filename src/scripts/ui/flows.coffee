
class FlowsUI extends ContentTools.ComponentUI

    # A UI component that displays a list of content flows a user can choose
    # from manage.

    constructor: (flows=[]) ->

        # A list of flows available to manage
        @_flows = flows

    # Read-only

    domSelect: () ->
        return @_domSelect

    # Methods

    flows: (flows) ->
        # Get/set the flows

        # If no flows value is provided return the current value
        if flows is undefined
            return flow

        # If the flows hasn't changed there's nothing to do so return
        if JSON.stringify(@_flows) is JSON.stringify(flows)
            return

        # Set the new list of flows
        @_flows = flows

        # Remove existing select options
        while @_domSelect.options.length > 0
            @_domSelect.remove(0)

        # Add new options inline with list of flows provided
        for flow in @_flows
            domOption = document.createElement('option')
            domOption.setAttribute('value', flow.id)
            domOption.textContent = flow.id
            @_domSelect.appendChild(domOption)

    mount: () ->
        super()

        # Create flows and the select field DOM elements
        @_domElement = @constructor.createDiv(['ct-flows'])
        @_domSelect = document.createElement('select')
        @_domSelect.classList.add('ct-flows__select')
        @_domSelect.setAttribute('name', 'flows')

        # Options
        for flow in @_flows
            domOption = document.createElement('option')
            domOption.setAttribute('value', flow.id)
            domOption.textContent = flow.id
            @_domSelect.appendChild(domOption)

        @_domElement.appendChild(@_domSelect)

        # Mount flows to the DOM
        @parent.domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

    unmount: () ->
        super()

        # Clear reference to the select element
        @_domSelect = null

    # Private methods

    _addDOMEventListeners: () ->

        # Handle the selection of a flow
        @_domSelect.addEventListener 'change', (ev) =>
            id = @_domSelect.value
            for flow in @_flows
                if flow.id == id
                    @dispatchEvent(@createEvent('select', {flow: flow}))