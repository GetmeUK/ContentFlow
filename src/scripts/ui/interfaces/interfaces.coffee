
class ContentFlow.InterfaceUI extends ContentFlow.InlayUI

    # A base interface UI component used for managing content flows.

    constructor: (heading) ->
        super(heading)

    init: (flow) ->
        # Initialize the interface

    # Read-only

    safeToClose: () ->
        # Returns true if the content flow manager app can be safely closed
        # while this view is open.
        return false