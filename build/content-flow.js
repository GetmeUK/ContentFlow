!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define([],t):"object"==typeof exports?exports.ManhattanSortable=t():e.ManhattanSortable=t()}(this,function(){return function(e){function __webpack_require__(r){if(t[r])return t[r].exports;var o=t[r]={exports:{},id:r,loaded:!1};return e[r].call(o.exports,o,o.exports,__webpack_require__),o.loaded=!0,o.exports}var t={};return __webpack_require__.m=e,__webpack_require__.c=t,__webpack_require__.p="",__webpack_require__(0)}([function(e,t,r){r(1),e.exports=r(2)},function(e,t,r){e.exports=r.p+"sortable.css"},function(e,t,r){var o,i,n=function(e,t){return function(){return e.apply(t,arguments)}};o=r(3),i=function(){function Sortable(e,t){var r;null==t&&(t={}),this._grab=n(this._grab,this),this._drop=n(this._drop,this),this._drag=n(this._drag,this),o.config(this,{axis:"vertical",childSelector:null,grabSelector:null},t,e,this.constructor.clsPrefix),this._behaviours={},o.config(this._behaviours,{before:"auto",children:"children",grabber:"self",helper:"clone"},t,e,this.constructor.clsPrefix),this._grabbed=null,this._grabbedOffset=null,this._dom={},this._dom.container=e,this._dom.container.__mh_sortable=this,this._dom.container.classList.add(this._bem("mh-sortable")),Object.defineProperty(this,"container",{value:this._dom.container}),Object.defineProperty(this,"children",{get:function(e){return function(){var t;return function(){var e,r,o,i;for(o=this._dom.children,i=[],e=0,r=o.length;e<r;e++)t=o[e],i.push(t);return i}.call(e)}}(this)}),r=this.constructor.behaviours.children[this._behaviours.children],this._dom.children=r(this),o.listen(document,{mousedown:this._grab,mousemove:this._drag,mouseup:this._drop,touchstart:this._grab,touchmove:this._drag,touchend:this._drop})}return Sortable.clsPrefix="data-mh-sortable--",Sortable.prototype.destroy=function(){return this.container.classList.remove(this._bem("mh-sortable")),o.ignore(document,{mousedown:this._grab,mousemove:this._drag,mouseup:this._drop,touchstart:this._grab,touchmove:this._drag,touchend:this._drop}),delete this._dom.container.__mh_sortable},Sortable.prototype._bem=function(e,t,r){var o;return null==t&&(t=""),null==r&&(r=""),o=e,t&&(o=o+"__"+t),r&&(o=o+"--"+r),o},Sortable.prototype._clearSelection=function(){},Sortable.prototype._et=function(e){return"mh-sortable--"+e},Sortable.prototype._getEventPos=function(e){return e.touches&&(e=e.touches[0]),[e.pageX-window.pageXOffset,e.pageY-window.pageYOffset]},Sortable.prototype._drag=function(e){var t,r,i,n,s,a,h,u,c,l;if(this._grabbed){for(h=this._getEventPos(e),a=[window.pageXOffset,window.pageYOffset],this._dom.helper.style.left=a[0]+h[0]-this._grabbedOffset[0]+"px",this._dom.helper.style.top=a[1]+h[1]-this._grabbedOffset[1]+"px",l=document.elementFromPoint(h[0],h[1]),c=null,u=this._dom.children,n=0,s=u.length;n<s;n++)if(r=u[n],r!==this._grabbed&&r.contains(l)){c=r;break}if(c)return t=this.constructor.behaviours.before[this._behaviours.before],t=t(this,c,h),this.container.removeChild(this._grabbed),t||(c=c.nextElementSibling),this.container.insertBefore(this._grabbed,c),i=this.constructor.behaviours.children[this._behaviours.children],this._dom.children=i(this),o.dispatch(this.container,this._et("sort"),{children:this._dom.children})}},Sortable.prototype._drop=function(e){if(this._grabbed)return this._grabbed.classList.remove(this._bem("mh-sortable-ghost")),this._grabbed=null,this._grabbedOffset=null,document.body.removeChild(this._dom.helper),this._dom.helper=null,this.container.classList.remove(this._bem("mh-sortable",null,"sorting")),o.dispatch(this.container,this._et("sorted"),{children:this._dom.children})},Sortable.prototype._grab=function(e){var t,r,i,n,s,a,h,u,c;if("mousedown"!==e.type.toLowerCase()||1===e.which){for(r=null,c=this._dom.children,s=0,a=c.length;s<a;s++)if(t=c[s],i=this.constructor.behaviours.grabber[this._behaviours.grabber],i(this,t).contains(e.target)){r=t;break}return r?(e.preventDefault(),this._grabbed=r,h=this._getEventPos(e),u=this._grabbed.getBoundingClientRect(),this._grabbedOffset=[h[0]-u.left,h[1]-u.top],n=this.constructor.behaviours.helper[this._behaviours.helper],this._dom.helper=n(this,this._grabbed),document.body.appendChild(this._dom.helper),this._dom.helper.style.left=h[0]-this._grabbedOffset[0]+"px",this._dom.helper.style.top=h[1]-this._grabbedOffset[1]+"px",this._grabbed.classList.add(this._bem("mh-sortable-ghost")),this.container.classList.add(this._bem("mh-sortable",null,"sorting")),o.dispatch(this.container,this._et("grabbed"),{child:r})):void 0}},Sortable.behaviours={before:{auto:function(e,t,r){var o,i,n,s,a,h,u,c;if(c=e.container.getBoundingClientRect().width,e._containerWidth!==c){for(e.axis="vertical",u={},a=e._dom.children,n=0,s=a.length;n<s;n++){if(i=a[n],h=i.getBoundingClientRect().top,u[h]){e.axis="horizontal";break}u[h]=!0}e._containerWidth=c}return(o=e.constructor.behaviours.before.axis)(e,t,r)},axis:function(e,t,r){var o,i;return i=t.getBoundingClientRect(),o=[r[0]-i.left,r[1]-i.top],"vertical"===e.axis?o[1]<i.height/2:o[0]<i.width/2}},children:{children:function(e){var t,r,o;return t=e.container.childNodes,o=1,function(){var e,i,n;for(n=[],e=0,i=t.length;e<i;e++)r=t[e],r.nodeType===o&&n.push(r);return n}()},selector:function(e){return o.many(e.childSelector,e.container)}},grabber:{selector:function(e,t){return o.one(e.grabSelector,t)},self:function(e,t){return t}},helper:{clone:function(e,t){var r,o;return r=t.cloneNode(!0),r.removeAttribute("id"),r.removeAttribute("name"),o=document.defaultView.getComputedStyle(t,"").cssText,r.style.cssText=o,r.style.position="absolute",r.style["pointer-events"]="none",r.classList.add(e._bem("mh-sortable-helper")),r}}},Sortable}(),e.exports={Sortable:i}},function(e,t,r){!function(t,r){e.exports=r()}(this,function(){return function(e){function __webpack_require__(r){if(t[r])return t[r].exports;var o=t[r]={exports:{},id:r,loaded:!1};return e[r].call(o.exports,o,o.exports,__webpack_require__),o.loaded=!0,o.exports}var t={};return __webpack_require__.m=e,__webpack_require__.c=t,__webpack_require__.p="",__webpack_require__(0)}([function(e,t,r){e.exports=r(1)},function(e,t){var r,o,i,n,s,a,h,u,c=[].indexOf||function(e){for(var t=0,r=this.length;t<r;t++)if(t in this&&this[t]===e)return t;return-1};o=function(e,t){var r,o,i;null==t&&(t={}),r=document.createElement(e);for(o in t)i=t[o],c.call(r,o)>=0?r[o]=i:r.setAttribute(o,i);return r},h=function(e,t){return null==t&&(t=document),Array.prototype.slice.call(t.querySelectorAll(e))},u=function(e,t){return null==t&&(t=document),t.querySelector(e)},i=function(e,t,r){var o,i,n;null==r&&(r={}),o=document.createEvent("Event"),o.initEvent(t,!0,!0);for(i in r)n=r[i],o[i]=n;return e.dispatchEvent(o)},s=function(e,t){var r,o,i,n;n=[];for(o in t)i=t[o],n.push(function(){var t,n,s,a;for(s=o.split(/\s+/),a=[],t=0,n=s.length;t<n;t++)r=s[t],a.push(e.removeEventListener(r,i));return a}());return n},a=function(e,t){var r,o,i,n;n=[];for(o in t)i=t[o],n.push(function(){var t,n,s,a;for(s=o.split(/\s+/),a=[],t=0,n=s.length;t<n;t++)r=s[t],a.push(e.addEventListener(r,i));return a}());return n},r=function(e,t,r,o,i){var n,s,a,h;null==i&&(i="data-"),a=[];for(s in t)h=t[s],e[s]=h,r.hasOwnProperty(s)&&(e[s]=r[s]),n=i+s.replace(/([a-z])([A-Z])/g,"$1-$2").toLowerCase(),o.hasAttribute(n)?"number"==typeof h?a.push(e[s]=parseInt(o.getAttribute(n))):h===!1?a.push(e[s]=!0):a.push(e[s]=o.getAttribute(n)):a.push(void 0);return a},n=function(e){return e.replace(/[\^\$\\\.\*\+\?\(\)\[\]\{\}\|]/g,"\\$&")},e.exports={create:o,one:u,many:h,dispatch:i,ignore:s,listen:a,config:r,escapeRegExp:n}}])})}])});
(function() {
  var ContentFlow, exports, _FlowMgr,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  ContentFlow = {
    dimSnippetDOMElement: function(flow, snippet) {
      var element;
      element = ContentFlow.getSnippetDOMElement(flow, snippet);
      if (element) {
        return element.classList.remove('cf--highlight-snippet');
      }
    },
    dimAllSnippetDOMElements: function() {
      var element, _i, _len, _ref, _results;
      _ref = document.querySelectorAll('.cf--highlight-snippet');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        _results.push(element.classList.remove('cf--highlight-snippet'));
      }
      return _results;
    },
    getFlowCls: function() {
      return ContentFlow.FlowModel;
    },
    getFlowDOMelement: function(flow) {
      return document.querySelector("[data-cf-flow='" + (flow.id || flow) + "']");
    },
    getFlowIdFromDOMElement: function(element) {
      return element.getAttribute('data-cf-flow');
    },
    getSnippetCls: function(flow) {
      return ContentFlow.SnippetModel;
    },
    getSnippetDOMElement: function(flow, snippet) {
      return document.querySelector("[data-cf-snippet='" + snippet.id + "']");
    },
    getSnippetIdFromDOMElement: function(element) {
      return element.getAttribute('data-cf-snippet');
    },
    getSnippetTypeCls: function(flow) {
      return ContentFlow.SnippetTypeModel;
    },
    highlightSnippetDOMElement: function(flow, snippet) {
      var element;
      element = ContentFlow.getSnippetDOMElement(flow, snippet);
      if (element) {
        return element.classList.add('cf--highlight-snippet');
      }
    }
  };

  if (typeof window !== 'undefined') {
    window.ContentFlow = ContentFlow;
  }

  if (typeof module !== 'undefined' && module.exports) {
    exports = module.exports = ContentFlow;
  }

  _FlowMgr = (function(_super) {
    __extends(_FlowMgr, _super);

    _FlowMgr._uiInterfaces = {};

    function _FlowMgr() {
      _FlowMgr.__super__.constructor.call(this);
      this._api = null;
      this._flow = null;
      this._open = false;
      this._draw = new ContentFlow.DrawUI();
      this.attach(this._draw);
      this._flows = new ContentFlow.FlowsUI();
      this._draw.attach(this._flows);
      this._toggle = new ContentFlow.ToggleUI();
      this.attach(this._toggle);
      this._flows.addEventListener('select', (function(_this) {
        return function(ev) {
          return _this.flow(ev.detail().flow);
        };
      })(this));
    }

    _FlowMgr.prototype.init = function(queryOrDOMElements, idProp, api) {
      var domFlow, editor, flows, _i, _len, _ref;
      if (queryOrDOMElements == null) {
        queryOrDOMElements = '[data-cf-flow]';
      }
      if (idProp == null) {
        idProp = 'data-cf-flow';
      }
      if (api == null) {
        api = null;
      }
      editor = ContentTools.EditorApp.get();
      this._api = api || new ContentFlow.BaseAPI();
      this._domFlows = queryOrDOMElements;
      if (typeof queryOrDOMElements === 'string' || queryOrDOMElements instanceof String) {
        this._domFlows = document.querySelectorAll(this._domFlows);
      }
      flows = [];
      _ref = this._domFlows;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        domFlow = _ref[_i];
        flows.push(new ContentFlow.FlowModel(domFlow.getAttribute(idProp)));
      }
      this._flows.flows(flows);
      this._toggle.addEventListener('on', (function(_this) {
        return function(ev) {
          return _this.open();
        };
      })(this));
      this._toggle.addEventListener('off', (function(_this) {
        return function(ev) {
          return _this.close();
        };
      })(this));
      editor.addEventListener('start', (function(_this) {
        return function(ev) {
          return _this._toggle.hide();
        };
      })(this));
      editor.addEventListener('stop', (function(_this) {
        return function(ev) {
          return _this._toggle.show();
        };
      })(this));
      if (this._domFlows.length > 0) {
        this.mount();
        this._toggle.show();
        return this.flow(flows[0]);
      }
    };

    _FlowMgr.prototype.api = function() {
      return this._api;
    };

    _FlowMgr.prototype.isOpen = function() {
      return this._open;
    };

    _FlowMgr.prototype.close = function() {
      var editor;
      if (!this.dispatchEvent(this.createEvent('close'))) {
        return;
      }
      document.body.classList.remove('cf--flow-mgr-open');
      this._draw.close();
      editor = ContentTools.EditorApp.get();
      if (editor.domRegions().length) {
        return editor.ignition().show();
      }
    };

    _FlowMgr.prototype.flow = function(flow) {
      if (flow === void 0) {
        return this._flow;
      }
      if (this._flow === flow) {
        return;
      }
      ContentFlow.dimAllSnippetDOMElements();
      this._flow = flow;
      return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
    };

    _FlowMgr.prototype.loadInterface = function() {
      var args, child, name, uiInterface;
      name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      uiInterface = new this.constructor._uiInterfaces[name]();
      if (!uiInterface) {
        return;
      }
      if (uiInterface.safeToClose()) {
        this._toggle.enable();
      } else {
        this._toggle.disable();
      }
      if (this._draw.children().length > 1) {
        child = this._draw.children()[1];
        child.unmount();
        this._draw.detach(child);
      }
      this._draw.attach(uiInterface);
      uiInterface.mount();
      return uiInterface.init.apply(uiInterface, args);
    };

    _FlowMgr.prototype.mount = function() {
      var child, _i, _len, _ref, _results;
      this._domElement = this.constructor.createDiv(['cf-flow-mgr']);
      document.body.insertBefore(this._domElement, null);
      this._addDOMEventListeners();
      _ref = this.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.mount());
      }
      return _results;
    };

    _FlowMgr.prototype.open = function() {
      if (!this.dispatchEvent(this.createEvent('open'))) {
        return;
      }
      document.body.classList.add('cf--flow-mgr-open');
      ContentTools.EditorApp.get().ignition().hide();
      return this._draw.open();
    };

    _FlowMgr.prototype.unmount = function() {
      if (!this.isMounted()) {
        return;
      }
      this._domElement.parentNode.removeChild(this._domElement);
      this._removeDOMEventListeners();
      this._draw = null;
      this._flowSelect = null;
      return this._toggle = null;
    };

    _FlowMgr.registerInterface = function(name, cls) {
      return this._uiInterfaces[name] = cls;
    };

    return _FlowMgr;

  })(ContentTools.ComponentUI);

  ContentFlow.FlowMgr = (function() {
    var instance;

    function FlowMgr() {}

    instance = null;

    FlowMgr.get = function() {
      var cls;
      cls = ContentFlow.FlowMgr.getCls();
      return instance != null ? instance : instance = new cls();
    };

    FlowMgr.getCls = function() {
      return _FlowMgr;
    };

    return FlowMgr;

  })();

  ContentFlow.BaseAPI = (function() {
    function BaseAPI(baseURL, baseParams) {
      if (baseURL == null) {
        baseURL = '/';
      }
      if (baseParams == null) {
        baseParams = {};
      }
      this.baseURL = baseURL;
      this.baseParams = baseParams;
    }

    BaseAPI.prototype.getGlobalSnippets = function(flow) {
      return this._callEndpoint('GET', 'global-snippets', {
        flow: flow.id
      });
    };

    BaseAPI.prototype.getSnippets = function(flow) {
      return this._callEndpoint('GET', 'snippets', {
        flow: flow.id
      });
    };

    BaseAPI.prototype.getSnippetTypes = function(flow) {
      return this._callEndpoint('GET', 'snippet-types', {
        flow: flow.id
      });
    };

    BaseAPI.prototype.getSnippetSettingsForm = function(flow, snippet) {
      return this._callEndpoint('GET', 'snippet-settings', {
        flow: flow.id
      });
    };

    BaseAPI.prototype.addSnippet = function(flow, snippetType) {
      return this._callEndpoint('POST', 'add-snippet', {
        flow: flow.id,
        snippet_type: snippetType.id
      });
    };

    BaseAPI.prototype.addGlobalSnippet = function(flow, globalSnippet) {
      return this._callEndpoint('POST', 'add-global-snippet', {
        flow: flow.id,
        global_snippet: globalSnippet.global_id
      });
    };

    BaseAPI.prototype.changeSnippetScope = function(flow, snippet, scope, label) {
      if (label == null) {
        label = null;
      }
      return this._callEndpoint('POST', 'snippet-scope', {
        flow: flow.id,
        snippet: snippet.id,
        scope: scope,
        label: label
      });
    };

    BaseAPI.prototype.changeSnippetSettings = function(flow, snippet, settings) {
      var k, params, v;
      params = {
        flow: flow.id,
        snippet: snippet.id
      };
      for (k in settings) {
        v = settings[k];
        params[k] = v;
      }
      return this._callEndpoint('POST', 'snippet-settings', params);
    };

    BaseAPI.prototype.deleteSnippet = function(flow, snippet) {
      return this._callEndpoint('POST', 'delete-snippet', {
        flow: flow.id,
        snippet: snippet.id
      });
    };

    BaseAPI.prototype.orderSnippets = function(flow, snippets) {
      var s;
      return this._callEndpoint('POST', 'order-snippets', {
        flow: flow.id,
        snippets: (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = snippets.length; _i < _len; _i++) {
            s = snippets[_i];
            _results.push(s.id);
          }
          return _results;
        })()
      });
    };

    BaseAPI.prototype._callEndpoint = function(method, endpoint, params) {
      var formData, k, pairs, paramsStr, v, xhr;
      if (params == null) {
        params = {};
      }
      xhr = new XMLHttpRequest();
      formData = null;
      paramsStr = '';
      switch (method.toLowerCase()) {
        case 'get':
          pairs = Object.keys(params).map(function(p) {
            return [p, params[p]].map(encodeURIComponent).join('=');
          });
          paramsStr = "?" + (pairs.join("&")) + "&_=" + (Date.now());
          break;
        case 'delete':
        case 'post':
        case 'post':
          formData = new FormData();
          for (k in params) {
            v = params[k];
            formData.append(k, v);
          }
      }
      xhr.open(method, "" + this.baseURL + endpoint + paramsStr);
      xhr.send();
      return xhr;
    };

    return BaseAPI;

  })();

  ContentFlow.FlowModel = (function() {
    function FlowModel(id, snippetTypes) {
      if (snippetTypes == null) {
        snippetTypes = [];
      }
      this.id = id;
      this.snippetTypes = snippetTypes;
    }

    FlowModel.prototype.getSnippetTypeById = function(snippetTypeId) {
      var snippetType, _i, _len, _ref;
      _ref = this.snippetTypes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        snippetType = _ref[_i];
        if (snippetTypeId === snippetType.id) {
          return snippetType;
        }
      }
    };

    return FlowModel;

  })();

  ContentFlow.SnippetModel = (function() {
    function SnippetModel(id, type, scope, settings, globalId, label) {
      if (scope == null) {
        scope = 'local';
      }
      if (settings == null) {
        settings = {};
      }
      if (globalId == null) {
        globalId = null;
      }
      if (label == null) {
        label = null;
      }
      this.id = id;
      this.type = type;
      this.scope = scope;
      this.settings = settings;
      this.globalId = globalId;
      this.label = label;
    }

    SnippetModel.fromJSONType = function(flow, jsonTypeData) {
      var snippetTypeClass;
      snippetTypeClass = ContentFlow.getSnippetTypeCls(flow);
      return new ContentFlow.SnippetModel(jsonTypeData.id, snippetTypeClass.fromJSONType(flow, jsonTypeData.type), jsonTypeData.scope, jsonTypeData.settings, jsonTypeData.global_id, jsonTypeData.label);
    };

    return SnippetModel;

  })();

  ContentFlow.SnippetTypeModel = (function() {
    function SnippetTypeModel(id, label, imageURL) {
      if (imageURL == null) {
        imageURL = null;
      }
      this.id = id;
      this.label = label;
      this.imageURL = imageURL;
    }

    SnippetTypeModel.prototype.toSnippet = function() {
      return new ContentFlow.SnippetModel('', this);
    };

    SnippetTypeModel.fromJSONType = function(flow, jsonTypeData) {
      return new ContentFlow.SnippetTypeModel(jsonTypeData.id, jsonTypeData.label, jsonTypeData.imageURL);
    };

    return SnippetTypeModel;

  })();

  ContentFlow.DrawUI = (function(_super) {
    __extends(DrawUI, _super);

    function DrawUI() {
      DrawUI.__super__.constructor.call(this);
      this._state = 'closed';
    }

    DrawUI.prototype.open = function() {
      if (this.dispatchEvent(this.createEvent('open'))) {
        return this.state('open');
      }
    };

    DrawUI.prototype.close = function() {
      if (this.dispatchEvent(this.createEvent('close'))) {
        return this.state('closed');
      }
    };

    DrawUI.prototype.mount = function() {
      var child, _i, _len, _ref, _results;
      DrawUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-widget', 'ct-draw', 'ct-draw--closed']);
      this.parent().domElement().appendChild(this._domElement);
      this._addDOMEventListeners();
      _ref = this.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.mount());
      }
      return _results;
    };

    DrawUI.prototype.state = function(state) {
      if (state === void 0) {
        return state;
      }
      if (this.state === state) {
        return;
      }
      if (!this.dispatchEvent(this.createEvent('statechange', {
        state: state
      }))) {
        return;
      }
      this._state = state;
      if (this.isMounted()) {
        this.removeCSSClass('ct-draw--open');
        this.removeCSSClass('ct-draw--closed');
        if (this._state === 'open') {
          return this.addCSSClass('ct-draw--open');
        } else {
          return this.addCSSClass('ct-draw--closed');
        }
      }
    };

    return DrawUI;

  })(ContentTools.ComponentUI);

  ContentFlow.FieldUI = (function(_super) {
    __extends(FieldUI, _super);

    function FieldUI(name, label, required, initialValue) {
      FieldUI.__super__.constructor.call(this);
      this._name = name;
      this._label = label;
      this._required = required;
      this._initialValue = initialValue;
    }

    FieldUI.prototype.name = function() {
      return this._name;
    };

    FieldUI.prototype.label = function() {
      return this._label;
    };

    FieldUI.prototype.required = function() {
      return this._required;
    };

    FieldUI.prototype.initialValue = function() {
      return this._initialValue;
    };

    FieldUI.prototype.errors = function(errors) {
      var domError, error, _i, _j, _len, _len1, _ref;
      if (!this.isMounted()) {
        throw Error('Cannot set error for unmounted field');
      }
      if (errors === void 0) {
        errors = [];
        _ref = this._domErrors.querySelector('.ct-field__error');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          domError = _ref[_i];
          errors.push(domError.textContent);
        }
        return errors;
      }
      this._domErrors.innerHTML = '';
      this._domErrors.classList.add('ct-field-errors__empty');
      if (errors) {
        for (_j = 0, _len1 = errors.length; _j < _len1; _j++) {
          error = errors[_j];
          domError = this.constructor.createDiv(['ct-field__error']);
          domError.textContent = ContentEdit._(error);
          this._domErrors.appendChild(domError);
        }
        return this._domErrors.classList.remove('ct-field-errors__empty');
      }
    };

    FieldUI.prototype.mount = function() {
      FieldUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-field', this._required ? 'ct-field--required' : 'ct-field--optional']);
      this._domLabel = document.createElement('label');
      this._domLabel.classList.add('ct-field__label');
      this._domLabel.setAttribute('for', this._name);
      this._domLabel.textContent = ContentEdit._(this._label);
      this._domElement.appendChild(this._domLabel);
      this.mount_input();
      this._domErrors = this.constructor.createDiv(['ct-field_errors', 'ct-field_errors__empty']);
      this._domElement.appendChild(this._domErrors);
      this.parent().domElement().appendChild(this._domElement);
      return this._addDOMEventListeners();
    };

    FieldUI.prototype.mount_input = function() {};

    FieldUI.prototype.value = function(value) {
      if (!this.isMounted()) {
        throw Error('Cannot set value for unmounted field');
      }
      if (value === void 0) {
        return this._domInput.value;
      }
      return this._domInput.value = value;
    };

    FieldUI.prototype.unmount = function() {
      FieldUI.__super__.unmount.call(this);
      this._domErrors = null;
      this._domInput = null;
      return this._domLabel = null;
    };

    FieldUI.fromJSONType = function(jsonTypeData) {
      switch (jsonTypeData['type']) {
        case 'boolean':
          return new ContentFlow.BooleanFieldUI(jsonTypeData['name'], jsonTypeData['label'], jsonTypeData['required'], jsonTypeData['value']);
        case 'select':
          return new ContentFlow.SelectFieldUI(jsonTypeData['name'], jsonTypeData['label'], jsonTypeData['required'], jsonTypeData['value'], jsonTypeData['choices']);
      }
      return new ContentFlow.TextFieldUI(jsonTypeData['name'], jsonTypeData['label'], jsonTypeData['required'], jsonTypeData['value']);
    };

    return FieldUI;

  })(ContentTools.ComponentUI);

  ContentFlow.BooleanFieldUI = (function(_super) {
    __extends(BooleanFieldUI, _super);

    function BooleanFieldUI() {
      return BooleanFieldUI.__super__.constructor.apply(this, arguments);
    }

    BooleanFieldUI.prototype.mount_input = function() {
      this._domInput = document.createElement('input');
      this._domInput.classList.add('ct-field__input');
      this._domInput.classList.add('ct-field__input--boolean');
      this._domInput.setAttribute('id', this._name);
      this._domInput.setAttribute('name', this._name);
      this._domInput.setAttribute('type', 'checkbox');
      if (this._initialValue) {
        this._domInput.setAttribute('checked', true);
      }
      return this._domElement.appendChild(this._domInput);
    };

    BooleanFieldUI.prototype.value = function(value) {
      if (!this.isMounted()) {
        throw Error('Cannot set value for unmounted field');
      }
      if (value === void 0) {
        if (this._domInput.checked) {
          return this.name;
        }
        return '';
      }
      this._domInput.removeAttribute('checked');
      if (value) {
        return this._domInput.setAttribute('checked', true);
      }
    };

    return BooleanFieldUI;

  })(ContentFlow.FieldUI);

  ContentFlow.SelectFieldUI = (function(_super) {
    __extends(SelectFieldUI, _super);

    function SelectFieldUI(name, label, required, initialValue, choices) {
      SelectFieldUI.__super__.constructor.call(this, name, label, required, initialValue, choices);
      this._choices = choices;
    }

    SelectFieldUI.prototype.choices = function() {
      return this.choices;
    };

    SelectFieldUI.prototype.mount_input = function() {
      var choice, domOption, _i, _len, _ref;
      this._domInput = document.createElement('select');
      this._domInput.classList.add('ct-field__input');
      this._domInput.classList.add('ct-field__input--select');
      this._domInput.setAttribute('id', this._name);
      this._domInput.setAttribute('name', this._name);
      _ref = this._choices;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        choice = _ref[_i];
        domOption = document.createElement('option');
        domOption.setAttribute('value', choice[0]);
        domOption.textContent = ContentEdit._(choice[1]);
        if (this._initialValue === choice[0]) {
          this._domInput.setAttribute('selected', true);
        }
        this._domInput.appendChild(domOption);
      }
      return this._domElement.appendChild(this._domInput);
    };

    return SelectFieldUI;

  })(ContentFlow.FieldUI);

  ContentFlow.TextFieldUI = (function(_super) {
    __extends(TextFieldUI, _super);

    function TextFieldUI() {
      return TextFieldUI.__super__.constructor.apply(this, arguments);
    }

    TextFieldUI.prototype.mount_input = function() {
      this._domInput = document.createElement('input');
      this._domInput.classList.add('ct-field__input');
      this._domInput.classList.add('ct-field__input--text');
      this._domInput.setAttribute('id', this._name);
      this._domInput.setAttribute('name', this._name);
      this._domInput.setAttribute('type', 'text');
      this._domInput.setAttribute('value', this._initialValue === void 0 ? '' : this._initialValue);
      return this._domElement.appendChild(this._domInput);
    };

    return TextFieldUI;

  })(ContentFlow.FieldUI);

  ContentFlow.FlowsUI = (function(_super) {
    __extends(FlowsUI, _super);

    function FlowsUI(flows) {
      if (flows == null) {
        flows = [];
      }
      FlowsUI.__super__.constructor.call(this);
      this._flows = flows;
    }

    FlowsUI.prototype.domSelect = function() {
      return this._domSelect;
    };

    FlowsUI.prototype.flows = function(flows) {
      var domOption, flow, _i, _len, _ref, _results;
      if (flows === void 0) {
        return flow;
      }
      if (JSON.stringify(this._flows) === JSON.stringify(flows)) {
        return;
      }
      this._flows = flows;
      if (this.isMounted()) {
        while (this._domSelect.options.length > 0) {
          this._domSelect.remove(0);
        }
        _ref = this._flows;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          flow = _ref[_i];
          domOption = document.createElement('option');
          domOption.setAttribute('value', flow.id);
          domOption.textContent = flow.id;
          _results.push(this._domSelect.appendChild(domOption));
        }
        return _results;
      }
    };

    FlowsUI.prototype.mount = function() {
      var domOption, flow, _i, _len, _ref;
      FlowsUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-flows']);
      this._domSelect = document.createElement('select');
      this._domSelect.classList.add('ct-flows__select');
      this._domSelect.setAttribute('name', 'flows');
      _ref = this._flows;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        flow = _ref[_i];
        domOption = document.createElement('option');
        domOption.setAttribute('value', flow.id);
        domOption.textContent = flow.id;
        this._domSelect.appendChild(domOption);
      }
      this._domElement.appendChild(this._domSelect);
      this.parent().domElement().appendChild(this._domElement);
      return this._addDOMEventListeners();
    };

    FlowsUI.prototype.unmount = function() {
      FlowsUI.__super__.unmount.call(this);
      return this._domSelect = null;
    };

    FlowsUI.prototype._addDOMEventListeners = function() {
      return this._domSelect.addEventListener('change', (function(_this) {
        return function(ev) {
          var flow, id, _i, _len, _ref, _results;
          id = _this._domSelect.value;
          _ref = _this._flows;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            flow = _ref[_i];
            if (flow.id === id) {
              _results.push(_this.dispatchEvent(_this.createEvent('select', {
                flow: flow
              })));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
      })(this));
    };

    return FlowsUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlayUI = (function(_super) {
    __extends(InlayUI, _super);

    function InlayUI(heading) {
      InlayUI.__super__.constructor.call(this);
      this._header = new ContentFlow.InlayHeaderUI(heading);
      this.attach(this._header);
      this._body = new ContentFlow.InlayBodyUI();
      this.attach(this._body);
    }

    InlayUI.prototype.body = function() {
      return this._body;
    };

    InlayUI.prototype.header = function() {
      return this._header;
    };

    InlayUI.prototype.mount = function() {
      InlayUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay']);
      this.parent().domElement().appendChild(this._domElement);
      this._addDOMEventListeners();
      this._header.mount();
      return this._body.mount();
    };

    return InlayUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlayBodyUI = (function(_super) {
    __extends(InlayBodyUI, _super);

    function InlayBodyUI() {
      return InlayBodyUI.__super__.constructor.apply(this, arguments);
    }

    InlayBodyUI.prototype.mount = function() {
      var child, _i, _len, _ref, _results;
      InlayBodyUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay__body']);
      this.parent().domElement().appendChild(this._domElement);
      this._addDOMEventListeners();
      _ref = this.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.mount());
      }
      return _results;
    };

    return InlayBodyUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlayHeaderToolsUI = (function(_super) {
    __extends(InlayHeaderToolsUI, _super);

    function InlayHeaderToolsUI() {
      return InlayHeaderToolsUI.__super__.constructor.apply(this, arguments);
    }

    InlayHeaderToolsUI.prototype.mount = function() {
      var child, _i, _len, _ref, _results;
      InlayHeaderToolsUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay__tools']);
      this.parent().domElement().appendChild(this._domElement);
      this._addDOMEventListeners();
      _ref = this.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.mount());
      }
      return _results;
    };

    return InlayHeaderToolsUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlayHeaderUI = (function(_super) {
    __extends(InlayHeaderUI, _super);

    function InlayHeaderUI(heading) {
      InlayHeaderUI.__super__.constructor.call(this);
      this._heading = heading;
      this._tools = new ContentFlow.InlayHeaderToolsUI();
      this.attach(this._tools);
    }

    InlayHeaderUI.prototype.tools = function() {
      return this._tools;
    };

    InlayHeaderUI.prototype.heading = function(heading) {
      if (heading === void 0) {
        return this._heading;
      }
      this._heading = heading;
      if (this.isMounted()) {
        return this._domHeading.textContent = ContentEdit._(heading);
      }
    };

    InlayHeaderUI.prototype.mount = function() {
      InlayHeaderUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay__header']);
      this._domHeading = this.constructor.createDiv(['ct-inlay__heading']);
      this._domHeading.textContent = ContentEdit._(this._heading);
      this._domElement.appendChild(this._domHeading);
      this.parent().domElement().appendChild(this._domElement);
      this._addDOMEventListeners();
      return this._tools.mount();
    };

    InlayHeaderUI.prototype.unmount = function() {
      InlayHeaderUI.__super__.unmount.call(this);
      return this._domHeading = null;
    };

    return InlayHeaderUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlayNoteUI = (function(_super) {
    __extends(InlayNoteUI, _super);

    function InlayNoteUI(content) {
      InlayNoteUI.__super__.constructor.call(this);
      this._content = content;
    }

    InlayNoteUI.prototype.content = function(content) {
      if (content === void 0) {
        return this._content;
      }
      this._content = content;
      if (this.isMounted()) {
        return this._domElement.innerHTML = content;
      }
    };

    InlayNoteUI.prototype.mount = function() {
      InlayNoteUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay-note']);
      this._domElement.innerHTML = this._content;
      this.parent().domElement().appendChild(this._domElement);
      return this._addDOMEventListeners();
    };

    return InlayNoteUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlaySectionUI = (function(_super) {
    __extends(InlaySectionUI, _super);

    function InlaySectionUI(heading) {
      InlaySectionUI.__super__.constructor.call(this);
      this._heading = heading;
    }

    InlaySectionUI.prototype.heading = function(heading) {
      if (heading === void 0) {
        return this._heading;
      }
      this._heading = heading;
      if (this.isMounted()) {
        return this._domHeading.textContent = ContentEdit._(heading);
      }
    };

    InlaySectionUI.prototype.mount = function() {
      var child, _i, _len, _ref, _results;
      InlaySectionUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay-section']);
      this._domHeading = this.constructor.createDiv(['ct-inlay-section__heading']);
      this._domHeading.textContent = ContentEdit._(this._heading);
      this._domElement.appendChild(this._domHeading);
      this.parent().domElement().appendChild(this._domElement);
      this._addDOMEventListeners();
      _ref = this.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.mount());
      }
      return _results;
    };

    InlaySectionUI.prototype.unmount = function() {
      InlaySectionUI.__super__.unmount.call(this);
      return this._domHeading = null;
    };

    return InlaySectionUI;

  })(ContentTools.ComponentUI);

  ContentFlow.InlayToolUI = (function(_super) {
    __extends(InlayToolUI, _super);

    function InlayToolUI(toolName, tooltip) {
      InlayToolUI.__super__.constructor.call(this);
      this._toolName = toolName;
      this._tooltip = tooltip;
    }

    InlayToolUI.prototype.toolName = function() {
      return this._toolName;
    };

    InlayToolUI.prototype.tooltip = function() {
      return this._tooltip;
    };

    InlayToolUI.prototype.mount = function() {
      InlayToolUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-inlay__tool', 'ct-inlay-tool', "ct-inlay-tool--" + this._toolName]);
      this._domElement.setAttribute('data-ct-tooltip', ContentEdit._(this._tooltip));
      this.parent().domElement().appendChild(this._domElement);
      return this._addDOMEventListeners();
    };

    InlayToolUI.prototype._addDOMEventListeners = function() {
      InlayToolUI.__super__._addDOMEventListeners.call(this);
      return this._domElement.addEventListener('click', (function(_this) {
        return function(ev) {
          return _this.dispatchEvent(_this.createEvent('click'));
        };
      })(this));
    };

    return InlayToolUI;

  })(ContentTools.ComponentUI);

  ContentFlow.SnippetUI = (function(_super) {
    __extends(SnippetUI, _super);

    function SnippetUI(snippet, behaviour) {
      SnippetUI.__super__.constructor.call(this);
      this._snippet = snippet;
      this._behaviour = behaviour;
    }

    SnippetUI.prototype.mount = function() {
      var bkgURL;
      SnippetUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-snippet', 'ct-snippet--behaviour-' + this._behaviour, 'ct-snippet--scope-' + this._snippet.scope]);
      this._domElement.setAttribute('data-snippet-id', this._snippet.id);
      this._domPreview = this.constructor.createDiv(['ct-snippet__preview']);
      if (this._snippet.type.imageURL) {
        bkgURL = "url(" + this._snippet.type.imageURL + ")";
        this._domPreview.style.backgroundImage = bkgURL;
      }
      this._domElement.appendChild(this._domPreview);
      this._domLabel = this.constructor.createDiv(['ct-snippet__label']);
      if (this._snippet.label) {
        this._domLabel.textContent = this._snippet.label;
      } else {
        this._domLabel.textContent = this._snippet.type.label;
      }
      this._domElement.appendChild(this._domLabel);
      if (this._behaviour === 'manage') {
        this._domTools = this.constructor.createDiv(['ct-snippet__tools']);
        this._domSettingsTool = this.constructor.createDiv(['ct-snippet__tool', 'ct-snippet__tool--settings']);
        this._domSettingsTool.setAttribute('data-ct-tooltip', ContentEdit._('Settings'));
        this._domTools.appendChild(this._domSettingsTool);
        this._domScopeTool = this.constructor.createDiv(['ct-snippet__tool', 'ct-snippet__tool--scope']);
        this._domScopeTool.setAttribute('data-ct-tooltip', ContentEdit._('Scope'));
        this._domTools.appendChild(this._domScopeTool);
        this._domDeleteTool = this.constructor.createDiv(['ct-snippet__tool', 'ct-snippet__tool--delete']);
        this._domDeleteTool.setAttribute('data-ct-tooltip', ContentEdit._('Delete'));
        this._domTools.appendChild(this._domDeleteTool);
        this._domElement.appendChild(this._domTools);
      }
      this.parent().domElement().appendChild(this._domElement);
      return this._addDOMEventListeners();
    };

    SnippetUI.prototype._addDOMEventListeners = function() {
      SnippetUI.__super__._addDOMEventListeners.call(this);
      this._domElement.addEventListener('mouseover', (function(_this) {
        return function(ev) {
          return _this.dispatchEvent(_this.createEvent('over', {
            snippet: _this._snippet
          }));
        };
      })(this));
      this._domElement.addEventListener('mouseout', (function(_this) {
        return function(ev) {
          return _this.dispatchEvent(_this.createEvent('out', {
            snippet: _this._snippet
          }));
        };
      })(this));
      if (this._behaviour === 'manage') {
        this._domSettingsTool.addEventListener('click', (function(_this) {
          return function(ev) {
            return _this.dispatchEvent(_this.createEvent('settings', {
              snippet: _this._snippet
            }));
          };
        })(this));
        this._domScopeTool.addEventListener('click', (function(_this) {
          return function(ev) {
            return _this.dispatchEvent(_this.createEvent('scope', {
              snippet: _this._snippet
            }));
          };
        })(this));
        return this._domDeleteTool.addEventListener('click', (function(_this) {
          return function(ev) {
            return _this.dispatchEvent(_this.createEvent('delete', {
              snippet: _this._snippet
            }));
          };
        })(this));
      } else if (this._behaviour === 'pick') {
        return this._domElement.addEventListener('click', (function(_this) {
          return function(ev) {
            return _this.dispatchEvent(_this.createEvent('pick', {
              snippet: _this._snippet
            }));
          };
        })(this));
      }
    };

    return SnippetUI;

  })(ContentTools.ComponentUI);

  ContentFlow.ToggleUI = (function(_super) {
    __extends(ToggleUI, _super);

    function ToggleUI() {
      ToggleUI.__super__.constructor.call(this);
      this._state = 'off';
      this._enabled = true;
    }

    ToggleUI.prototype.enabled = function() {
      return this._enabled;
    };

    ToggleUI.prototype.disable = function() {
      if (this.dispatchEvent(this.createEvent('disable'))) {
        this._enabled = false;
        if (this.isMounted()) {
          return this.addCSSClass('ct-toggle--disabled');
        }
      }
    };

    ToggleUI.prototype.enable = function() {
      if (this.dispatchEvent(this.createEvent('enable'))) {
        this._enabled = true;
        if (this.isMounted()) {
          return this.removeCSSClass('ct-toggle--disabled');
        }
      }
    };

    ToggleUI.prototype.mount = function() {
      ToggleUI.__super__.mount.call(this);
      this._domElement = this.constructor.createDiv(['ct-widget', 'ct-toggle', 'ct-toggle--off']);
      this._domOff = this.constructor.createDiv(['ct-toggle__button', 'ct-toggle__button--off']);
      this._domElement.appendChild(this._domOff);
      this._domOn = this.constructor.createDiv(['ct-toggle__button', 'ct-toggle__button--on']);
      this._domElement.appendChild(this._domOn);
      this.parent().domElement().appendChild(this._domElement);
      return this._addDOMEventListeners();
    };

    ToggleUI.prototype.off = function() {
      if (this.dispatchEvent(this.createEvent('off'))) {
        return this.state('off');
      }
    };

    ToggleUI.prototype.on = function() {
      if (this.dispatchEvent(this.createEvent('on'))) {
        return this.state('on');
      }
    };

    ToggleUI.prototype.state = function(state) {
      if (state === void 0) {
        return state;
      }
      if (this.state === state) {
        return;
      }
      if (!this.dispatchEvent(this.createEvent('statechange', {
        state: state
      }))) {
        return;
      }
      this._state = state;
      if (this.isMounted()) {
        this.removeCSSClass('ct-toggle--off');
        this.removeCSSClass('ct-toggle--on');
        if (this._state === 'on') {
          return this.addCSSClass('ct-toggle--on');
        } else {
          return this.addCSSClass('ct-toggle--off');
        }
      }
    };

    ToggleUI.prototype.toggle = function() {
      if (this._state === 'on') {
        return this.off();
      } else {
        return this.on();
      }
    };

    ToggleUI.prototype.unmount = function() {
      ToggleUI.__super__.unmount.call(this);
      this._domOn = null;
      return this._domOff = null;
    };

    ToggleUI.prototype._addDOMEventListeners = function() {
      ToggleUI.__super__._addDOMEventListeners.call(this);
      this._domOff.addEventListener('click', (function(_this) {
        return function(ev) {
          ev.preventDefault();
          if (_this._enabled) {
            return _this.off();
          }
        };
      })(this));
      return this._domOn.addEventListener('click', (function(_this) {
        return function(ev) {
          ev.preventDefault();
          if (_this._enabled) {
            return _this.on();
          }
        };
      })(this));
    };

    return ToggleUI;

  })(ContentTools.WidgetUI);

  ContentFlow.InterfaceUI = (function(_super) {
    __extends(InterfaceUI, _super);

    function InterfaceUI(heading) {
      InterfaceUI.__super__.constructor.call(this, heading);
    }

    InterfaceUI.prototype.init = function() {};

    InterfaceUI.prototype.safeToClose = function() {
      return false;
    };

    return InterfaceUI;

  })(ContentFlow.InlayUI);

  ContentFlow.AddSnippetUI = (function(_super) {
    __extends(AddSnippetUI, _super);

    function AddSnippetUI() {
      AddSnippetUI.__super__.constructor.call(this, 'Add');
      this._tools = {
        cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
      };
      this._header.tools().attach(this._tools.cancel);
      this._tools.cancel.addEventListener('click', (function(_this) {
        return function(ev) {
          return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
        };
      })(this));
    }

    AddSnippetUI.prototype.init = function() {
      var flowMgr, result;
      AddSnippetUI.__super__.init.call(this);
      flowMgr = ContentFlow.FlowMgr.get();
      result = flowMgr.api().getSnippetTypes(flowMgr.flow());
      return result.addEventListener('load', (function(_this) {
        return function(ev) {
          var child, flow, payload, snippetType, snippetTypeData, uiSnippet, _i, _j, _len, _len1, _ref, _ref1;
          flow = ContentFlow.FlowMgr.get().flow();
          payload = JSON.parse(ev.target.responseText).payload;
          _ref = _this._body.children;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _this._body.detach(child);
          }
          _this._local = new ContentFlow.InlaySectionUI('Local scope');
          _ref1 = payload['snippet_types'];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            snippetTypeData = _ref1[_j];
            snippetType = ContentFlow.SnippetTypeModel.fromJSONType(flow, snippetTypeData);
            uiSnippet = new ContentFlow.SnippetUI(snippetType.toSnippet(), 'pick');
            _this._local.attach(uiSnippet);
            uiSnippet.addEventListener('pick', function(ev) {
              flowMgr = ContentFlow.FlowMgr.get();
              result = flowMgr.api().addSnippet(flowMgr.flow(), ev.detail().snippet.type);
              return result.addEventListener('load', (function(_this) {
                return function(ev) {
                  var domFlow, domSnippet;
                  flow = ContentFlow.FlowMgr.get().flow();
                  payload = JSON.parse(ev.target.responseText).payload;
                  domSnippet = document.createElement('div');
                  domSnippet.innerHTML = payload['html'];
                  domSnippet = domSnippet.children[0];
                  domFlow = ContentFlow.getFlowDOMelement(flow);
                  domFlow.appendChild(domSnippet);
                  return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
                };
              })(this));
            });
          }
          _this._body.attach(_this._local);
          result = flowMgr.api().getGlobalSnippets(flowMgr.flow());
          return result.addEventListener('load', function(ev) {
            var snippet, snippetCls, snippetData, _k, _len2, _ref2;
            payload = JSON.parse(ev.target.responseText).payload;
            flow = ContentFlow.FlowMgr.get().flow();
            snippetCls = ContentFlow.getSnippetCls(flow);
            _this._global = new ContentFlow.InlaySectionUI('Global scope');
            _ref2 = payload.snippets;
            for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
              snippetData = _ref2[_k];
              snippet = snippetCls.fromJSONType(flow, snippetData);
              uiSnippet = new ContentFlow.SnippetUI(snippet, 'pick');
              _this._global.attach(uiSnippet);
              uiSnippet.addEventListener('pick', function(ev) {
                flowMgr = ContentFlow.FlowMgr.get();
                result = flowMgr.api().addGlobalSnippet(flowMgr.flow(), ev.detail().snippet);
                return result.addEventListener('load', (function(_this) {
                  return function(ev) {
                    var domFlow, domSnippet;
                    flow = ContentFlow.FlowMgr.get().flow();
                    payload = JSON.parse(ev.target.responseText).payload;
                    domSnippet = document.createElement('div');
                    domSnippet.innerHTML = payload['html'];
                    domSnippet = domSnippet.children[0];
                    domFlow = ContentFlow.getFlowDOMelement(flow);
                    domFlow.appendChild(domSnippet);
                    return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
                  };
                })(this));
              });
            }
            if (_this._global.children().length > 0) {
              _this._body.attach(_this._global);
            }
            _this._body.unmount();
            return _this._body.mount();
          });
        };
      })(this));
    };

    return AddSnippetUI;

  })(ContentFlow.InterfaceUI);

  ContentFlow.FlowMgr.getCls().registerInterface('add-snippet', ContentFlow.AddSnippetUI);

  ContentFlow.ListSnippetsUI = (function(_super) {
    __extends(ListSnippetsUI, _super);

    function ListSnippetsUI() {
      ListSnippetsUI.__super__.constructor.call(this, 'Snippets');
      this._tools = {
        order: new ContentFlow.InlayToolUI('order', 'Order', true),
        add: new ContentFlow.InlayToolUI('add', 'Add', true)
      };
      this._header.tools().attach(this._tools.order);
      this._header.tools().attach(this._tools.add);
      this._tools.order.addEventListener('click', (function(_this) {
        return function(ev) {
          return ContentFlow.FlowMgr.get().loadInterface('order-snippets');
        };
      })(this));
      this._tools.add.addEventListener('click', (function(_this) {
        return function(ev) {
          return ContentFlow.FlowMgr.get().loadInterface('add-snippet');
        };
      })(this));
    }

    ListSnippetsUI.prototype.init = function() {
      var flowMgr, result;
      ListSnippetsUI.__super__.init.call(this);
      flowMgr = ContentFlow.FlowMgr.get();
      result = flowMgr.api().getSnippets(flowMgr.flow());
      return result.addEventListener('load', (function(_this) {
        return function(ev) {
          var child, flow, payload, snippet, snippetCls, snippetData, uiSnippet, _i, _j, _len, _len1, _ref, _ref1;
          payload = JSON.parse(ev.target.responseText).payload;
          _ref = _this._body.children;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _this._body.detach(child);
          }
          flow = ContentFlow.FlowMgr.get().flow();
          snippetCls = ContentFlow.getSnippetCls(flow);
          _ref1 = payload.snippets;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            snippetData = _ref1[_j];
            snippet = snippetCls.fromJSONType(flow, snippetData);
            uiSnippet = new ContentFlow.SnippetUI(snippet, 'manage');
            _this._body.attach(uiSnippet);
            uiSnippet.addEventListener('over', function(ev) {
              return ContentFlow.highlightSnippetDOMElement(ContentFlow.FlowMgr.get().flow(), ev.detail().snippet);
            });
            uiSnippet.addEventListener('out', function(ev) {
              return ContentFlow.dimSnippetDOMElement(ContentFlow.FlowMgr.get().flow(), ev.detail().snippet);
            });
            uiSnippet.addEventListener('settings', function(ev) {
              return ContentFlow.FlowMgr.get().loadInterface('snippet-settings', ev.detail().snippet);
            });
            uiSnippet.addEventListener('scope', function(ev) {
              var scope;
              scope = 'local';
              if (ev.detail().snippet.scope === 'local') {
                scope = 'global';
              }
              return ContentFlow.FlowMgr.get().loadInterface("make-snippet-" + scope, ev.detail().snippet);
            });
            uiSnippet.addEventListener('delete', function(ev) {
              var msg, _removeSnippet;
              msg = ContentEdit._('Are you sure you want to delete this snippet?');
              if (confirm(msg)) {
                flowMgr = ContentFlow.FlowMgr.get();
                result = flowMgr.api().deleteSnippet(flowMgr.flow(), ev.detail().snippet);
                _removeSnippet = function(flow, snippet) {
                  return function(ev) {
                    var domSnippet;
                    domSnippet = ContentFlow.getSnippetDOMElement(flow, snippet);
                    domSnippet.remove();
                    return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
                  };
                };
                return result.addEventListener('load', _removeSnippet(flowMgr.flow(), ev.detail().snippet));
              }
            });
          }
          _this._body.unmount();
          return _this._body.mount();
        };
      })(this));
    };

    ListSnippetsUI.prototype.safeToClose = function() {
      return true;
    };

    return ListSnippetsUI;

  })(ContentFlow.InterfaceUI);

  ContentFlow.FlowMgr.getCls().registerInterface('list-snippets', ContentFlow.ListSnippetsUI);

  ContentFlow.MakeSnippetGlobalUI = (function(_super) {
    __extends(MakeSnippetGlobalUI, _super);

    function MakeSnippetGlobalUI() {
      MakeSnippetGlobalUI.__super__.constructor.call(this, 'Make global');
      this._tools = {
        confirm: new ContentFlow.InlayToolUI('confirm', 'Confirm', true),
        cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
      };
      this._header.tools().attach(this._tools.confirm);
      this._header.tools().attach(this._tools.cancel);
      this._tools.confirm.addEventListener('click', (function(_this) {
        return function(ev) {
          var flowMgr, result;
          flowMgr = ContentFlow.FlowMgr.get();
          result = flowMgr.api().changeSnippetScope(flowMgr.flow(), _this._snippet, 'global', _this._labelField.value());
          return result.addEventListener('load', function(ev) {
            var response;
            response = JSON.parse(ev.target.responseText);
            if (response.status === 'success') {
              return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
            } else {
              return _this._labelField.errors([response.errors.label]);
            }
          });
        };
      })(this));
      this._tools.cancel.addEventListener('click', (function(_this) {
        return function(ev) {
          return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
        };
      })(this));
    }

    MakeSnippetGlobalUI.prototype.init = function(snippet) {
      var note;
      MakeSnippetGlobalUI.__super__.init.call(this);
      this._snippet = snippet;
      this._labelField = new ContentFlow.TextFieldUI('label', 'Label', true);
      this._body.attach(this._labelField);
      note = new ContentFlow.InlayNoteUI(ContentEdit._('Once you make a snippet global it can be inserted into other pages\nand changes made to the snippet&apos;s content or settings will be\napplied to all instances of the snippet.'));
      this._body.attach(note);
      this._body.unmount();
      return this._body.mount();
    };

    return MakeSnippetGlobalUI;

  })(ContentFlow.InterfaceUI);

  ContentFlow.FlowMgr.getCls().registerInterface('make-snippet-global', ContentFlow.MakeSnippetGlobalUI);

  ContentFlow.MakeSnippetLocaUI = (function(_super) {
    __extends(MakeSnippetLocaUI, _super);

    function MakeSnippetLocaUI() {
      MakeSnippetLocaUI.__super__.constructor.call(this, 'Make local');
      this._tools = {
        confirm: new ContentFlow.InlayToolUI('confirm', 'Confirm', true),
        cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
      };
      this._header.tools().attach(this._tools.confirm);
      this._header.tools().attach(this._tools.cancel);
      this._tools.confirm.addEventListener('click', (function(_this) {
        return function(ev) {
          var flowMgr, result;
          flowMgr = ContentFlow.FlowMgr.get();
          result = flowMgr.api().changeSnippetScope(flowMgr.flow(), _this._snippet, 'local');
          return result.addEventListener('load', function(ev) {
            return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
          });
        };
      })(this));
      this._tools.cancel.addEventListener('click', (function(_this) {
        return function(ev) {
          return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
        };
      })(this));
    }

    MakeSnippetLocaUI.prototype.init = function(snippet) {
      var note;
      MakeSnippetLocaUI.__super__.init.call(this);
      this._snippet = snippet;
      note = new ContentFlow.InlayNoteUI(ContentEdit._('This action replaces the global snippet within the page with a\nlocal version of the snippet. Changes to local snippets are only\napplied to that instance of the snippet.'));
      this._body.attach(note);
      this._body.unmount();
      return this._body.mount();
    };

    return MakeSnippetLocaUI;

  })(ContentFlow.InterfaceUI);

  ContentFlow.FlowMgr.getCls().registerInterface('make-snippet-local', ContentFlow.MakeSnippetLocaUI);

  ContentFlow.OrderSnippetsUI = (function(_super) {
    __extends(OrderSnippetsUI, _super);

    function OrderSnippetsUI() {
      OrderSnippetsUI.__super__.constructor.call(this, 'Order');
      this._tools = {
        confirm: new ContentFlow.InlayToolUI('confirm', 'Confirm', true),
        cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
      };
      this._header.tools().attach(this._tools.confirm);
      this._header.tools().attach(this._tools.cancel);
      this._tools.confirm.addEventListener('click', (function(_this) {
        return function(ev) {
          var flowMgr, result;
          flowMgr = ContentFlow.FlowMgr.get();
          result = flowMgr.api().orderSnippets(flowMgr.flow(), _this._newSnippetOrder);
          return result.addEventListener('load', function(ev) {
            return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
          });
        };
      })(this));
      this._tools.cancel.addEventListener('click', (function(_this) {
        return function(ev) {
          _this._orderSnippetsOnPage(_this._originalSnippetOrder);
          return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
        };
      })(this));
    }

    OrderSnippetsUI.prototype.init = function() {
      var flowMgr, result;
      OrderSnippetsUI.__super__.init.call(this);
      flowMgr = ContentFlow.FlowMgr.get();
      result = flowMgr.api().getSnippets(flowMgr.flow());
      return result.addEventListener('load', (function(_this) {
        return function(ev) {
          var child, flow, payload, snippet, snippetCls, snippetData, _i, _j, _len, _len1, _ref, _ref1;
          _this._snippets = {};
          _this._originalSnippetOrder = [];
          _this._newSnippetOrder = [];
          payload = JSON.parse(ev.target.responseText).payload;
          _ref = _this._body.children;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _this._body.detach(child);
          }
          flow = ContentFlow.FlowMgr.get().flow();
          snippetCls = ContentFlow.getSnippetCls(flow);
          _ref1 = payload.snippets;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            snippetData = _ref1[_j];
            snippet = snippetCls.fromJSONType(flow, snippetData);
            _this._snippets[snippet.id] = snippet;
            _this._originalSnippetOrder.push(snippet);
            _this._newSnippetOrder.push(snippet);
            _this._body.attach(new ContentFlow.SnippetUI(snippet, 'order'));
          }
          _this._body.unmount();
          _this._body.mount();
          _this._sorter = new ManhattanSortable.Sortable(_this._body.domElement());
          return _this._body.domElement().addEventListener('mh-sortable--sorted', function(ev) {
            var id, _k, _len2, _ref2;
            _this._newSnippetOrder = [];
            _ref2 = ev.children;
            for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
              child = _ref2[_k];
              id = child.dataset.snippetId;
              _this._newSnippetOrder.push(_this._snippets[id]);
            }
            return _this._orderSnippetsOnPage(_this._newSnippetOrder);
          });
        };
      })(this));
    };

    OrderSnippetsUI.prototype.unmount = function() {
      OrderSnippetsUI.__super__.unmount.call(this);
      if (this._sorter) {
        return this._sorter.destroy();
      }
    };

    OrderSnippetsUI.prototype._orderSnippetsOnPage = function(snippets) {
      var domLastSnippet, domSnippet, flow, i, snippet, _i, _len, _results;
      flow = ContentFlow.FlowMgr.get().flow();
      _results = [];
      for (i = _i = 0, _len = snippets.length; _i < _len; i = ++_i) {
        snippet = snippets[i];
        if (i === 0) {
          continue;
        }
        domLastSnippet = ContentFlow.getSnippetDOMElement(flow, snippets[i - 1]);
        domSnippet = ContentFlow.getSnippetDOMElement(flow, snippet);
        if (domLastSnippet.nextSibling === domSnippet) {
          continue;
        }
        domSnippet.parentNode.removeChild(domSnippet);
        _results.push(domLastSnippet.parentNode.insertBefore(domSnippet, domLastSnippet.nextSibling));
      }
      return _results;
    };

    return OrderSnippetsUI;

  })(ContentFlow.InterfaceUI);

  ContentFlow.FlowMgr.getCls().registerInterface('order-snippets', ContentFlow.OrderSnippetsUI);

  ContentFlow.SnippetSettingsUI = (function(_super) {
    __extends(SnippetSettingsUI, _super);

    function SnippetSettingsUI() {
      SnippetSettingsUI.__super__.constructor.call(this, 'Settings');
      this._tools = {
        confirm: new ContentFlow.InlayToolUI('confirm', 'Confirm', true),
        cancel: new ContentFlow.InlayToolUI('cancel', 'Cancel', true)
      };
      this._header.tools().attach(this._tools.confirm);
      this._header.tools().attach(this._tools.cancel);
      this._tools.confirm.addEventListener('click', (function(_this) {
        return function(ev) {
          var field, flowMgr, result, settings, _, _i, _len, _ref;
          if (!_this._fields) {
            ContentFlow.FlowMgr.get().loadInterface('list-snippets');
            return;
          }
          settings = {};
          _ref = _this._fields;
          for (field = _i = 0, _len = _ref.length; _i < _len; field = ++_i) {
            _ = _ref[field];
            settings[field.name()] = field.value();
          }
          flowMgr = ContentFlow.FlowMgr.get();
          result = flowMgr.api().changeSnippetSettings(flowMgr.flow(), _this._snippet, settings);
          return result.addEventListener('load', function(ev) {
            var errors, fieldName, flow, newElement, originalElement, response, _j, _len1, _ref1, _results;
            response = JSON.parse(ev.target.responseText);
            if (response.status === 'success') {
              flow = ContentFlow.FlowMgr.get().flow();
              originalElement = ContentFlow.getSnippetDOMElement(flow, _this._snippet);
              newElement = document.createElement('div');
              newElement.innerHTML = response.payload['html'];
              newElement = newElement.children[0];
              originalElement.parentNode.replaceChild(newElement, originalElement);
              return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
            } else {
              _ref1 = response.payload.errors;
              _results = [];
              for (errors = _j = 0, _len1 = _ref1.length; _j < _len1; errors = ++_j) {
                fieldName = _ref1[errors];
                if (_this._fields[fieldName]) {
                  _results.push(_this._fields[fieldName].errors(errors));
                } else {
                  _results.push(void 0);
                }
              }
              return _results;
            }
          });
        };
      })(this));
      this._tools.cancel.addEventListener('click', (function(_this) {
        return function(ev) {
          return ContentFlow.FlowMgr.get().loadInterface('list-snippets');
        };
      })(this));
    }

    SnippetSettingsUI.prototype.init = function(snippet) {
      var flowMgr, result;
      this._snippet = snippet;
      flowMgr = ContentFlow.FlowMgr.get();
      result = flowMgr.api().getSnippetSettingsForm(flowMgr.flow(), snippet);
      return result.addEventListener('load', (function(_this) {
        return function(ev) {
          var field, fieldData, k, note, payload, v, _i, _j, _len, _len1, _ref, _ref1, _results;
          payload = JSON.parse(ev.target.responseText).payload;
          if (!payload.fields) {
            _this._fields = null;
            note = ContentFlow.InlayNoteUI('There are no settings defined for this snippet.');
            _this._body.unmount();
            _this._body.mount();
            return;
          }
          _this._fields = {};
          _ref = payload.fields;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            fieldData = _ref[_i];
            field = ContentFlow.FieldUI.fromJSONType(fieldData);
            _this._fields[field.name()] = field;
            _this._body.attach(field);
          }
          _this._body.unmount();
          _this._body.mount();
          _ref1 = _this._snippet.settings;
          _results = [];
          for (v = _j = 0, _len1 = _ref1.length; _j < _len1; v = ++_j) {
            k = _ref1[v];
            if (_this._fields[k]) {
              _results.push(_this._fields[k].value(v));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
      })(this));
    };

    return SnippetSettingsUI;

  })(ContentFlow.InterfaceUI);

  ContentFlow.FlowMgr.getCls().registerInterface('snippet-settings', ContentFlow.SnippetSettingsUI);

}).call(this);
