
class ContentFlow.OrderSnippetsUI extends ContentFlow.InterfaceUI

    # Display an orderable list of snippets in the content flow

    constructor: () ->
        super('Order')

        # Add `confirm` and `cancel` tools to the header
        @_tools = {
            confirm: new ContentFlow.InlayToolUI('confirm', 'Confirm', true),
            cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
        }
        @_header.tools().attach(@_tools.confirm)
        @_header.tools().attach(@_tools.cancel)

        # Handle interactions

        # Sorting
        @_grabbed = null
        @_grabbedHelper = null
        @_grabbedOffset = null

        document.addEventListener('mousedown', @_grab)
        document.addEventListener('mousemove', @_drag)
        document.addEventListener('mouseup', @_drop)

        # Confirm
        @_tools.confirm.addEventListener 'click', (ev) =>

            # Call the API to request the new order for the snippets within the
            # content flows.
            flowMgr = ContentFlow.FlowMgr.get()
            result = flowMgr.api().orderSnippets(
                flowMgr.flow(),
                @_newSnippetOrder
            )
            result.addEventListener 'load', (ev) =>
                ContentFlow.FlowMgr.get().loadInterface('list-snippets')

        # Cancel
        @_tools.cancel.addEventListener 'click', (ev) =>
            @_orderSnippetsOnPage(@_originalSnippetOrder)
            ContentFlow.FlowMgr.get().loadInterface('list-snippets')

    init: () ->
        super()

        # Load the list of the snippets within the content flow
        flowMgr = ContentFlow.FlowMgr.get()
        result = flowMgr.api().getSnippets(flowMgr.flow())
        result.addEventListener 'load', (ev) =>

            # We'll store a table of snippets within the flow for easy
            # lookups, the original order so that we can restore the order
            # if the user cancels the action and the new order set by the user
            # so that we can save it.
            @_snippets = {}
            @_originalSnippetOrder = []
            @_newSnippetOrder = []

            # Unpack the response
            payload = JSON.parse(ev.target.responseText).payload

            # Remove existing snippets from the interface
            for child in @_body.children
                @_body.detach(child)

            # Add snippets
            flow = ContentFlow.FlowMgr.get().flow()
            snippetCls = ContentFlow.getSnippetCls(flow)
            for snippetData in payload.snippets
                snippet = snippetCls.fromJSONType(flow, snippetData)
                @_snippets[snippet.id] = snippet
                @_originalSnippetOrder.push(snippet)
                @_newSnippetOrder.push(snippet)
                @_body.attach(new ContentFlow.SnippetUI(snippet, 'order'))

            # (Re)mount the body
            @_body.unmount()
            @_body.mount()

    # Methods

    unmount: () ->
        super()

        # Remove document event listeners
        document.removeEventListener('mousedown', @_grab)
        document.removeEventListener('mousemove', @_drag)
        document.removeEventListener('mouseup', @_drop)

    # Private methods

    _drag: (ev) =>
        # Handle snippet being dragged to a new position
        unless @_grabbed
            return

        # Get the position of the pointer
        pos = @_getEventPos(ev)

        # Move the helper inline with the pointer
        offset = [window.pageXOffset, window.pageYOffset]
        left = "#{offset[0] + pos[0] - @_grabbedOffset[0]}px"
        @_grabbedHelper.style.left = left
        top = "#{offset[1] + pos[1] - @_grabbedOffset[1]}px"
        @_grabbedHelper.style.top = top

        # Is the pointer over sibling of the grabbed snippet?
        target = document.elementFromPoint(pos[0], pos[1])
        domSibling = null
        for child in @_body.children()
            domChild = child.domElement()

            # Ignore the currently grabbed snippet
            if domChild is @_grabbed
                continue

            if domChild.contains(target)
                domSibling = domChild
                break

        if not domSibling
            return

        # Move the grabbed snippet into its new position
        rect = domSibling.getBoundingClientRect()
        overlap = [pos[0] - rect.left, pos[1] - rect.top]
        @_body.domElement().removeChild(@_grabbed)
        if overlap[1] >= (rect.height / 2)
            domSibling = domSibling.nextElementSibling
        @_body.domElement().insertBefore(@_grabbed, domSibling)

    _drop: (ev) =>
        # Handle snippet being dropped into a new position
        unless @_grabbed
            return

        # Remove the ghost class from the grabbed element
        @_grabbed.classList.remove('ct-snippet--ghost')
        @_grabbed = null
        @_grabbedOffset = null

        # Remove the helper element
        document.body.removeChild(@_grabbedHelper)
        @_grabbedHelper = null

        # Remove the sorting class from the container
        @_body.domElement().classList.remove('ct-inlay__body--sorting')

        # Update the order of the snippets
        @_newSnippetOrder = []
        for domChild in @_body.domElement().childNodes
            unless domChild.nodeType is 1 # (Node.ELEMENT_NODE)
                continue

            id = domChild.dataset.snippetId
            @_newSnippetOrder.push(@_snippets[id])

        @_orderSnippetsOnPage(@_newSnippetOrder)

    _getEventPos: (ev) ->
        # Return the `[x, y]` coordinates for an event
        return [ev.pageX - window.pageXOffset, ev.pageY - window.pageYOffset]

    _grab: (ev) =>
        # Handle the grabbing of a snippet to sort

        # If this is a mouse down event then we check that the user pressed the
        # primary mouse button (left).
        if ev.type.toLowerCase() is 'mousedown' and not (ev.which is 1)
            return

        # Determine if the target of the event relates to the grabber for a
        # sortable child.
        grabbed = null
        for child in @_body.children()
            domChild = child.domElement()
            if domChild.contains(ev.target)
                grabbed = domChild
                break

        unless grabbed
            return

        # Store the grabbed snippet element
        @_grabbed = grabbed

        # Get x, y for event origin
        pos = @_getEventPos(ev)

        # Store the offset at which we grabbed the snippet
        rect = @_grabbed.getBoundingClientRect()
        @_grabbedOffset = [pos[0] - rect.left, pos[1] - rect.top]

        # Create a helper to represent the grabbed child being dragged
        @_grabbedHelper = grabbed.cloneNode(true)

        # Copy CSS styles
        css = document.defaultView.getComputedStyle(grabbed, '').cssText
        @_grabbedHelper.style.cssText = css

        # Set the position of the helper element to be absolute
        @_grabbedHelper.style.position = 'absolute'

        # Prevent the capture of pointer events
        @_grabbedHelper.style['pointer-events'] = 'none'

        # Move the helper inline with the pointer
        @_grabbedHelper.style.left = "#{pos[0] - @_grabbedOffset[0]}px"
        @_grabbedHelper.style.top = "#{pos[1] - @_grabbedOffset[1]}px"

        # Add a helper class to the clone
        @_grabbedHelper.classList.add('ct-snippet--helper')

        # Add the helper
        document.body.appendChild(@_grabbedHelper)

        # Add the ghost class to the grabbed child to change its appearance
        # within the list.
        @_grabbed.classList.add('ct-snippet--ghost')

        # Add a class to the container to indicate that the user is sorting
        # the list.
        @_body.domElement().classList.add('ct-inlay__body--sorting')

    _orderSnippetsOnPage: (snippets) ->
        # Set the DOM elements represented as snippets within the page to the
        # order of the list of snippets provided.
        flow = ContentFlow.FlowMgr.get().flow()

        for snippet, i in snippets
            if i is 0
                continue

            domLastSnippet = ContentFlow.getSnippetDOMElement(
                flow,
                snippets[i - 1]
            )
            domSnippet = ContentFlow.getSnippetDOMElement(flow, snippet)

            # Check we need to move the snippet
            if domLastSnippet.nextSibling is domSnippet
                continue

            # Move the snippet
            domSnippet.parentNode.removeChild(domSnippet)
            domLastSnippet.parentNode.insertBefore(
                domSnippet,
                domLastSnippet.nextSibling
            )


# Register the interface with the content flow manager
ContentFlow.FlowMgr.getCls().registerInterface(
    'order-snippets',
    ContentFlow.OrderSnippetsUI
)