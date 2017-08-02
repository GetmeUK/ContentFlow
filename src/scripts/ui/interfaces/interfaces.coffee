
class ContentFlow.InterfaceUI extends ContentFlow.InlayUI

    # A base interface UI component used for managing content flows.

    constructor: (heading) ->
        super(heading)

    init: (flow) ->
        # Initialize the interface