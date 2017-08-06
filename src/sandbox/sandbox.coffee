
window.addEventListener 'load', () ->

    # Get handles to the CT editor and CF flow manager
    editor = ContentTools.EditorApp.get()
    flowMgr = ContentFlow.FlowMgr.get()

    # Configure and initialize the CT editor
    editor.init('[data-editable], [data-fixture]', 'data-editable')

    # Configure and initialize the CF flow manager
    flowMgr.init(
        queryOrDOMElements='[data-cf-flow]',
        idProp='data-cf-flow',
        api=new ContentFlow.MockAPI()
        )