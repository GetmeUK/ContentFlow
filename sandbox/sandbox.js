(function() {
  window.addEventListener('load', function() {
    var editor, flowMgr;
    editor = ContentTools.EditorApp.get();
    flowMgr = ContentFlow.FlowMgr.get();
    editor.init('[data-editable], [data-fixture]', 'data-editable');
    return flowMgr.init();
  });

}).call(this);
