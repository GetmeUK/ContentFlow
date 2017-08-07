(function() {
  window.addEventListener('load', function() {
    var api, editor, flowMgr, idProp, queryOrDOMElements;
    editor = ContentTools.EditorApp.get();
    flowMgr = ContentFlow.FlowMgr.get();
    editor.init('[data-cf-snippet], [data-fixture]', 'data-cf-snippet');
    return flowMgr.init(queryOrDOMElements = '[data-cf-flow]', idProp = 'data-cf-flow', api = new ContentFlow.MockAPI());
  });

}).call(this);
